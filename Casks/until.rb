cask "until" do
  os macos: "darwin-arm64.dmg", linux: "linux-amd64.tar.gz"

  version "0.28.0"
  sha256 arm:          "4da5ba5b3708e3d56227702dd644f8529282259f3c6ecc6564421c48aba3a66e",
         x86_64_linux: "bd586a890620ee0f2ee25dcfe1e3a9a37af1e4bc32fa31d76ad135a0a81c3869"

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
