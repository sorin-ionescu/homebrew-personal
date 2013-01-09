require 'formula'

class Colordiff < Formula
  homepage 'http://www.colordiff.org/'
  url 'http://www.colordiff.org/colordiff-1.0.13.tar.gz'
  sha1 '64e369aed2230f3aa5f1510b231fcac270793c09'

  def patches
    # Fixes the path to colordiffrc.
    # Uses git-diff colors due to Git popularity.
    # Improves wdiff support through better regular expressions.
    DATA
  end

  def install
    bin.install "colordiff.pl" => "colordiff"
    bin.install "cdiff.sh" => "cdiff"
    etc.install "colordiffrc"
    etc.install "colordiffrc-lightbg"
    man1.install "colordiff.1"
    man1.install "cdiff.1"
  end
end
__END__
diff --git i/colordiff.pl w/colordiff.pl
index 79376b5..8cece49 100755
--- i/colordiff.pl
+++ w/colordiff.pl
@@ -23,6 +23,7 @@
 
 use strict;
 use Getopt::Long qw(:config pass_through no_auto_abbrev);
+use File::Basename;
 use IPC::Open2;
 
 my $app_name     = 'colordiff';
@@ -64,7 +65,7 @@ my $cvs_stuff  = $colour{green};
 
 # Locations for personal and system-wide colour configurations
 my $HOME   = $ENV{HOME};
-my $etcdir = '/etc';
+my $etcdir = dirname(__FILE__) . "/../etc";
 my ($setting, $value);
 my @config_files = ("$etcdir/colordiffrc");
 push (@config_files, "$ENV{HOME}/.colordiffrc") if (defined $ENV{HOME});
@@ -480,8 +481,8 @@ foreach (@inputstream) {
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
-newtext=blue
+newtext=green
 oldtext=red
-diffstuff=magenta
-cvsstuff=green
+diffstuff=cyan
+cvsstuff=magenta
