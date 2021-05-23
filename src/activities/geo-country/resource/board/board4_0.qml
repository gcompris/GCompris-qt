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
   property string instruction: qsTr("Districts of Poland")
   property var levels: [
      {
         "pixmapfile" : "poland/poland.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "poland/dolnoslaskie.png",
         //: District of Poland: Dolnoslaskie
         "toolTipText" : qsTr("Dolnoslaskie"),
         "x" : "0.202",
         "y" : "0.664"
      },
      {
         "pixmapfile" : "poland/zachodnio-pomorskie.png",
         //: District of Poland: Zachodnio Pomorskie
         "toolTipText" : qsTr("Zachodnio Pomorskie"),
         "x" : "0.14",
         "y" : "0.203"
      },
      {
         "pixmapfile" : "poland/wielkopolskie.png",
         //: District of Poland: Wielkopolskie
         "toolTipText" : qsTr("Wielkopolskie"),
         "x" : "0.32",
         "y" : "0.422"
      },
      {
         "pixmapfile" : "poland/warminsko-mazurskie.png",
         //: District of Poland: Warminsko-Mazurskie
         "toolTipText" : qsTr("Warminsko-Mazurskie"),
         "x" : "0.66",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "poland/swietokrzyskie.png",
         //: District of Poland: Swietokrzyskie
         "toolTipText" : qsTr("Swietokrzyskie"),
         "x" : "0.656",
         "y" : "0.702"
      },
      {
         "pixmapfile" : "poland/slaskie.png",
         //: District of Poland: Slaskie
         "toolTipText" : qsTr("Slaskie"),
         "x" : "0.47",
         "y" : "0.795"
      },
      {
         "pixmapfile" : "poland/pomorskie.png",
         //: District of Poland: Pomorskie
         "toolTipText" : qsTr("Pomorskie"),
         "x" : "0.396",
         "y" : "0.113"
      },
      {
         "pixmapfile" : "poland/podlaskie.png",
         //: District of Poland: Podlaskie
         "toolTipText" : qsTr("Podlaskie"),
         "x" : "0.842",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "poland/podkarpackie.png",
         //: District of Poland: Podkarpackie
         "toolTipText" : qsTr("Podkarpackie"),
         "x" : "0.818",
         "y" : "0.841"
      },
      {
         "pixmapfile" : "poland/opolskie.png",
         //: District of Poland: Opolskie
         "toolTipText" : qsTr("Opolskie"),
         "x" : "0.35",
         "y" : "0.734"
      },
      {
         "pixmapfile" : "poland/mazowieckie.png",
         //: District of Poland: Mazowieckie
         "toolTipText" : qsTr("Mazowieckie"),
         "x" : "0.692",
         "y" : "0.447"
      },
      {
         "pixmapfile" : "poland/malopolskie.png",
         //: District of Poland: Malopolskie
         "toolTipText" : qsTr("Malopolskie"),
         "x" : "0.604",
         "y" : "0.862"
      },
      {
         "pixmapfile" : "poland/lodzkie.png",
         //: District of Poland: Lódzkie
         "toolTipText" : qsTr("Lódzkie"),
         "x" : "0.512",
         "y" : "0.557"
      },
      {
         "pixmapfile" : "poland/lubuskie.png",
         //: District of Poland: Lubuskie
         "toolTipText" : qsTr("Lubuskie"),
         "x" : "0.124",
         "y" : "0.437"
      },
      {
         "pixmapfile" : "poland/lubelskie.png",
         //: District of Poland: Lubelskie
         "toolTipText" : qsTr("Lubelskie"),
         "x" : "0.868",
         "y" : "0.605"
      },
      {
         "pixmapfile" : "poland/kujawsko-pomorskie.png",
         //: District of Poland: Kujawsko-Pomorskie
         "toolTipText" : qsTr("Kujawsko-Pomorskie"),
         "x" : "0.426",
         "y" : "0.308"
      }
   ]
}
