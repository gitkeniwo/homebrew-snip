class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "8dde44dcfd733926a09d9170a2ff719774373862be78da7d52181b8709ec0372"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "c909ca16fca8ffb9d14a5767aa9491994ecc7a6f66dab0ed68b0d6b2ee73f57b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "732f644ba50daf49441fa6cf2bc80a843913278ef99ecf48cba0655861127b38"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21f7e81fa46f160bb124a55908b0df98468d15e66575979e234ce249c044d058"
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
