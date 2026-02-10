class GitTwig < Formula
  desc "A high-performance, interactive git status visualizer"
  homepage "https://martinp7r.github.io/git-twig/"
  version "1.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.8/git-twig-aarch64-apple-darwin.tar.xz"
      sha256 "5a2f219b2e44b1faf5e9f9515433c6d2ac624b7d4e287d075facf1af3b81863b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.8/git-twig-x86_64-apple-darwin.tar.xz"
      sha256 "9dc2520066ec2e280e2fcfbb8943466cfb237af5c077ef57abfd4b53860d91ab"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.8/git-twig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a926ad84ff5a2091b8f43207eb8f7eabc795687d659e177450d2b954c4844c8f"
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
    bin.install "git-twig" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-twig" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-twig" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
