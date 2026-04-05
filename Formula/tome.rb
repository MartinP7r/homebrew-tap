class Tome < Formula
  desc "Sync AI coding skills across tools"
  homepage "https://github.com/martinP7r/tome"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.5.1/tome-aarch64-apple-darwin.tar.xz"
      sha256 "468aec04aff00839ccf7343d06c01287a263e09e5823edc14e6c7f7fe8891602"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.5.1/tome-x86_64-apple-darwin.tar.xz"
      sha256 "f13f97c80618c2b2f6dc32cd17772b68dfc60dad7c321a69e54304711926b142"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.5.1/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5f17bcb0fcd335298966232de0f909aa7b771cc469ef7c1ae0150bcdec45a111"
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
