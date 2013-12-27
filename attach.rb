require 'formula'

class Attach < Formula
  url 'https://github.com/sorin-ionescu/attach/archive/1.0.7.tar.gz'
  homepage 'https://github.com/sorin-ionescu/attach'
  head 'https://github.com/sorin-ionescu/attach.git'

  depends_on 'dtach'

  def install
    bin.install 'attach'
    man1.install 'attach.1'
  end
end

