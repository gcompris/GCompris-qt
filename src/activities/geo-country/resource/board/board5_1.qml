/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Eastern Provinces of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey_east.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/van.svgz",
         //: Province of Turkey: Van
         "toolTipText" : qsTr("Van"),
         "x" : "0.8495",
         "y" : "0.5608"
      },
      {
         "pixmapfile" : "turkey/tunceli.svgz",
         //: Province of Turkey: Tunceli
         "toolTipText" : qsTr("Tunceli"),
         "x" : "0.4422",
         "y" : "0.4648"
      },
      {
         "pixmapfile" : "turkey/trabzon.svgz",
         //: Province of Turkey: Trabzon
         "toolTipText" : qsTr("Trabzon"),
         "x" : "0.4673",
         "y" : "0.2231"
      },
      {
         "pixmapfile" : "turkey/tokat.svgz",
         //: Province of Turkey: Tokat
         "toolTipText" : qsTr("Tokat"),
         "x" : "0.1363",
         "y" : "0.2841"
      },
      {
         "pixmapfile" : "turkey/sivas.svgz",
         //: Province of Turkey: Sivas
         "toolTipText" : qsTr("Sivas"),
         "x" : "0.2137",
         "y" : "0.4118"
      },
      {
         "pixmapfile" : "turkey/sirnak.svgz",
         //: Province of Turkey: Şırnak
         "toolTipText" : qsTr("Şırnak"),
         "x" : "0.7416",
         "y" : "0.726"
      },
      {
         "pixmapfile" : "turkey/siirt.svgz",
         //: Province of Turkey: Siirt
         "toolTipText" : qsTr("Siirt"),
         "x" : "0.7011",
         "y" : "0.6532"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.svgz",
         //: Province of Turkey: Şanlıurfa
         "toolTipText" : qsTr("Şanlıurfa"),
         "x" : "0.3884",
         "y" : "0.7396"
      },
      {
         "pixmapfile" : "turkey/rize.svgz",
         //: Province of Turkey: Rize
         "toolTipText" : qsTr("Rize"),
         "x" : "0.5724",
         "y" : "0.2069"
      },
      {
         "pixmapfile" : "turkey/osmaniye.svgz",
         //: Province of Turkey: Osmaniye
         "toolTipText" : qsTr("Osmaniye"),
         "x" : "0.1097",
         "y" : "0.7404"
      },
      {
         "pixmapfile" : "turkey/ordu.svgz",
         //: Province of Turkey: Ordu
         "toolTipText" : qsTr("Ordu"),
         "x" : "0.2225",
         "y" : "0.2338"
      },
      {
         "pixmapfile" : "turkey/mus.svgz",
         //: Province of Turkey: Muş
         "toolTipText" : qsTr("Muş"),
         "x" : "0.6794",
         "y" : "0.4914"
      },
      {
         "pixmapfile" : "turkey/mardin.svgz",
         //: Province of Turkey: Mardin
         "toolTipText" : qsTr("Mardin"),
         "x" : "0.5763",
         "y" : "0.7427"
      },
      {
         "pixmapfile" : "turkey/malatya.svgz",
         //: Province of Turkey: Malatya
         "toolTipText" : qsTr("Malatya"),
         "x" : "0.3043",
         "y" : "0.566"
      },
      {
         "pixmapfile" : "turkey/kilis.svgz",
         //: Province of Turkey: Kilis
         "toolTipText" : qsTr("Kilis"),
         "x" : "0.1965",
         "y" : "0.8157"
      },
      {
         "pixmapfile" : "turkey/kars.svgz",
         //: Province of Turkey: Kars
         "toolTipText" : qsTr("Kars"),
         "x" : "0.7822",
         "y" : "0.2673"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.svgz",
         //: Province of Turkey: Kahramanmaraş
         "toolTipText" : qsTr("Kahramanmaraş"),
         "x" : "0.1797",
         "y" : "0.6593"
      },
      {
         "pixmapfile" : "turkey/igdir.svgz",
         //: Province of Turkey: Iğdır
         "toolTipText" : qsTr("Iğdır"),
         "x" : "0.8965",
         "y" : "0.3619"
      },
      {
         "pixmapfile" : "turkey/hatay.svgz",
         //: Province of Turkey: Hatay
         "toolTipText" : qsTr("Hatay"),
         "x" : "0.1048",
         "y" : "0.8792"
      },
      {
         "pixmapfile" : "turkey/hakkari.svgz",
         //: Province of Turkey: Hakkari
         "toolTipText" : qsTr("Hakkari"),
         "x" : "0.8974",
         "y" : "0.7333"
      },
      {
         "pixmapfile" : "turkey/gumushane.svgz",
         //: Province of Turkey: Gümüşhane
         "toolTipText" : qsTr("Gümüşhane"),
         "x" : "0.4279",
         "y" : "0.2938"
      },
      {
         "pixmapfile" : "turkey/giresun.svgz",
         //: Province of Turkey: Giresun
         "toolTipText" : qsTr("Giresun"),
         "x" : "0.3412",
         "y" : "0.2601"
      },
      {
         "pixmapfile" : "turkey/gaziantep.svgz",
         //: Province of Turkey: Gaziantep
         "toolTipText" : qsTr("Gaziantep"),
         "x" : "0.2085",
         "y" : "0.7737"
      },
      {
         "pixmapfile" : "turkey/erzurum.svgz",
         //: Province of Turkey: Erzurum
         "toolTipText" : qsTr("Erzurum"),
         "x" : "0.6312",
         "y" : "0.3336"
      },
      {
         "pixmapfile" : "turkey/erzincan.svgz",
         //: Province of Turkey: Erzincan
         "toolTipText" : qsTr("Erzincan"),
         "x" : "0.437",
         "y" : "0.4116"
      },
      {
         "pixmapfile" : "turkey/elazig.svgz",
         //: Province of Turkey: Elazığ
         "toolTipText" : qsTr("Elazığ"),
         "x" : "0.4196",
         "y" : "0.5354"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.svgz",
         //: Province of Turkey: Diyarbakır
         "toolTipText" : qsTr("Diyarbakır"),
         "x" : "0.51",
         "y" : "0.6255"
      },
      {
         "pixmapfile" : "turkey/bitlis.svgz",
         //: Province of Turkey: Bitlis
         "toolTipText" : qsTr("Bitlis"),
         "x" : "0.7237",
         "y" : "0.568"
      },
      {
         "pixmapfile" : "turkey/bingol.svgz",
         //: Province of Turkey: Bingöl
         "toolTipText" : qsTr("Bingöl"),
         "x" : "0.5468",
         "y" : "0.4899"
      },
      {
         "pixmapfile" : "turkey/bayburt.svgz",
         //: Province of Turkey: Bayburt
         "toolTipText" : qsTr("Bayburt"),
         "x" : "0.5049",
         "y" : "0.3068"
      },
      {
         "pixmapfile" : "turkey/batman.svgz",
         //: Province of Turkey: Batman
         "toolTipText" : qsTr("Batman"),
         "x" : "0.628",
         "y" : "0.6385"
      },
      {
         "pixmapfile" : "turkey/artvin.svgz",
         //: Province of Turkey: Artvin
         "toolTipText" : qsTr("Artvin"),
         "x" : "0.6745",
         "y" : "0.1889"
      },
      {
         "pixmapfile" : "turkey/ardahan.svgz",
         //: Province of Turkey: Ardahan
         "toolTipText" : qsTr("Ardahan"),
         "x" : "0.7794",
         "y" : "0.1779"
      },
      {
         "pixmapfile" : "turkey/agri.svgz",
         //: Province of Turkey: Ağrı
         "toolTipText" : qsTr("Ağrı"),
         "x" : "0.8286",
         "y" : "0.4235"
      },
      {
         "pixmapfile" : "turkey/adiyaman.svgz",
         //: Province of Turkey: Adıyaman
         "toolTipText" : qsTr("Adıyaman"),
         "x" : "0.3188",
         "y" : "0.6703"
      }
   ]
}
