class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "f23dabba4b07ae34e67ba3f1a916dca59c37918202ee221036b3df074b6a6133"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "081b490e00ff19fde8d5cb8b010a1e6df533b9165ca1fdfd592a7286a54939e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c79448be8f07684c4c3122f25cc29778b67cedbcab1f87f0c2bf14aaf466d20e"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "94b56807d2f5cf487db9ea3329ee398104721c466bd98e0e9fc6fef82da359e9"
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
