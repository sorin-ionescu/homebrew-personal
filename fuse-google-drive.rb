require 'formula'

class FuseGoogleDrive < Formula
  homepage 'https://github.com/jcline/fuse-google-drive'
  head 'https://github.com/jcline/fuse-google-drive.git'

  depends_on 'automake' => :build if MacOS.xcode_version.to_f >= 4.3
  depends_on 'fuse4x' unless File.exists? '/usr/local/lib/libfuse.dylib'
  depends_on 'json-c'
  depends_on 'libxml2'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
