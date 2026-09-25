class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.4/snip-aarch64-apple-darwin.tar.gz"
      sha256 "98ffe3bfc39e24f83ded24bac3d28febfbe0363c9f66c94ea9632ae121a25a50"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.4/snip-x86_64-apple-darwin.tar.gz"
      sha256 "889954b42b908ad4ff255939c28522efeed31add57ea28814a765ca661743056"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.4/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "81f3f1b8b83e8a1e845508dffa75d2563a6b58cb76632b8ac239a7d24176798d"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.4/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d41c3cab85b2c3fb7c53032fd82b5d7f4269df1ac2dfb722a392c0af260ca041"
    end
  end

  def install
    bin.install "snip"
    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
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
