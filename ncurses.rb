require 'formula'

class Ncurses < Formula
  url 'http://ftpmirror.gnu.org/ncurses/ncurses-5.9.tar.gz'
  homepage 'http://www.gnu.org/s/ncurses/'
  sha1 '3e042e5f2c7223bffdaac9646a533b8c758b65b5'

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-widec",
                          "--enable-overwrite",
                          "--with-shared",
                          "--without-ada",
                          "--enable-sigwinch",
                          "--mandir=${prefix}/share/man",
                          "--with-manpage-format=normal",
                          "--enable-pc-files",
                          "--enable-symlinks",
                          "--disable-mixed-case"

    system "make"
    system "make install"
  end
end
