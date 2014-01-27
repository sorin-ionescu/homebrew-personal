require 'formula'

class Breaknotify < Formula
  url 'https://github.com/sorin-ionescu/breaknotify.git', :revision => 'c1447c4f9a'
  homepage 'https://github.com/sorin-ionescu/breaknotify'
  head 'https://github.com/sorin-ionescu/breaknotify.git'
  version '20130226'

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
          <string>#{opt_prefix}/bin/breaknotifyd</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end

