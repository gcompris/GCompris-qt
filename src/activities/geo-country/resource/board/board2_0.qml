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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Germany")
   property var levels: [
      {
         "pixmapfile" : "germany/back.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "germany/thueringen.png",
         "toolTipText" : "Thüringen",
         "x" : "0.584",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "germany/schleswig_holstein.png",
         "toolTipText" : "Schleswig-Holstein",
         "x" : "0.436",
         "y" : "0.14"
      },
      {
         "pixmapfile" : "germany/sachsen.png",
         "toolTipText" : "Sachsen",
         "x" : "0.805",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "germany/sachsen-anhalt.png",
         "toolTipText" : "Sachsen-Anhalt",
         "x" : "0.645",
         "y" : "0.409"
      },
      {
         "pixmapfile" : "germany/saarland.png",
         "toolTipText" : "Saarland",
         "x" : "0.13",
         "y" : "0.729"
      },
      {
         "pixmapfile" : "germany/rheinland-pfalz.png",
         "toolTipText" : "Rheinland-Pfalz",
         "x" : "0.178",
         "y" : "0.656"
      },
      {
         "pixmapfile" : "germany/nordrhein-westfalen.png",
         "toolTipText" : "Nordrhein-Westfalen",
         "x" : "0.221",
         "y" : "0.473"
      },
      {
         "pixmapfile" : "germany/niedersachsen.png",
         "toolTipText" : "Niedersachsen",
         "x" : "0.371",
         "y" : "0.292"
      },
      {
         "pixmapfile" : "germany/mecklenburg-vorpommern.png",
         "toolTipText" : "Mecklenburg-Vorpommern",
         "x" : "0.699",
         "y" : "0.176"
      },
      {
         "pixmapfile" : "germany/hessen.png",
         "toolTipText" : "Hessen",
         "x" : "0.356",
         "y" : "0.587"
      },
      {
         "pixmapfile" : "germany/hamburg.png",
         "toolTipText" : "Hamburg",
         "x" : "0.463",
         "y" : "0.235"
      },
      {
         "pixmapfile" : "germany/bremen.png",
         "toolTipText" : "Bremen",
         "x" : "0.289",
         "y" : "0.252"
      },
      {
         "pixmapfile" : "germany/brandenburg.png",
         "toolTipText" : "Brandenburg",
         "x" : "0.758",
         "y" : "0.344"
      },
      {
         "pixmapfile" : "germany/berlin.png",
         "toolTipText" : "Berlin",
         "x" : "0.823",
         "y" : "0.339"
      },
      {
         "pixmapfile" : "germany/bayern.png",
         "toolTipText" : "Bayern",
         "x" : "0.605",
         "y" : "0.786"
      },
      {
         "pixmapfile" : "germany/baden-wuerttemberg.png",
         "toolTipText" : "Baden-Württemberg",
         "x" : "0.351",
         "y" : "0.817"
      }
   ]
}
