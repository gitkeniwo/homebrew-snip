class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "e0bccbc9e6bf69b767ac57a11edce03734054bf093264d382a7cd5fc4990797c"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "b319ad55f35ea077ebf39b4a7b659d0a5723348f87ba506e1bb875b1522d2a8e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ede7095cbdc206aa4037db07ea0b3588054ee0d6d01e1e1eeda04ef50c84a56b"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.2.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "07f9dd97ef935a436cf6dbe33ae1ab701011ed4dbc3a702e4585d52f5e40be59"
    end
  end

  def install
    bin.install "snip"
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
