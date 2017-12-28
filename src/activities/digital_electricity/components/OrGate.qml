/* GCompris - OrGate.qml
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
    id: orGate
    terminalSize: 0.251
    noOfInputs: 2
    noOfOutputs: 1
    property var inputTerminalPosY: [0.223, 0.786]

    information: qsTr("OR gate takes 2 or more binary input in its input terminals and outputs a single " +
                      "value. The output is 1 if any of the input is 1, else it is 0. In this activity, a " +
                      "2 input OR gate is shown. Truth table for 2 input OR gate is:")
    truthTable: [['A','B',"A+B"],
                 ['0','0','0'],
                 ['0','1','1'],
                 ['1','0','1'],
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
                posX: 0.045
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
                posX: 0.955
                posY: 0.509
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var terminal = outputTerminals.itemAt(0)
        /* Keep the output value == 0 if only one of the input terminals is connected */
        terminal.value = (inputTerminals.itemAt(0).wires.length != 0 && inputTerminals.itemAt(1).wires.length != 0) ? (inputTerminals.itemAt(0).value | inputTerminals.itemAt(1).value) : 0
        for(var i = 0 ; i < terminal.wires.length ; ++i)
            terminal.wires[i].to.value = terminal.value

        var componentVisited = []
        for(var i = 0 ; i < terminal.wires.length ; ++i) {
            var wire = terminal.wires[i]
            var component = wire.to.parent
            /*
            // NOTE: Removed because the output of a > 1 input gate may depend on > 1 conditions
            // thus it may be needed to be revisited
            if(componentVisited[component] != true && wireVisited[wire] != true) {
                componentVisited[component] = true
                wireVisited[wire] = true
                component.updateOutput(wireVisited)
            }
            */
            componentVisited[component] = true
            wireVisited[wire] = true
            component.updateOutput(wireVisited)
        }
    }
}
