class Tome < Formula
  desc "Manage and synchronize AI coding skills across tools"
  homepage "https://github.com/MartinP7r/tome"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.17.1/tome-aarch64-apple-darwin.tar.xz"
      sha256 "74d2944609bc69619eab8535c9b7ca573c2d75fc225d67500e178124648c6079"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.17.1/tome-x86_64-apple-darwin.tar.xz"
      sha256 "cf5b6616f3e68b60fde7482bf4bd98f88ed91a2720515b3b5e15a9c94b1dc34a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.17.1/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "34f849aac9199e61887c3311a26bc1c8df83f8233ab5610946150e4402206c09"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tome"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tome"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tome"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tome --version")
  end
end
