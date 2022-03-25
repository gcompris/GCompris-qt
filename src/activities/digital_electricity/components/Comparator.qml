/* GCompris - Comparator.qml
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
    id: comparator
    terminalSize: 0.25
    noOfInputs: 2
    noOfOutputs: 3
    property var inputTerminalPosY: [0.25, 0.75]
    property var outputTerminalPosY: [0.13, 0.5, 0.87]

    information: qsTr("A comparator takes 2 numbers as input, A and B. It compares them and outputs 3 " +
                      "values. The first output is 1 if A < B, otherwise it's 0. The second output is 1 " +
                      "if A = B, otherwise it's 0. The third output is 1 if A > B, otherwise it's 0. ")

    truthTable: []

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 2
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
        model: 3
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
        outputTerminals.itemAt(0).value = (inputTerminals.itemAt(0).value < inputTerminals.itemAt(1).value)
        outputTerminals.itemAt(1).value = (inputTerminals.itemAt(0).value == inputTerminals.itemAt(1).value)
        outputTerminals.itemAt(2).value = (inputTerminals.itemAt(0).value > inputTerminals.itemAt(1).value)

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
}
