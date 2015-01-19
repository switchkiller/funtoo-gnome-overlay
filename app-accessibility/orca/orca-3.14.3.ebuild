# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE="threads"

inherit gnome2 python-r1

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/Orca"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE="+braille"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# liblouis is not in portage yet
# it is used to provide contracted braille support
# XXX: Check deps for correctness
COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.14:2
	>=app-accessibility/at-spi2-core-2.14:2[introspection]
	>=dev-libs/atk-2.14
	>=dev-libs/glib-2.42:2
	>=dev-python/pygobject-3.14:3[${PYTHON_USEDEP}]
	>=x11-libs/gtk+-3.14:3[introspection]
	braille? (
		>=app-accessibility/brltty-5.0-r3[python,${PYTHON_USEDEP}]
		dev-libs/liblouis[python,${PYTHON_USEDEP}] )
	${PYTHON_DEPS}
"
RDEPEND="${COMMON_DEPEND}
	>=app-accessibility/speech-dispatcher-0.8[python,${PYTHON_USEDEP}]
	dev-libs/atk[introspection]
	dev-python/pyatspi[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"
#	app-text/yelp-tools

src_prepare() {
	gnome2_src_prepare

	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome2_src_configure \
		ITSTOOL="$(type -P true)" \
		$(use_with braille liblouis)
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_install() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"
	installing() {
		gnome2_src_install
		# Massage shebang to make python_doscript happy
		sed -e 's:#!'"${PYTHON}:#!/usr/bin/python:" \
			-i src/orca/orca || die
		python_doscript src/orca/orca
	}
	python_foreach_impl run_in_build_dir installing
}
