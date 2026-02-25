class Tome < Formula
  desc "Sync AI coding skills across tools"
  homepage "https://github.com/martinP7r/tome"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.1.4/tome-aarch64-apple-darwin.tar.xz"
      sha256 "eca5fcf8739c980af99546e02ca4609cff5f68082911c5e0726df815214d896e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.1.4/tome-x86_64-apple-darwin.tar.xz"
      sha256 "04b5916616b547a222576dbdc3f95c65b6b765513fb326613d6378d539706fe5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.1.4/tome-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05ea623a3d1df7c32847b808281b3995eb54b1ebeab875b858212d83c77670ff"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tome" if OS.mac? && Hardware::CPU.arm?
    bin.install "tome" if OS.mac? && Hardware::CPU.intel?
    bin.install "tome" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
