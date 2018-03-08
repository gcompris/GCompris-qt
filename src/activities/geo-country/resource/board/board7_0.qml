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
   property string instruction: qsTr("Counties of Brazil")
   property var levels: [
      {
         "pixmapfile" : "brazil/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "brazil/Amazonas.png",
         "toolTipText" : "Amazonas",
         "x" : "0.269",
         "y" : "0.266"
      },
      {
         "pixmapfile" : "brazil/Para.png",
         "toolTipText" : "Pará",
         "x" : "0.538",
         "y" : "0.259"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso.png",
         "toolTipText" : "Mato Grosso",
         "x" : "0.467",
         "y" : "0.466"
      },
      {
         "pixmapfile" : "brazil/Minas_Gerais.png",
         "toolTipText" : "Minas Gerais",
         "x" : "0.692",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "brazil/Bahia.png",
         "toolTipText" : "Bahia",
         "x" : "0.764",
         "y" : "0.481"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso_do_Sul.png",
         "toolTipText" : "Mato Grosso do Sul",
         "x" : "0.497",
         "y" : "0.642"
      },
      {
         "pixmapfile" : "brazil/Goias.png",
         "toolTipText" : "Goiás",
         "x" : "0.601",
         "y" : "0.539"
      },
      {
         "pixmapfile" : "brazil/Maranhao.png",
         "toolTipText" : "Maranhão",
         "x" : "0.698",
         "y" : "0.305"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Sul.png",
         "toolTipText" : "Rio Grande do Sul",
         "x" : "0.519",
         "y" : "0.865"
      },
      {
         "pixmapfile" : "brazil/Tocantins.png",
         "toolTipText" : "Tocantins",
         "x" : "0.63",
         "y" : "0.387"
      },
      {
         "pixmapfile" : "brazil/Piaui.png",
         "toolTipText" : "Piauí",
         "x" : "0.74",
         "y" : "0.331"
      },
      {
         "pixmapfile" : "brazil/Sao_Paulo.png",
         "toolTipText" : "São Paulo",
         "x" : "0.627",
         "y" : "0.685"
      },
      {
         "pixmapfile" : "brazil/Rondonia.png",
         "toolTipText" : "Rondônia",
         "x" : "0.322",
         "y" : "0.422"
      },
      {
         "pixmapfile" : "brazil/Roraima.png",
         "toolTipText" : "Roraima",
         "x" : "0.345",
         "y" : "0.133"
      },
      {
         "pixmapfile" : "brazil/Parana.png",
         "toolTipText" : "Paraná",
         "x" : "0.565",
         "y" : "0.733"
      },
      {
         "pixmapfile" : "brazil/Acre.png",
         "toolTipText" : "Acre",
         "x" : "0.159",
         "y" : "0.386"
      },
      {
         "pixmapfile" : "brazil/Ceara.png",
         "toolTipText" : "Ceará",
         "x" : "0.82",
         "y" : "0.296"
      },
      {
         "pixmapfile" : "brazil/Amapa.png",
         "toolTipText" : "Amapá",
         "x" : "0.546",
         "y" : "0.14"
      },
      {
         "pixmapfile" : "brazil/Pernambuco.png",
         "toolTipText" : "Pernambuco",
         "x" : "0.853",
         "y" : "0.368"
      },
      {
         "pixmapfile" : "brazil/Santa_Catarina.png",
         "toolTipText" : "Santa Catarina",
         "x" : "0.57",
         "y" : "0.8"
      },
      {
         "pixmapfile" : "brazil/Paraiba.png",
         "toolTipText" : "Paraíba",
         "x" : "0.878",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Norte.png",
         "toolTipText" : "Rio Grande do Norte",
         "x" : "0.883",
         "y" : "0.308"
      },
      {
         "pixmapfile" : "brazil/Espirito_Santo.png",
         "toolTipText" : "Espírito Santo",
         "x" : "0.794",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "brazil/Rio_de_Janeiro.png",
         "toolTipText" : "Rio de Janeiro",
         "x" : "0.752",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "brazil/Alagoas.png",
         "toolTipText" : "Alagoas",
         "x" : "0.879",
         "y" : "0.395"
      },
      {
         "pixmapfile" : "brazil/Sergipe.png",
         "toolTipText" : "Sergipe",
         "x" : "0.866",
         "y" : "0.418"
      },
      {
         "pixmapfile" : "brazil/Distrito_Federal.png",
         "toolTipText" : "Distrito Federal",
         "x" : "0.641",
         "y" : "0.533"
      }
   ]
}
