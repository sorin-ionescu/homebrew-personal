require 'formula'

class ItunesNotify < Formula
  url 'http://cmus.sourceforge.net/wiki/lib/exe/fetch.php?media=itunes-notify.c.zip'
  homepage 'http://cmus.sourceforge.net/wiki/doku.php?id=status_display_programs'
  version '20110818'

  def install
    system 'cc itunes-notify.c -framework CoreFoundation -o itunes-notify'
    bin.install 'itunes-notify'
  end

  test do
    system "itunes-notify"
  end
end
