class Tome < Formula
  desc "Sync AI coding skills across tools"
  homepage "https://github.com/martinP7r/tome"
  version "0.16.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.16.4/tome-aarch64-apple-darwin.tar.xz"
      sha256 "2b9b8ed9bc5210daedf24125239801aebfaf08b9142558171f882254848ac2bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.16.4/tome-x86_64-apple-darwin.tar.xz"
      sha256 "277a5ad57907fe3d299ea2c28a62f33802f579b51d0f0fdc124bbcc92633e9b5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.16.4/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9bcc739f96ec9b3c93137373646f9e2948224fc12ecfa92e335a3f71f227d34e"
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
