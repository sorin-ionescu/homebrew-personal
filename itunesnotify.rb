require 'formula'

class Itunesnotify < Formula
  homepage 'https://github.com/sorin-ionescu/itunesnotify'
  head 'https://github.com/sorin-ionescu/itunesnotify.git'

  depends_on 'growl-framework'

  def install
    ENV.append 'CFLAGS', "-F#{HOMEBREW_PREFIX}/Frameworks"
    system "make install prefix=#{prefix}"
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
          <string>#{opt_prefix}/bin/itunesnotifyd</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end

