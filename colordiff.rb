class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "http://www.colordiff.org/"
  url "http://www.colordiff.org/colordiff-1.0.15.tar.gz"
  sha256 "595ee4e9796ba02fad0b181e21df3ee34ae71d1611e301e146c0bf00c5269d45"

  bottle do
    cellar :any
    sha256 "c5ed797abdaedc5a5f163bafce625307249408afd87bd1a2d31b086af29e02d6" => :yosemite
    sha256 "a316bce78fc4bfd7fead8f6a6ce87161e9bd862e61882c72be60bcc42d248db1" => :mavericks
    sha256 "45232a4a2de9ccf1848b28593d2a870efaf38017b465fdb8f04e261f7ccad8e7" => :mountain_lion
  end

  # Fixes Makefile.
  # Fixes the path to colordiffrc.
  # Uses git-diff colors due to Git popularity.
  # Improves wdiff support through better regular expressions.
  patch :DATA

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 6ccbfc7..e5d64e7 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +29,8 @@ install:
 	if [ ! -f ${DESTDIR}${INSTALL_DIR}/cdiff ] ; then \
 	  install cdiff.sh ${DESTDIR}${INSTALL_DIR}/cdiff; \
 	fi
-	install -Dm 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
-	install -Dm 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
+	install -m 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
+	install -m 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
 	if [ -f ${DESTDIR}${ETC_DIR}/colordiffrc ]; then \
 	  mv -f ${DESTDIR}${ETC_DIR}/colordiffrc \
 	    ${DESTDIR}${ETC_DIR}/colordiffrc.old; \
@@ -37,7 +38,6 @@ install:
 	  install -d ${DESTDIR}${ETC_DIR}; \
 	fi
 	cp colordiffrc ${DESTDIR}${ETC_DIR}/colordiffrc
-	-chown root.root ${DESTDIR}${ETC_DIR}/colordiffrc
 	chmod 644 ${DESTDIR}${ETC_DIR}/colordiffrc

 .PHONY: uninstall
diff --git i/colordiff.pl w/colordiff.pl
index 79376b5..8cece49 100755
--- i/colordiff.pl
+++ w/colordiff.pl
@@ -24,4 +23,5 @@
 use strict;
 use Getopt::Long qw(:config pass_through no_auto_abbrev);
+use File::Basename;

 my $app_name     = 'colordiff';
@@ -63,7 +64,7 @@ my $cvs_stuff  = $colour{green};

 # Locations for personal and system-wide colour configurations
 my $HOME   = $ENV{HOME};
-my $etcdir = '/etc';
+my $etcdir = dirname(__FILE__) . "/../etc";
 my ($setting, $value);
 my @config_files = ("$etcdir/colordiffrc");
 push (@config_files, "$ENV{HOME}/.colordiffrc") if (defined $ENV{HOME});
@@ -534,8 +535,8 @@ foreach (@inputstream) {
         }
     }
     elsif ($diff_type eq 'wdiff') {
-        $_ =~ s/(\[-.+?-\])/$file_old$1$colour{off}/g;
-        $_ =~ s/(\{\+.+?\+\})/$file_new$1$colour{off}/g;
+        $_ =~ s/(\[-([^-]*(-[^]])?)*-\])/$file_old$1$colour{off}/g;
+        $_ =~ s/(\{\+([^+]*(\+[^}])?)*\+\})/$file_new$1$colour{off}/g;
     }
     elsif ($diff_type eq 'debdiff') {
         $_ =~ s/(\[-.+?-\])/$file_old$1$colour{off}/g;
diff --git i/colordiffrc w/colordiffrc
index 4bcb02d..c46043e 100644
--- i/colordiffrc
+++ w/colordiffrc
@@ -23,7 +23,7 @@ diff_cmd=diff
 # this, use the default output colour"
 #
 plain=off
-newtext=darkgreen
+newtext=green
 oldtext=darkred
-diffstuff=darkcyan
-cvsstuff=cyan
+diffstuff=cyan
+cvsstuff=magenta
