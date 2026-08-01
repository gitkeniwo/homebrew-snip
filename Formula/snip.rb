class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "2f3c56f902008544ad6dd1cb9587ba525941f031f53e275591d11c6d8c5fd894"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "9cc9f21eba5aa03fc3069cd296dcbf9dd2e26eac16d25254f97c5f146349763f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d6bfbf1083a54cd248fdaa90f00f707684682581216e349afa1b5f31857845d"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b83eaff492a64efffaadc678db94b0eb8c7b42f87d7cd247485e7edcec84cc85"
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
