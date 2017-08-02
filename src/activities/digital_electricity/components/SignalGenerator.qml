/* GCompris - SignalGenerator.qml
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
import "../../../core"

ElectricalComponent {
    id: signalGenerator
    terminalSize: 0.24
    noOfInputs: 0
    noOfOutputs: 1

    information: qsTr("Signal Generator is used to generate alternating signals of 0 and 1. " +
                      "It takes period as input, and generate outputs accordingly. Period " +
                      "refers to the number of seconds after which the output will. So 1s " +
                      "means that the output will change after every 1 second, 0.5s means that " +
                      "the output will change after every 0.5 seconds, and so on. For the demonstration " +
                      "purpose, the minimum period of signal generator in this activity is " +
                      "0.25s, and maximum period is 2s. The period can be changed by clicking " +
                      "on the arrows on the signal generator")

    property alias outputTerminals: outputTerminals
    property double period: 1
    property variant periodFraction: ["1/4","1/2","1","2"]
    property int periodIndex: 2

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.95
                posY: 0.504
                value: 0
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {
        var terminal = outputTerminals.itemAt(0)
        terminal.value = terminal.value == 1 ? 0 : 1
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

    Timer {
        id: timer
        interval: 1000 * signalGenerator.period
        running: true
        repeat: true
        onTriggered: Activity.updateComponent(signalGenerator.index)
    }

    Image {
        source: Activity.url + "arrowUp.svg"
        height: 0.339 * parent.height
        width: 0.123 * parent.width
        property double posX: 0.688
        property double posY: 0.284
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
        MouseArea {
            anchors.fill: parent
            anchors.centerIn: parent
            enabled: signalGenerator.period != 2
            onPressed: {
                signalGenerator.period *= 2
                periodIndex++
                timer.restart()
                outputTerminals.itemAt(0).value = 1
                Activity.updateComponent(signalGenerator.index)
            }
        }
    }

    Image {
        source: Activity.url + "arrowDown.svg"
        height: 0.339 * parent.height
        width: 0.133 * parent.width
        property double posX: 0.688
        property double posY: 0.713
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
        MouseArea {
            anchors.fill: parent
            anchors.centerIn: parent
            enabled: signalGenerator.period != 0.25
            onPressed: {
                signalGenerator.period /= 2
                periodIndex--
                timer.restart()
                outputTerminals.itemAt(0).value = 1
                Activity.updateComponent(signalGenerator.index)
            }
        }
    }

    Image {
        source: Activity.url + "valueContainer.svg"
        sourceSize.height: 0.818 * parent.height
        sourceSize.width: 0.557 * parent.width
        property double posX: 0.333
        property double posY: 0.503
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        GCText {
            id: value
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            minimumPointSize: 6
            font.pointSize: 40
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: parent.height - 10
            width: parent.width - 10
            text: qsTr("%1s").arg(signalGenerator.periodFraction[periodIndex])
        }
    }
}
