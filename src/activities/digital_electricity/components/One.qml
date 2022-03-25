/* GCompris - One.qml
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
    id: one
    terminalSize: 0.25
    noOfInputs: 0
    noOfOutputs: 1

    information: qsTr("Digital circuits work with only two states: 0 and 1. " +
                      "This allows to operate mathematical operations such as additions, subtractions... " +
                      "It is the basics of computer technics. In reality, 0 is often the representation of a voltage nearly equal to ground voltage " +
                      "and 1 is the representation of the supply voltage of a circuit.")

    property alias outputTerminals: outputTerminals

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.9
                posY: 0.5
                value: 1
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var terminal = outputTerminals.itemAt(0)
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
