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
   property string instruction: qsTr("Regions of France")
   property var levels: [
      {
         "pixmapfile" : "france/france.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "france/corsica.svgz",
         "sound" : "voices-$CA/$LOCALE/france/corse.$CA",
         "x" : "0.9454",
         "y" : "0.8898",
         //: Region of France: Corsica
         "toolTipText" : qsTr("Corsica")
      },
      {
         "pixmapfile" : "france/nouvelle-aquitaine.svgz",
         "sound" : "voices-$CA/$LOCALE/france/nouvelle-aquitaine.$CA",
         "x" : "0.3499",
         "y" : "0.6263",
         //: Region of France: Nouvelle-Aquitaine
         "toolTipText" : qsTr("Nouvelle-Aquitaine")
      },
      {
         "pixmapfile" : "france/occitanie.svgz",
         "sound" : "voices-$CA/$LOCALE/france/occitanie.$CA",
         "x" : "0.4734",
         "y" : "0.7584",
         //: Region of France: Occitanie
         "toolTipText" : qsTr("Occitanie")
      },
      {
         "pixmapfile" : "france/paca.svgz",
         "sound" : "voices-$CA/$LOCALE/france/paca.$CA",
         "x" : "0.7256",
         "y" : "0.7177",
         //: Region of France: Provence-Alpes-Côte d'Azur
         "toolTipText" : qsTr("Provence-Alpes-Côte d'Azur")
      },
      {
         "pixmapfile" : "france/auvergne-rhone-alpes.svgz",
         "sound" : "voices-$CA/$LOCALE/france/auvergne-rhone-alpes.$CA",
         "x" : "0.632",
         "y" : "0.5817",
         //: Region of France: Auvergne-Rhône-Alpes
         "toolTipText" : qsTr("Auvergne-Rhône-Alpes")
      },
      {
         "pixmapfile" : "france/centre-val_de_loire.svgz",
         "sound" : "voices-$CA/$LOCALE/france/centre-val-de-loire.$CA",
         "x" : "0.4359",
         "y" : "0.3658",
         //: Region of France: Centre-Val de Loire
         "toolTipText" : qsTr("Centre-Val de Loire")
      },
      {
         "pixmapfile" : "france/pays_de_la_loire.svgz",
         "sound" : "voices-$CA/$LOCALE/france/pays-de-la-loire.$CA",
         "x" : "0.2845",
         "y" : "0.3827",
         //: Region of France: Pays de la Loire
         "toolTipText" : qsTr("Pays de la Loire")
      },
      {
         "pixmapfile" : "france/ile-de-france.svgz",
         "sound" : "voices-$CA/$LOCALE/france/ile-de-france.$CA",
         "x" : "0.4945",
         "y" : "0.263",
         //: Region of France: Île-de-France
         "toolTipText" : qsTr("Île-de-France")
      },
      {
         "pixmapfile" : "france/brittany.svgz",
         "sound" : "voices-$CA/$LOCALE/france/bretagne.$CA",
         "x" : "0.1475",
         "y" : "0.3082",
         //: Region of France: Brittany
         "toolTipText" : qsTr("Brittany")
      },
      {
         "pixmapfile" : "france/normandy.svgz",
         "sound" : "voices-$CA/$LOCALE/france/normandie.$CA",
         "x" : "0.339",
         "y" : "0.2175",
         //: Region of France: Normandy
         "toolTipText" : qsTr("Normandy")
      },
      {
         "pixmapfile" : "france/hauts_de_france.svgz",
         "sound" : "voices-$CA/$LOCALE/france/haut-de-france.$CA",
         "x" : "0.5149",
         "y" : "0.1357",
         //: Region of France: Hauts de France
         "toolTipText" : qsTr("Hauts de France")
      },
      {
         "pixmapfile" : "france/grand_est.svgz",
         "sound" : "voices-$CA/$LOCALE/france/grand-est.$CA",
         "x" : "0.698",
         "y" : "0.2476",
         //: Region of France: Grand est
         "toolTipText" : qsTr("Grand est")
      },
      {
         "pixmapfile" : "france/bourgogne-franche-comte.svgz",
         "sound" : "voices-$CA/$LOCALE/france/bourgogne-franche-comte.$CA",
         "x" : "0.6514",
         "y" : "0.4027",
         //: Region of France: Bourgogne-Franche-Comté
         "toolTipText" : qsTr("Bourgogne-Franche-Comté")
      }
   ]
}
