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
  desc "FUSE for OS X: extend native file handling via 3rd-party file systems"
  homepage 'http://osxfuse.github.io'
  url 'http://example.com', :using => :nounzip
  sha256 '3587cb776ce0e4e8237f215800b7dffba0f25865cb84550e87ea8bbac838c423'
  version '2.8.2'

  depends_on OsxfuseInstalled
  depends_on :macos => :snow_leopard
  conflicts_with 'homebrew/fuse/fuse4x', :because => 'both install `fuse.pc`'

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
