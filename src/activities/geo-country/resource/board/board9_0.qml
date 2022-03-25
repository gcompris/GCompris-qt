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
         "x" : "0.4575",
         "y" : "0.548"
      },
      {
         "pixmapfile" : "mexico/yucatan.svgz",
         //: State of Mexico: Yucatán
         "toolTipText" : qsTr("Yucatán"),
         "x" : "0.9058",
         "y" : "0.645"
      },
      {
         "pixmapfile" : "mexico/veracruz.svgz",
         //: State of Mexico: Veracruz
         "toolTipText" : qsTr("Veracruz"),
         "x" : "0.673",
         "y" : "0.7067"
      },
      {
         "pixmapfile" : "mexico/tlaxcala.svgz",
         //: State of Mexico: Tlaxcala
         "toolTipText" : qsTr("Tlaxcala"),
         "x" : "0.6035",
         "y" : "0.7301"
      },
      {
         "pixmapfile" : "mexico/tamaulipas.svgz",
         //: State of Mexico: Tamaulipas
         "toolTipText" : qsTr("Tamaulipas"),
         "x" : "0.5835",
         "y" : "0.4537"
      },
      {
         "pixmapfile" : "mexico/tabasco.svgz",
         //: State of Mexico: Tabasco
         "toolTipText" : qsTr("Tabasco"),
         "x" : "0.7954",
         "y" : "0.7918"
      },
      {
         "pixmapfile" : "mexico/sonora.svgz",
         //: State of Mexico: Sonora
         "toolTipText" : qsTr("Sonora"),
         "x" : "0.1777",
         "y" : "0.2139"
      },
      {
         "pixmapfile" : "mexico/sinaloa.svgz",
         //: State of Mexico: Sinaloa
         "toolTipText" : qsTr("Sinaloa"),
         "x" : "0.3021",
         "y" : "0.4601"
      },
      {
         "pixmapfile" : "mexico/san_luis_potosi.svgz",
         //: State of Mexico: San Luis Potosí
         "toolTipText" : qsTr("San Luis Potosí"),
         "x" : "0.5308",
         "y" : "0.5608"
      },
      {
         "pixmapfile" : "mexico/quintana_roo.svgz",
         //: State of Mexico: Quintana Roo
         "toolTipText" : qsTr("Quintana Roo"),
         "x" : "0.9401",
         "y" : "0.6838"
      },
      {
         "pixmapfile" : "mexico/queretaro.svgz",
         //: State of Mexico: Querétaro
         "toolTipText" : qsTr("Querétaro"),
         "x" : "0.5482",
         "y" : "0.6601"
      },
      {
         "pixmapfile" : "mexico/puebla.svgz",
         //: State of Mexico: Puebla
         "toolTipText" : qsTr("Puebla"),
         "x" : "0.6131",
         "y" : "0.7335"
      },
      {
         "pixmapfile" : "mexico/oaxaca.svgz",
         //: State of Mexico: Oaxaca
         "toolTipText" : qsTr("Oaxaca"),
         "x" : "0.6728",
         "y" : "0.8417"
      },
      {
         "pixmapfile" : "mexico/nuevo_leon.svgz",
         //: State of Mexico: Nuevo León
         "toolTipText" : qsTr("Nuevo León"),
         "x" : "0.5454",
         "y" : "0.4274"
      },
      {
         "pixmapfile" : "mexico/nayarit.svgz",
         //: State of Mexico: Nayarit
         "toolTipText" : qsTr("Nayarit"),
         "x" : "0.3705",
         "y" : "0.6095"
      },
      {
         "pixmapfile" : "mexico/morelos.svgz",
         //: State of Mexico: Morelos
         "toolTipText" : qsTr("Morelos"),
         "x" : "0.5739",
         "y" : "0.7655"
      },
      {
         "pixmapfile" : "mexico/michoacan.svgz",
         //: State of Mexico: Michoacán
         "toolTipText" : qsTr("Michoacán"),
         "x" : "0.4788",
         "y" : "0.7459"
      },
      {
         "pixmapfile" : "mexico/jalisco.svgz",
         //: State of Mexico: Jalisco
         "toolTipText" : qsTr("Jalisco"),
         "x" : "0.422",
         "y" : "0.6609"
      },
      {
         "pixmapfile" : "mexico/hidalgo.svgz",
         //: State of Mexico: Hidalgo
         "toolTipText" : qsTr("Hidalgo"),
         "x" : "0.5774",
         "y" : "0.6765"
      },
      {
         "pixmapfile" : "mexico/guerrero.svgz",
         //: State of Mexico: Guerrero
         "toolTipText" : qsTr("Guerrero"),
         "x" : "0.5402",
         "y" : "0.8229"
      },
      {
         "pixmapfile" : "mexico/guanajuato.svgz",
         //: State of Mexico: Guanajuato
         "toolTipText" : qsTr("Guanajuato"),
         "x" : "0.5119",
         "y" : "0.659"
      },
      {
         "pixmapfile" : "mexico/estado_de_mexico.svgz",
         //: State of Mexico: Estado de México
         "toolTipText" : qsTr("Estado de México"),
         "x" : "0.5556",
         "y" : "0.7368"
      },
      {
         "pixmapfile" : "mexico/durango.svgz",
         //: State of Mexico: Durango
         "toolTipText" : qsTr("Durango"),
         "x" : "0.3848",
         "y" : "0.4715"
      },
      {
         "pixmapfile" : "mexico/districto_federal.svgz",
         //: State of Mexico: Districto Federal
         "toolTipText" : qsTr("Districto Federal"),
         "x" : "0.5707",
         "y" : "0.737"
      },
      {
         "pixmapfile" : "mexico/coahuila.svgz",
         //: State of Mexico: Coahuila
         "toolTipText" : qsTr("Coahuila"),
         "x" : "0.4786",
         "y" : "0.3407"
      },
      {
         "pixmapfile" : "mexico/chiapas.svgz",
         //: State of Mexico: Chiapas
         "toolTipText" : qsTr("Chiapas"),
         "x" : "0.8079",
         "y" : "0.8772"
      },
      {
         "pixmapfile" : "mexico/chihuahua.svgz",
         //: State of Mexico: Chihuahua
         "toolTipText" : qsTr("Chihuahua"),
         "x" : "0.3449",
         "y" : "0.2622"
      },
      {
         "pixmapfile" : "mexico/campeche.svgz",
         //: State of Mexico: Campeche
         "toolTipText" : qsTr("Campeche"),
         "x" : "0.8531",
         "y" : "0.7166"
      },
      {
         "pixmapfile" : "mexico/baja_california.svgz",
         //: State of Mexico: Baja California
         "toolTipText" : qsTr("Baja California"),
         "x" : "0.0791",
         "y" : "0.1601"
      },
      {
         "pixmapfile" : "mexico/baja_california_sur.svgz",
         //: State of Mexico: Baja California Sur
         "toolTipText" : qsTr("Baja California Sur"),
         "x" : "0.1509",
         "y" : "0.4134"
      },
      {
         "pixmapfile" : "mexico/colima.svgz",
         //: State of Mexico: Colima
         "toolTipText" : qsTr("Colima"),
         "x" : "0.407",
         "y" : "0.7482"
      },
      {
         "pixmapfile" : "mexico/aguascalientes.svgz",
         //: State of Mexico: Aguascalientes
         "toolTipText" : qsTr("Aguascalientes"),
         "x" : "0.464",
         "y" : "0.6012"
      }
   ]
}
