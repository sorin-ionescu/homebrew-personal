class Atach < Formula
  url 'https://github.com/sorin-ionescu/attach/archive/v1.0.8.tar.gz'
  homepage 'https://github.com/sorin-ionescu/atach'
  sha1 '0150d6db71040d3e602cf628d677df843bbcedd3'
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
