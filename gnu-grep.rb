class GnuGrep < Formula
  homepage 'https://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.20.tar.xz'
  mirror 'https://ftp.gnu.org/gnu/grep/grep-2.20.tar.xz'
  sha256 'f0af452bc0d09464b6d089b6d56a0a3c16672e9ed9118fbe37b0b6aeaf069a65'

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
