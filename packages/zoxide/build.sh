TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@itsaky"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=55f4bf374421f842f5541d95db14d7a63f5d24e269613fb95f769f00cdb9ffc3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f ./Makefile
}

termux_step_post_make_install() {
	# Install man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp -r $TERMUX_PKG_SRCDIR/man/* $TERMUX_PREFIX/share/man/man1/
}
