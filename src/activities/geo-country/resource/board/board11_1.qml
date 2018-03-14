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
   property string instruction: qsTr("Districts of Northern Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/north/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/north/aosta.png",
         "toolTipText" : "Aosta",
         "x" : "0.126",
         "y" : "0.425"
      },
      {
         "pixmapfile" : "italy/north/imperia.png",
         "toolTipText" : "Imperia",
         "x" : "0.182",
         "y" : "0.895"
      },
      {
         "pixmapfile" : "italy/north/savona.png",
         "toolTipText" : "Savona",
         "x" : "0.244",
         "y" : "0.826"
      },
      {
         "pixmapfile" : "italy/north/genova.png",
         "toolTipText" : "Genova",
         "x" : "0.344",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "italy/north/la_spezia.png",
         "toolTipText" : "La_Spezia",
         "x" : "0.43",
         "y" : "0.82"
      },
      {
         "pixmapfile" : "italy/north/verbania.png",
         "toolTipText" : "Verbania",
         "x" : "0.245",
         "y" : "0.32"
      },
      {
         "pixmapfile" : "italy/north/vercelli.png",
         "toolTipText" : "Vercelli",
         "x" : "0.23",
         "y" : "0.469"
      },
      {
         "pixmapfile" : "italy/north/biella.png",
         "toolTipText" : "Biella",
         "x" : "0.218",
         "y" : "0.467"
      },
      {
         "pixmapfile" : "italy/north/novara.png",
         "toolTipText" : "Novara",
         "x" : "0.28",
         "y" : "0.463"
      },
      {
         "pixmapfile" : "italy/north/torino.png",
         "toolTipText" : "Torino",
         "x" : "0.131",
         "y" : "0.58"
      },
      {
         "pixmapfile" : "italy/north/cuneo.png",
         "toolTipText" : "Cuneo",
         "x" : "0.154",
         "y" : "0.756"
      },
      {
         "pixmapfile" : "italy/north/asti.png",
         "toolTipText" : "Asti",
         "x" : "0.231",
         "y" : "0.663"
      },
      {
         "pixmapfile" : "italy/north/alessandria.png",
         "toolTipText" : "Alessandria",
         "x" : "0.289",
         "y" : "0.663"
      },
      {
         "pixmapfile" : "italy/north/piacenza.png",
         "toolTipText" : "Piacenza",
         "x" : "0.413",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "italy/north/parma.png",
         "toolTipText" : "Parma",
         "x" : "0.457",
         "y" : "0.698"
      },
      {
         "pixmapfile" : "italy/north/reggio_emilia.png",
         "toolTipText" : "Reggio_Emilia",
         "x" : "0.527",
         "y" : "0.721"
      },
      {
         "pixmapfile" : "italy/north/modena.png",
         "toolTipText" : "Modena",
         "x" : "0.577",
         "y" : "0.741"
      },
      {
         "pixmapfile" : "italy/north/bologna.png",
         "toolTipText" : "Bologna",
         "x" : "0.63",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "italy/north/ferrara.png",
         "toolTipText" : "Ferrara",
         "x" : "0.687",
         "y" : "0.688"
      },
      {
         "pixmapfile" : "italy/north/ravenna.png",
         "toolTipText" : "Ravenna",
         "x" : "0.711",
         "y" : "0.783"
      },
      {
         "pixmapfile" : "italy/north/forli-cesena.png",
         "toolTipText" : "Forli-Cesena",
         "x" : "0.723",
         "y" : "0.87"
      },
      {
         "pixmapfile" : "italy/north/rimini.png",
         "toolTipText" : "Rimini",
         "x" : "0.77",
         "y" : "0.89"
      },
      {
         "pixmapfile" : "italy/north/varese.png",
         "toolTipText" : "Varese",
         "x" : "0.307",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "italy/north/milano.png",
         "toolTipText" : "Milano",
         "x" : "0.352",
         "y" : "0.482"
      },
      {
         "pixmapfile" : "italy/north/pavia.png",
         "toolTipText" : "Pavia",
         "x" : "0.335",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "italy/north/como.png",
         "toolTipText" : "Como",
         "x" : "0.358",
         "y" : "0.368"
      },
      {
         "pixmapfile" : "italy/north/lecco.png",
         "toolTipText" : "Lecco",
         "x" : "0.386",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "italy/north/sondrio.png",
         "toolTipText" : "Sondrio",
         "x" : "0.456",
         "y" : "0.267"
      },
      {
         "pixmapfile" : "italy/north/bergamo.png",
         "toolTipText" : "Bergamo",
         "x" : "0.442",
         "y" : "0.414"
      },
      {
         "pixmapfile" : "italy/north/brescia.png",
         "toolTipText" : "Brescia",
         "x" : "0.502",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "italy/north/lodi.png",
         "toolTipText" : "Lodi",
         "x" : "0.409",
         "y" : "0.546"
      },
      {
         "pixmapfile" : "italy/north/cremona.png",
         "toolTipText" : "Cremona",
         "x" : "0.465",
         "y" : "0.559"
      },
      {
         "pixmapfile" : "italy/north/mantova.png",
         "toolTipText" : "Mantova",
         "x" : "0.566",
         "y" : "0.573"
      },
      {
         "pixmapfile" : "italy/north/bolzano.png",
         "toolTipText" : "Bolzano",
         "x" : "0.643",
         "y" : "0.171"
      },
      {
         "pixmapfile" : "italy/north/trento.png",
         "toolTipText" : "Trento",
         "x" : "0.613",
         "y" : "0.325"
      },
      {
         "pixmapfile" : "italy/north/verona.png",
         "toolTipText" : "Verona",
         "x" : "0.596",
         "y" : "0.502"
      },
      {
         "pixmapfile" : "italy/north/vicenza.png",
         "toolTipText" : "Vicenza",
         "x" : "0.651",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "italy/north/padova.png",
         "toolTipText" : "Padova",
         "x" : "0.691",
         "y" : "0.51"
      },
      {
         "pixmapfile" : "italy/north/rovigo.png",
         "toolTipText" : "Rovigo",
         "x" : "0.7",
         "y" : "0.622"
      },
      {
         "pixmapfile" : "italy/north/venezia.png",
         "toolTipText" : "Venezia",
         "x" : "0.782",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "italy/north/treviso.png",
         "toolTipText" : "Treviso",
         "x" : "0.749",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "italy/north/belluno.png",
         "toolTipText" : "Belluno",
         "x" : "0.745",
         "y" : "0.276"
      },
      {
         "pixmapfile" : "italy/north/pordenone.png",
         "toolTipText" : "Pordenone",
         "x" : "0.805",
         "y" : "0.315"
      },
      {
         "pixmapfile" : "italy/north/udine.png",
         "toolTipText" : "Udine",
         "x" : "0.859",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "italy/north/gorizia.png",
         "toolTipText" : "Gorizia",
         "x" : "0.905",
         "y" : "0.392"
      },
      {
         "pixmapfile" : "italy/north/trieste.png",
         "toolTipText" : "Trieste",
         "x" : "0.941",
         "y" : "0.434"
      }
   ]
}
