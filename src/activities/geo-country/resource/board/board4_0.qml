/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Poland")
   property var levels: [
      {
         "pixmapfile" : "poland/poland.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "poland/dolnoslaskie.png",
         "toolTipText" : "Dolnoslaskie",
         "x" : "0.202",
         "y" : "0.664"
      },
      {
         "pixmapfile" : "poland/zachodnio-pomorskie.png",
         "toolTipText" : "Zachodnio Pomorskie",
         "x" : "0.14",
         "y" : "0.203"
      },
      {
         "pixmapfile" : "poland/wielkopolskie.png",
         "toolTipText" : "Wielkopolskie",
         "x" : "0.32",
         "y" : "0.422"
      },
      {
         "pixmapfile" : "poland/warminsko-mazurskie.png",
         "toolTipText" : "Warminsko-Mazurskie",
         "x" : "0.66",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "poland/swietokrzyskie.png",
         "toolTipText" : "Swietokrzyskie",
         "x" : "0.656",
         "y" : "0.702"
      },
      {
         "pixmapfile" : "poland/slaskie.png",
         "toolTipText" : "Slaskie",
         "x" : "0.47",
         "y" : "0.795"
      },
      {
         "pixmapfile" : "poland/pomorskie.png",
         "toolTipText" : "Pomorskie",
         "x" : "0.396",
         "y" : "0.113"
      },
      {
         "pixmapfile" : "poland/podlaskie.png",
         "toolTipText" : "Podlaskie",
         "x" : "0.842",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "poland/podkarpackie.png",
         "toolTipText" : "Podkarpackie",
         "x" : "0.818",
         "y" : "0.841"
      },
      {
         "pixmapfile" : "poland/opolskie.png",
         "toolTipText" : "Opolskie",
         "x" : "0.35",
         "y" : "0.734"
      },
      {
         "pixmapfile" : "poland/mazowieckie.png",
         "toolTipText" : "Mazowieckie",
         "x" : "0.692",
         "y" : "0.447"
      },
      {
         "pixmapfile" : "poland/malopolskie.png",
         "toolTipText" : "Malopolskie",
         "x" : "0.604",
         "y" : "0.862"
      },
      {
         "pixmapfile" : "poland/lodzkie.png",
         "toolTipText" : "Lódzkie",
         "x" : "0.512",
         "y" : "0.557"
      },
      {
         "pixmapfile" : "poland/lubuskie.png",
         "toolTipText" : "Lubuskie",
         "x" : "0.124",
         "y" : "0.437"
      },
      {
         "pixmapfile" : "poland/lubelskie.png",
         "toolTipText" : "Lubelskie",
         "x" : "0.868",
         "y" : "0.605"
      },
      {
         "pixmapfile" : "poland/kujawsko-pomorskie.png",
         "toolTipText" : "Kujawsko-Pomorskie",
         "x" : "0.426",
         "y" : "0.308"
      }
   ]
}
