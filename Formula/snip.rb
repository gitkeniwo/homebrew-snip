class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "ba682e27e5e65f863261a8cfd28f5c62471ac739f26e1915b2f197880b104233"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "d7c50cfff731bbe5fef9ea05c4436f2204e239010f43163ee13f4c14be9aad6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1fed92b6e98a2b983d421e9c32c2e5dc6df9d2d774886ab86bd3df2bd9704879"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f28b38588d406e383956dea322273b172d13b43bf97920128192f00cc87df9ff"
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
