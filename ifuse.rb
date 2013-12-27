require 'formula'

class Ifuse < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/ifuse-1.1.2.tar.bz2'
  sha1 '885d88b45edb85c38b0ce9863f0d45fd378b5614'

  head do
    url 'http://cgit.sukimashita.com/ifuse.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libimobiledevice'
  depends_on 'osxfuse' unless File.exists? '/usr/local/lib/libfuse.dylib'

  def install
    if File.exists? '/usr/local/lib/libfuse.dylib'
      ENV.append_path 'PKG_CONFIG_PATH', '/usr/local/lib/pkgconfig'
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make install"
  end

  test do
    system "ifuse", "--version"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info osxfuse`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
