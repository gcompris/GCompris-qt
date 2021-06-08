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
         "x" : "0.4289",
         "y" : "0.1718"
      },
      {
         "pixmapfile" : "argentina/tierra_del_fuego.svgz",
         //: Province of Argentina: Tierra del Fuego
         "toolTipText" : qsTr("Tierra del Fuego"),
         "x" : "0.3922",
         "y" : "0.9464"
      },
      {
         "pixmapfile" : "argentina/santiago_del_estero.svgz",
         //: Province of Argentina: Santiago del Estero
         "toolTipText" : qsTr("Santiago del Estero"),
         "x" : "0.5066",
         "y" : "0.2005"
      },
      {
         "pixmapfile" : "argentina/santa_fe.svgz",
         //: Province of Argentina: Santa Fe
         "toolTipText" : qsTr("Santa Fe"),
         "x" : "0.612",
         "y" : "0.2916"
      },
      {
         "pixmapfile" : "argentina/santa_cruz.svgz",
         //: Province of Argentina: Santa Cruz
         "toolTipText" : qsTr("Santa Cruz"),
         "x" : "0.2514",
         "y" : "0.8102"
      },
      {
         "pixmapfile" : "argentina/san_luis.svgz",
         //: Province of Argentina: San Luis
         "toolTipText" : qsTr("San Luis"),
         "x" : "0.3936",
         "y" : "0.3704"
      },
      {
         "pixmapfile" : "argentina/san_juan.svgz",
         //: Province of Argentina: San Juan
         "toolTipText" : qsTr("San Juan"),
         "x" : "0.2929",
         "y" : "0.272"
      },
      {
         "pixmapfile" : "argentina/salta.svgz",
         //: Province of Argentina: Salta
         "toolTipText" : qsTr("Salta"),
         "x" : "0.4238",
         "y" : "0.0899"
      },
      {
         "pixmapfile" : "argentina/rio_negro.svgz",
         //: Province of Argentina: Río Negro
         "toolTipText" : qsTr("Río Negro"),
         "x" : "0.3451",
         "y" : "0.5393"
      },
      {
         "pixmapfile" : "argentina/neuquen.svgz",
         //: Province of Argentina: Neuquén
         "toolTipText" : qsTr("Neuquén"),
         "x" : "0.2365",
         "y" : "0.5045"
      },
      {
         "pixmapfile" : "argentina/misiones.svgz",
         //: Province of Argentina: Misiones
         "toolTipText" : qsTr("Misiones"),
         "x" : "0.8607",
         "y" : "0.1656"
      },
      {
         "pixmapfile" : "argentina/mendoza.svgz",
         //: Province of Argentina: Mendoza
         "toolTipText" : qsTr("Mendoza"),
         "x" : "0.2963",
         "y" : "0.3952"
      },
      {
         "pixmapfile" : "argentina/la_rioja.svgz",
         //: Province of Argentina: La Rioja
         "toolTipText" : qsTr("La Rioja"),
         "x" : "0.3385",
         "y" : "0.2535"
      },
      {
         "pixmapfile" : "argentina/la_pampa.svgz",
         //: Province of Argentina: La Pampa
         "toolTipText" : qsTr("La Pampa"),
         "x" : "0.4076",
         "y" : "0.4637"
      },
      {
         "pixmapfile" : "argentina/jujuy.svgz",
         //: Province of Argentina: Jujuy
         "toolTipText" : qsTr("Jujuy"),
         "x" : "0.4142",
         "y" : "0.0608"
      },
      {
         "pixmapfile" : "argentina/formosa.svgz",
         //: Province of Argentina: Formosa
         "toolTipText" : qsTr("Formosa"),
         "x" : "0.6502",
         "y" : "0.1036"
      },
      {
         "pixmapfile" : "argentina/entre_rios.svgz",
         //: Province of Argentina: Entre Rios
         "toolTipText" : qsTr("Entre Rios"),
         "x" : "0.6782",
         "y" : "0.3177"
      },
      {
         "pixmapfile" : "argentina/corrientes.svgz",
         //: Province of Argentina: Corrientes
         "toolTipText" : qsTr("Corrientes"),
         "x" : "0.7454",
         "y" : "0.2279"
      },
      {
         "pixmapfile" : "argentina/cordoba.svgz",
         //: Province of Argentina: Córdoba
         "toolTipText" : qsTr("Córdoba"),
         "x" : "0.4927",
         "y" : "0.3228"
      },
      {
         "pixmapfile" : "argentina/chubut.svgz",
         //: Province of Argentina: Chubut
         "toolTipText" : qsTr("Chubut"),
         "x" : "0.3232",
         "y" : "0.6606"
      },
      {
         "pixmapfile" : "argentina/chaco.svgz",
         //: Province of Argentina: Chaco
         "toolTipText" : qsTr("Chaco"),
         "x" : "0.6118",
         "y" : "0.1434"
      },
      {
         "pixmapfile" : "argentina/catamarca.svgz",
         //: Province of Argentina: Catamarca
         "toolTipText" : qsTr("Catamarca"),
         "x" : "0.3623",
         "y" : "0.1895"
      },
      {
         "pixmapfile" : "argentina/buenos_aires.svgz",
         //: Province of Argentina: Buenos Aires
         "toolTipText" : qsTr("Buenos Aires"),
         "x" : "0.6472",
         "y" : "0.4638"
      }
   ]
}
