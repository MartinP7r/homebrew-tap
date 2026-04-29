class Tome < Formula
  desc "Sync AI coding skills across tools"
  homepage "https://github.com/martinP7r/tome"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.9.0/tome-aarch64-apple-darwin.tar.xz"
      sha256 "4f8067cbfdce26434d0ec9b88cee17164b01970089482d32c2051b43b69b3f92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.9.0/tome-x86_64-apple-darwin.tar.xz"
      sha256 "c13ab47459c5262af21d0a0e83ad08870d4207c080b09275ad1f63be776cc109"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.9.0/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "13e4e277e06f9a7713f30afea25858e278e1260adf4a75211db76530cf539cc3"
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
