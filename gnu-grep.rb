require 'formula'

class GnuGrep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.15.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/grep/grep-2.15.tar.xz'
  sha1 '1dffd7a82761166cc4d39727944655233c2d95fd'

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
