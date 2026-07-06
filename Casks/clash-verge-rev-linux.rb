cask "clash-verge-rev-linux" do
  arch arm: "arm64", intel: "amd64"
  os linux: "linux"

  version "2.5.1"
  sha256 arm64_linux:  "99cf1f8e230cb9a3a14a5b247eb85c9e6b1def9ff7a84dbe6062b8b8446f73b8",
         x86_64_linux: "e3089744cf44518328ee6145a020ce4dbb68a1953107565796bbabf7013adc87"

  url "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v#{version}/Clash.Verge_#{version}_#{arch}.deb",
      verified: "github.com/clash-verge-rev/clash-verge-rev/"
  name "Clash Verge Rev"
  desc "Continuation of Clash Verge - A Clash Meta GUI based on Tauri"
  homepage "https://clash-verge-rev.github.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "usr/bin/clash-verge"
  binary "usr/bin/clash-verge-service"
  binary "usr/bin/clash-verge-service-install"
  binary "usr/bin/clash-verge-service-uninstall"
  binary "usr/bin/verge-mihomo"
  binary "usr/bin/verge-mihomo-alpha"
  artifact "usr/share/applications/Clash Verge.desktop",
           target: "#{Dir.home}/.local/share/applications/clash-verge.desktop"
  artifact "usr/share/icons/hicolor/32x32/apps/clash-verge.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/32x32/apps/clash-verge.png"
  artifact "usr/share/icons/hicolor/128x128/apps/clash-verge.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/128x128/apps/clash-verge.png"
  artifact "usr/share/icons/hicolor/256x256@2/apps/clash-verge.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/256x256@2/apps/clash-verge.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    FileUtils.mkdir_p "#{Dir.home}/.local/share/icons"
  end

  zap trash: [
    "~/.config/clash-verge",
    "~/.local/share/applications/clash-verge.desktop",
    "~/.local/share/icons/hicolor/128x128/apps/clash-verge.png",
    "~/.local/share/icons/hicolor/256x256@2/apps/clash-verge.png",
    "~/.local/share/icons/hicolor/32x32/apps/clash-verge.png",
  ]
end
