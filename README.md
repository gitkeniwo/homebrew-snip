# homebrew-snip

Homebrew tap for [snip](https://github.com/gitkeniwo/snip), a filesystem-native
snippet library and agent-friendly CLI.

```bash
brew install gitkeniwo/snip/snip
```

Or tap first, then install by name:

```bash
brew tap gitkeniwo/snip
brew install snip
```

Upgrade with `brew upgrade snip`.

The formula installs a prebuilt binary from the snip release page — macOS
arm64/Intel and Linux arm64/x86_64 — and generates bash, zsh, and fish
completions. No Rust toolchain is needed.

## Updating the formula for a new release

`Formula/snip.rb` pins one URL and SHA-256 per platform. After tagging a new
version in the snip repository and waiting for the release build to publish its
archives:

```bash
VERSION=0.2.0
for asset in aarch64-apple-darwin x86_64-apple-darwin \
             aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu; do
  echo "$asset $(curl -sL https://github.com/gitkeniwo/snip/releases/download/v$VERSION/snip-$asset.tar.gz | shasum -a 256 | cut -d' ' -f1)"
done
```

Replace the four `v0.1.0` URLs and their `sha256` lines, then verify:

```bash
brew style ./Formula/snip.rb
brew audit --strict --online gitkeniwo/snip/snip
brew install --build-from-source gitkeniwo/snip/snip
brew test gitkeniwo/snip/snip
```

## License

The formula is MIT, matching snip itself.
