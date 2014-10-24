# Distributed under the terms of the GNU General Public License v2

EAPI="5"

VALA_MIN_API_VERSION="0.24"
PYTHON_COMPAT=( python{3_2,3_3,3_4} )

inherit autotools gnome2 python-r1 vala

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Gitg"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~*"
IUSE="debug glade +python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# test if unbundling of libgd is possible
# Currently it seems not to be (unstable API/ABI)
RDEPEND="
	dev-libs/libgee:0.8[introspection]
	>=dev-libs/json-glib-1.0.2
	>=app-text/gtkspell-3.0.3:3
	>=dev-libs/glib-2.42.0:2
	>=dev-libs/gobject-introspection-1.42.0
	dev-libs/libgit2[threads]
	>=dev-libs/libgit2-glib-0.0.20
	>=dev-libs/libpeas-1.12.0[gtk]
	>=gnome-base/gsettings-desktop-schemas-3.14.0
	|| (
		>=net-libs/webkit-gtk-2.2:4[introspection]
		>=net-libs/webkit-gtk-2.2:3[introspection] )
	>=x11-libs/gtk+-3.14.0:3
	>=x11-libs/gtksourceview-3.14.0:3.0
	x11-themes/adwaita-icon-theme
	glade? ( >=dev-util/glade-3.2:3.10 )
	python? (
		${PYTHON_DEPS}
		dev-libs/libpeas[python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	$(vala_depend)"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	sed \
		-e '/CFLAGS/s:-g::g' \
		-e '/CFLAGS/s:-O0::g' \
		-i configure.ac || die
	eautoreconf
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-deprecations \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable glade glade-catalog) \
		$(use_enable python)
}

src_install() {
	gnome2_src_install -j1
}