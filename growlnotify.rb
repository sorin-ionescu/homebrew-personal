require 'formula'

class Growlnotify < Formula
  homepage 'http://growl.info/extras.php#growlnotify'
  url 'https://github.com/indirect/growlnotify/tarball/v1.3'
  sha1 '928047d8561041f4a0c402751768ff870bfcdf6d'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end
end
