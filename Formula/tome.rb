class Tome < Formula
  desc "Manage and synchronize AI coding skills across tools"
  homepage "https://github.com/MartinP7r/tome"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/martinP7r/tome/releases/download/v0.17.0/tome-aarch64-apple-darwin.tar.xz"
      sha256 "3fd7bb6c562c52395b1c5b96b2c4d479ed89eb2b2d3799ce1e44a669bf8d9f58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/martinP7r/tome/releases/download/v0.17.0/tome-x86_64-apple-darwin.tar.xz"
      sha256 "4228f216ea1df23931f20aaa6cbc359e3db4789fd70890c82df81b20ff168ab7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/martinP7r/tome/releases/download/v0.17.0/tome-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "13d910e0c4ed83d68853ea5b74303e0cc3a42e59bbcddf55ff808905f486d9bb"
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
