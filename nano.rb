require 'formula'

class Nano < Formula
  homepage 'http://www.nano-editor.org/'
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.6.tar.gz'
  sha1 'f2a628394f8dda1b9f28c7e7b89ccb9a6dbd302a'
  head 'svn://svn.sv.gnu.org/nano/trunk/nano'

  devel do
    url 'http://www.nano-editor.org/dist/v2.3/nano-2.3.6.tar.gz'
    sha1 '7dd39f21bbb1ab176158e0292fd61c47ef681f6d'
  end

  depends_on "gettext"
  depends_on "libiconv"
  depends_on "sorin-ionescu/personal/ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--disable-nls",
                          "--enable-utf8",
                          "--with-ncurses=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  test do
    system "nano", "--version"
  end
end
