class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "a5de9c57fec7bf6a09df4ef188498c0aa2a83edaf0be5eee52a29dd0bbaa0fd1"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "5e58297160090b214676ce17362a63c1f56883f946391a997778cd2437a1796b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c062e1682b99f3ae068ffa30f3ee5d289b3a6f2a53e97bb4de650d5dc440bbe7"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c8969dd86626d02e97af2d9b21fdc9559aec41c56eb12ff561e79beef16b9d7"
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
