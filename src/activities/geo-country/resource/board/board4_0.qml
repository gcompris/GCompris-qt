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
         "x" : "0.2136",
         "y" : "0.6595"
      },
      {
         "pixmapfile" : "poland/west_pomeranian.svgz",
         //: Province of Poland: West Pomeranian
         "toolTipText" : qsTr("West Pomeranian"),
         "x" : "0.1559",
         "y" : "0.2205"
      },
      {
         "pixmapfile" : "poland/greater_poland.svgz",
         //: Province of Poland: Greater Poland
         "toolTipText" : qsTr("Greater Poland"),
         "x" : "0.3303",
         "y" : "0.4281"
      },
      {
         "pixmapfile" : "poland/warmian-masurian.svgz",
         //: Province of Poland: Warmian-Masurian
         "toolTipText" : qsTr("Warmian-Masurian"),
         "x" : "0.6555",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "poland/holy_cross.svgz",
         //: Province of Poland: Holy Cross
         "toolTipText" : qsTr("Holy Cross"),
         "x" : "0.6516",
         "y" : "0.6941"
      },
      {
         "pixmapfile" : "poland/silesian.svgz",
         //: Province of Poland: Silesian
         "toolTipText" : qsTr("Silesian"),
         "x" : "0.4767",
         "y" : "0.7809"
      },
      {
         "pixmapfile" : "poland/pomeranian.svgz",
         //: Province of Poland: Pomeranian
         "toolTipText" : qsTr("Pomeranian"),
         "x" : "0.4021",
         "y" : "0.1352"
      },
      {
         "pixmapfile" : "poland/podlaskie.svgz",
         //: Province of Poland: Podlaskie
         "toolTipText" : qsTr("Podlaskie"),
         "x" : "0.8283",
         "y" : "0.2598"
      },
      {
         "pixmapfile" : "poland/subcarpathian.svgz",
         //: Province of Poland: Subcarpathian
         "toolTipText" : qsTr("Subcarpathian"),
         "x" : "0.8085",
         "y" : "0.8268"
      },
      {
         "pixmapfile" : "poland/opole.svgz",
         //: Province of Poland: Opole
         "toolTipText" : qsTr("Opole"),
         "x" : "0.3585",
         "y" : "0.7242"
      },
      {
         "pixmapfile" : "poland/masovian.svgz",
         //: Province of Poland: Masovian
         "toolTipText" : qsTr("Masovian"),
         "x" : "0.6847",
         "y" : "0.4469"
      },
      {
         "pixmapfile" : "poland/lesser_poland.svgz",
         //: Province of Poland: Lesser Poland
         "toolTipText" : qsTr("Lesser Poland"),
         "x" : "0.6028",
         "y" : "0.8445"
      },
      {
         "pixmapfile" : "poland/lodz.svgz",
         //: Province of Poland: Łódź
         "toolTipText" : qsTr("Łódź"),
         "x" : "0.5115",
         "y" : "0.555"
      },
      {
         "pixmapfile" : "poland/lubusz.svgz",
         //: Province of Poland: Lubusz
         "toolTipText" : qsTr("Lubusz"),
         "x" : "0.1407",
         "y" : "0.4437"
      },
      {
         "pixmapfile" : "poland/lublin.svgz",
         //: Province of Poland: Lublin
         "toolTipText" : qsTr("Lublin"),
         "x" : "0.8547",
         "y" : "0.5988"
      },
      {
         "pixmapfile" : "poland/kuyavian-pomeranian.svgz",
         //: Province of Poland: Kuyavian-Pomeranian
         "toolTipText" : qsTr("Kuyavian-Pomeranian"),
         "x" : "0.4311",
         "y" : "0.318"
      }
   ]
}
