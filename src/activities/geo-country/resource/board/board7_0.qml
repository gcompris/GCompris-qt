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
         "x" : "0.2521",
         "y" : "0.2321"
      },
      {
         "pixmapfile" : "brazil/Para.svgz",
         //: Federative unit of Brazil: Pará
         "toolTipText" : qsTr("Pará"),
         "x" : "0.5445",
         "y" : "0.2281"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso.svgz",
         //: Federative unit of Brazil: Mato Grosso
         "toolTipText" : qsTr("Mato Grosso"),
         "x" : "0.4638",
         "y" : "0.443"
      },
      {
         "pixmapfile" : "brazil/Minas_Gerais.svgz",
         //: Federative unit of Brazil: Minas Gerais
         "toolTipText" : qsTr("Minas Gerais"),
         "x" : "0.7097",
         "y" : "0.5851"
      },
      {
         "pixmapfile" : "brazil/Bahia.svgz",
         //: Federative unit of Brazil: Bahia
         "toolTipText" : qsTr("Bahia"),
         "x" : "0.7904",
         "y" : "0.4603"
      },
      {
         "pixmapfile" : "brazil/Mato_Grosso_do_Sul.svgz",
         //: Federative unit of Brazil: Mato Grosso do Sul
         "toolTipText" : qsTr("Mato Grosso do Sul"),
         "x" : "0.4963",
         "y" : "0.6353"
      },
      {
         "pixmapfile" : "brazil/Goias.svgz",
         //: Federative unit of Brazil: Goiás
         "toolTipText" : qsTr("Goiás"),
         "x" : "0.613",
         "y" : "0.5209"
      },
      {
         "pixmapfile" : "brazil/Maranhao.svgz",
         //: Federative unit of Brazil: Maranhão
         "toolTipText" : qsTr("Maranhão"),
         "x" : "0.716",
         "y" : "0.2758"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Sul.svgz",
         //: Federative unit of Brazil: Rio Grande do Sul
         "toolTipText" : qsTr("Rio Grande do Sul"),
         "x" : "0.5177",
         "y" : "0.8903"
      },
      {
         "pixmapfile" : "brazil/Tocantins.svgz",
         //: Federative unit of Brazil: Tocantins
         "toolTipText" : qsTr("Tocantins"),
         "x" : "0.6449",
         "y" : "0.3617"
      },
      {
         "pixmapfile" : "brazil/Piaui.svgz",
         //: Federative unit of Brazil: Piauí
         "toolTipText" : qsTr("Piauí"),
         "x" : "0.7623",
         "y" : "0.303"
      },
      {
         "pixmapfile" : "brazil/Sao_Paulo.svgz",
         //: Federative unit of Brazil: São Paulo
         "toolTipText" : qsTr("São Paulo"),
         "x" : "0.635",
         "y" : "0.6827"
      },
      {
         "pixmapfile" : "brazil/Rondonia.svgz",
         //: Federative unit of Brazil: Rondônia
         "toolTipText" : qsTr("Rondônia"),
         "x" : "0.2913",
         "y" : "0.3969"
      },
      {
         "pixmapfile" : "brazil/Roraima.svgz",
         //: Federative unit of Brazil: Roraima
         "toolTipText" : qsTr("Roraima"),
         "x" : "0.3249",
         "y" : "0.0985"
      },
      {
         "pixmapfile" : "brazil/Parana.svgz",
         //: Federative unit of Brazil: Paraná
         "toolTipText" : qsTr("Paraná"),
         "x" : "0.5714",
         "y" : "0.7356"
      },
      {
         "pixmapfile" : "brazil/Acre.svgz",
         //: Federative unit of Brazil: Acre
         "toolTipText" : qsTr("Acre"),
         "x" : "0.127",
         "y" : "0.3571"
      },
      {
         "pixmapfile" : "brazil/Ceara.svgz",
         //: Federative unit of Brazil: Ceará
         "toolTipText" : qsTr("Ceará"),
         "x" : "0.8533",
         "y" : "0.2675"
      },
      {
         "pixmapfile" : "brazil/Amapa.svgz",
         //: Federative unit of Brazil: Amapá
         "toolTipText" : qsTr("Amapá"),
         "x" : "0.5473",
         "y" : "0.1053"
      },
      {
         "pixmapfile" : "brazil/Pernambuco.svgz",
         //: Federative unit of Brazil: Pernambuco
         "toolTipText" : qsTr("Pernambuco"),
         "x" : "0.8825",
         "y" : "0.3389"
      },
      {
         "pixmapfile" : "brazil/Santa_Catarina.svgz",
         //: Federative unit of Brazil: Santa Catarina
         "toolTipText" : qsTr("Santa Catarina"),
         "x" : "0.5775",
         "y" : "0.8145"
      },
      {
         "pixmapfile" : "brazil/Paraiba.svgz",
         //: Federative unit of Brazil: Paraíba
         "toolTipText" : qsTr("Paraíba"),
         "x" : "0.9132",
         "y" : "0.3103"
      },
      {
         "pixmapfile" : "brazil/Rio_Grande_do_Norte.svgz",
         //: Federative unit of Brazil: Rio Grande do Norte
         "toolTipText" : qsTr("Rio Grande do Norte"),
         "x" : "0.9135",
         "y" : "0.2806"
      },
      {
         "pixmapfile" : "brazil/Espirito_Santo.svgz",
         //: Federative unit of Brazil: Espírito Santo
         "toolTipText" : qsTr("Espírito Santo"),
         "x" : "0.8198",
         "y" : "0.6092"
      },
      {
         "pixmapfile" : "brazil/Rio_de_Janeiro.svgz",
         //: Federative unit of Brazil: Rio de Janeiro
         "toolTipText" : qsTr("Rio de Janeiro"),
         "x" : "0.769",
         "y" : "0.6708"
      },
      {
         "pixmapfile" : "brazil/Alagoas.svgz",
         //: Federative unit of Brazil: Alagoas
         "toolTipText" : qsTr("Alagoas"),
         "x" : "0.9152",
         "y" : "0.3691"
      },
      {
         "pixmapfile" : "brazil/Sergipe.svgz",
         //: Federative unit of Brazil: Sergipe
         "toolTipText" : qsTr("Sergipe"),
         "x" : "0.9003",
         "y" : "0.3897"
      },
      {
         "pixmapfile" : "brazil/Distrito_Federal.svgz",
         //: Federative unit of Brazil: Distrito Federal
         "toolTipText" : qsTr("Distrito Federal"),
         "x" : "0.6545",
         "y" : "0.5157"
      }
   ]
}
