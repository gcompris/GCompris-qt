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
   property string instruction: qsTr("Districts of Germany")
   property var levels: [
      {
         "pixmapfile" : "germany/back.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "germany/thueringen.png",
         //: District of Germany: Thüringen
         "toolTipText" : qsTr("Thüringen"),
         "x" : "0.584",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "germany/schleswig_holstein.png",
         //: District of Germany: Schleswig-Holstein
         "toolTipText" : qsTr("Schleswig-Holstein"),
         "x" : "0.436",
         "y" : "0.14"
      },
      {
         "pixmapfile" : "germany/sachsen.png",
         //: District of Germany: Sachsen
         "toolTipText" : qsTr("Sachsen"),
         "x" : "0.805",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "germany/sachsen-anhalt.png",
         //: District of Germany: Sachsen-Anhalt
         "toolTipText" : qsTr("Sachsen-Anhalt"),
         "x" : "0.645",
         "y" : "0.409"
      },
      {
         "pixmapfile" : "germany/saarland.png",
         //: District of Germany: Saarland
         "toolTipText" : qsTr("Saarland"),
         "x" : "0.13",
         "y" : "0.729"
      },
      {
         "pixmapfile" : "germany/rheinland-pfalz.png",
         //: District of Germany: Rheinland-Pfalz
         "toolTipText" : qsTr("Rheinland-Pfalz"),
         "x" : "0.178",
         "y" : "0.656"
      },
      {
         "pixmapfile" : "germany/nordrhein-westfalen.png",
         //: District of Germany: Nordrhein-Westfalen
         "toolTipText" : qsTr("Nordrhein-Westfalen"),
         "x" : "0.221",
         "y" : "0.473"
      },
      {
         "pixmapfile" : "germany/niedersachsen.png",
         //: District of Germany: Niedersachsen
         "toolTipText" : qsTr("Niedersachsen"),
         "x" : "0.371",
         "y" : "0.292"
      },
      {
         "pixmapfile" : "germany/mecklenburg-vorpommern.png",
         //: District of Germany: Mecklenburg-Vorpommern
         "toolTipText" : qsTr("Mecklenburg-Vorpommern"),
         "x" : "0.699",
         "y" : "0.176"
      },
      {
         "pixmapfile" : "germany/hessen.png",
         //: District of Germany: Hessen
         "toolTipText" : qsTr("Hessen"),
         "x" : "0.356",
         "y" : "0.587"
      },
      {
         "pixmapfile" : "germany/hamburg.png",
         //: District of Germany: Hamburg
         "toolTipText" : qsTr("Hamburg"),
         "x" : "0.463",
         "y" : "0.235"
      },
      {
         "pixmapfile" : "germany/bremen.png",
         //: District of Germany: Bremen
         "toolTipText" : qsTr("Bremen"),
         "x" : "0.289",
         "y" : "0.252"
      },
      {
         "pixmapfile" : "germany/brandenburg.png",
         //: District of Germany: Brandenburg
         "toolTipText" : qsTr("Brandenburg"),
         "x" : "0.758",
         "y" : "0.344"
      },
      {
         "pixmapfile" : "germany/berlin.png",
         //: District of Germany: Berlin
         "toolTipText" : qsTr("Berlin"),
         "x" : "0.823",
         "y" : "0.339"
      },
      {
         "pixmapfile" : "germany/bayern.png",
         //: District of Germany: Bayern
         "toolTipText" : qsTr("Bayern"),
         "x" : "0.605",
         "y" : "0.786"
      },
      {
         "pixmapfile" : "germany/baden-wuerttemberg.png",
         //: District of Germany: Baden-Württemberg
         "toolTipText" : qsTr("Baden-Württemberg"),
         "x" : "0.351",
         "y" : "0.817"
      }
   ]
}
