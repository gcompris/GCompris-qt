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
   property string instruction: qsTr("Districts of France")
   property var levels: [
      {
         "pixmapfile" : "france/france-regions.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "france/corse.png",
         "sound" : "voices-$CA/$LOCALE/france/corse.$CA",
         "x" : "0.836",
         "y" : "0.905",
         "toolTipText" : "Corse"
      },
      {
         "pixmapfile" : "france/nouvelle-aquitaine.png",
         "sound" : "voices-$CA/$LOCALE/france/nouvelle-aquitaine.$CA",
         "x" : "0.37",
         "y" : "0.64",
         "toolTipText" : "Nouvelle-Aquitaine"
      },
      {
         "pixmapfile" : "france/occitanie.png",
         "sound" : "voices-$CA/$LOCALE/france/occitanie.$CA",
         "x" : "0.47",
         "y" : "0.776",
         "toolTipText" : "Occitanie"
      },
      {
         "pixmapfile" : "france/paca.png",
         "sound" : "voices-$CA/$LOCALE/france/paca.$CA",
         "x" : "0.672",
         "y" : "0.728",
         "toolTipText" : "Provence-Alpes-Côte d'Azur"
      },
      {
         "pixmapfile" : "france/auvergne-rhone-alpes.png",
         "sound" : "voices-$CA/$LOCALE/france/auvergne-rhone-alpes.$CA",
         "x" : "0.597",
         "y" : "0.586",
         "toolTipText" : "Auvergne-Rhône-Alpes"
      },
      {
         "pixmapfile" : "france/centre-val-de-loire.png",
         "sound" : "voices-$CA/$LOCALE/france/centre-val-de-loire.$CA",
         "x" : "0.439",
         "y" : "0.360",
         "toolTipText" : "Centre-Val de Loire"
      },
      {
         "pixmapfile" : "france/pays-de-la-loire.png",
         "sound" : "voices-$CA/$LOCALE/france/pays-de-la-loire.$CA",
         "x" : "0.316",
         "y" : "0.378",
         "toolTipText" : "Pays de la Loire"
      },
      {
         "pixmapfile" : "france/ile-de-france.png",
         "sound" : "voices-$CA/$LOCALE/france/ile-de-france.$CA",
         "x" : "0.486",
         "y" : "0.253",
         "toolTipText" : "Île-de-france"
      },
      {
         "pixmapfile" : "france/bretagne.png",
         "sound" : "voices-$CA/$LOCALE/france/bretagne.$CA",
         "x" : "0.216",
         "y" : "0.291",
         "toolTipText" : "Bretagne"
      },
      {
         "pixmapfile" : "france/normandie.png",
         "sound" : "voices-$CA/$LOCALE/france/normandie.$CA",
         "x" : "0.366",
         "y" : "0.199",
         "toolTipText" : "Normandie"
      },
      {
         "pixmapfile" : "france/haut-de-france.png",
         "sound" : "voices-$CA/$LOCALE/france/haut-de-france.$CA",
         "x" : "0.503",
         "y" : "0.117",
         "toolTipText" : "Haut de France"
      },
      {
         "pixmapfile" : "france/grand-est.png",
         "sound" : "voices-$CA/$LOCALE/france/grand-est.$CA",
         "x" : "0.649",
         "y" : "0.233",
         "toolTipText" : "Grand est"
      },
      {
         "pixmapfile" : "france/bourgogne-franche-comte.png",
         "sound" : "voices-$CA/$LOCALE/france/bourgogne-franche-comte.$CA",
         "x" : "0.613",
         "y" : "0.398",
         "toolTipText" : "Bourgogne-Franche-Comté"
      }
   ]
}
