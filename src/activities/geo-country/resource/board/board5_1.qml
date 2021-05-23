/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Eastern Districts of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey-east.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/van.png",
         //: Eastern District of Turkey: Van
         "toolTipText" : qsTr("Van"),
         "x" : "0.85",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "turkey/tunceli.png",
         //: Eastern District of Turkey: Tunceli
         "toolTipText" : qsTr("Tunceli"),
         "x" : "0.413",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "turkey/trabzon.png",
         //: Eastern District of Turkey: Trabzon
         "toolTipText" : qsTr("Trabzon"),
         "x" : "0.435",
         "y" : "0.21"
      },
      {
         "pixmapfile" : "turkey/tokat.png",
         //: Eastern District of Turkey: Tokat
         "toolTipText" : qsTr("Tokat"),
         "x" : "0.098",
         "y" : "0.287"
      },
      {
         "pixmapfile" : "turkey/sivas.png",
         //: Eastern District of Turkey: Sivas
         "toolTipText" : qsTr("Sivas"),
         "x" : "0.163",
         "y" : "0.405"
      },
      {
         "pixmapfile" : "turkey/sirnak.png",
         //: Eastern District of Turkey: Şırnak
         "toolTipText" : qsTr("Şırnak"),
         "x" : "0.733",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "turkey/siirt.png",
         //: Eastern District of Turkey: Siirt
         "toolTipText" : qsTr("Siirt"),
         "x" : "0.7",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.png",
         //: Eastern District of Turkey: Şanlıurfa
         "toolTipText" : qsTr("Şanlıurfa"),
         "x" : "0.368",
         "y" : "0.69"
      },
      {
         "pixmapfile" : "turkey/rize.png",
         //: Eastern District of Turkey: Rize
         "toolTipText" : qsTr("Rize"),
         "x" : "0.543",
         "y" : "0.177"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         //: Eastern District of Turkey: Osmaniye
         "toolTipText" : qsTr("Osmaniye"),
         "x" : "0.065",
         "y" : "0.695"
      },
      {
         "pixmapfile" : "turkey/ordu.png",
         //: Eastern District of Turkey: Ordu
         "toolTipText" : qsTr("Ordu"),
         "x" : "0.188",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/mus.png",
         //: Eastern District of Turkey: Muş
         "toolTipText" : qsTr("Muş"),
         "x" : "0.67",
         "y" : "0.444"
      },
      {
         "pixmapfile" : "turkey/mardin.png",
         //: Eastern District of Turkey: Mardin
         "toolTipText" : qsTr("Mardin"),
         "x" : "0.565",
         "y" : "0.685"
      },
      {
         "pixmapfile" : "turkey/malatya.png",
         //: Eastern District of Turkey: Malatya
         "toolTipText" : qsTr("Malatya"),
         "x" : "0.27",
         "y" : "0.528"
      },
      {
         "pixmapfile" : "turkey/kilis.png",
         //: Eastern District of Turkey: Kilis
         "toolTipText" : qsTr("Kilis"),
         "x" : "0.158",
         "y" : "0.774"
      },
      {
         "pixmapfile" : "turkey/kars.png",
         //: Eastern District of Turkey: Kars
         "toolTipText" : qsTr("Kars"),
         "x" : "0.76",
         "y" : "0.223"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.png",
         //: Eastern District of Turkey: Kahramanmaraş
         "toolTipText" : qsTr("Kahramanmaraş"),
         "x" : "0.14",
         "y" : "0.621"
      },
      {
         "pixmapfile" : "turkey/igdir.png",
         //: Eastern District of Turkey: Iğdır
         "toolTipText" : qsTr("Iğdır"),
         "x" : "0.875",
         "y" : "0.297"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         //: Eastern District of Turkey: Hatay
         "toolTipText" : qsTr("Hatay"),
         "x" : "0.073",
         "y" : "0.836"
      },
      {
         "pixmapfile" : "turkey/hakkari.png",
         //: Eastern District of Turkey: Hakkari
         "toolTipText" : qsTr("Hakkari"),
         "x" : "0.903",
         "y" : "0.633"
      },
      {
         "pixmapfile" : "turkey/gumushane.png",
         //: Eastern District of Turkey: Gümüşhane
         "toolTipText" : qsTr("Gümüşhane"),
         "x" : "0.38",
         "y" : "0.277"
      },
      {
         "pixmapfile" : "turkey/giresun.png",
         //: Eastern District of Turkey: Giresun
         "toolTipText" : qsTr("Giresun"),
         "x" : "0.298",
         "y" : "0.251"
      },
      {
         "pixmapfile" : "turkey/gaziantep.png",
         //: Eastern District of Turkey: Gaziantep
         "toolTipText" : qsTr("Gaziantep"),
         "x" : "0.173",
         "y" : "0.744"
      },
      {
         "pixmapfile" : "turkey/erzurum.png",
         //: Eastern District of Turkey: Erzurum
         "toolTipText" : qsTr("Erzurum"),
         "x" : "0.605",
         "y" : "0.29"
      },
      {
         "pixmapfile" : "turkey/erzincan.png",
         //: Eastern District of Turkey: Erzincan
         "toolTipText" : qsTr("Erzincan"),
         "x" : "0.395",
         "y" : "0.382"
      },
      {
         "pixmapfile" : "turkey/elazig.png",
         //: Eastern District of Turkey: Elazığ
         "toolTipText" : qsTr("Elazığ"),
         "x" : "0.39",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.png",
         //: Eastern District of Turkey: Diyarbakır
         "toolTipText" : qsTr("Diyarbakır"),
         "x" : "0.493",
         "y" : "0.577"
      },
      {
         "pixmapfile" : "turkey/bitlis.png",
         //: Eastern District of Turkey: Bitlis
         "toolTipText" : qsTr("Bitlis"),
         "x" : "0.715",
         "y" : "0.505"
      },
      {
         "pixmapfile" : "turkey/bingol.png",
         //: Eastern District of Turkey: Bingöl
         "toolTipText" : qsTr("Bingöl"),
         "x" : "0.525",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "turkey/bayburt.png",
         //: Eastern District of Turkey: Bayburt
         "toolTipText" : qsTr("Bayburt"),
         "x" : "0.478",
         "y" : "0.279"
      },
      {
         "pixmapfile" : "turkey/batman.png",
         //: Eastern District of Turkey: Batman
         "toolTipText" : qsTr("Batman"),
         "x" : "0.618",
         "y" : "0.579"
      },
      {
         "pixmapfile" : "turkey/artvin.png",
         //: Eastern District of Turkey: Artvin
         "toolTipText" : qsTr("Artvin"),
         "x" : "0.635",
         "y" : "0.162"
      },
      {
         "pixmapfile" : "turkey/ardahan.png",
         //: Eastern District of Turkey: Ardahan
         "toolTipText" : qsTr("Ardahan"),
         "x" : "0.74",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "turkey/agri.png",
         //: Eastern District of Turkey: Ağrı
         "toolTipText" : qsTr("Ağrı"),
         "x" : "0.818",
         "y" : "0.369"
      },
      {
         "pixmapfile" : "turkey/adiyaman.png",
         //: Eastern District of Turkey: Adıyaman
         "toolTipText" : qsTr("Adıyaman"),
         "x" : "0.288",
         "y" : "0.626"
      }
   ]
}
