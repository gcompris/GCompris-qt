/* GCompris - NotGate.qml
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
    id: notGate
    terminalSize: 0.5
    noOfInputs: 1
    noOfOutputs: 1

    information: qsTr("A Not gate (also known as inverter) outputs the opposite of the input. " +
                      "An input 0 gives an output 1. An Input 1 gives an output 0:")

    truthTable: [['A',qsTr("NOT A")],
                 ['0','1'],
                 ['1','0']]

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 1
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.04
                posY: 0.5
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
        terminal.value = (inputTerminals.itemAt(0).wires.length != 0) ? !inputTerminals.itemAt(0).value : 0
        for(var i = 0 ; i < terminal.wires.length ; ++i)
            terminal.wires[i].to.value = terminal.value

        var componentVisited = []
        for(var i = 0 ; i < terminal.wires.length ; ++i) {
            var wire = terminal.wires[i]
            var component = wire.to.parent
            if(componentVisited[component] != true && wireVisited[wire] != true) {
                componentVisited[component] = true
                wireVisited[wire] = true
                component.updateOutput(wireVisited)
            }
        }
    }
}
