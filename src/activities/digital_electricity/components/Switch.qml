/* GCompris - Switch.qml
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
    id: switchComponent
    terminalSize: 0.5
    noOfInputs: 1
    noOfOutputs: 1

    information: qsTr("Switch is used to connect or disconnect two terminals. " +
                      "If the switch is turned on, current can flow through the switch. " +
                      "If the switch is turned off, then the connection between terminal is broken and current can not flow through it.")

    truthTable: []

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
        terminal.value = imgSrc == "switchOn.svg" ? inputTerminals.itemAt(0).value : 0
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
