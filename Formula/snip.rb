class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.3/snip-aarch64-apple-darwin.tar.gz"
      sha256 "dd07fd119a9fb381df67ae218fe2cde0102dac36be00bced9d2560f5199946f2"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.3/snip-x86_64-apple-darwin.tar.gz"
      sha256 "4e5521f9fbb3a918105559d091ced6224f44f666f9132082b7f041346c932c3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.3/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c3837bfa8dd91c014d53ab6b34d60e4866229ae21ef7a616bbafa3744fbbd6da"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.3/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dc4858bfab3bec5834c98783d7f75d3987bb48232f377966c0d8b391eb63a1f1"
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
