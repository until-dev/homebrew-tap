cask "until" do
  os macos: "darwin-arm64.dmg", linux: "linux-amd64.tar.gz"

  version "0.32.0"
  sha256 arm:          "d991f2fb1a21c2f39d750072f9d8fbe76ae74eb5ed367a23594223b9f85b1cac",
         x86_64_linux: "62128c4a781e4e86144914ab49be57005665981dd10fa7be1596f5f6fa504ef7"

  on_macos do
    depends_on arch: :arm64

    app "untl-desktop.app"
    binary "#{appdir}/untl-desktop.app/Contents/Resources/bin/untl"

    # The app is signed, notarized and checksum-verified, so skip the
    # "downloaded from the internet" prompt on first launch. Clear the flag on
    # the staged copy before Homebrew moves it into the appdir: macOS refuses
    # changes to an app in /Applications without App Management, and a
    # refusal must never fail the install.
    preflight_steps do
      run "/usr/bin/xattr", args: ["-drs", "com.apple.quarantine", "{{staged_path}}/untl-desktop.app"],
          must_succeed: false, print_stderr: false
    end
  end
  on_linux do
    depends_on arch: :x86_64

    app_image "untl-desktop.AppImage"
    binary "untl"

    zap trash: "~/.config/untl-desktop"
  end

  url "https://github.com/until-dev/homebrew-tap/releases/download/v#{version}/untl-desktop-#{os}"
  name "Until"
  desc "Git-backed ticketing for people and agents"
  homepage "https://until.dev/"

  conflicts_with cask: "until@preview"

  caveats <<~EOS
    Until sends one anonymous ping a day: a hash of you, a hash of your
    Workspace, and the Until version. It never sends names, emails,
    repository names or Ticket content.
    See exactly what it sends with `untl telemetry`. Turn it off with
    `untl telemetry off`, or set UNTIL_TELEMETRY=0 or DO_NOT_TRACK=1.

    To get started from the command line, run:

        $ untl
  EOS
end
