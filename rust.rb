class RustInstalled < Requirement
  fatal true

  satisfy do
    File.exists? '/usr/local/bin/rustc'
  end

  def message
    'Rust is not installed. Install it from https://www.rust-lang.org/.'
  end
end

class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage 'https://www.rust-lang.org/'
  url 'http://example.com', :using => :nounzip
  sha256 '3587cb776ce0e4e8237f215800b7dffba0f25865cb84550e87ea8bbac838c423'
  version '1.13.0'

  depends_on RustInstalled
  conflicts_with "multirust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  def install
    bin.mkpath
    Dir['/usr/local/bin/*'].grep(/cargo|rust*/).each do |file|
      File.symlink file, File.join(bin, File.basename(file))
    end

    (prefix + 'etc/bash_completion.d').mkpath
    File.symlink '/usr/local/etc/bash_completion.d/cargo', "#{prefix}/etc/bash_completion.d/cargo"

    lib.mkpath
    Dir['/usr/local/lib/*'].grep(
      /lib(arena|flate|fmt_macros|getopts|graphviz|log|proc_macro|rust*|serialize|std|syntax*|term|test)|rustlib/
    ).each do |file|
      File.symlink file, File.join(lib, File.basename(file))
    end

    (share + 'doc').mkpath
    Dir['/usr/local/share/doc/*'].grep(/cargo|rust/).each do |file|
      File.symlink file, File.join(share + 'doc', File.basename(file))
    end

    (share + 'man/man1').mkpath
    Dir['/usr/local/share/man/man1/*.1'].grep(/cargo*|rust*/).each do |file|
      File.symlink file, File.join(share + 'man/man1', File.basename(file))
    end

    (share + 'zsh/site-functions').mkpath
    File.symlink '/usr/local/share/zsh/site-functions/_cargo', "#{share}/zsh/site-functions/_cargo"
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<-EOS.undent
    fn main() {
      println!("Hello World!");
    }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
