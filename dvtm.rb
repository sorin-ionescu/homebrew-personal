require 'formula'

class Dvtm < Formula
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.8.tar.gz'
  sha1 '367fe528010a69c705cd046f63201c61086c14ec'
  head 'git://repo.or.cz/dvtm.git'

  def patches
    # Change the modifier from Ctrl + G to Ctrl + \.
    DATA
  end

  def install
    inreplace 'config.mk', 'LIBS = -lc -lutil -lncursesw', 'LIBS = -lc -lutil -lncurses'
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
__END__
diff --git 1/dvtm-0.7.a/config.h 2/dvtm-0.7.b/config.h
index 2b00776..cb00de6 100644
--- 1/config.h
+++ 2/config.h
@@ -53,7 +53,7 @@ Layout layouts[] = {
 	{ "[ ]", fullscreen },
 };

-#define MOD CTRL('g')
+#define MOD CTRL('\\')

 /* you can at most specifiy MAX_ARGS (2) number of arguments */
 Key keys[] = {