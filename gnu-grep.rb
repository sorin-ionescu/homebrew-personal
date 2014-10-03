require 'formula'

class GnuGrep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.20.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/grep/grep-2.20.tar.xz'
  sha1 '55aac6158b51baa505669cf8f86440bcc106ec65'

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
