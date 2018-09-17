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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Argentina")
   property var levels: [
      {
         "pixmapfile" : "argentina/argentina.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "argentina/tucuman.png",
         "toolTipText" : "Tucuman",
         "x" : "0.434",
         "y" : "0.178"
      },
      {
         "pixmapfile" : "argentina/tierra_del_fuego.png",
         "toolTipText" : "Tierra del Fuego",
         "x" : "0.437",
         "y" : "0.881"
      },
      {
         "pixmapfile" : "argentina/santiago_del_estero.png",
         "toolTipText" : "Santiago del Estero",
         "x" : "0.489",
         "y" : "0.192"
      },
      {
         "pixmapfile" : "argentina/santa_fe.png",
         "toolTipText" : "Santa Fe",
         "x" : "0.56",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "argentina/santa_cruz.png",
         "toolTipText" : "Santa Cruz",
         "x" : "0.363",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "argentina/san_luis.png",
         "toolTipText" : "San Luis",
         "x" : "0.415",
         "y" : "0.355"
      },
      {
         "pixmapfile" : "argentina/san_juan.png",
         "toolTipText" : "San Juan",
         "x" : "0.346",
         "y" : "0.269"
      },
      {
         "pixmapfile" : "argentina/salta.png",
         "toolTipText" : "Salta",
         "x" : "0.432",
         "y" : "0.103"
      },
      {
         "pixmapfile" : "argentina/rio_negro.png",
         "toolTipText" : "Rio Negro",
         "x" : "0.4",
         "y" : "0.507"
      },
      {
         "pixmapfile" : "argentina/neuquen.png",
         "toolTipText" : "Neuquen",
         "x" : "0.332",
         "y" : "0.481"
      },
      {
         "pixmapfile" : "argentina/misiones.png",
         "toolTipText" : "Misiones",
         "x" : "0.734",
         "y" : "0.178"
      },
      {
         "pixmapfile" : "argentina/mendoza.png",
         "toolTipText" : "Mendoza",
         "x" : "0.36",
         "y" : "0.379"
      },
      {
         "pixmapfile" : "argentina/la_rioja.png",
         "toolTipText" : "La Rioja",
         "x" : "0.377",
         "y" : "0.25"
      },
      {
         "pixmapfile" : "argentina/la_pampa.png",
         "toolTipText" : "La Pampa",
         "x" : "0.432",
         "y" : "0.437"
      },
      {
         "pixmapfile" : "argentina/jujuy.png",
         "toolTipText" : "Jujuy",
         "x" : "0.42",
         "y" : "0.075"
      },
      {
         "pixmapfile" : "argentina/formosa.png",
         "toolTipText" : "Formosa",
         "x" : "0.588",
         "y" : "0.117"
      },
      {
         "pixmapfile" : "argentina/entre_rios.png",
         "toolTipText" : "Entre Rios",
         "x" : "0.6",
         "y" : "0.308"
      },
      {
         "pixmapfile" : "argentina/corrientes.png",
         "toolTipText" : "Corrientes",
         "x" : "0.648",
         "y" : "0.227"
      },
      {
         "pixmapfile" : "argentina/cordoba.png",
         "toolTipText" : "Cordoba",
         "x" : "0.477",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "argentina/chubut.png",
         "toolTipText" : "Chubut",
         "x" : "0.389",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "argentina/chaco.png",
         "toolTipText" : "Chaco",
         "x" : "0.563",
         "y" : "0.152"
      },
      {
         "pixmapfile" : "argentina/catamarca.png",
         "toolTipText" : "Catamarca",
         "x" : "0.389",
         "y" : "0.189"
      },
      {
         "pixmapfile" : "argentina/buenos_aires.png",
         "toolTipText" : "Buenos Aires",
         "x" : "0.577",
         "y" : "0.439"
      }
   ]
}
