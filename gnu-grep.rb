require 'formula'

class GnuGrep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.14.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/grep/grep-2.14.tar.xz'
  sha1 'fb6ea404a0ef915334ca6212c7b517432ffe193e'

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
