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
   property string instruction: qsTr("Districts of Mexico")
   property var levels: [
      {
         "pixmapfile" : "mexico/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "mexico/zacatecas.png",
         "toolTipText" : "Zacatecas",
         "x" : "0.451",
         "y" : "0.554"
      },
      {
         "pixmapfile" : "mexico/yucatan.png",
         "toolTipText" : "Yucatan",
         "x" : "0.923",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "mexico/veracruz.png",
         "toolTipText" : "Veracruz",
         "x" : "0.68",
         "y" : "0.73"
      },
      {
         "pixmapfile" : "mexico/tlaxcala.png",
         "toolTipText" : "Tlaxcala",
         "x" : "0.604",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "mexico/tamaulipas.png",
         "toolTipText" : "Tamaulipas",
         "x" : "0.585",
         "y" : "0.459"
      },
      {
         "pixmapfile" : "mexico/tabasco.png",
         "toolTipText" : "Tabasco",
         "x" : "0.807",
         "y" : "0.817"
      },
      {
         "pixmapfile" : "mexico/sonora.png",
         "toolTipText" : "Sonora",
         "x" : "0.167",
         "y" : "0.194"
      },
      {
         "pixmapfile" : "mexico/sinaloa.png",
         "toolTipText" : "Sinaloa",
         "x" : "0.288",
         "y" : "0.461"
      },
      {
         "pixmapfile" : "mexico/san_luis_potosi.png",
         "toolTipText" : "San Luis Potosi",
         "x" : "0.528",
         "y" : "0.57"
      },
      {
         "pixmapfile" : "mexico/quintana_roo.png",
         "toolTipText" : "Quintana Roo",
         "x" : "0.955",
         "y" : "0.712"
      },
      {
         "pixmapfile" : "mexico/queretaro.png",
         "toolTipText" : "Queretaro",
         "x" : "0.547",
         "y" : "0.677"
      },
      {
         "pixmapfile" : "mexico/puebla.png",
         "toolTipText" : "Puebla",
         "x" : "0.615",
         "y" : "0.756"
      },
      {
         "pixmapfile" : "mexico/oaxaca.png",
         "toolTipText" : "Oaxaca",
         "x" : "0.677",
         "y" : "0.871"
      },
      {
         "pixmapfile" : "mexico/nuevo_leon.png",
         "toolTipText" : "Nuevo Leon",
         "x" : "0.545",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "mexico/nayarit.png",
         "toolTipText" : "Nayarit",
         "x" : "0.369",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "mexico/morelos.png",
         "toolTipText" : "Morelos",
         "x" : "0.573",
         "y" : "0.792"
      },
      {
         "pixmapfile" : "mexico/michoacan.png",
         "toolTipText" : "Michoacan",
         "x" : "0.472",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "mexico/jalisco.png",
         "toolTipText" : "Jalisco",
         "x" : "0.413",
         "y" : "0.674"
      },
      {
         "pixmapfile" : "mexico/hidalgo.png",
         "toolTipText" : "Hidalgo",
         "x" : "0.58",
         "y" : "0.693"
      },
      {
         "pixmapfile" : "mexico/guerrero.png",
         "toolTipText" : "Guerrero",
         "x" : "0.538",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "mexico/guanajuato.png",
         "toolTipText" : "Guanajuato",
         "x" : "0.507",
         "y" : "0.675"
      },
      {
         "pixmapfile" : "mexico/estado_de_mexico.png",
         "toolTipText" : "Estado de Mexico",
         "x" : "0.558",
         "y" : "0.758"
      },
      {
         "pixmapfile" : "mexico/durango.png",
         "toolTipText" : "Durango",
         "x" : "0.377",
         "y" : "0.471"
      },
      {
         "pixmapfile" : "mexico/distrito_federal.png",
         "toolTipText" : "Distrito Federal",
         "x" : "0.572",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "mexico/coahuila.png",
         "toolTipText" : "Coahuila",
         "x" : "0.477",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "mexico/chiapas.png",
         "toolTipText" : "Chiapas",
         "x" : "0.822",
         "y" : "0.91"
      },
      {
         "pixmapfile" : "mexico/chihuahua.png",
         "toolTipText" : "Chihuahua",
         "x" : "0.338",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "mexico/campeche.png",
         "toolTipText" : "Campeche",
         "x" : "0.862",
         "y" : "0.749"
      },
      {
         "pixmapfile" : "mexico/baja_california_norte.png",
         "toolTipText" : "Baja California Norte",
         "x" : "0.06",
         "y" : "0.133"
      },
      {
         "pixmapfile" : "mexico/baja_california_sur.png",
         "toolTipText" : "Baja California Sur",
         "x" : "0.129",
         "y" : "0.403"
      },
      {
         "pixmapfile" : "mexico/colima.png",
         "toolTipText" : "Colima",
         "x" : "0.394",
         "y" : "0.771"
      },
      {
         "pixmapfile" : "mexico/aguascalientes.png",
         "toolTipText" : "Aguascalientes",
         "x" : "0.455",
         "y" : "0.614"
      }
   ]
}
