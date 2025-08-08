class SchemeBytestructures < Formula
  desc "Structured access to bytevector contents in Scheme"
  homepage "https://github.com/TaylanUB/scheme-bytestructures"
  url "https://github.com/TaylanUB/scheme-bytestructures/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "b0681daa006c80efd2fce5dc174ac439d44be8a9c2e70938e497efad08cd5659"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "guile"

  def install
    ENV["GUILE_LOAD_PATH"] = lib.to_s
    ENV.prepend_path "PATH", Formula["libtool"].opt_bin
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    system "guile", "-c", "(import (bytestructures guile))"
  end
end
