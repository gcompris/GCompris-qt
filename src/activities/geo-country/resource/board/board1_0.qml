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
   property string instruction: qsTr("Regions of France")
   property var levels: [
      {
         "pixmapfile" : "france/france.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "france/corsica.svgz",
         "sound" : "voices-$CA/$LOCALE/france/corse.$CA",
         "x" : "0.9472",
         "y" : "0.8862",
         //: Region of France: Corsica
         "toolTipText" : qsTr("Corsica")
      },
      {
         "pixmapfile" : "france/nouvelle-aquitaine.svgz",
         "sound" : "voices-$CA/$LOCALE/france/nouvelle-aquitaine.$CA",
         "x" : "0.3829",
         "y" : "0.6183",
         //: Region of France: Nouvelle-Aquitaine
         "toolTipText" : qsTr("Nouvelle-Aquitaine")
      },
      {
         "pixmapfile" : "france/occitanie.svgz",
         "sound" : "voices-$CA/$LOCALE/france/occitanie.$CA",
         "x" : "0.5034",
         "y" : "0.7422",
         //: Region of France: Occitanie
         "toolTipText" : qsTr("Occitanie")
      },
      {
         "pixmapfile" : "france/paca.svgz",
         "sound" : "voices-$CA/$LOCALE/france/paca.$CA",
         "x" : "0.7459",
         "y" : "0.7075",
         //: Region of France: Provence-Alpes-Côte d'Azur
         "toolTipText" : qsTr("Provence-Alpes-Côte d'Azur")
      },
      {
         "pixmapfile" : "france/auvergne-rhone-alpes.svgz",
         "sound" : "voices-$CA/$LOCALE/france/auvergne-rhone-alpes.$CA",
         "x" : "0.6575",
         "y" : "0.5722",
         //: Region of France: Auvergne-Rhône-Alpes
         "toolTipText" : qsTr("Auvergne-Rhône-Alpes")
      },
      {
         "pixmapfile" : "france/centre-val_de_loire.svgz",
         "sound" : "voices-$CA/$LOCALE/france/centre-val-de-loire.$CA",
         "x" : "0.46",
         "y" : "0.3624",
         //: Region of France: Centre-Val de Loire
         "toolTipText" : qsTr("Centre-Val de Loire")
      },
      {
         "pixmapfile" : "france/pays_de_la_loire.svgz",
         "sound" : "voices-$CA/$LOCALE/france/pays-de-la-loire.$CA",
         "x" : "0.3026",
         "y" : "0.3842",
         //: Region of France: Pays de la Loire
         "toolTipText" : qsTr("Pays de la Loire")
      },
      {
         "pixmapfile" : "france/ile-de-france.svgz",
         "sound" : "voices-$CA/$LOCALE/france/ile-de-france.$CA",
         "x" : "0.5188",
         "y" : "0.2626",
         //: Region of France: Île-de-France
         "toolTipText" : qsTr("Île-de-France")
      },
      {
         "pixmapfile" : "france/brittany.svgz",
         "sound" : "voices-$CA/$LOCALE/france/bretagne.$CA",
         "x" : "0.1549",
         "y" : "0.3213",
         //: Region of France: Brittany
         "toolTipText" : qsTr("Brittany")
      },
      {
         "pixmapfile" : "france/normandy.svgz",
         "sound" : "voices-$CA/$LOCALE/france/normandie.$CA",
         "x" : "0.3514",
         "y" : "0.2198",
         //: Region of France: Normandy
         "toolTipText" : qsTr("Normandy")
      },
      {
         "pixmapfile" : "france/hauts_de_france.svgz",
         "sound" : "voices-$CA/$LOCALE/france/haut-de-france.$CA",
         "x" : "0.5403",
         "y" : "0.1398",
         //: Region of France: Hauts de France
         "toolTipText" : qsTr("Hauts de France")
      },
      {
         "pixmapfile" : "france/grand_est.svgz",
         "sound" : "voices-$CA/$LOCALE/france/grand-est.$CA",
         "x" : "0.7346",
         "y" : "0.252",
         //: Region of France: Grand est
         "toolTipText" : qsTr("Grand est")
      },
      {
         "pixmapfile" : "france/bourgogne-franche-comte.svgz",
         "sound" : "voices-$CA/$LOCALE/france/bourgogne-franche-comte.$CA",
         "x" : "0.6816",
         "y" : "0.3977",
         //: Region of France: Bourgogne-Franche-Comté
         "toolTipText" : qsTr("Bourgogne-Franche-Comté")
      }
   ]
}
