require 'formula'

class Nano < Formula
  homepage 'http://www.nano-editor.org/'
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.6.tar.gz'
  sha1 'f2a628394f8dda1b9f28c7e7b89ccb9a6dbd302a'
  head 'svn://svn.sv.gnu.org/nano/trunk/nano'

  devel do
    url 'http://www.nano-editor.org/dist/v2.3/nano-2.3.2.tar.gz'
    sha1 '5d4bed4f15088fc3cba0650a89bd343b061f456d'
  end

  depends_on "gettext"
  depends_on "libiconv"
  depends_on "ncurses"

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
end
