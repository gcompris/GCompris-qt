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
   property string instruction: qsTr("Districts of Northern Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/north/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/north/aosta.png",
         //: District of Northern Italy: Aosta
         "toolTipText" : qsTr("Aosta"),
         "x" : "0.126",
         "y" : "0.425"
      },
      {
         "pixmapfile" : "italy/north/imperia.png",
         //: District of Northern Italy: Imperia
         "toolTipText" : qsTr("Imperia"),
         "x" : "0.182",
         "y" : "0.895"
      },
      {
         "pixmapfile" : "italy/north/savona.png",
         //: District of Northern Italy: Savona
         "toolTipText" : qsTr("Savona"),
         "x" : "0.244",
         "y" : "0.826"
      },
      {
         "pixmapfile" : "italy/north/genova.png",
         //: District of Northern Italy: Genova
         "toolTipText" : qsTr("Genova"),
         "x" : "0.344",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "italy/north/la_spezia.png",
         //: District of Northern Italy: La Spezia
         "toolTipText" : qsTr("La Spezia"),
         "x" : "0.43",
         "y" : "0.82"
      },
      {
         "pixmapfile" : "italy/north/verbania.png",
         //: District of Northern Italy: Verbania
         "toolTipText" : qsTr("Verbania"),
         "x" : "0.245",
         "y" : "0.32"
      },
      {
         "pixmapfile" : "italy/north/vercelli.png",
         //: District of Northern Italy: Vercelli
         "toolTipText" : qsTr("Vercelli"),
         "x" : "0.23",
         "y" : "0.469"
      },
      {
         "pixmapfile" : "italy/north/biella.png",
         //: District of Northern Italy: Biella
         "toolTipText" : qsTr("Biella"),
         "x" : "0.218",
         "y" : "0.467"
      },
      {
         "pixmapfile" : "italy/north/novara.png",
         //: District of Northern Italy: Novara
         "toolTipText" : qsTr("Novara"),
         "x" : "0.28",
         "y" : "0.463"
      },
      {
         "pixmapfile" : "italy/north/torino.png",
         //: District of Northern Italy: Torino
         "toolTipText" : qsTr("Torino"),
         "x" : "0.131",
         "y" : "0.58"
      },
      {
         "pixmapfile" : "italy/north/cuneo.png",
         //: District of Northern Italy: Cuneo
         "toolTipText" : qsTr("Cuneo"),
         "x" : "0.154",
         "y" : "0.756"
      },
      {
         "pixmapfile" : "italy/north/asti.png",
         //: District of Northern Italy: Asti
         "toolTipText" : qsTr("Asti"),
         "x" : "0.231",
         "y" : "0.663"
      },
      {
         "pixmapfile" : "italy/north/alessandria.png",
         //: District of Northern Italy: Alessandria
         "toolTipText" : qsTr("Alessandria"),
         "x" : "0.289",
         "y" : "0.663"
      },
      {
         "pixmapfile" : "italy/north/piacenza.png",
         //: District of Northern Italy: Piacenza
         "toolTipText" : qsTr("Piacenza"),
         "x" : "0.413",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "italy/north/parma.png",
         //: District of Northern Italy: Parma
         "toolTipText" : qsTr("Parma"),
         "x" : "0.457",
         "y" : "0.698"
      },
      {
         "pixmapfile" : "italy/north/reggio_emilia.png",
         //: District of Northern Italy: Reggio Emilia
         "toolTipText" : qsTr("Reggio Emilia"),
         "x" : "0.527",
         "y" : "0.721"
      },
      {
         "pixmapfile" : "italy/north/modena.png",
         //: District of Northern Italy: Modena
         "toolTipText" : qsTr("Modena"),
         "x" : "0.577",
         "y" : "0.741"
      },
      {
         "pixmapfile" : "italy/north/bologna.png",
         //: District of Northern Italy: Bologna
         "toolTipText" : qsTr("Bologna"),
         "x" : "0.63",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "italy/north/ferrara.png",
         //: District of Northern Italy: Ferrara
         "toolTipText" : qsTr("Ferrara"),
         "x" : "0.687",
         "y" : "0.688"
      },
      {
         "pixmapfile" : "italy/north/ravenna.png",
         //: District of Northern Italy: Ravenna
         "toolTipText" : qsTr("Ravenna"),
         "x" : "0.711",
         "y" : "0.783"
      },
      {
         "pixmapfile" : "italy/north/forli-cesena.png",
         //: District of Northern Italy: Forli-Cesena
         "toolTipText" : qsTr("Forli-Cesena"),
         "x" : "0.723",
         "y" : "0.87"
      },
      {
         "pixmapfile" : "italy/north/rimini.png",
         //: District of Northern Italy: Rimini
         "toolTipText" : qsTr("Rimini"),
         "x" : "0.77",
         "y" : "0.89"
      },
      {
         "pixmapfile" : "italy/north/varese.png",
         //: District of Northern Italy: Varese
         "toolTipText" : qsTr("Varese"),
         "x" : "0.307",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "italy/north/milano.png",
         //: District of Northern Italy: Milano
         "toolTipText" : qsTr("Milano"),
         "x" : "0.352",
         "y" : "0.482"
      },
      {
         "pixmapfile" : "italy/north/pavia.png",
         //: District of Northern Italy: Pavia
         "toolTipText" : qsTr("Pavia"),
         "x" : "0.335",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "italy/north/como.png",
         //: District of Northern Italy: Como
         "toolTipText" : qsTr("Como"),
         "x" : "0.358",
         "y" : "0.368"
      },
      {
         "pixmapfile" : "italy/north/lecco.png",
         //: District of Northern Italy: Lecco
         "toolTipText" : qsTr("Lecco"),
         "x" : "0.386",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "italy/north/sondrio.png",
         //: District of Northern Italy: Sondrio
         "toolTipText" : qsTr("Sondrio"),
         "x" : "0.456",
         "y" : "0.267"
      },
      {
         "pixmapfile" : "italy/north/bergamo.png",
         //: District of Northern Italy: Bergamo
         "toolTipText" : qsTr("Bergamo"),
         "x" : "0.442",
         "y" : "0.414"
      },
      {
         "pixmapfile" : "italy/north/brescia.png",
         //: District of Northern Italy: Brescia
         "toolTipText" : qsTr("Brescia"),
         "x" : "0.502",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "italy/north/lodi.png",
         //: District of Northern Italy: Lodi
         "toolTipText" : qsTr("Lodi"),
         "x" : "0.409",
         "y" : "0.546"
      },
      {
         "pixmapfile" : "italy/north/cremona.png",
         //: District of Northern Italy: Cremona
         "toolTipText" : qsTr("Cremona"),
         "x" : "0.465",
         "y" : "0.559"
      },
      {
         "pixmapfile" : "italy/north/mantova.png",
         //: District of Northern Italy: Mantova
         "toolTipText" : qsTr("Mantova"),
         "x" : "0.566",
         "y" : "0.573"
      },
      {
         "pixmapfile" : "italy/north/bolzano.png",
         //: District of Northern Italy: Bolzano
         "toolTipText" : qsTr("Bolzano"),
         "x" : "0.643",
         "y" : "0.171"
      },
      {
         "pixmapfile" : "italy/north/trento.png",
         //: District of Northern Italy: Trento
         "toolTipText" : qsTr("Trento"),
         "x" : "0.613",
         "y" : "0.325"
      },
      {
         "pixmapfile" : "italy/north/verona.png",
         //: District of Northern Italy: Verona
         "toolTipText" : qsTr("Verona"),
         "x" : "0.596",
         "y" : "0.502"
      },
      {
         "pixmapfile" : "italy/north/vicenza.png",
         //: District of Northern Italy: Vicenza
         "toolTipText" : qsTr("Vicenza"),
         "x" : "0.651",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "italy/north/padova.png",
         //: District of Northern Italy: Padova
         "toolTipText" : qsTr("Padova"),
         "x" : "0.691",
         "y" : "0.51"
      },
      {
         "pixmapfile" : "italy/north/rovigo.png",
         //: District of Northern Italy: Rovigo
         "toolTipText" : qsTr("Rovigo"),
         "x" : "0.7",
         "y" : "0.622"
      },
      {
         "pixmapfile" : "italy/north/venezia.png",
         //: District of Northern Italy: Venezia
         "toolTipText" : qsTr("Venezia"),
         "x" : "0.782",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "italy/north/treviso.png",
         //: District of Northern Italy: Treviso
         "toolTipText" : qsTr("Treviso"),
         "x" : "0.749",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "italy/north/belluno.png",
         //: District of Northern Italy: Belluno
         "toolTipText" : qsTr("Belluno"),
         "x" : "0.745",
         "y" : "0.276"
      },
      {
         "pixmapfile" : "italy/north/pordenone.png",
         //: District of Northern Italy: Pordenone
         "toolTipText" : qsTr("Pordenone"),
         "x" : "0.805",
         "y" : "0.315"
      },
      {
         "pixmapfile" : "italy/north/udine.png",
         //: District of Northern Italy: Udine
         "toolTipText" : qsTr("Udine"),
         "x" : "0.859",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "italy/north/gorizia.png",
         //: District of Northern Italy: Gorizia
         "toolTipText" : qsTr("Gorizia"),
         "x" : "0.905",
         "y" : "0.392"
      },
      {
         "pixmapfile" : "italy/north/trieste.png",
         //: District of Northern Italy: Trieste
         "toolTipText" : qsTr("Trieste"),
         "x" : "0.941",
         "y" : "0.434"
      }
   ]
}
