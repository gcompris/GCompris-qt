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
import QtQuick 2.3
import "../digital_electricity.js" as Activity

import GCompris 1.0

ElectricalComponent {
    id: bcdTo7Segment
    terminalSize: 0.097
    noOfInputs: 4
    noOfOutputs: 7

    property variant inputTerminalPosY: [0.057,0.35,0.649,0.935]
    property variant outputTerminalPosY: [0.048,0.198,0.353,0.509,0.664,0.812,0.952]

    property variant blackChar: ["BCDTo7SegmentA_black.svgz","BCDTo7SegmentB_black.svgz","BCDTo7SegmentC_black.svgz",
                                 "BCDTo7SegmentD_black.svgz","BCDTo7SegmentE_black.svgz","BCDTo7SegmentF_black.svgz",
                                 "BCDTo7SegmentG_black.svgz"]
    property variant redChar: ["BCDTo7SegmentA_red.svgz","BCDTo7SegmentB_red.svgz","BCDTo7SegmentC_red.svgz",
                               "BCDTo7SegmentD_red.svgz","BCDTo7SegmentE_red.svgz","BCDTo7SegmentF_red.svgz",
                               "BCDTo7SegmentG_red.svgz"]

    information: qsTr("BCD to 7 segment converter takes 4 binary inputs in its input terminals and gives " +
                      "7 binary outputs. The 4 binary inputs represents a BCD number (binary-coded decimal). " +
                      "The converter converts this BCD number to corresponding bits, which are used to " +
                      "display the decimal number (represented by the BCD number) on the 7 segment display. " +
                      "The truth table for BCD To 7 Segment converted is:")

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
                posX: 0.031
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
                posX: 0.969
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
                outputChar.itemAt(j).source = Activity.url + blackChar[j]
            }
        }
        else {
            for(var j = 0 ; j < noOfOutputs ; ++j) {
                var terminal = outputTerminals.itemAt(j)
                terminal.value = truthTable[i][j + noOfInputs]
                outputChar.itemAt(j).source = Activity.url + (terminal.value == 0 ? blackChar[j] : redChar[j])
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
