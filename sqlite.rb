class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2016/sqlite-autoconf-3150100.tar.gz"
  version "3.15.1"
  sha256 "5dfa89b7697ee3c2ac7b44e8e157e7f204bf999c866afcaa8bb1c7ff656ae2c5"

  bottle do
    cellar :any
    sha256 "5930afd695e249a4aa24f7d62c6ec1fe01e384d374a777ceb142c71a5041e02c" => :sierra
    sha256 "fe2bebe84ac29e945b56c2e462bb73c2d34c963cf3852b6d962aa419fc7ba20d" => :el_capitan
    sha256 "aeacc77ade52894afbce93b3e9a29188c8f60cb451d7ade76c999b2e262df79c" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides an older sqlite3."

  option :universal
  option "with-docs", "Install HTML documentation"
  option "without-rtree", "Disable the R*Tree index module"
  option "with-fts", "Enable the FTS3 module"
  option "with-fts5", "Enable the FTS5 module (experimental)"
  option "with-secure-delete", "Defaults secure_delete to on"
  option "with-unlock-notify", "Enable the unlock notification feature"
  option "with-icu4c", "Enable the ICU module"
  option "with-functions", "Enable more math and string functions for SQL queries"
  option "with-dbstat", "Enable the 'dbstat' virtual table"
  option "with-json1", "Enable the JSON1 extension"
  option "with-session", "Enable the session extension"
  option "with-regexp", "Enable regular expressions for SQL queries"

  depends_on "readline" => :recommended
  depends_on "icu4c" => :optional

  if build.with? "regexp"
    depends_on "pkg-config" => :build
    depends_on "pcre"
  end

  resource "functions" do
    url "https://sqlite.org/contrib/download/extension-functions.c?get=25", :using => :nounzip
    version "2010-01-06"
    sha256 "991b40fe8b2799edc215f7260b890f14a833512c9d9896aa080891330ffe4052"
  end

  resource "regexp" do
    url "https://raw.github.com/ralight/sqlite3-pcre/c98da412b431edb4db22d3245c99e6c198d49f7a/pcre.c", :using  => :nounzip
    version "2010-02-08"
    sha256 "3173f4fa57f311c688886479873edce0f776f9567c8a9537a4747e9b4bb2c119"
  end

  resource "docs" do
    url "https://sqlite.org/2016/sqlite-doc-3150100.zip"
    version "3.15.1"
    sha256 "121363c75da7f6c8988f70dfa5bed5f0f06b5c9d37b4e2230316c55a80760825"
  end

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1" if build.with? "rtree"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1" if build.with? "fts"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS5=1" if build.with? "fts5"
    ENV.append "CPPFLAGS", "-DSQLITE_SECURE_DELETE=1" if build.with? "secure-delete"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_UNLOCK_NOTIFY=1" if build.with? "unlock-notify"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_DBSTAT_VTAB=1" if build.with? "dbstat"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1" if build.with? "json1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_PREUPDATE_HOOK=1 -DSQLITE_ENABLE_SESSION=1" if build.with? "session"

    if build.with? "icu4c"
      icu4c = Formula["icu4c"]
      icu4cldflags = `#{icu4c.opt_bin}/icu-config --ldflags`.tr("\n", " ")
      icu4ccppflags = `#{icu4c.opt_bin}/icu-config --cppflags`.tr("\n", " ")
      ENV.append "LDFLAGS", icu4cldflags
      ENV.append "CPPFLAGS", icu4ccppflags
      ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_ICU=1"
    end

    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-dynamic-extensions"
    system "make", "install"

    if build.with? "functions"
      buildpath.install resource("functions")
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "extension-functions.c",
                     "-o", "libsqlite3-functions.dylib",
                     *ENV.cflags.to_s.split
      lib.install "libsqlite3-functions.dylib"
    end

    if build.with? "regexp"
      buildpath.install resource("regexp")
      ENV.append_path "PKG_CONFIG_PATH", lib + "pkgconfig"
      ENV.append "CFLAGS", `pkg-config --cflags sqlite3 libpcre`.chomp.strip
      ENV.append "LDFLAGS", `pkg-config --libs libpcre`.chomp.strip
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "pcre.c",
                     "-o", "libsqlite3-regexp.dylib",
                     *(ENV.cflags.split + ENV.ldflags.split)
      lib.install "libsqlite3-regexp.dylib"
    end

    doc.install resource("docs") if build.with? "docs"
  end

  def caveats
    msg = ""
    if build.with? "functions" or build.with? "regexp" then msg += <<-EOS.undent
      Usage instructions for applications calling the SQLite3 API functions:

          In your application, call sqlite3_enable_load_extension(db, TRUE) to
          allow loading of external libraries. Then load the extension library
          using sqlite3_load_extension(filename, entrypoint).
          See http://www.sqlite.org/cvstrac/wiki?p=LoadableExtensions.

      Usage instructions for the sqlite3 program:

          Use either of the following two lines to load the extension library:

          sqlite> SELECT load_extension('#{lib}/libsqlite3-<extension>.dylib');
          sqlite> .load #{lib}/libsqlite3-<extension>.dylib

          The second line can be put in ~/.sqliterc to auto load the extension
          at startup.
    EOS
    end

    if build.with? 'functions' then msg += <<-EOS.undent

      libsqlite3-functions:

          Select statements may now use functions:

          SELECT cos(radians(inclination)) FROM satsum WHERE satnum = 25544;
    EOS
    end

    if build.with? 'regexp' then msg += <<-EOS.undent

      libsqlite3-regexp:

          Select statements may now use regular expressions:

          SELECT id,name FROM people WHERE name REGEXP '^George.*$';
    EOS
    end

    msg
  end

  test do
    path = testpath/"school.sql"
    path.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
