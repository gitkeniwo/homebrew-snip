class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.2/snip-aarch64-apple-darwin.tar.gz"
      sha256 "c5c9118c31ba4a385ef21f6fb4ed4ec6737c04e038a1202059654811ef27e5dd"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.2/snip-x86_64-apple-darwin.tar.gz"
      sha256 "08166b94a68196ad1ae9dcb23f659c0c281eddbee3de12dd7f35234d1941eba3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.2/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ded6a79e8de53f6ea86b234825919d89fb31e767046e5ab47ccc6d7003a8dd6d"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.2/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "657447d88492fbce1555079f7f131d083a7642b2475ad87f00a55952dd5d1fdd"
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
