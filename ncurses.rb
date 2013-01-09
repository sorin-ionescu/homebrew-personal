require 'formula'

class Ncurses < Formula
  homepage 'http://www.gnu.org/s/ncurses/'
  url 'http://ftpmirror.gnu.org/ncurses/ncurses-5.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
  sha1 '3e042e5f2c7223bffdaac9646a533b8c758b65b5'

  option :universal

  def install
    ENV.universal_binary if build.universal?

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
