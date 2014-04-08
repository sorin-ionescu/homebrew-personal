require 'formula'

class Sqlite < Formula
  homepage 'http://sqlite.org/'
  url 'http://sqlite.org/2014/sqlite-autoconf-3080403.tar.gz'
  version '3.8.4.3'
  sha1 '70f3b100fa22e5bfebfe1b0a2102612e3c6c53fb'

  bottle do
    cellar :any
    sha1 "f8099e15c5ffd67f861ea09651cb7ae0c4dfa359" => :mavericks
    sha1 "c25f37d9cd188465dd568e9f49c22b95a2320835" => :mountain_lion
    sha1 "d40eacfc3df225d16dc0908bf450b47a27a27d44" => :lion
  end

  keg_only :provided_by_osx, "OS X provides an older sqlite3."

  option :universal
  option 'with-docs', 'Install HTML documentation'
  option 'without-rtree', 'Disable the R*Tree index module'
  option 'with-fts', 'Enable the FTS module'
  option 'with-functions', 'Enable more math and string functions for SQL queries'
  option 'with-regexp', 'Enable regular expressions for SQL queries'

  depends_on 'readline' => :recommended

  if build.with? 'regexp'
    depends_on 'pkg-config' => :build
    depends_on 'pcre'
  end

  resource 'functions' do
    url 'http://www.sqlite.org/contrib/download/extension-functions.c?get=25', :using  => :nounzip
    version '2010-01-06'
    sha1 'c68fa706d6d9ff98608044c00212473f9c14892f'
  end

  resource 'regexp' do
    url 'https://raw2.github.com/ralight/sqlite3-pcre/c98da412b431edb4db22d3245c99e6c198d49f7a/pcre.c', :using  => :nounzip
    version '2010-02-08'
    sha1 'fcc2355570e648ecb9a525252590c3770b04b3ac'
  end

  resource 'docs' do
    url 'http://sqlite.org/2014/sqlite-doc-3080402.zip'
    version '3.8.4.2'
    sha1 '3f615f9fa81b737e652b06eddef8307235d84f2c'
  end

  def install
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_RTREE" if build.with? "rtree"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if build.with? "fts"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_COLUMN_METADATA"

    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--enable-dynamic-extensions"
    system "make install"

    if build.with? "functions"
      buildpath.install resource('functions')
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "extension-functions.c",
                     "-o", "libsqlite3-functions.dylib",
                     *ENV.cflags.split
      lib.install "libsqlite3-functions.dylib"
    end

    if build.with? "regexp"
      buildpath.install resource('regexp')
      ENV.append_path 'PKG_CONFIG_PATH', lib + 'pkgconfig'
      ENV.append 'CFLAGS', `pkg-config --cflags sqlite3 libpcre`.chomp.strip
      ENV.append 'LDFLAGS', `pkg-config --libs libpcre`.chomp.strip
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "pcre.c",
                     "-o", "libsqlite3-regexp.dylib",
                     *(ENV.cflags.split + ENV.ldflags.split)
      lib.install "libsqlite3-regexp.dylib"
    end

    doc.install resource('docs') if build.with? "docs"
  end

  def caveats
    msg = ''
    if build.with? 'functions' or build.with? "regexp" then msg += <<-EOS.undent
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
