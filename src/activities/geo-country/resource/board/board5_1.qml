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
import QtQuick 2.12

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
         "x" : "0.8295",
         "y" : "0.4923"
      },
      {
         "pixmapfile" : "turkey/tunceli.svgz",
         //: Province of Turkey: Tunceli
         "toolTipText" : qsTr("Tunceli"),
         "x" : "0.4214",
         "y" : "0.4401"
      },
      {
         "pixmapfile" : "turkey/trabzon.svgz",
         //: Province of Turkey: Trabzon
         "toolTipText" : qsTr("Trabzon"),
         "x" : "0.4319",
         "y" : "0.1967"
      },
      {
         "pixmapfile" : "turkey/tokat.svgz",
         //: Province of Turkey: Tokat
         "toolTipText" : qsTr("Tokat"),
         "x" : "0.1224",
         "y" : "0.2811"
      },
      {
         "pixmapfile" : "turkey/sivas.svgz",
         //: Province of Turkey: Sivas
         "toolTipText" : qsTr("Sivas"),
         "x" : "0.1987",
         "y" : "0.4036"
      },
      {
         "pixmapfile" : "turkey/sirnak.svgz",
         //: Province of Turkey: Şırnak
         "toolTipText" : qsTr("Şırnak"),
         "x" : "0.7343",
         "y" : "0.6726"
      },
      {
         "pixmapfile" : "turkey/siirt.svgz",
         //: Province of Turkey: Siirt
         "toolTipText" : qsTr("Siirt"),
         "x" : "0.69",
         "y" : "0.6054"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.svgz",
         //: Province of Turkey: Şanlıurfa
         "toolTipText" : qsTr("Şanlıurfa"),
         "x" : "0.3889",
         "y" : "0.7207"
      },
      {
         "pixmapfile" : "turkey/rize.svgz",
         //: Province of Turkey: Rize
         "toolTipText" : qsTr("Rize"),
         "x" : "0.5281",
         "y" : "0.1703"
      },
      {
         "pixmapfile" : "turkey/osmaniye.svgz",
         //: Province of Turkey: Osmaniye
         "toolTipText" : qsTr("Osmaniye"),
         "x" : "0.1118",
         "y" : "0.7384"
      },
      {
         "pixmapfile" : "turkey/ordu.svgz",
         //: Province of Turkey: Ordu
         "toolTipText" : qsTr("Ordu"),
         "x" : "0.2018",
         "y" : "0.2243"
      },
      {
         "pixmapfile" : "turkey/mus.svgz",
         //: Province of Turkey: Muş
         "toolTipText" : qsTr("Muş"),
         "x" : "0.6545",
         "y" : "0.4446"
      },
      {
         "pixmapfile" : "turkey/mardin.svgz",
         //: Province of Turkey: Mardin
         "toolTipText" : qsTr("Mardin"),
         "x" : "0.5707",
         "y" : "0.7105"
      },
      {
         "pixmapfile" : "turkey/malatya.svgz",
         //: Province of Turkey: Malatya
         "toolTipText" : qsTr("Malatya"),
         "x" : "0.2961",
         "y" : "0.5523"
      },
      {
         "pixmapfile" : "turkey/kilis.svgz",
         //: Province of Turkey: Kilis
         "toolTipText" : qsTr("Kilis"),
         "x" : "0.1999",
         "y" : "0.8108"
      },
      {
         "pixmapfile" : "turkey/kars.svgz",
         //: Province of Turkey: Kars
         "toolTipText" : qsTr("Kars"),
         "x" : "0.736",
         "y" : "0.2065"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.svgz",
         //: Province of Turkey: Kahramanmaraş
         "toolTipText" : qsTr("Kahramanmaraş"),
         "x" : "0.1763",
         "y" : "0.6537"
      },
      {
         "pixmapfile" : "turkey/igdir.svgz",
         //: Province of Turkey: Iğdır
         "toolTipText" : qsTr("Iğdır"),
         "x" : "0.8523",
         "y" : "0.2846"
      },
      {
         "pixmapfile" : "turkey/hatay.svgz",
         //: Province of Turkey: Hatay
         "toolTipText" : qsTr("Hatay"),
         "x" : "0.1104",
         "y" : "0.8777"
      },
      {
         "pixmapfile" : "turkey/hakkari.svgz",
         //: Province of Turkey: Hakkari
         "toolTipText" : qsTr("Hakkari"),
         "x" : "0.8902",
         "y" : "0.6563"
      },
      {
         "pixmapfile" : "turkey/gumushane.svgz",
         //: Province of Turkey: Gümüşhane
         "toolTipText" : qsTr("Gümüşhane"),
         "x" : "0.3976",
         "y" : "0.2722"
      },
      {
         "pixmapfile" : "turkey/giresun.svgz",
         //: Province of Turkey: Giresun
         "toolTipText" : qsTr("Giresun"),
         "x" : "0.3124",
         "y" : "0.2407"
      },
      {
         "pixmapfile" : "turkey/gaziantep.svgz",
         //: Province of Turkey: Gaziantep
         "toolTipText" : qsTr("Gaziantep"),
         "x" : "0.2094",
         "y" : "0.7652"
      },
      {
         "pixmapfile" : "turkey/erzurum.svgz",
         //: Province of Turkey: Erzurum
         "toolTipText" : qsTr("Erzurum"),
         "x" : "0.5939",
         "y" : "0.2862"
      },
      {
         "pixmapfile" : "turkey/erzincan.svgz",
         //: Province of Turkey: Erzincan
         "toolTipText" : qsTr("Erzincan"),
         "x" : "0.4153",
         "y" : "0.3888"
      },
      {
         "pixmapfile" : "turkey/elazig.svgz",
         //: Province of Turkey: Elazığ
         "toolTipText" : qsTr("Elazığ"),
         "x" : "0.4067",
         "y" : "0.5096"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.svgz",
         //: Province of Turkey: Diyarbakır
         "toolTipText" : qsTr("Diyarbakır"),
         "x" : "0.497",
         "y" : "0.593"
      },
      {
         "pixmapfile" : "turkey/bitlis.svgz",
         //: Province of Turkey: Bitlis
         "toolTipText" : qsTr("Bitlis"),
         "x" : "0.7012",
         "y" : "0.512"
      },
      {
         "pixmapfile" : "turkey/bingol.svgz",
         //: Province of Turkey: Bingöl
         "toolTipText" : qsTr("Bingöl"),
         "x" : "0.5255",
         "y" : "0.4594"
      },
      {
         "pixmapfile" : "turkey/bayburt.svgz",
         //: Province of Turkey: Bayburt
         "toolTipText" : qsTr("Bayburt"),
         "x" : "0.4743",
         "y" : "0.2785"
      },
      {
         "pixmapfile" : "turkey/batman.svgz",
         //: Province of Turkey: Batman
         "toolTipText" : qsTr("Batman"),
         "x" : "0.6193",
         "y" : "0.5984"
      },
      {
         "pixmapfile" : "turkey/artvin.svgz",
         //: Province of Turkey: Artvin
         "toolTipText" : qsTr("Artvin"),
         "x" : "0.6234",
         "y" : "0.1437"
      },
      {
         "pixmapfile" : "turkey/ardahan.svgz",
         //: Province of Turkey: Ardahan
         "toolTipText" : qsTr("Ardahan"),
         "x" : "0.724",
         "y" : "0.1216"
      },
      {
         "pixmapfile" : "turkey/agri.svgz",
         //: Province of Turkey: Ağrı
         "toolTipText" : qsTr("Ağrı"),
         "x" : "0.7888",
         "y" : "0.3628"
      },
      {
         "pixmapfile" : "turkey/adiyaman.svgz",
         //: Province of Turkey: Adıyaman
         "toolTipText" : qsTr("Adıyaman"),
         "x" : "0.3136",
         "y" : "0.6543"
      }
   ]
}
