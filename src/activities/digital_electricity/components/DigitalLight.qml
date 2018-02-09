/* GCompris - DigitalLight.qml
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
import "../digital_electricity.js" as Activity

ElectricalComponent {
    id: digitalLight
    terminalSize: 0.25
    noOfInputs: 1
    noOfOutputs: 0

    information: qsTr("Digital light is used to check the output of other digital components. It turns " +
                      "green if the input is 1, and turns red if the input is 0.")

    truthTable: []

    property alias inputTerminals: inputTerminals

    Repeater {
        id: inputTerminals
        model: 1
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.1
                posY: 0.5
                type: "In"
            }
        }
    }

    function updateOutput(wireVisited) {
        if(inputTerminals.itemAt(0).value == 1)
            imgSrc = "DigitalLightOn.svg"
        else
            imgSrc = "DigitalLightOff.svg"
    }
}
