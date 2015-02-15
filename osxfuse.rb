class OsxfuseInstalled < Requirement
  fatal true

  satisfy do
    File.exists? '/usr/local/lib/libosxfuse.dylib'
  end

  def message
    'OSXFUSE is not installed. Install it from http://osxfuse.github.io.'
  end
end

class Osxfuse < Formula
  homepage 'http://osxfuse.github.io'
  url 'http://example.com', :using => :nounzip
  sha1 '0e973b59f476007fd10f87f347c3956065516fc0'
  version '2.7.5'

  depends_on OsxfuseInstalled
  depends_on :macos => :snow_leopard
  conflicts_with 'fuse4x', :because => 'both install `fuse.pc`'

  def install
    include.mkpath
    File.symlink '/usr/local/include/osxfuse', File.join(include, 'osxfuse')

    lib.mkpath
    Dir['/usr/local/lib/libosxfuse*'].each do |file|
      File.symlink file, File.join(lib, File.basename(file))
    end

    (lib + 'pkgconfig').mkpath
    Dir['/usr/local/lib/pkgconfig/*fuse.pc'].each do |file|
      File.symlink file, File.join("#{lib}/pkgconfig", File.basename(file))
    end
  end
end
