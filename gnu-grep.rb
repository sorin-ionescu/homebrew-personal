require 'formula'

class GnuGrep < Formula
  url 'http://ftpmirror.gnu.org/grep/grep-2.10.tar.xz'
  homepage 'http://www.gnu.org/software/grep/'
  md5 '709915434d09f5db655e5ebd7fd6bb7f'

  depends_on 'pcre'

  def install
    system "./configure", "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--info=#{info}"
    system "make"
    system "make install"
  end
end
