class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "f3940d547c1182f90a86b532047fbe64be372c1ccd66f7640bf9749f53385ddc"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "2f26cc6c984e2cd271aef92b04e840f3ea70a2041fdee14f902a16253df0327a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "88c6bb062bb210cf435d13e5d92e7411f2c12c8664f6d37d27a01fb7f9ac988b"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23ba8d0277f92b39e1ee3773fd88d56a3911d810b5ac236092dc3229f8d00429"
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
