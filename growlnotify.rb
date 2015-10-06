class Growlnotify < Formula
  homepage 'http://growl.info/extras.php#growlnotify'
  url 'https://github.com/indirect/growlnotify/archive/v1.3.tar.gz'
  sha256 'f7fd55d256e1680faf8ffe22a13e73b1fd2cf3776683409031651665369fd56b'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end

  test do
    system "growlnotify", "--version"
  end
end
