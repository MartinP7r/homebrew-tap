class Tome < Formula
  desc "Sync AI coding skills across tools"
  homepage "https://github.com/martinP7r/tome"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.4.1/tome-aarch64-apple-darwin.tar.xz"
      sha256 "408698fa121dbfa9d738b3bc2538b7e1e5b6632ba262be88db959aa119ee5f1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.4.1/tome-x86_64-apple-darwin.tar.xz"
      sha256 "b89e3e2c51991cf5e7604b4cbf574f8007522133d477312d342159e411bf6257"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.4.1/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e5f67c74018a6b44718c9a7cbf54723ff28f8ef41297fa44608cb370541bc8f9"
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
