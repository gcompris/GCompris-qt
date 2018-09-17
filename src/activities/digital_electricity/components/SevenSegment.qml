/* GCompris - SevenSegment.qml
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../digital_electricity.js" as Activity

ElectricalComponent {
    id: sevenSegmentDisplay
    terminalSize: 0.125
    noOfInputs: 7
    noOfOutputs: 0
    property var inputTerminalPosY: [0.066, 0.211, 0.355, 0.5, 0.645, 0.789, 0.934]
    property var redBars: ["sevenSegmentDisplayA.svg","sevenSegmentDisplayB.svg","sevenSegmentDisplayC.svg",
                               "sevenSegmentDisplayD.svg","sevenSegmentDisplayE.svg","sevenSegmentDisplayF.svg",
                               "sevenSegmentDisplayG.svg"]

    information: qsTr("7 segment display takes 7 binary inputs in its input terminals. The display " +
                      "consists of 7 segments and each segment gets lighted according to the input. " +
                      "By generating different combination of binary inputs, the display can be used to " +
                      "display numbers from 0 to 9 and a few letters. The diagram is:")

    property string infoImageSrc: "7SegmentDisplay.svg"

    property alias inputTerminals: inputTerminals

    Repeater {
        id: inputTerminals
        model: 7
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.06
                posY: inputTerminalPosY[index]
                type: "In"
            }
        }
    }

    function updateOutput(wireVisited) {
        for(var i = 0 ; i < noOfInputs ; ++i) {
            if(inputTerminals.itemAt(i).value == 1)
                outputBar.itemAt(i).visible = true;
            else
                outputBar.itemAt(i).visible = false;
        }
    }

    Repeater {
        id: outputBar
        model: 7
        delegate: outputBarImages
        Component {
            id: outputBarImages
            Image {
                source: Activity.url + redBars[index]
                visible: false //code[0] == 1
                anchors.centerIn: parent
                height: parent.height
                width: parent.width
                fillMode: Image.PreserveAspectFit
                mipmap: true
                antialiasing: true
            }
        }
    }
}
