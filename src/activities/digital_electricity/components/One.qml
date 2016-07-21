/* GCompris - One.qml
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
import GCompris 1.0

ElectricalComponent {
    id: one
    terminalSize: 0.218
    noOfInputs: 0
    noOfOutputs: 1

    information: qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                      "(i.e discrete signals instead of continous signals). Therefore all values within " +
                      "a range or band represent the same numeric value. In most cases, the number of " +
                      "these states is two and they are represented by two voltage bands: one near a " +
                      "reference value (typically termed as 'ground' or zero volts), and other value near " +
                      "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                      "of the Boolean domain respectively (named after its inventor, George Boole). " +
                      "In this activity, you can give '0' and '1' as input to other logical devices, " +
                      "and see their output through an output device.")

    property alias outputTerminals: outputTerminals

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.91
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
