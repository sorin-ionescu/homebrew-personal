class Growlnotify < Formula
  homepage 'http://growl.info/extras.php#growlnotify'
  url 'https://github.com/indirect/growlnotify/archive/v1.3.tar.gz'
  sha1 'fcfcd8d939994af2303bb7ce65e4ae839d7e216b'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end

  test do
    system "growlnotify", "--version"
  end
end
