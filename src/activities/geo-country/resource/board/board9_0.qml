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
   property string instruction: qsTr("States of Mexico")
   property var levels: [
      {
         "pixmapfile" : "mexico/mexico.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "mexico/zacatecas.svgz",
         //: State of Mexico: Zacatecas
         "toolTipText" : qsTr("Zacatecas"),
         "x" : "0.4807",
         "y" : "0.5274"
      },
      {
         "pixmapfile" : "mexico/yucatan.svgz",
         //: State of Mexico: Yucatan
         "toolTipText" : qsTr("Yucatan"),
         "x" : "0.9099",
         "y" : "0.6548"
      },
      {
         "pixmapfile" : "mexico/veracruz.svgz",
         //: State of Mexico: Veracruz
         "toolTipText" : qsTr("Veracruz"),
         "x" : "0.6832",
         "y" : "0.6947"
      },
      {
         "pixmapfile" : "mexico/tlaxcala.svgz",
         //: State of Mexico: Tlaxcala
         "toolTipText" : qsTr("Tlaxcala"),
         "x" : "0.6191",
         "y" : "0.7143"
      },
      {
         "pixmapfile" : "mexico/tamaulipas.svgz",
         //: State of Mexico: Tamaulipas
         "toolTipText" : qsTr("Tamaulipas"),
         "x" : "0.6038",
         "y" : "0.4327"
      },
      {
         "pixmapfile" : "mexico/tabasco.svgz",
         //: State of Mexico: Tabasco
         "toolTipText" : qsTr("Tabasco"),
         "x" : "0.796",
         "y" : "0.7891"
      },
      {
         "pixmapfile" : "mexico/sonora.svgz",
         //: State of Mexico: Sonora
         "toolTipText" : qsTr("Sonora"),
         "x" : "0.1897",
         "y" : "0.2058"
      },
      {
         "pixmapfile" : "mexico/sinaloa.svgz",
         //: State of Mexico: Sinaloa
         "toolTipText" : qsTr("Sinaloa"),
         "x" : "0.3268",
         "y" : "0.4421"
      },
      {
         "pixmapfile" : "mexico/san_luis_potosi.svgz",
         //: State of Mexico: San Luis Potosi
         "toolTipText" : qsTr("San Luis Potosi"),
         "x" : "0.5512",
         "y" : "0.5405"
      },
      {
         "pixmapfile" : "mexico/quintana_roo.svgz",
         //: State of Mexico: Quintana Roo
         "toolTipText" : qsTr("Quintana Roo"),
         "x" : "0.94",
         "y" : "0.6975"
      },
      {
         "pixmapfile" : "mexico/queretaro.svgz",
         //: State of Mexico: Queretaro
         "toolTipText" : qsTr("Queretaro"),
         "x" : "0.5667",
         "y" : "0.6413"
      },
      {
         "pixmapfile" : "mexico/puebla.svgz",
         //: State of Mexico: Puebla
         "toolTipText" : qsTr("Puebla"),
         "x" : "0.6251",
         "y" : "0.7179"
      },
      {
         "pixmapfile" : "mexico/oaxaca.svgz",
         //: State of Mexico: Oaxaca
         "toolTipText" : qsTr("Oaxaca"),
         "x" : "0.6805",
         "y" : "0.8292"
      },
      {
         "pixmapfile" : "mexico/nuevo_leon.svgz",
         //: State of Mexico: Nuevo Leon
         "toolTipText" : qsTr("Nuevo Leon"),
         "x" : "0.5671",
         "y" : "0.4055"
      },
      {
         "pixmapfile" : "mexico/nayarit.svgz",
         //: State of Mexico: Nayarit
         "toolTipText" : qsTr("Nayarit"),
         "x" : "0.3962",
         "y" : "0.5905"
      },
      {
         "pixmapfile" : "mexico/morelos.svgz",
         //: State of Mexico: Morelos
         "toolTipText" : qsTr("Morelos"),
         "x" : "0.5895",
         "y" : "0.7484"
      },
      {
         "pixmapfile" : "mexico/michoacan.svgz",
         //: State of Mexico: Michoacan
         "toolTipText" : qsTr("Michoacan"),
         "x" : "0.5005",
         "y" : "0.7276"
      },
      {
         "pixmapfile" : "mexico/jalisco.svgz",
         //: State of Mexico: Jalisco
         "toolTipText" : qsTr("Jalisco"),
         "x" : "0.4466",
         "y" : "0.6422"
      },
      {
         "pixmapfile" : "mexico/hidalgo.svgz",
         //: State of Mexico: Hidalgo
         "toolTipText" : qsTr("Hidalgo"),
         "x" : "0.5952",
         "y" : "0.6595"
      },
      {
         "pixmapfile" : "mexico/guerrero.svgz",
         //: State of Mexico: Guerrero
         "toolTipText" : qsTr("Guerrero"),
         "x" : "0.5582",
         "y" : "0.8067"
      },
      {
         "pixmapfile" : "mexico/guanajuato.svgz",
         //: State of Mexico: Guanajuato
         "toolTipText" : qsTr("Guanajuato"),
         "x" : "0.5331",
         "y" : "0.6401"
      },
      {
         "pixmapfile" : "mexico/estado_de_mexico.svgz",
         //: State of Mexico: Estado de Mexico
         "toolTipText" : qsTr("Estado de Mexico"),
         "x" : "0.5733",
         "y" : "0.7188"
      },
      {
         "pixmapfile" : "mexico/durango.svgz",
         //: State of Mexico: Durango
         "toolTipText" : qsTr("Durango"),
         "x" : "0.4082",
         "y" : "0.4505"
      },
      {
         "pixmapfile" : "mexico/districto_federal.svgz",
         //: State of Mexico: Districto Federal
         "toolTipText" : qsTr("Districto Federal"),
         "x" : "0.5873",
         "y" : "0.7192"
      },
      {
         "pixmapfile" : "mexico/coahuila.svgz",
         //: State of Mexico: Coahuila
         "toolTipText" : qsTr("Coahuila"),
         "x" : "0.5009",
         "y" : "0.3171"
      },
      {
         "pixmapfile" : "mexico/chiapas.svgz",
         //: State of Mexico: Chiapas
         "toolTipText" : qsTr("Chiapas"),
         "x" : "0.8053",
         "y" : "0.8759"
      },
      {
         "pixmapfile" : "mexico/chihuahua.svgz",
         //: State of Mexico: Chihuahua
         "toolTipText" : qsTr("Chihuahua"),
         "x" : "0.3653",
         "y" : "0.2424"
      },
      {
         "pixmapfile" : "mexico/campeche.svgz",
         //: State of Mexico: Campeche
         "toolTipText" : qsTr("Campeche"),
         "x" : "0.8517",
         "y" : "0.7186"
      },
      {
         "pixmapfile" : "mexico/baja_california.svgz",
         //: State of Mexico: Baja California
         "toolTipText" : qsTr("Baja California"),
         "x" : "0.0884",
         "y" : "0.1571"
      },
      {
         "pixmapfile" : "mexico/baja_california_sur.svgz",
         //: State of Mexico: Baja California Sur
         "toolTipText" : qsTr("Baja California Sur"),
         "x" : "0.1741",
         "y" : "0.4074"
      },
      {
         "pixmapfile" : "mexico/colima.svgz",
         //: State of Mexico: Colima
         "toolTipText" : qsTr("Colima"),
         "x" : "0.4336",
         "y" : "0.7302"
      },
      {
         "pixmapfile" : "mexico/aguascalientes.svgz",
         //: State of Mexico: Aguascalientes
         "toolTipText" : qsTr("Aguascalientes"),
         "x" : "0.4867",
         "y" : "0.5804"
      }
   ]
}
