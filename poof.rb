class Poof < Formula
  homepage "https://github.com/ruda/poof"
  url "https://github.com/ruda/poof/archive/2013.tar.gz"
  sha256 "9c4b03ff361d7dcd0ee9f767ffa60af5edfa640bd9f90cb8b049365884d786ac"
  head "https://github.com/ruda/poof.git"

  def install
    system "make install PREFIX=#{prefix}"
  end

  test do
    system "poof"
  end
end
