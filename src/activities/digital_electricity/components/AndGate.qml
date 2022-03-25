/* GCompris - AndGate.qml
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

ElectricalComponent {
    id: andGate
    terminalSize: 0.50
    noOfInputs: 2
    noOfOutputs: 1
    property var inputTerminalPosY: [0.2, 0.8]

    information: qsTr("An AND gate outputs 1 only if all its inputs are equal to 1. " +
                      "As soon as one input is equal to 0 the result is 0. The output for a 2 inputs AND gate is:")

    truthTable: [['A','B',qsTr("A AND B")],
                 ['0','0','0'],
                 ['0','1','0'],
                 ['1','0','0'],
                 ['1','1','1']]

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 2
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.04
                posY: inputTerminalPosY[index]
                type: "In"
            }
        }
    }

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.96
                posY: 0.5
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var terminal = outputTerminals.itemAt(0)
        /* Keep the output value == 0 if only one of the input terminals is connected */
        terminal.value = (inputTerminals.itemAt(0).wires.length != 0 && inputTerminals.itemAt(1).wires.length != 0) ? (inputTerminals.itemAt(0).value & inputTerminals.itemAt(1).value) : 0
        for(var i = 0 ; i < terminal.wires.length ; ++i)
            terminal.wires[i].to.value = terminal.value

        var componentVisited = []
        for(var i = 0 ; i < terminal.wires.length ; ++i) {
            var wire = terminal.wires[i]
            var component = wire.to.parent
            componentVisited[component] = true
            wireVisited[wire] = true
            component.updateOutput(wireVisited)
        }
    }
}
