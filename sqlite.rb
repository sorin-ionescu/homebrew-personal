class Sqlite < Formula
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2015/sqlite-autoconf-3080900.tar.gz"
  sha256 "76ebb6392cd2289fbff903af7ff67f3e49bd01ff30544b8028ecededd60269a2"
  version "3.8.9"

  bottle do
    cellar :any
    sha256 "d5a52bf21f658982d67f09a51ef6e4a270b260f831560ced5eae7b45c58fc91e" => :yosemite
    sha256 "69ddf05054b7d5430d21c3d786d22f05a10bc98a71b02c24a2148f49f1943997" => :mavericks
    sha256 "cec7decc25d9a13c7ab57d94250856729ae40e51a9b66ced0ccc507e486c9492" => :mountain_lion
  end

  keg_only :provided_by_osx, "OS X provides an older sqlite3."

  option :universal
  option "with-docs", "Install HTML documentation"
  option "without-rtree", "Disable the R*Tree index module"
  option "with-fts", "Enable the FTS module"
  option "with-secure-delete", "Defaults secure_delete to on"
  option "with-unlock-notify", "Enable the unlock notification feature"
  option "with-icu4c", "Enable the ICU module"
  option "with-functions", "Enable more math and string functions for SQL queries"
  option "with-regexp", "Enable regular expressions for SQL queries"

  depends_on "readline" => :recommended
  depends_on "icu4c" => :optional

  if build.with? "regexp"
    depends_on "pkg-config" => :build
    depends_on "pcre"
  end

  resource "functions" do
    url "https://www.sqlite.org/contrib/download/extension-functions.c?get=25", :using  => :nounzip
    version "2010-01-06"
    sha256 "991b40fe8b2799edc215f7260b890f14a833512c9d9896aa080891330ffe4052"
  end

  resource "regexp" do
    url "https://raw.github.com/ralight/sqlite3-pcre/c98da412b431edb4db22d3245c99e6c198d49f7a/pcre.c", :using  => :nounzip
    version "2010-02-08"
    sha1 "fcc2355570e648ecb9a525252590c3770b04b3ac"
  end

  resource "docs" do
    url "https://sqlite.org/2015/sqlite-doc-3080900.zip"
    version "3.8.9"
    sha256 "aeeb5b9a410c3efabaccb13860dd04e3dbdfcd75e9f05fcb5c2a41d3a1f8f296"
  end

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE" if build.with? "rtree"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if build.with? "fts"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA"
    ENV.append "CPPFLAGS", "-DSQLITE_SECURE_DELETE" if build.with? "secure-delete"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_UNLOCK_NOTIFY" if build.with? "unlock-notify"

    if build.with? "icu4c"
      icu4c = Formula["icu4c"]
      icu4cldflags = `#{icu4c.opt_bin}/icu-config --ldflags`.tr("\n", " ")
      icu4ccppflags = `#{icu4c.opt_bin}/icu-config --cppflags`.tr("\n", " ")
      ENV.append "LDFLAGS", icu4cldflags
      ENV.append "CPPFLAGS", icu4ccppflags
      ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_ICU"
    end

    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--enable-dynamic-extensions"
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

    names = `#{bin}/sqlite3 < #{path}`.strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
    assert_equal 0, $?.exitstatus
  end
end
