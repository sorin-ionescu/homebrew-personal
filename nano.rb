require 'formula'

class Nano < Formula
  homepage 'http://www.nano-editor.org/'
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.6.tar.gz'
  sha1 'f2a628394f8dda1b9f28c7e7b89ccb9a6dbd302a'
  head 'svn://svn.sv.gnu.org/nano/trunk/nano'

  devel do
    url 'http://www.nano-editor.org/dist/v2.3/nano-2.3.6.tar.gz'
    sha1 '7dd39f21bbb1ab176158e0292fd61c47ef681f6d'
  end

  depends_on "gettext"
  depends_on "sorin-ionescu/personal/ncurses"

  # Fixes regex in the default nanorc.nanorc; fixed upstream:
  # http://savannah.gnu.org/bugs/index.php?42929
  patch :DATA if build.devel?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--disable-nls",
                          "--enable-utf8",
                          "--with-ncurses=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  test do
    system "nano", "--version"
  end
end


__END__
diff --git a/doc/syntax/nanorc.nanorc b/doc/syntax/nanorc.nanorc
index fd66d6b..6e52942 100644
--- a/doc/syntax/nanorc.nanorc
+++ b/doc/syntax/nanorc.nanorc
@@ -7,7 +7,7 @@ icolor brightred "^[[:space:]]*((un)?(bind|set)|include|syntax|header|magic|lint

 # Keywords
 icolor brightgreen "^[[:space:]]*(set|unset)[[:space:]]+(allow_insecure_backup|autoindent|backup|backwards|boldtext|casesensitive|const|cut|fill|historylog|locking|morespace|mouse|multibuffer|noconvert|nofollow|nohelp|nonewlines|nowrap|poslog|preserve|quickblank|quiet|rebinddelete|rebindkeypad|regexp|smarthome|smooth|softwrap|suspend|tabsize|tabstospaces|tempfile|undo|view|wordbounds)\>"
-icolor yellow "^[[:space:]]*set[[:space:]]+(functioncolor|keycolor||statuscolor|titlecolor)[[:space:]]+(bright)?(white|black|red|blue|green|yellow|magenta|cyan)?(,(white|black|red|blue|green|yellow|magenta|cyan))?\>"
+icolor yellow "^[[:space:]]*set[[:space:]]+(functioncolor|keycolor|statuscolor|titlecolor)[[:space:]]+(bright)?(white|black|red|blue|green|yellow|magenta|cyan)?(,(white|black|red|blue|green|yellow|magenta|cyan))?\>"
 icolor brightgreen "^[[:space:]]*set[[:space:]]+(backupdir|brackets|functioncolor|keycolor|matchbrackets|operatingdir|punct|quotestr|speller|statuscolor|titlecolor|whitespace)[[:space:]]+"
 icolor brightgreen "^[[:space:]]*bind[[:space:]]+((\^|M-)([[:alpha:]]|space|[]]|[0-9_=+{}|;:'\",./<>\?-])|F([1-9]|1[0-6])|Ins|Del)[[:space:]]+[[:alpha:]]+[[:space:]]+[[:alpha:]]+[[:space:]]*$"
 icolor brightgreen "^[[:space:]]*unbind[[:space:]]+((\^|M-)([[:alpha:]]|space|[]]|[0-9_=+{}|;:'\",./<>\?-])|F([1-9]|1[0-6])|Ins|Del)[[:space:]]+[[:alpha:]]+[[:space:]]*$"
