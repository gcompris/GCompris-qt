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
         //: District of France: Corse
         "toolTipText" : qsTr("Corse")
      },
      {
         "pixmapfile" : "france/nouvelle-aquitaine.png",
         "sound" : "voices-$CA/$LOCALE/france/nouvelle-aquitaine.$CA",
         "x" : "0.37",
         "y" : "0.64",
         //: District of France: Nouvelle-Aquitaine
         "toolTipText" : qsTr("Nouvelle-Aquitaine")
      },
      {
         "pixmapfile" : "france/occitanie.png",
         "sound" : "voices-$CA/$LOCALE/france/occitanie.$CA",
         "x" : "0.47",
         "y" : "0.776",
         //: District of France: Occitanie
         "toolTipText" : qsTr("Occitanie")
      },
      {
         "pixmapfile" : "france/paca.png",
         "sound" : "voices-$CA/$LOCALE/france/paca.$CA",
         "x" : "0.672",
         "y" : "0.728",
         //: District of France: Provence-Alpes-Côte d'Azur
         "toolTipText" : qsTr("Provence-Alpes-Côte d'Azur")
      },
      {
         "pixmapfile" : "france/auvergne-rhone-alpes.png",
         "sound" : "voices-$CA/$LOCALE/france/auvergne-rhone-alpes.$CA",
         "x" : "0.597",
         "y" : "0.586",
         //: District of France: Auvergne-Rhône-Alpes
         "toolTipText" : qsTr("Auvergne-Rhône-Alpes")
      },
      {
         "pixmapfile" : "france/centre-val-de-loire.png",
         "sound" : "voices-$CA/$LOCALE/france/centre-val-de-loire.$CA",
         "x" : "0.439",
         "y" : "0.360",
         //: District of France: Centre-Val de Loire
         "toolTipText" : qsTr("Centre-Val de Loire")
      },
      {
         "pixmapfile" : "france/pays-de-la-loire.png",
         "sound" : "voices-$CA/$LOCALE/france/pays-de-la-loire.$CA",
         "x" : "0.316",
         "y" : "0.378",
         //: District of France: Pays de la Loire
         "toolTipText" : qsTr("Pays de la Loire")
      },
      {
         "pixmapfile" : "france/ile-de-france.png",
         "sound" : "voices-$CA/$LOCALE/france/ile-de-france.$CA",
         "x" : "0.486",
         "y" : "0.253",
         //: District of France: Île-de-france
         "toolTipText" : qsTr("Île-de-france")
      },
      {
         "pixmapfile" : "france/bretagne.png",
         "sound" : "voices-$CA/$LOCALE/france/bretagne.$CA",
         "x" : "0.216",
         "y" : "0.291",
         //: District of France: Bretagne
         "toolTipText" : qsTr("Bretagne")
      },
      {
         "pixmapfile" : "france/normandie.png",
         "sound" : "voices-$CA/$LOCALE/france/normandie.$CA",
         "x" : "0.366",
         "y" : "0.199",
         //: District of France: Normandie
         "toolTipText" : qsTr("Normandie")
      },
      {
         "pixmapfile" : "france/haut-de-france.png",
         "sound" : "voices-$CA/$LOCALE/france/haut-de-france.$CA",
         "x" : "0.503",
         "y" : "0.117",
         //: District of France: Haut de France
         "toolTipText" : qsTr("Haut de France")
      },
      {
         "pixmapfile" : "france/grand-est.png",
         "sound" : "voices-$CA/$LOCALE/france/grand-est.$CA",
         "x" : "0.649",
         "y" : "0.233",
         //: District of France: Grand est
         "toolTipText" : qsTr("Grand est")
      },
      {
         "pixmapfile" : "france/bourgogne-franche-comte.png",
         "sound" : "voices-$CA/$LOCALE/france/bourgogne-franche-comte.$CA",
         "x" : "0.613",
         "y" : "0.398",
         //: District of France: Bourgogne-Franche-Comté
         "toolTipText" : qsTr("Bourgogne-Franche-Comté")
      }
   ]
}
