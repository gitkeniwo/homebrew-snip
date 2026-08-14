class Snip < Formula
  desc "Filesystem-native snippet library and agent-friendly CLI"
  homepage "https://github.com/gitkeniwo/snip"
  license "MIT"

  # Optional integration with system git for automated backup & history
  uses_from_macos "git"
  on_macos do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.0/snip-aarch64-apple-darwin.tar.gz"
      sha256 "373b67bb52bc80752a1eb6142549974c7fab69824c9be513194c12785b9d176b"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.0/snip-x86_64-apple-darwin.tar.gz"
      sha256 "7f4164d29dd47fcbf78d59742003da96f8a104d78506e76f78a6f5a3b853f712"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.0/snip-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e5dbfdd2ca45c6fbf9a0015daf834560c58472d1d28dd99e826b811c6ee84559"
    end

    on_intel do
      url "https://github.com/gitkeniwo/snip/releases/download/v0.6.0/snip-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93571ef0b61eb53c6e81e47fee811b8a6ba13602319665ed579e34a359fbeb51"
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
