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
   property string instruction: qsTr("Federative units of Brazil")
   property var levels: [
      {
         "pixmapfile" : "brazil/brazil.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "brazil/Amazonas.svgz",
         //: Federative unit of Brazil: Amazonas
         "toolTipText" : qsTr("Amazonas"),
         "x" : "0.2386",
         "y" : "0.2446"
      },
      {
         "pixmapfile" : "brazil/Para.svgz",
         //: Federative unit of Brazil: Pará
         "toolTipText" : qsTr("Pará"),
         "x" : "0.5458",
         "y" : "0.241"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso.svgz",
         //: Federative unit of Brazil: Mato Grosso
         "toolTipText" : qsTr("Mato Grosso"),
         "x" : "0.4626",
         "y" : "0.4623"
      },
      {
         "pixmapfile" : "brazil/Minas_Gerais.svgz",
         //: Federative unit of Brazil: Minas Gerais
         "toolTipText" : qsTr("Minas Gerais"),
         "x" : "0.7197",
         "y" : "0.6063"
      },
      {
         "pixmapfile" : "brazil/Bahia.svgz",
         //: Federative unit of Brazil: Bahia
         "toolTipText" : qsTr("Bahia"),
         "x" : "0.8036",
         "y" : "0.48"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso_do_Sul.svgz",
         //: Federative unit of Brazil: Mato Grosso do Sul
         "toolTipText" : qsTr("Mato Grosso do Sul"),
         "x" : "0.4966",
         "y" : "0.6563"
      },
      {
         "pixmapfile" : "brazil/Goias.svgz",
         //: Federative unit of Brazil: Goiás
         "toolTipText" : qsTr("Goiás"),
         "x" : "0.6183",
         "y" : "0.5428"
      },
      {
         "pixmapfile" : "brazil/Maranhao.svgz",
         //: Federative unit of Brazil: Maranhão
         "toolTipText" : qsTr("Maranhão"),
         "x" : "0.7263",
         "y" : "0.2908"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Sul.svgz",
         //: Federative unit of Brazil: Rio Grande do Sul
         "toolTipText" : qsTr("Rio Grande do Sul"),
         "x" : "0.519",
         "y" : "0.8961"
      },
      {
         "pixmapfile" : "brazil/Tocantins.svgz",
         //: Federative unit of Brazil: Tocantins
         "toolTipText" : qsTr("Tocantins"),
         "x" : "0.6506",
         "y" : "0.3779"
      },
      {
         "pixmapfile" : "brazil/Piaui.svgz",
         //: Federative unit of Brazil: Piauí
         "toolTipText" : qsTr("Piauí"),
         "x" : "0.7746",
         "y" : "0.3186"
      },
      {
         "pixmapfile" : "brazil/Sao_Paulo.svgz",
         //: Federative unit of Brazil: São Paulo
         "toolTipText" : qsTr("São Paulo"),
         "x" : "0.6414",
         "y" : "0.7033"
      },
      {
         "pixmapfile" : "brazil/Rondonia.svgz",
         //: Federative unit of Brazil: Rondônia
         "toolTipText" : qsTr("Rondônia"),
         "x" : "0.2814",
         "y" : "0.4173"
      },
      {
         "pixmapfile" : "brazil/Roraima.svgz",
         //: Federative unit of Brazil: Roraima
         "toolTipText" : qsTr("Roraima"),
         "x" : "0.3182",
         "y" : "0.1041"
      },
      {
         "pixmapfile" : "brazil/Parana.svgz",
         //: Federative unit of Brazil: Paraná
         "toolTipText" : qsTr("Paraná"),
         "x" : "0.5746",
         "y" : "0.7541"
      },
      {
         "pixmapfile" : "brazil/Acre.svgz",
         //: Federative unit of Brazil: Acre
         "toolTipText" : qsTr("Acre"),
         "x" : "0.1105",
         "y" : "0.3753"
      },
      {
         "pixmapfile" : "brazil/Ceara.svgz",
         //: Federative unit of Brazil: Ceará
         "toolTipText" : qsTr("Ceará"),
         "x" : "0.8682",
         "y" : "0.2823"
      },
      {
         "pixmapfile" : "brazil/Amapa.svgz",
         //: Federative unit of Brazil: Amapá
         "toolTipText" : qsTr("Amapá"),
         "x" : "0.5511",
         "y" : "0.1119"
      },
      {
         "pixmapfile" : "brazil/Pernambuco.svgz",
         //: Federative unit of Brazil: Pernambuco
         "toolTipText" : qsTr("Pernambuco"),
         "x" : "0.8994",
         "y" : "0.3567"
      },
      {
         "pixmapfile" : "brazil/Santa_Catarina.svgz",
         //: Federative unit of Brazil: Santa Catarina
         "toolTipText" : qsTr("Santa Catarina"),
         "x" : "0.5811",
         "y" : "0.8289"
      },
      {
         "pixmapfile" : "brazil/Paraiba.svgz",
         //: Federative unit of Brazil: Paraíba
         "toolTipText" : qsTr("Paraíba"),
         "x" : "0.9316",
         "y" : "0.3268"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Norte.svgz",
         //: Federative unit of Brazil: Rio Grande do Norte
         "toolTipText" : qsTr("Rio Grande do Norte"),
         "x" : "0.9312",
         "y" : "0.2963"
      },
      {
         "pixmapfile" : "brazil/Espirito_Santo.svgz",
         //: Federative unit of Brazil: Espírito Santo
         "toolTipText" : qsTr("Espírito Santo"),
         "x" : "0.8336",
         "y" : "0.6308"
      },
      {
         "pixmapfile" : "brazil/Rio_de_Janeiro.svgz",
         //: Federative unit of Brazil: Rio de Janeiro
         "toolTipText" : qsTr("Rio de Janeiro"),
         "x" : "0.7813",
         "y" : "0.692"
      },
      {
         "pixmapfile" : "brazil/Alagoas.svgz",
         //: Federative unit of Brazil: Alagoas
         "toolTipText" : qsTr("Alagoas"),
         "x" : "0.9334",
         "y" : "0.3881"
      },
      {
         "pixmapfile" : "brazil/Sergipe.svgz",
         //: Federative unit of Brazil: Sergipe
         "toolTipText" : qsTr("Sergipe"),
         "x" : "0.9183",
         "y" : "0.4101"
      },
      {
         "pixmapfile" : "brazil/Distrito_Federal.svgz",
         //: Federative unit of Brazil: Distrito Federal
         "toolTipText" : qsTr("Distrito Federal"),
         "x" : "0.6619",
         "y" : "0.5377"
      }
   ]
}
