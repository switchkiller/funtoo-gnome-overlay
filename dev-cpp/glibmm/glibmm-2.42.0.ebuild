# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+ GPL-2+" # GPL-2+ applies only to the build system
SLOT="2"
KEYWORDS="~*"
IUSE="doc debug examples test"

RDEPEND="
	>=dev-libs/libsigc++-2.2.10:2
	>=dev-libs/glib-2.40:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
# dev-cpp/mm-common needed for eautoreconf

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die "sed 1 failed"
	fi

	if ! use examples; then
		# don't waste time building examples
		sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die "sed 2 failed"
	fi

	# Test fails with IPv6 but not v4, upstream bug #720073
	sed -e 's:giomm_tls_client/test::' \
		-i tests/Makefile.{am,in} || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable debug debug-refcounting) \
		$(use_enable doc documentation) \
		--enable-deprecated-api
}

src_test() {
	cd "${S}/tests/"
	default

	for i in */test; do
		${i} || die "Running tests failed at ${i}"
	done
}

src_install() {
	gnome2_src_install

	if ! use doc && ! use examples; then
		rm -fr "${ED}usr/share/doc/glibmm*"
	fi

	if use examples; then
		find examples -type d -name '.deps' -exec rm -rf {} \; 2>/dev/null
		dodoc -r examples
	fi
}
