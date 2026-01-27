class GitTwig < Formula
  desc "A high-performance, interactive git status visualizer"
  homepage "https://martinp7r.github.io/git-twig/"
  version "1.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.5/git-twig-aarch64-apple-darwin.tar.xz"
      sha256 "b51ddcf50797547050ac94e3482f6474ddb03038cdd71291585f4aaeb5b387e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.5/git-twig-x86_64-apple-darwin.tar.xz"
      sha256 "e74a7eb6a29dfe4caa45dbc0abb2b27876ccbde474d7ebbc39295c39520d7a1b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/MartinP7r/git-twig/releases/download/v1.2.5/git-twig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2713109e0b8b1cb35c67e2a665ba25f5efdf51482e25b89282020afe41e45de0"
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
