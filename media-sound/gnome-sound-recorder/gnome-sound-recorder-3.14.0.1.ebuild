# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit gnome2

DESCRIPTION="Gnome Sound Recorder"
HOMEPAGE="https://wiki.gnome.org/ThreePointEleven/Features/SoundRecorder"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# For the list of plugins, see src/audioProfile.js
COMMON_DEPEND="
	dev-libs/gjs
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.14.0:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.26
	virtual/pkgconfig
"
