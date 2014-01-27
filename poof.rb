require "formula"

class Poof < Formula
  homepage "https://github.com/ruda/poof"
  url "https://github.com/ruda/poof/archive/2013.tar.gz"
  sha1 "4232d478ce08633742c3380267c8c57025a95e01"
  head "https://github.com/ruda/poof.git"

  def install
    system "make install PREFIX=#{prefix}"
  end

  test do
    system "poof"
  end
end
