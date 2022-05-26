TERMUX_PKG_HOMEPAGE=https://solidity.readthedocs.io
TERMUX_PKG_DESCRIPTION="An Ethereum smart contract-oriented language."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION="0.8.14"
TERMUX_PKG_SRCURL=https://github.com/ethereum/solidity/releases/download/v${TERMUX_PKG_VERSION}/solidity_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ccdf20c889206103d0a48fe10b1c3f1f21269070861e80382f7ede8785e61d4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, jsoncpp"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_Z3=OFF
-DUSE_CVC4=OFF
-DUSE_LD_GOLD=OFF
-DBoost_USE_STATIC_LIBS=OFF
"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	LDFLAGS+=" -ljsoncpp"
}
