require 'formula'

class Ncurses < Formula
  homepage 'http://www.gnu.org/s/ncurses/'
  url 'http://ftpmirror.gnu.org/ncurses/ncurses-5.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
  sha1 '3e042e5f2c7223bffdaac9646a533b8c758b65b5'

  keg_only :provided_by_osx

  option :universal

  # Fix building C++ bindings with clang
  def patches
    { :p0 => "https://trac.macports.org/export/103963/trunk/dports/devel/ncurses/files/constructor_types.diff" }
  end

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
                          "--mandir=#{man}",
                          "--with-manpage-format=normal",
                          "--enable-pc-files",
                          "--enable-symlinks",
                          "--disable-mixed-case"

    system "make"
    system "make install"
    make_libncurses_symlinks
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]

    cd lib do
      %w{form menu ncurses panel}.each do |name|
        ln_s "lib#{name}w.#{major}.dylib", "lib#{name}.dylib"
        ln_s "lib#{name}w.#{major}.dylib", "lib#{name}.#{major}.dylib"
        ln_s "lib#{name}w.a", "lib#{name}.a"
        ln_s "lib#{name}w_g.a", "lib#{name}_g.a"
      end

      ln_s "libncurses++w.a", "libncurses++.a"
    end

    cd bin do
      ln_s "ncursesw#{major}-config", "ncurses#{major}-config"
    end
  end
end
