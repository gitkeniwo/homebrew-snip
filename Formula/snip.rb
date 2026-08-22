class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.2/snip-aarch64-apple-darwin.tar.gz"
      sha256 "44b6cabfe7b713e2af7a1fb14198eb13e225ada973d84a20e4e527d77de25aec"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.2/snip-x86_64-apple-darwin.tar.gz"
      sha256 "999b20f02a504ae55ae106ee1a64ef3566cdb2d4c19d988ef980b1e14478ee73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.2/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57ac4c3ec79f7a6ef60a0f71f77874425fc66b225b37a10797112f9e81ae393a"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.2/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43d5a5d409d52199bc4d35135463ae82135a551945721d313b2d7f8b1a57d82f"
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
