require 'formula'

class Dvtm < Formula
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.10.tar.gz'
  sha1 '00e3d6cb746f8eace07e6784452d53781e76db13'
  head 'git://repo.or.cz/dvtm.git'

  depends_on 'ncurses'

  def install
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "dvtm", "-v"
  end
end
