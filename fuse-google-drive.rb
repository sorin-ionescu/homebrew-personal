require 'formula'

class FuseGoogleDrive < Formula
  homepage 'https://github.com/jcline/fuse-google-drive'
  head 'https://github.com/jcline/fuse-google-drive.git'

  depends_on 'automake' => :build if MacOS.xcode_version.to_f >= 4.3
  depends_on 'osxfuse' unless File.exists? '/usr/local/lib/libfuse.dylib'
  depends_on 'json-c'
  depends_on 'libxml2'

  def install
    if File.exists? '/usr/local/lib/libfuse.dylib'
      ENV.append_path 'PKG_CONFIG_PATH', '/usr/local/lib/pkgconfig'
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info osxfuse`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
