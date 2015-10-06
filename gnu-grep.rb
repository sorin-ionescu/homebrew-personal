class GnuGrep < Formula
  homepage 'https://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.21.tar.xz'
  mirror 'https://ftp.gnu.org/gnu/grep/grep-2.21.tar.xz'
  sha256 '5244a11c00dee8e7e5e714b9aaa053ac6cbfa27e104abee20d3c778e4bb0e5de'

  depends_on 'pcre'

  def install
    system "./configure", "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--info=#{info}"
    system "make"
    system "make install"
  end

  test do
    system "ggrep", "--version"
  end
end
