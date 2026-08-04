class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.3/snip-aarch64-apple-darwin.tar.gz"
      sha256 "2e612c3ce939cbaf7b4f710315887000d0d103f8885183c20c91b1a53378f6a6"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.3/snip-x86_64-apple-darwin.tar.gz"
      sha256 "87663c827d79de404699be0ed68ec0e0b4e62cccdfa6ef96924473fa0203566b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.3/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c1f16761915f2a3b17c3ea0a7b651d9c6b0d74afb677325ff7acfa4ac520623"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.5.3/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd6e78272c17da8c35f5bdd71a416d8995e57ff53bf6e587e3ac58888bdcafee"
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
