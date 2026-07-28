class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.1.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "b52412ace855e010d780110410aa150c7186387029bd28dcb6f848b547e394ae"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.1.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "d056062bf7169543a5587bd55714ad451852e72c456aead0e36cc67c485ad23d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.1.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3aa75c9377578f596e0ba7e25a6e930ec91d6edaafb07c852015371d06405408"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.1.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1e0cd9d82111ec9862223784e9c26b351434f609fbaeb0f235bf05bad29b42a"
    end
  end

  def install
    bin.install "snip"
    generate_completions_from_executable(bin/"snip", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snip --version")

    library = testpath/"Main.sniplib"
    system bin/"snip", "init", library, "--name", "Main"
    assert_path_exists library/"snip.toml"

    (testpath/"hello.sh").write "echo hello\n"
    system bin/"snip", "--library", library, "create",
           "--title", "Hello",
           "--language", "bash",
           "--content-file", testpath/"hello.sh"

    output = shell_output("#{bin}/snip --library #{library} --output json list")
    assert_match "Hello", output
  end
end
