class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "de4eaa2fdf6172523865643e12aa249345e39648c144969fd5dc7a0284ac3166"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "275d9c902556d4e76c53e31d4ff302f08f5226281f8ed147a8d9c6642b7609e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9451395135b86eac83bcc27554f4052aacf5db370a9e0a460f4b77682d5c541"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f50c0a1191d3efd7da1f8fe7d6265e7bb64330fa5ffbcbdd1d704f093c08d8b8"
    end
  end

  def install
    bin.install "snip"
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
