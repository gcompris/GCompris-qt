/* GCompris - BcdCounter.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../digital_electricity.js" as Activity

ElectricalComponent {
    id: bcdTo7Segment
    terminalSize: 0.125
    noOfInputs: 1
    noOfOutputs: 4
    property var outputTerminalPosY: [0.125, 0.375, 0.625, 0.875]
    property int count: 0
    property int previousInput: 0

    information: qsTr("A BCD counter usually takes a signal generator as input. " +
                      "The output is a BCD number starting from 0 which is increased by one at each tick.")

    truthTable: []
    property var outputTable: [['0','0','0','0'],
                                   ['0','0','0','1'],
                                   ['0','0','1','0'],
                                   ['0','0','1','1'],
                                   ['0','1','0','0'],
                                   ['0','1','0','1'],
                                   ['0','1','1','0'],
                                   ['0','1','1','1'],
                                   ['1','0','0','0'],
                                   ['1','0','0','1']]

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 1
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.07
                posY: 0.5
                type: "In"
            }
        }
    }

    Repeater {
        id: outputTerminals
        model: 4
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.93
                posY: outputTerminalPosY[index]
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        for(var i = 0 ; i < noOfOutputs ; ++i) {
            var terminal = outputTerminals.itemAt(i)
            terminal.value = outputTable[count][i]
            for(var j = 0 ; j < terminal.wires.length ; ++j)
                terminal.wires[j].to.value = terminal.value
        }

        if(previousInput != inputTerminals.itemAt(0).value) {
            previousInput = inputTerminals.itemAt(0).value
            count = (count + 1) % 10;

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
    }
}
