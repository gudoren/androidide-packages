TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION="108"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7fea5013da7f98daeeb6a0a60333e8aa917bcb0b1b418ba8531fe710d09041f2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
"
