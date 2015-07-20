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
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Districts of France")
   property variant levels: [
      {
         "pixmapfile" : "france/france-regions.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "france/rhone-alpes.png",
         "sound": "voices-$CA/$LOCALE/france/rhone-alpes.$CA",
         "toolTipText" : "Rhône Alpes",
         "x" : "0.639",
         "y" : "0.6"
      },
      {
         "pixmapfile" : "france/paca.png",
         "sound": "voices-$CA/$LOCALE/france/provence-alpes-cote_d_azur.$CA",
         "toolTipText" : "Provence Alpes Côte d'Azur",
         "x" : "0.671",
         "y" : "0.73"
      },
      {
         "pixmapfile" : "france/poitou-charentes.png",
         "sound": "voices-$CA/$LOCALE/france/poitou-charentes.$CA",
         "toolTipText" : "Poitou Charentes",
         "x" : "0.363",
         "y" : "0.517"
      },
      {
         "pixmapfile" : "france/picardie.png",
         "sound": "voices-$CA/$LOCALE/france/picardie.$CA",
         "toolTipText" : "Picardie",
         "x" : "0.506",
         "y" : "0.158"
      },
      {
         "pixmapfile" : "france/pays-de-la-loire.png",
         "sound": "voices-$CA/$LOCALE/france/pays-de-la-loire.$CA",
         "toolTipText" : "Pays de la Loire",
         "x" : "0.333",
         "y" : "0.382"
      },
      {
         "pixmapfile" : "france/nord-pas-de-calais.png",
         "sound": "voices-$CA/$LOCALE/france/nord-pas-de-calais.$CA",
         "toolTipText" : "Nord Pas de Calais",
         "x" : "0.51",
         "y" : "0.062"
      },
      {
         "pixmapfile" : "france/midi-pyrenees.png",
         "sound": "voices-$CA/$LOCALE/france/midi-pyrenees.$CA",
         "toolTipText" : "Midi Pyrénées",
         "x" : "0.444",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "france/lorraine.png",
         "sound": "voices-$CA/$LOCALE/france/lorraine.$CA",
         "toolTipText" : "Lorraine",
         "x" : "0.667",
         "y" : "0.243"
      },
      {
         "pixmapfile" : "france/limousin.png",
         "sound": "voices-$CA/$LOCALE/france/limousin.$CA",
         "toolTipText" : "Limousin",
         "x" : "0.45",
         "y" : "0.566"
      },
      {
         "pixmapfile" : "france/languedoc-roussillon.png",
         "sound": "voices-$CA/$LOCALE/france/languedoc-roussillon.$CA",
         "toolTipText" : "Languedoc Roussillon",
         "x" : "0.532",
         "y" : "0.778"
      },
      {
         "pixmapfile" : "france/ile-de-france.png",
         "sound": "voices-$CA/$LOCALE/france/ile-de-france.$CA",
         "toolTipText" : "Ile de France",
         "x" : "0.493",
         "y" : "0.253"
      },
      {
         "pixmapfile" : "france/haute-normandie.png",
         "sound": "voices-$CA/$LOCALE/france/haute-normandie.$CA",
         "toolTipText" : "Normandie",
         "x" : "0.421",
         "y" : "0.181"
      },
      {
         "pixmapfile" : "france/franche-conte.png",
         "sound": "voices-$CA/$LOCALE/france/franche-conte.$CA",
         "toolTipText" : "Franche Comté",
         "x" : "0.669",
         "y" : "0.407"
      },
      {
         "pixmapfile" : "france/corse.png",
         "sound": "voices-$CA/$LOCALE/france/corse.$CA",
         "toolTipText" : "Corse",
         "x" : "0.836",
         "y" : "0.909"
      },
      {
         "pixmapfile" : "france/champagne-ardenne.png",
         "sound": "voices-$CA/$LOCALE/france/champagne-ardenne.$CA",
         "toolTipText" : "Champagne Ardenne",
         "x" : "0.593",
         "y" : "0.23"
      },
      {
         "pixmapfile" : "france/centre.png",
         "sound": "voices-$CA/$LOCALE/france/centre.$CA",
         "toolTipText" : "Centre",
         "x" : "0.449",
         "y" : "0.361"
      },
      {
         "pixmapfile" : "france/bretagne.png",
         "sound": "voices-$CA/$LOCALE/france/bretagne.$CA",
         "toolTipText" : "Bretagne",
         "x" : "0.231",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "france/bourgogne.png",
         "sound": "voices-$CA/$LOCALE/france/bourgogne.$CA",
         "toolTipText" : "Bourgogne",
         "x" : "0.574",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "france/basse-normandie.png",
         "sound": "voices-$CA/$LOCALE/france/basse-normandie.$CA",
         "toolTipText" : "Basse Normandie",
         "x" : "0.354",
         "y" : "0.22"
      },
      {
         "pixmapfile" : "france/auvergne.png",
         "sound": "voices-$CA/$LOCALE/france/auvergne.$CA",
         "toolTipText" : "Auvergne",
         "x" : "0.532",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "france/aquitaine.png",
         "sound": "voices-$CA/$LOCALE/france/aquitaine.$CA",
         "toolTipText" : "Aquitaine",
         "x" : "0.357",
         "y" : "0.714"
      },
      {
         "pixmapfile" : "france/alsace.png",
         "sound": "voices-$CA/$LOCALE/france/alsace.$CA",
         "toolTipText" : "Alsace",
         "x" : "0.729",
         "y" : "0.286"
      }
   ]
}
