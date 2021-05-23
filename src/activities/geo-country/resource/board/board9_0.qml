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
   property string instruction: qsTr("Districts of Mexico")
   property var levels: [
      {
         "pixmapfile" : "mexico/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "mexico/zacatecas.png",
         //: District of Mexico: Zacatecas
         "toolTipText" : qsTr("Zacatecas"),
         "x" : "0.451",
         "y" : "0.554"
      },
      {
         "pixmapfile" : "mexico/yucatan.png",
         //: District of Mexico: Yucatan
         "toolTipText" : qsTr("Yucatan"),
         "x" : "0.923",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "mexico/veracruz.png",
         //: District of Mexico: Veracruz
         "toolTipText" : qsTr("Veracruz"),
         "x" : "0.68",
         "y" : "0.73"
      },
      {
         "pixmapfile" : "mexico/tlaxcala.png",
         //: District of Mexico: Tlaxcala
         "toolTipText" : qsTr("Tlaxcala"),
         "x" : "0.604",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "mexico/tamaulipas.png",
         //: District of Mexico: Tamaulipas
         "toolTipText" : qsTr("Tamaulipas"),
         "x" : "0.585",
         "y" : "0.459"
      },
      {
         "pixmapfile" : "mexico/tabasco.png",
         //: District of Mexico: Tabasco
         "toolTipText" : qsTr("Tabasco"),
         "x" : "0.807",
         "y" : "0.817"
      },
      {
         "pixmapfile" : "mexico/sonora.png",
         //: District of Mexico: Sonora
         "toolTipText" : qsTr("Sonora"),
         "x" : "0.167",
         "y" : "0.194"
      },
      {
         "pixmapfile" : "mexico/sinaloa.png",
         //: District of Mexico: Sinaloa
         "toolTipText" : qsTr("Sinaloa"),
         "x" : "0.288",
         "y" : "0.461"
      },
      {
         "pixmapfile" : "mexico/san_luis_potosi.png",
         //: District of Mexico: San Luis Potosi
         "toolTipText" : qsTr("San Luis Potosi"),
         "x" : "0.528",
         "y" : "0.57"
      },
      {
         "pixmapfile" : "mexico/quintana_roo.png",
         //: District of Mexico: Quintana Roo
         "toolTipText" : qsTr("Quintana Roo"),
         "x" : "0.955",
         "y" : "0.712"
      },
      {
         "pixmapfile" : "mexico/queretaro.png",
         //: District of Mexico: Queretaro
         "toolTipText" : qsTr("Queretaro"),
         "x" : "0.547",
         "y" : "0.677"
      },
      {
         "pixmapfile" : "mexico/puebla.png",
         //: District of Mexico: Puebla
         "toolTipText" : qsTr("Puebla"),
         "x" : "0.615",
         "y" : "0.756"
      },
      {
         "pixmapfile" : "mexico/oaxaca.png",
         //: District of Mexico: Oaxaca
         "toolTipText" : qsTr("Oaxaca"),
         "x" : "0.677",
         "y" : "0.871"
      },
      {
         "pixmapfile" : "mexico/nuevo_leon.png",
         //: District of Mexico: Nuevo Leon
         "toolTipText" : qsTr("Nuevo Leon"),
         "x" : "0.545",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "mexico/nayarit.png",
         //: District of Mexico: Nayarit
         "toolTipText" : qsTr("Nayarit"),
         "x" : "0.369",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "mexico/morelos.png",
         //: District of Mexico: Morelos
         "toolTipText" : qsTr("Morelos"),
         "x" : "0.573",
         "y" : "0.792"
      },
      {
         "pixmapfile" : "mexico/michoacan.png",
         //: District of Mexico: Michoacan
         "toolTipText" : qsTr("Michoacan"),
         "x" : "0.472",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "mexico/jalisco.png",
         //: District of Mexico: Jalisco
         "toolTipText" : qsTr("Jalisco"),
         "x" : "0.413",
         "y" : "0.674"
      },
      {
         "pixmapfile" : "mexico/hidalgo.png",
         //: District of Mexico: Hidalgo
         "toolTipText" : qsTr("Hidalgo"),
         "x" : "0.58",
         "y" : "0.693"
      },
      {
         "pixmapfile" : "mexico/guerrero.png",
         //: District of Mexico: Guerrero
         "toolTipText" : qsTr("Guerrero"),
         "x" : "0.538",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "mexico/guanajuato.png",
         //: District of Mexico: Guanajuato
         "toolTipText" : qsTr("Guanajuato"),
         "x" : "0.507",
         "y" : "0.675"
      },
      {
         "pixmapfile" : "mexico/estado_de_mexico.png",
         //: District of Mexico: Estado de Mexico
         "toolTipText" : qsTr("Estado de Mexico"),
         "x" : "0.558",
         "y" : "0.758"
      },
      {
         "pixmapfile" : "mexico/durango.png",
         //: District of Mexico: Durango
         "toolTipText" : qsTr("Durango"),
         "x" : "0.377",
         "y" : "0.471"
      },
      {
         "pixmapfile" : "mexico/distrito_federal.png",
         //: District of Mexico: Distrito Federal
         "toolTipText" : qsTr("Distrito Federal"),
         "x" : "0.572",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "mexico/coahuila.png",
         //: District of Mexico: Coahuila
         "toolTipText" : qsTr("Coahuila"),
         "x" : "0.477",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "mexico/chiapas.png",
         //: District of Mexico: Chiapas
         "toolTipText" : qsTr("Chiapas"),
         "x" : "0.822",
         "y" : "0.91"
      },
      {
         "pixmapfile" : "mexico/chihuahua.png",
         //: District of Mexico: Chihuahua
         "toolTipText" : qsTr("Chihuahua"),
         "x" : "0.338",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "mexico/campeche.png",
         //: District of Mexico: Campeche
         "toolTipText" : qsTr("Campeche"),
         "x" : "0.862",
         "y" : "0.749"
      },
      {
         "pixmapfile" : "mexico/baja_california_norte.png",
         //: District of Mexico: Baja California Norte
         "toolTipText" : qsTr("Baja California Norte"),
         "x" : "0.06",
         "y" : "0.133"
      },
      {
         "pixmapfile" : "mexico/baja_california_sur.png",
         //: District of Mexico: Baja California Sur
         "toolTipText" : qsTr("Baja California Sur"),
         "x" : "0.129",
         "y" : "0.403"
      },
      {
         "pixmapfile" : "mexico/colima.png",
         //: District of Mexico: Colima
         "toolTipText" : qsTr("Colima"),
         "x" : "0.394",
         "y" : "0.771"
      },
      {
         "pixmapfile" : "mexico/aguascalientes.png",
         //: District of Mexico: Aguascalientes
         "toolTipText" : qsTr("Aguascalientes"),
         "x" : "0.455",
         "y" : "0.614"
      }
   ]
}
