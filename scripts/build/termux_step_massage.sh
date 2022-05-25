termux_step_massage() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"

	# Remove lib/charset.alias which is installed by gettext-using packages:
	rm -f lib/charset.alias

	# Remove locale files we're not interested in::
	rm -Rf share/locale

	# Remove old kept libraries (readline):
	find . -name '*.old' -print0 | xargs -0 -r rm -f

	# Move over sbin to bin:
	for file in sbin/*; do if test -f "$file"; then mv "$file" bin/; fi; done

	# Remove world permissions and make sure that user still have read-write permissions.
	chmod -Rf u+rw,g-rwx,o-rwx . || true

	if [ "$TERMUX_DEBUG_BUILD" = "false" ]; then
		# Strip binaries. file(1) may fail for certain unusual files, so disable pipefail.
		set +e +o pipefail
		find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" \) -type f |
			xargs -r file | grep -E "ELF .+ (executable|shared object)" | cut -f 1 -d : |
			xargs -r "$STRIP" --strip-unneeded --preserve-dates
		set -e -o pipefail
	fi

	if [ "$TERMUX_PKG_NO_ELF_CLEANER" != "true" ]; then
		# Remove entries unsupported by Android's linker:
		find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" -o -path "./opt/*" \) -type f -print0 | xargs -r -0 "$TERMUX_ELF_CLEANER"
	fi

	if [ "$TERMUX_PKG_NO_SHEBANG_FIX" != "true" ]; then
		# Fix shebang paths:
		while IFS= read -r -d '' file; do
			head -c 100 "$file" | grep -E "^#\!.*\\/bin\\/.*" | grep -q -E -v "^#\! ?\\/system" &&
				sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$TERMUX_PREFIX/bin/\2@" "$file"
		done < <(find -L . -type f -print0)
	fi

	# Delete the info directory file.
	rm -rf ./share/info/dir

	# Mostly specific to X11-related packages.
	rm -f ./share/icons/hicolor/icon-theme.cache

	test ! -z "$TERMUX_PKG_RM_AFTER_INSTALL" && rm -Rf $TERMUX_PKG_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

	if [ -d share/man ]; then
		# Remove non-english man pages:
		find share/man -mindepth 1 -maxdepth 1 -type d ! -name man\* | xargs -r rm -rf

		# Compress man pages with gzip:
		find share/man -type f ! -iname \*.gz -print0 | xargs -r -0 gzip

		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
		while IFS= read -r -d '' file; do
			local _link_value
			_link_value=$(readlink $file)
			rm $file
			ln -s $_link_value.gz $file.gz
		done < <(find share/man -type l ! -iname \*.gz -print0)
	fi

	# Check so files were actually installed. Exclude
	# share/doc/$TERMUX_PKG_NAME/ as a license file is always
	# installed there.
	if [ "$(find . -type f -not -path "./share/doc/$TERMUX_PKG_NAME/*")" = "" ]; then
		termux_error_exit "No files in package. Maybe you need to run autoreconf -fi before configuring?"
	fi

	local HARDLINKS
	HARDLINKS="$(find . -type f -links +1)"
	if [ -n "$HARDLINKS" ]; then
		termux_error_exit "Package contains hard links: $HARDLINKS"
	fi

	# Check so that package is not affected by https://github.com/android/ndk/issues/1614
	SYMBOLS="$(readelf -s $($TERMUX_HOST_PLATFORM-clang -print-libgcc-file-name) | grep "FUNC    GLOBAL HIDDEN" | awk '{print $8}')"
	# Also check for unresolved symbols defined in libandroid-* (#9944)
	SYMBOLS+=" $(echo libandroid_{sem_{open,close,unlink},shm{ctl,get,at,dt}})"
	LIBRARIES=""
	if [ -d "lib" ]; then
		LIBRARIES="$(find lib -name "*.so")"
	fi
	for lib in $LIBRARIES; do
		for sym in $SYMBOLS; do
			if ! readelf -h $lib &> /dev/null; then
				continue
			fi
			if readelf -s $lib | egrep 'NOTYPE[[:space:]]+GLOBAL[[:space:]]+DEFAULT[[:space:]]+UND[[:space:]]+'$sym'$' &> /dev/null; then
				termux_error_exit "$lib contains undefined symbol $sym"
			fi
		done
	done

	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
		termux_create_debian_subpackages
	elif [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		termux_create_pacman_subpackages
	fi

	# Remove unnecessary files in haskell pacakges:
	if [[ "${TERMUX_PKG_NAME}" != "ghc-libs" ]] && [[ "${TERMUX_PKG_NAME}" != "ghc" ]]; then
		test -d ./lib/ghc-* && rm -rf ./lib/ghc-* 2>/dev/null # Remove full ghc-* dir since cross compiler installs packages in "./lib/${TERMUX_ARCH}-android-ghc-X.Y.Z"
	fi

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
}
