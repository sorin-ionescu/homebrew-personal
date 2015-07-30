class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.4/minidlna-1.1.4.tar.gz"
  sha256 "9814c04a2c506a0dd942c4218d30c07dedf90dabffbdef2d308a3f9f23545314"
  head "http://git.code.sf.net/p/minidlna/git", :using => :git
  revision 2

  option "with-tivo", "Build with TiVo support"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build
  depends_on "exif"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "libvorbis"

  # Use the Apple icon.
  # patch do
  #   url "https://gist.githubusercontent.com/sorin-ionescu/8118073/raw/e2c62c5a360dc4bccd52c9af36981f84674c8c4f/icon.patch"
  #   sha1 "ee3a2ba571b2643f08df92727ba442c2e1b8fda0"
  # end

  # Homebrew downloads the wrong patch using the commented code above.
  def patches
    # Use the Apple icon.
    "https://gist.githubusercontent.com/sorin-ionescu/8118073/raw/e2c62c5a360dc4bccd52c9af36981f84674c8c4f/icon.patch"
  end

  # Enable the '-S' switch to disable forking for launchd.
  patch do
    url "https://gist.githubusercontent.com/sorin-ionescu/8118073/raw/7734969fe95ea4db4f798fb94084f5d51f1f54bf/launchd.patch"
    sha1 "66ad6c5bcf9f067fcb041ba2d9c1dbfcf52592d9"
  end

  # Use FSEvents for filesystem notifications.
  patch do
    url "https://gist.githubusercontent.com/sorin-ionescu/8118073/raw/d7611b4cb3f7e2a47aba61382e31b04cc9ded282/fsevents.patch"
    sha1 "eb071da25c930982d9bfc285afb494dbb9347378"
  end

  def install
    inreplace "minidlna.conf" do |s|
      s.gsub! "#friendly_name=My DLNA Server", "friendly_name=MiniDLNA (#{`hostname -s`.strip})"
      s.gsub! "#db_dir=/var/cache/minidlna", "db_dir=#{ENV['HOME']}/Library/Application Support/minidlna"
      s.gsub! "#log_dir=/var/log", "log_dir=#{ENV['HOME']}/Library/Logs"
      s.gsub! "#presentation_url=http://www.mylan/index.php", "#presentation_url=http://localhost:8200/"
      s.gsub! "media_dir=/opt", <<-EOS.undent
        media_dir=P,#{ENV['HOME']}/Pictures
        media_dir=V,#{ENV['HOME']}/Movies
        media_dir=A,#{ENV['HOME']}/Music/iTunes/iTunes Music/Music
        media_dir=V,#{ENV['HOME']}/Music/iTunes/iTunes Music/Movies
        media_dir=V,#{ENV['HOME']}/Music/iTunes/iTunes Music/TV Shows
        media_dir=V,#{ENV['HOME']}/Music/iTunes/iTunes Music/Home Videos
      EOS
    end

    # Specify the C langauge version to make it compile.
    ENV.append "CFLAGS", "-std=gnu89"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
    ]

    args << "--enable-tivo" if build.with? "tivo"

    system "./autogen.sh"
    system "./configure", *args
    system "make"

    bin.install "minidlnad"
    etc.install "minidlna.conf"
    man5.install "minidlna.conf.5"
    man8.install "minidlnad.8"
  end

  test do
    system "#{bin}/minidlnad", "-V"
  end

  def caveats; <<-EOS.undent
    This formula pre-configurers MiniDLNA for single user mode.

    Link the configuration file and edit it as needed:

        ln -sfv #{etc}/minidlna.conf ~/Library/Preferences/minidlna.conf

    Start MiniDLNA manually:

        minidlnad -f ~/Library/Preferences/minidlna.conf -P ~/Library/Caches/minidlnad.pid
    EOS
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
        <key>EnableGlobbing</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/minidlnad</string>
            <string>-S</string>
            <string>-f</string>
            <string>#{ENV['HOME']}/Library/Preferences/minidlna.conf</string>
            <string>-P</string>
            <string>#{ENV['HOME']}/Library/Caches/minidlnad.pid</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
