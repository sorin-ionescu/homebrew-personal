require 'formula'

class Tor < Formula
  homepage 'https://www.torproject.org/'
  url 'https://www.torproject.org/dist/tor-0.2.3.25.tar.gz'
  sha1 'ef02e5b0eb44ab1a5d6108c39bd4e28918de79dc'

  depends_on 'libevent'

  def patches
    # Fix the path to the control cookie.
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    bin.install "contrib/tor-ctrl.sh" => "tor-ctrl"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
__END__

diff --git c/contrib/tor-ctrl.sh i/contrib/tor-ctrl.sh
index 58320ce..942dfef 100644
--- c/contrib/tor-ctrl.sh
+++ i/contrib/tor-ctrl.sh
@@ -58,7 +58,7 @@
 VERSION=v1
 TORCTLIP=127.0.0.1
 TORCTLPORT=9051
-TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"
+TOR_COOKIE="$HOME/.tor/control_auth_cookie"
 SLEEP_AFTER_CMD=1
 VERBOSE=0
