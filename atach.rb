class Atach < Formula
  url 'https://github.com/sorin-ionescu/attach/archive/v1.0.8.tar.gz'
  homepage 'https://github.com/sorin-ionescu/atach'
  sha256 '11455bc26c00c83c2542c0d462d2d7d80caac297ea2b68af363ed1b1267ad610'
  head 'https://github.com/sorin-ionescu/atach.git'

  depends_on 'dtach'

  def install
    bin.install 'atach'
    man1.install 'atach.1'
  end

  test do
    system 'attach', '--version'
  end
end
