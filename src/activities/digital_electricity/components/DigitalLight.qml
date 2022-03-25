/* GCompris - DigitalLight.qml
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
    id: digitalLight
    terminalSize: 0.25
    noOfInputs: 1
    noOfOutputs: 0

    information: qsTr("A digital light is used to check the output of other digital components. It turns " +
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
