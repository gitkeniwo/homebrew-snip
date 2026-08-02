class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "59987bf49996a99922d7830b6c7f3159cc9371fdd37b0a1dfb9b8d5b851a54d6"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "05371a65f28da70838d583f678cf478760ef472c1e690e5dbe05ee0b49f29d39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a4c42e62179d5cdd8fdb9e9c8ce4c2336d14c45cf98472b8097fa005567ea39e"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b0041c6f1147787e80e70d58e9ac935bf49ff12e9af3db64a6aba1909709490"
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
