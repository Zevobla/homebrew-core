class Gostcoin < Formula
  desc "Blockchain-based digital currency for privacy"
  homepage "https://gostco.in"
  url "https://github.com/GOSTSec/gostcoin/archive/refs/heads/master.tar.gz"
  version "0.8.5.12"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "qt@5" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"
  depends_on "qrencode"

  def install
    ENV.cxx11

    qt5 = Formula["qt@5"].opt_prefix
    berkeleydb = Formula["berkeley-db@4"].opt_prefix
    openssl = Formula["openssl@3"].opt_prefix
    boost = Formula["boost"].opt_prefix

    # Set up environment for dependencies
    ENV.append "CPPFLAGS", "-I#{openssl}/include"
    ENV.append "CPPFLAGS", "-I#{berkeleydb}/include"
    ENV.append "CPPFLAGS", "-I#{boost}/include"
    ENV.append "LDFLAGS", "-L#{openssl}/lib"
    ENV.append "LDFLAGS", "-L#{berkeleydb}/lib"
    ENV.append "LDFLAGS", "-L#{boost}/lib"

    # Additional flags for compatibility
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++"

    # Fix Qt5 API compatibility issues
    inreplace "src/qt/gostcoin.cpp",
              "QLibraryInfo::path(QLibraryInfo::TranslationsPath)",
              "QLibraryInfo::location(QLibraryInfo::TranslationsPath)"

    # Override qmake's hardcoded paths with our Homebrew dependency paths
    system "#{qt5}/bin/qmake",
           "OPENSSL_INCLUDE_PATH=#{openssl}/include",
           "OPENSSL_LIB_PATH=#{openssl}/lib",
           "BDB_INCLUDE_PATH=#{berkeleydb}/include",
           "BDB_LIB_PATH=#{berkeleydb}/lib",
           "BOOST_INCLUDE_PATH=#{boost}/include",
           "BOOST_LIB_PATH=#{boost}/lib",
           "QRENCODE_INCLUDE_PATH=#{Formula["qrencode"].opt_include}",
           "QRENCODE_LIB_PATH=#{Formula["qrencode"].opt_lib}",
           "USE_QRCODE=1"
    system "make"

    # Install the macOS app bundle
    prefix.install "GOSTCoin-Qt.app"

    # Create a symlink in bin for command line access
    bin.write_exec_script "#{prefix}/GOSTCoin-Qt.app/Contents/MacOS/GOSTCoin-Qt"
  end
end
