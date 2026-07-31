class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "a40e3e35f0ec7052570ae672f80a0904b9453d3a958f8e9340e5f651119edb01"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "7a92a8cbeef427541bca6cfc79c231dd7c796c3e0e234fd022a630f3634c8ba2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2fbd8e989c6da15b1cf7a39ccd3ed5b91ead4603009f3fb1c4ff12436535ed35"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9ee20705ea49aba5569b8dec3b65918454923349123c170bb2ab800335500c39"
    end
  end

  def install
    bin.install "snip"
    man1.install Dir["man/*.1"]
    generate_completions_from_executable(bin/"snip", "completion")
  end

  def caveats
    <<~EOS
      Optional integrations:
        - Git: Automated backup & version control (uses system 'git')
        - Editor: Interactive editing uses $EDITOR, $VISUAL, or 'vi'
        - VS Code: TUI 'v' shortcut & `snip open` use 'code' CLI (configurable via `snip config set vscode_cmd <cmd>`)
    EOS
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
