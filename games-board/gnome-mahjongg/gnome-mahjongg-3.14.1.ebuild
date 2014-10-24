# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.24"

inherit gnome-games vala

DESCRIPTION="Disassemble a pile of tiles by removing matching pairs"
HOMEPAGE="https://wiki.gnome.org/Apps/Mahjongg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=gnome-base/librsvg-2.40.0
	>=x11-libs/gtk+-3.14.0:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

src_prepare() {
	gnome-games_src_prepare
	vala_src_prepare
}