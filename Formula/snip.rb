class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-apple-darwin.tar.gz"
      sha256 "ff4d5cd0507a228dfd004865dadde765c4e738f995c01fbe0ebbdbe7cb639834"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-apple-darwin.tar.gz"
      sha256 "e5f2927ea6656e57ab241455f46e84acad2618d3dbe25075f52cc3dcd4b5ef1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c44da0c99800b14671a4c41351d9d5f0dd9e7dd15b0a060f19a830c7f79f767c"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.4.1/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4192f04fe63fca71f1f3f9d676eea6067b702a6ad21773b5fae37e7ce758e37f"
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
