# Note: if you are viewing this from the tap repo, this file is automatically
# updated from:
# https://github.com/I-Info/wezterm/blob/main/ci/wezterm-homebrew-macos.rb.template
# by automation in the wezterm repo.
# vim:ft=ruby:
cask "wezterm" do
  version "20251001-210841-30eedad8"
  sha256 "2b4236272ff8e345034713f752faf494b5c7d0830aa31163f4e191f2b615ee71"

  url "https://github.com/I-Info/wezterm/releases/download/#{version}/WezTerm-macos-#{version}.zip"
  name "WezTerm"
  desc "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust"
  homepage "https://wezterm.org/"

  conflicts_with cask: "wezterm wezterm@nightly"

  # Unclear what the minimal OS version is
  # depends_on macos: ">= :sierra"

  app "WezTerm.app"
  [
    "wezterm",
    "wezterm-gui",
    "strip-ansi-escapes"
  ].each do |tool|
    binary "#{appdir}/WezTerm.app/Contents/MacOS/#{tool}"
  end

  bash_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/bash", target: "wezterm"
  fish_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/fish", target: "wezterm.fish"
  zsh_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/zsh", target: "_wezterm"

  preflight do
    # Move "WezTerm-macos-#{version}/WezTerm.app" out of the subfolder
    staged_subfolder = staged_path.glob(["WezTerm-*", "wezterm-*"]).first
    if staged_subfolder
      FileUtils.mv(staged_subfolder/"WezTerm.app", staged_path)
      FileUtils.rm_rf(staged_subfolder)
    end
  end

  zap trash: [
    "~/.local/share/wezterm",
    "~/Library/Saved Application State/com.github.wez.wezterm.savedState",
  ]
end
