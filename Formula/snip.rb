class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.5/snip-aarch64-apple-darwin.tar.gz"
      sha256 "c181aed7dcbe014d03020afcba53e16d590194561ce5f2ca9c725c1bcd091e40"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.5/snip-x86_64-apple-darwin.tar.gz"
      sha256 "b2f990f966becc47a67543af5748d3f7254e5c6c9b733a25f3fa2ca14d7cdaf0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.5/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "29d26ecb19767242ee1aff3c3559e03933ff2978df09c481d5234e16e29632e2"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.5/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3f7a85368ff765b80b5922a398262d6934016499a558fd5cc69f96593a786a0"
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
