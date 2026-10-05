# Named lens-window-manager because `lens` is taken in Homebrew by the Kubernetes IDE.
class LensWindowManager < Formula
  desc "Keyboard-driven window manager for macOS that remembers your layouts"
  homepage "https://github.com/surfer1225/lens"
  # Tag pinned to a commit: tags can be moved, commits cannot.
  url "https://github.com/surfer1225/lens.git",
      tag:      "v1.0.0",
      revision: "7dea213dac115a1f9488c548c21a16aa86afd0c9"
  license "MIT"
  head "https://github.com/surfer1225/lens.git", branch: "main"

  # The Command Line Tools lack the SwiftUI macro plugin that `@State` needs on current SDKs.
  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sonoma

  # Homebrew builds have no network access, so the dependency Scripts/package.sh would clone is
  # fetched here instead, at the same commit the script verifies.
  resource "KeyboardShortcuts" do
    url "https://github.com/sindresorhus/KeyboardShortcuts.git",
        tag:      "v1.10.0",
        revision: "70caa8dea43e2d273cd5ab78885d7eff01df550c"
  end

  def install
    resource("KeyboardShortcuts").stage(buildpath/"build/deps/KeyboardShortcuts")
    ENV["LENS_BUILD_DIR"] = buildpath/"build"
    system "bash", "Scripts/package.sh"
    prefix.install "build/Lens.app"
  end

  def caveats
    <<~EOS
      Lens.app was installed to:
        #{opt_prefix}/Lens.app

      To find it in Spotlight and Launchpad, link it into Applications:
        ln -sf "#{opt_prefix}/Lens.app" ~/Applications/Lens.app

      Lens needs Accessibility access to move windows. Builds are ad-hoc signed, so
      macOS asks again after each upgrade.
    EOS
  end

  test do
    app = prefix/"Lens.app"
    assert_path_exists app/"Contents/MacOS/Lens"
    assert_equal version.to_s,
                 shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' " \
                              "#{app}/Contents/Info.plist").strip
    system "codesign", "--verify", "--strict", app
  end
end
