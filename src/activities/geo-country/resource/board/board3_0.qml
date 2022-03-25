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
   property string instruction: qsTr("Provinces of Argentina")
   property var levels: [
      {
         "pixmapfile" : "argentina/argentina.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "argentina/tucuman.svgz",
         //: Province of Argentina: Tucumán
         "toolTipText" : qsTr("Tucumán"),
         "x" : "0.3337",
         "y" : "0.1706"
      },
      {
         "pixmapfile" : "argentina/tierra_del_fuego.svgz",
         //: Province of Argentina: Tierra del Fuego
         "toolTipText" : qsTr("Tierra del Fuego"),
         "x" : "0.3426",
         "y" : "0.9469"
      },
      {
         "pixmapfile" : "argentina/santiago_del_estero.svgz",
         //: Province of Argentina: Santiago del Estero
         "toolTipText" : qsTr("Santiago del Estero"),
         "x" : "0.4326",
         "y" : "0.1996"
      },
      {
         "pixmapfile" : "argentina/santa_fe.svgz",
         //: Province of Argentina: Santa Fe
         "toolTipText" : qsTr("Santa Fe"),
         "x" : "0.5636",
         "y" : "0.2901"
      },
      {
         "pixmapfile" : "argentina/santa_cruz.svgz",
         //: Province of Argentina: Santa Cruz
         "toolTipText" : qsTr("Santa Cruz"),
         "x" : "0.203",
         "y" : "0.8116"
      },
      {
         "pixmapfile" : "argentina/san_luis.svgz",
         //: Province of Argentina: San Luis
         "toolTipText" : qsTr("San Luis"),
         "x" : "0.2989",
         "y" : "0.3705"
      },
      {
         "pixmapfile" : "argentina/san_juan.svgz",
         //: Province of Argentina: San Juan
         "toolTipText" : qsTr("San Juan"),
         "x" : "0.177",
         "y" : "0.2757"
      },
      {
         "pixmapfile" : "argentina/salta.svgz",
         //: Province of Argentina: Salta
         "toolTipText" : qsTr("Salta"),
         "x" : "0.3268",
         "y" : "0.0891"
      },
      {
         "pixmapfile" : "argentina/rio_negro.svgz",
         //: Province of Argentina: Río Negro
         "toolTipText" : qsTr("Río Negro"),
         "x" : "0.2651",
         "y" : "0.5441"
      },
      {
         "pixmapfile" : "argentina/neuquen.svgz",
         //: Province of Argentina: Neuquén
         "toolTipText" : qsTr("Neuquén"),
         "x" : "0.1449",
         "y" : "0.511"
      },
      {
         "pixmapfile" : "argentina/misiones.svgz",
         //: Province of Argentina: Misiones
         "toolTipText" : qsTr("Misiones"),
         "x" : "0.8769",
         "y" : "0.1709"
      },
      {
         "pixmapfile" : "argentina/mendoza.svgz",
         //: Province of Argentina: Mendoza
         "toolTipText" : qsTr("Mendoza"),
         "x" : "0.1922",
         "y" : "0.3975"
      },
      {
         "pixmapfile" : "argentina/la_rioja.svgz",
         //: Province of Argentina: La Rioja
         "toolTipText" : qsTr("La Rioja"),
         "x" : "0.2261",
         "y" : "0.2545"
      },
      {
         "pixmapfile" : "argentina/la_pampa.svgz",
         //: Province of Argentina: La Pampa
         "toolTipText" : qsTr("La Pampa"),
         "x" : "0.3221",
         "y" : "0.462"
      },
      {
         "pixmapfile" : "argentina/jujuy.svgz",
         //: Province of Argentina: Jujuy
         "toolTipText" : qsTr("Jujuy"),
         "x" : "0.3123",
         "y" : "0.0603"
      },
      {
         "pixmapfile" : "argentina/formosa.svgz",
         //: Province of Argentina: Formosa
         "toolTipText" : qsTr("Formosa"),
         "x" : "0.6138",
         "y" : "0.1036"
      },
      {
         "pixmapfile" : "argentina/entre_rios.svgz",
         //: Province of Argentina: Entre Rios
         "toolTipText" : qsTr("Entre Rios"),
         "x" : "0.6382",
         "y" : "0.3183"
      },
      {
         "pixmapfile" : "argentina/corrientes.svgz",
         //: Province of Argentina: Corrientes
         "toolTipText" : qsTr("Corrientes"),
         "x" : "0.7271",
         "y" : "0.2289"
      },
      {
         "pixmapfile" : "argentina/cordoba.svgz",
         //: Province of Argentina: Córdoba
         "toolTipText" : qsTr("Córdoba"),
         "x" : "0.4156",
         "y" : "0.3211"
      },
      {
         "pixmapfile" : "argentina/chubut.svgz",
         //: Province of Argentina: Chubut
         "toolTipText" : qsTr("Chubut"),
         "x" : "0.245",
         "y" : "0.664"
      },
      {
         "pixmapfile" : "argentina/chaco.svgz",
         //: Province of Argentina: Chaco
         "toolTipText" : qsTr("Chaco"),
         "x" : "0.5635",
         "y" : "0.143"
      },
      {
         "pixmapfile" : "argentina/catamarca.svgz",
         //: Province of Argentina: Catamarca
         "toolTipText" : qsTr("Catamarca"),
         "x" : "0.2531",
         "y" : "0.1895"
      },
      {
         "pixmapfile" : "argentina/city_of_buenos_aires.svgz",
         // Province of Argentina: City of Buenos Aires
         // "toolTipText" : qsTr("City of Buenos Aires"),
          "type": "SHAPE_BACKGROUND",
         "x" : "0.6722",
         "y" : "0.3909"
      },
      {
         "pixmapfile" : "argentina/buenos_aires.svgz",
         //: Province of Argentina: Buenos Aires
         "toolTipText" : qsTr("Buenos Aires"),
         "x" : "0.5921",
         "y" : "0.4623"
      }
   ]
}
