TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Thibault Meyer <meyer.thibault@gmail.com>"
TERMUX_PKG_VERSION=8.12.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/libvips/libvips/releases/download/v${TERMUX_PKG_VERSION}/vips-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=565252992aff2c7cd10c866c7a58cd57bc536e03924bde29ae0f0cb9e074010b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, giflib, glib, harfbuzz, imagemagick, libc++, libcairo, libexif, libexpat, libheif, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openjpeg, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk-doc"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
