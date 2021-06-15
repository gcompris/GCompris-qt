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
   property string instruction: qsTr("Provinces of Poland")
   property var levels: [
      {
         "pixmapfile" : "poland/poland.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "poland/lower_silesian.svgz",
         //: Province of Poland: Lower Silesian
         "toolTipText" : qsTr("Lower Silesian"),
         "x" : "0.2292",
         "y" : "0.6539"
      },
      {
         "pixmapfile" : "poland/west_pomeranian.svgz",
         //: Province of Poland: West Pomeranian
         "toolTipText" : qsTr("West Pomeranian"),
         "x" : "0.1569",
         "y" : "0.2319"
      },
      {
         "pixmapfile" : "poland/greater_poland.svgz",
         //: Province of Poland: Greater Poland
         "toolTipText" : qsTr("Greater Poland"),
         "x" : "0.3377",
         "y" : "0.4262"
      },
      {
         "pixmapfile" : "poland/warmian-masurian.svgz",
         //: Province of Poland: Warmian-Masurian
         "toolTipText" : qsTr("Warmian-Masurian"),
         "x" : "0.6756",
         "y" : "0.201"
      },
      {
         "pixmapfile" : "poland/holy_cross.svgz",
         //: Province of Poland: Holy Cross
         "toolTipText" : qsTr("Holy Cross"),
         "x" : "0.6583",
         "y" : "0.6842"
      },
      {
         "pixmapfile" : "poland/silesian.svgz",
         //: Province of Poland: Silesian
         "toolTipText" : qsTr("Silesian"),
         "x" : "0.4875",
         "y" : "0.7668"
      },
      {
         "pixmapfile" : "poland/pomeranian.svgz",
         //: Province of Poland: Pomeranian
         "toolTipText" : qsTr("Pomeranian"),
         "x" : "0.408",
         "y" : "0.1417"
      },
      {
         "pixmapfile" : "poland/podlaskie.svgz",
         //: Province of Poland: Podlaskie
         "toolTipText" : qsTr("Podlaskie"),
         "x" : "0.8482",
         "y" : "0.2724"
      },
      {
         "pixmapfile" : "poland/subcarpathian.svgz",
         //: Province of Poland: Subcarpathian
         "toolTipText" : qsTr("Subcarpathian"),
         "x" : "0.8074",
         "y" : "0.8204"
      },
      {
         "pixmapfile" : "poland/opole.svgz",
         //: Province of Poland: Opole
         "toolTipText" : qsTr("Opole"),
         "x" : "0.3723",
         "y" : "0.7132"
      },
      {
         "pixmapfile" : "poland/masovian.svgz",
         //: Province of Poland: Masovian
         "toolTipText" : qsTr("Masovian"),
         "x" : "0.6972",
         "y" : "0.4474"
      },
      {
         "pixmapfile" : "poland/lesser_poland.svgz",
         //: Province of Poland: Lesser Poland
         "toolTipText" : qsTr("Lesser Poland"),
         "x" : "0.6071",
         "y" : "0.8301"
      },
      {
         "pixmapfile" : "poland/lodz.svgz",
         //: Province of Poland: Łódź
         "toolTipText" : qsTr("Łódź"),
         "x" : "0.5222",
         "y" : "0.5478"
      },
      {
         "pixmapfile" : "poland/lubusz.svgz",
         //: Province of Poland: Lubusz
         "toolTipText" : qsTr("Lubusz"),
         "x" : "0.1495",
         "y" : "0.4487"
      },
      {
         "pixmapfile" : "poland/lublin.svgz",
         //: Province of Poland: Lublin
         "toolTipText" : qsTr("Lublin"),
         "x" : "0.8588",
         "y" : "0.6034"
      },
      {
         "pixmapfile" : "poland/kuyavian-pomeranian.svgz",
         //: Province of Poland: Kuyavian-Pomeranian
         "toolTipText" : qsTr("Kuyavian-Pomeranian"),
         "x" : "0.4396",
         "y" : "0.3183"
      }
   ]
}
