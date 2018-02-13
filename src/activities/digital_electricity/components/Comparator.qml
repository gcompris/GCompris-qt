/* GCompris - Comparator.qml
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
import GCompris 1.0

ElectricalComponent {
    id: comparator
    terminalSize: 0.25
    noOfInputs: 2
    noOfOutputs: 3
    property var inputTerminalPosY: [0.25, 0.75]
    property var outputTerminalPosY: [0.13, 0.5, 0.87]

    information: qsTr("Comparator takes 2 numbers as input, A and B. It compares them and outputs 3 " +
                      "values. First output is 1 if A < B, 0 otherwise. Second is 1 " +
                      "if A = B, 0 otherwise. Third is 1 if A > B, 0 otherwise. ")

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
