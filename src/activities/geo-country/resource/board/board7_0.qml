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
   property string instruction: qsTr("Counties of Brazil")
   property var levels: [
      {
         "pixmapfile" : "brazil/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "brazil/Amazonas.png",
         //: County of Brazil: Amazonas
         "toolTipText" : qsTr("Amazonas"),
         "x" : "0.269",
         "y" : "0.266"
      },
      {
         "pixmapfile" : "brazil/Para.png",
         //: County of Brazil: Pará
         "toolTipText" : qsTr("Pará"),
         "x" : "0.538",
         "y" : "0.259"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso.png",
         //: County of Brazil: Mato Grosso
         "toolTipText" : qsTr("Mato Grosso"),
         "x" : "0.467",
         "y" : "0.466"
      },
      {
         "pixmapfile" : "brazil/Minas_Gerais.png",
         //: County of Brazil: Minas Gerais
         "toolTipText" : qsTr("Minas Gerais"),
         "x" : "0.692",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "brazil/Bahia.png",
         //: County of Brazil: Bahia
         "toolTipText" : qsTr("Bahia"),
         "x" : "0.764",
         "y" : "0.481"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso_do_Sul.png",
         //: County of Brazil: Mato Grosso do Sul
         "toolTipText" : qsTr("Mato Grosso do Sul"),
         "x" : "0.497",
         "y" : "0.642"
      },
      {
         "pixmapfile" : "brazil/Goias.png",
         //: County of Brazil: Goiás
         "toolTipText" : qsTr("Goiás"),
         "x" : "0.601",
         "y" : "0.539"
      },
      {
         "pixmapfile" : "brazil/Maranhao.png",
         //: County of Brazil: Maranhão
         "toolTipText" : qsTr("Maranhão"),
         "x" : "0.698",
         "y" : "0.305"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Sul.png",
         //: County of Brazil: Rio Grande do Sul
         "toolTipText" : qsTr("Rio Grande do Sul"),
         "x" : "0.519",
         "y" : "0.865"
      },
      {
         "pixmapfile" : "brazil/Tocantins.png",
         //: County of Brazil: Tocantins
         "toolTipText" : qsTr("Tocantins"),
         "x" : "0.63",
         "y" : "0.387"
      },
      {
         "pixmapfile" : "brazil/Piaui.png",
         //: County of Brazil: Piauí
         "toolTipText" : qsTr("Piauí"),
         "x" : "0.74",
         "y" : "0.331"
      },
      {
         "pixmapfile" : "brazil/Sao_Paulo.png",
         //: County of Brazil: São Paulo
         "toolTipText" : qsTr("São Paulo"),
         "x" : "0.627",
         "y" : "0.685"
      },
      {
         "pixmapfile" : "brazil/Rondonia.png",
         //: County of Brazil: Rondônia
         "toolTipText" : qsTr("Rondônia"),
         "x" : "0.322",
         "y" : "0.422"
      },
      {
         "pixmapfile" : "brazil/Roraima.png",
         //: County of Brazil: Roraima
         "toolTipText" : qsTr("Roraima"),
         "x" : "0.345",
         "y" : "0.133"
      },
      {
         "pixmapfile" : "brazil/Parana.png",
         //: County of Brazil: Paraná
         "toolTipText" : qsTr("Paraná"),
         "x" : "0.565",
         "y" : "0.733"
      },
      {
         "pixmapfile" : "brazil/Acre.png",
         //: County of Brazil: Acre
         "toolTipText" : qsTr("Acre"),
         "x" : "0.159",
         "y" : "0.386"
      },
      {
         "pixmapfile" : "brazil/Ceara.png",
         //: County of Brazil: Ceará
         "toolTipText" : qsTr("Ceará"),
         "x" : "0.82",
         "y" : "0.296"
      },
      {
         "pixmapfile" : "brazil/Amapa.png",
         //: County of Brazil: Amapá
         "toolTipText" : qsTr("Amapá"),
         "x" : "0.546",
         "y" : "0.14"
      },
      {
         "pixmapfile" : "brazil/Pernambuco.png",
         //: County of Brazil: Pernambuco
         "toolTipText" : qsTr("Pernambuco"),
         "x" : "0.853",
         "y" : "0.368"
      },
      {
         "pixmapfile" : "brazil/Santa_Catarina.png",
         //: County of Brazil: Santa Catarina
         "toolTipText" : qsTr("Santa Catarina"),
         "x" : "0.57",
         "y" : "0.8"
      },
      {
         "pixmapfile" : "brazil/Paraiba.png",
         //: County of Brazil: Paraíba
         "toolTipText" : qsTr("Paraíba"),
         "x" : "0.878",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Norte.png",
         //: County of Brazil: Rio Grande do Norte
         "toolTipText" : qsTr("Rio Grande do Norte"),
         "x" : "0.883",
         "y" : "0.308"
      },
      {
         "pixmapfile" : "brazil/Espirito_Santo.png",
         //: County of Brazil: Espírito Santo
         "toolTipText" : qsTr("Espírito Santo"),
         "x" : "0.794",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "brazil/Rio_de_Janeiro.png",
         //: County of Brazil: Rio de Janeiro
         "toolTipText" : qsTr("Rio de Janeiro"),
         "x" : "0.752",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "brazil/Alagoas.png",
         //: County of Brazil: Alagoas
         "toolTipText" : qsTr("Alagoas"),
         "x" : "0.879",
         "y" : "0.395"
      },
      {
         "pixmapfile" : "brazil/Sergipe.png",
         //: County of Brazil: Sergipe
         "toolTipText" : qsTr("Sergipe"),
         "x" : "0.866",
         "y" : "0.418"
      },
      {
         "pixmapfile" : "brazil/Distrito_Federal.png",
         //: County of Brazil: Distrito Federal
         "toolTipText" : qsTr("Distrito Federal"),
         "x" : "0.641",
         "y" : "0.533"
      }
   ]
}
