# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Guile"
version = v"2.2.4"

# Collection of sources required to build Guile
sources = [
    "https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.gz" =>
    "33b904c0bf4e48e156f3fb1d0e6b0392033bd610c6c9d9a0410c6e0ea96a3e5c",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd guile-2.2.4/
./configure LDFLAGS=-L$prefix/lib CFLAGS=-I$prefix/include --prefix=$prefix --host=$targt
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libguile", :libguile),
    ExecutableProduct(prefix, "guile", :guile)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libiconv-v1.15-0/build_Libiconv.v1.15.0.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Gettext-v0.19.8-0/build_Gettext.v0.19.8.jl",
    "https://github.com/yukota/LibtoolBuilder/releases/download/v2.4.6-1/build_Libtool.v2.4.6.jl",
    "https://github.com/yukota/libunistringBuilder/releases/download/v0.9.10-2/build_libunistring.v0.9.10.jl",
    "https://github.com/yukota/libgcBuilder/releases/download/v8.0.2-0/build_libgc.v8.0.2.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libffi-v3.2.1-0/build_Libffi.v3.2.1.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

