class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "433c6121fd56dad60df47ac225e69a56486c3e20ea245f35469fd312f6f6d75a"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "4999349e4ef0feef10048e1ee50b3fe11ad3b8d3ffad43584f8b1447cb485b70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "815b74a3bda523ab55449afc348eefff38302b93b7933525fd4c97a9d27d7263"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0c17664884746ff2595f46425d53b94bea1b8fc1af08897a6de59f5c033ae56"
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
