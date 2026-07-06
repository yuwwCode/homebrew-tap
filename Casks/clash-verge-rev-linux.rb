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

  preflight do
    deb_file = Dir.glob("#{staged_path}/*.deb").first
    if deb_file
      system "ar", "x", deb_file, "data.tar.gz", chdir: staged_path.to_s
      system "tar", "xzf", "#{staged_path}/data.tar.gz", "-C", staged_path.to_s
      FileUtils.rm "#{staged_path}/data.tar.gz"
    end

    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    FileUtils.mkdir_p "#{Dir.home}/.local/share/icons"
  end

  postflight do
    desktop_source = "#{staged_path}/usr/share/applications/Clash Verge.desktop"
    if File.exist?(desktop_source)
      FileUtils.cp(desktop_source, "#{Dir.home}/.local/share/applications/clash-verge.desktop")
    end

    icons_dir = "#{staged_path}/usr/share/icons/hicolor"
    %w[32x32 128x128 256x256@2].each do |size|
      src = "#{icons_dir}/#{size}/apps/clash-verge.png"
      dst = "#{Dir.home}/.local/share/icons/hicolor/#{size}/apps/clash-verge.png"
      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.cp(src, dst) if File.exist?(src)
    end
  end

  zap trash: [
    "~/.config/clash-verge",
    "~/.local/share/applications/clash-verge.desktop",
    "~/.local/share/icons/hicolor/128x128/apps/clash-verge.png",
    "~/.local/share/icons/hicolor/256x256@2/apps/clash-verge.png",
    "~/.local/share/icons/hicolor/32x32/apps/clash-verge.png",
  ]

  caveats do
    [
      "TUN virtual network adapter support requires manual setup:",
      "",
      "1. Grant capabilities (once per install/upgrade):",
      "   sudo setcap cap_net_admin+ep $(readlink -f $(brew --prefix)/bin/verge-mihomo)",
      "",
      "2. Create service directory:",
      "mkdir -p ~/.config/systemd/user",
      "",
      "3. Save the following content as:",
      "   ~/.config/systemd/user/clash-verge-service.service",
      "---",
      "[Unit]",
      "Description=Clash Verge Service",
      "After=network-online.target",
      "",
      "[Service]",
      "Type=simple",
      "ExecStart=#{HOMEBREW_PREFIX}/bin/clash-verge-service",
      "Restart=always",
      "RestartSec=5",
      "",
      "[Install]",
      "WantedBy=default.target",
      "---",
      "",
      "4. Enable and start the service:",
      "systemctl --user daemon-reload",
      "systemctl --user enable --now clash-verge-service",
    ].join("\n")
  end
end
