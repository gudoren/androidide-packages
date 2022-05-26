TERMUX_PKG_HOMEPAGE=https://strophe.im/libstrophe
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C."
TERMUX_PKG_LICENSE="MIT, GPL-3.0"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/releases/download/${TERMUX_PKG_VERSION}/libstrophe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f7b7b8bdc268ff1b9eed6a9796777a6f8fac62b40fe316cfe91323696805b64
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, libexpat, c-ares"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cares"

termux_step_pre_configure() {
	./bootstrap.sh
}
