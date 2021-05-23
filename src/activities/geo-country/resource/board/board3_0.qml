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
   property string instruction: qsTr("Districts of Argentina")
   property var levels: [
      {
         "pixmapfile" : "argentina/argentina.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "argentina/tucuman.png",
         //: District of Argentina: Tucuman
         "toolTipText" : qsTr("Tucuman"),
         "x" : "0.434",
         "y" : "0.178"
      },
      {
         "pixmapfile" : "argentina/tierra_del_fuego.png",
         //: District of Argentina: Tierra del Fuego
         "toolTipText" : qsTr("Tierra del Fuego"),
         "x" : "0.437",
         "y" : "0.881"
      },
      {
         "pixmapfile" : "argentina/santiago_del_estero.png",
         //: District of Argentina: Santiago del Estero
         "toolTipText" : qsTr("Santiago del Estero"),
         "x" : "0.489",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "argentina/santa_fe.png",
         //: District of Argentina: Santa Fe
         "toolTipText" : qsTr("Santa Fe"),
         "x" : "0.56",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "argentina/santa_cruz.png",
         //: District of Argentina: Santa Cruz
         "toolTipText" : qsTr("Santa Cruz"),
         "x" : "0.363",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "argentina/san_luis.png",
         //: District of Argentina: San Luis
         "toolTipText" : qsTr("San Luis"),
         "x" : "0.415",
         "y" : "0.355"
      },
      {
         "pixmapfile" : "argentina/san_juan.png",
         //: District of Argentina: San Juan
         "toolTipText" : qsTr("San Juan"),
         "x" : "0.346",
         "y" : "0.269"
      },
      {
         "pixmapfile" : "argentina/salta.png",
         //: District of Argentina: Salta
         "toolTipText" : qsTr("Salta"),
         "x" : "0.432",
         "y" : "0.103"
      },
      {
         "pixmapfile" : "argentina/rio_negro.png",
         //: District of Argentina: Rio Negro
         "toolTipText" : qsTr("Rio Negro"),
         "x" : "0.4",
         "y" : "0.507"
      },
      {
         "pixmapfile" : "argentina/neuquen.png",
         //: District of Argentina: Neuquen
         "toolTipText" : qsTr("Neuquen"),
         "x" : "0.332",
         "y" : "0.481"
      },
      {
         "pixmapfile" : "argentina/misiones.png",
         //: District of Argentina: Misiones
         "toolTipText" : qsTr("Misiones"),
         "x" : "0.734",
         "y" : "0.178"
      },
      {
         "pixmapfile" : "argentina/mendoza.png",
         //: District of Argentina: Mendoza
         "toolTipText" : qsTr("Mendoza"),
         "x" : "0.36",
         "y" : "0.379"
      },
      {
         "pixmapfile" : "argentina/la_rioja.png",
         //: District of Argentina: La Rioja
         "toolTipText" : qsTr("La Rioja"),
         "x" : "0.377",
         "y" : "0.25"
      },
      {
         "pixmapfile" : "argentina/la_pampa.png",
         //: District of Argentina: La Pampa
         "toolTipText" : qsTr("La Pampa"),
         "x" : "0.432",
         "y" : "0.437"
      },
      {
         "pixmapfile" : "argentina/jujuy.png",
         //: District of Argentina: Jujuy
         "toolTipText" : qsTr("Jujuy"),
         "x" : "0.42",
         "y" : "0.075"
      },
      {
         "pixmapfile" : "argentina/formosa.png",
         //: District of Argentina: Formosa
         "toolTipText" : qsTr("Formosa"),
         "x" : "0.588",
         "y" : "0.117"
      },
      {
         "pixmapfile" : "argentina/entre_rios.png",
         //: District of Argentina: Entre Rios
         "toolTipText" : qsTr("Entre Rios"),
         "x" : "0.6",
         "y" : "0.308"
      },
      {
         "pixmapfile" : "argentina/corrientes.png",
         //: District of Argentina: Corrientes
         "toolTipText" : qsTr("Corrientes"),
         "x" : "0.648",
         "y" : "0.227"
      },
      {
         "pixmapfile" : "argentina/cordoba.png",
         //: District of Argentina: Cordoba
         "toolTipText" : qsTr("Cordoba"),
         "x" : "0.477",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "argentina/chubut.png",
         //: District of Argentina: Chubut
         "toolTipText" : qsTr("Chubut"),
         "x" : "0.389",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "argentina/chaco.png",
         //: District of Argentina: Chaco
         "toolTipText" : qsTr("Chaco"),
         "x" : "0.563",
         "y" : "0.152"
      },
      {
         "pixmapfile" : "argentina/catamarca.png",
         //: District of Argentina: Catamarca
         "toolTipText" : qsTr("Catamarca"),
         "x" : "0.389",
         "y" : "0.189"
      },
      {
         "pixmapfile" : "argentina/buenos_aires.png",
         //: District of Argentina: Buenos Aires
         "toolTipText" : qsTr("Buenos Aires"),
         "x" : "0.577",
         "y" : "0.439"
      }
   ]
}
