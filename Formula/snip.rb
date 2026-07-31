class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.2/snip-aarch64-apple-darwin.tar.gz"
      sha256 "29c467b98c4e80a4a71a5514552d0a3dbf81d14b01d4d71ab5744123e7a1cce1"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.2/snip-x86_64-apple-darwin.tar.gz"
      sha256 "9fba82eb043db1bb764326297ef81dfecafc73b38237f59eb2d0facb6f615fe6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.2/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2beb966a273b71ae876bca127ad1fd9decdbd4abf50efe6afd702a38f42e272"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.3.2/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "39835d057a1cf75537bb6e2a0283f51b84eb6baecb38bd6011fac78d53fedc4d"
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
