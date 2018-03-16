/* GCompris - BCDToSevenSegment.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import "../digital_electricity.js" as Activity

import GCompris 1.0

ElectricalComponent {
    id: bcdTo7Segment
    terminalSize: 0.125
    noOfInputs: 4
    noOfOutputs: 7

    property var inputTerminalPosY: [0.125, 0.375, 0.625, 0.875]
    property var outputTerminalPosY: [0.066, 0.211, 0.355, 0.5, 0.645, 0.789, 0.934]

    property var redChar: ["BCDTo7SegmentA_on.svg","BCDTo7SegmentB_on.svg","BCDTo7SegmentC_on.svg",
                               "BCDTo7SegmentD_on.svg","BCDTo7SegmentE_on.svg","BCDTo7SegmentF_on.svg",
                               "BCDTo7SegmentG_on.svg"]

    information: qsTr("BCD to 7 segment converter takes 4 binary inputs in its input terminals " +
                      "and gives 7 binary outputs which allow to light BCD number segments (binary-coded decimal) " +
                      "to display numbers between 0 and 9. The output for BCD To 7 Segment converted is:")

    truthTable: [['D','C','B','A','a','b','c','d','e','f','g'],
                 ['0','0','0','0','1','1','1','1','1','1','0'],
                 ['0','0','0','1','0','1','1','0','0','0','0'],
                 ['0','0','1','0','1','1','0','1','1','0','1'],
                 ['0','0','1','1','1','1','1','1','0','0','1'],
                 ['0','1','0','0','0','1','1','0','0','1','1'],
                 ['0','1','0','1','1','0','1','1','0','1','1'],
                 ['0','1','1','0','1','0','1','1','1','1','1'],
                 ['0','1','1','1','1','1','1','0','0','0','0'],
                 ['1','0','0','0','1','1','1','1','1','1','1'],
                 ['1','0','0','1','1','1','1','1','0','1','1']]

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 4
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.05
                posY: inputTerminalPosY[index]
                type: "In"
            }
        }
    }

    Repeater {
        id: outputTerminals
        model: 7
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.95
                posY: outputTerminalPosY[index]
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var i
        for(i = 1 ; i < truthTable.length ; ++i) {
            var j
            for(j = 0 ; j < noOfInputs; ++j) {
                if(inputTerminals.itemAt(j).value != truthTable[i][j])
                    break
            }
            if(j == noOfInputs)
                break
        }
        if(i == truthTable.length) {
            for(var j = 0 ; j < noOfOutputs ; ++j) {
                outputTerminals.itemAt(j).value = 0
                outputChar.itemAt(j).source = "qrc:/gcompris/src/core/resource/empty.svg"
            }
        }
        else {
            for(var j = 0 ; j < noOfOutputs ; ++j) {
                var terminal = outputTerminals.itemAt(j)
                terminal.value = truthTable[i][j + noOfInputs]
                outputChar.itemAt(j).source = (terminal.value == 0 ? "qrc:/gcompris/src/core/resource/empty.svg" : Activity.url + redChar[j])
            }
        }

        for(var i = 0 ; i < noOfOutputs ; ++i) {
            var terminal = outputTerminals.itemAt(i)
            for(var j = 0 ; j < terminal.wires.length ; ++j)
                terminal.wires[j].to.value = terminal.value
        }

        var componentVisited = []
        for(var i = 0 ; i < noOfOutputs ; ++i) {
            var terminal = outputTerminals.itemAt(i)
            for(var j = 0 ; j < terminal.wires.length ; ++j) {
                var wire = terminal.wires[j]
                var component = wire.to.parent
                if(componentVisited[component] != true && wireVisited[wire] != true) {
                    componentVisited[component] = true
                    wireVisited[wire] = true
                    component.updateOutput(wireVisited)
                }
            }
        }
    }

    Repeater {
        id: outputChar
        model: 7
        delegate: outputCharImages
        Component {
            id: outputCharImages
            Image {
                source: ""
                anchors.centerIn: parent
                height: parent.height
                width: parent.width
                fillMode: Image.PreserveAspectFit
                mipmap: true
                antialiasing: true
            }
        }
    }
}
