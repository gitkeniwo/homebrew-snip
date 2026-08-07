class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.4/snip-aarch64-apple-darwin.tar.gz"
      sha256 "d307af856249991f0c3d7010c180773fea3bce749d20bc227638b339271a50f7"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.4/snip-x86_64-apple-darwin.tar.gz"
      sha256 "6d13a9affa5057557051def53058f467149e7a0f1a9df3d615e048f7ff3680a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.4/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "889e2b6500162057e15ddbb36349d55a3fdd15bfc01b986fcaa21bf92970c7a8"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.4/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c50c06099a6ab5150e76bc052f8564fe5cd283575e24d08ce0575f5fc03bdfb1"
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
