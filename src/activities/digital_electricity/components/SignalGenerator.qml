/* GCompris - SignalGenerator.qml
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
import "../../../core"

ElectricalComponent {
    id: signalGenerator
    terminalSize: 0.25
    noOfInputs: 0
    noOfOutputs: 1

    information: qsTr("A signal generator is used to generate alternating signals of 0 and 1. " +
    "The time between two changes can be modified by pressing the arrows on the generator.")

    property alias outputTerminals: outputTerminals
    property double period: 1
    property var periodFraction: ["1/4","1/2","1","2"]
    property int periodIndex: 2

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.94
                posY: 0.5
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
        height: 0.437 * parent.height
        width: 0.208 * parent.width
        sourceSize.height: height
        sourceSize.width: width
        property double posX: 0.6
        property double posY: 0.28
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        opacity: 0
        MouseArea {
            anchors.fill: parent
            anchors.centerIn: parent
            enabled: signalGenerator.period != 2
            onPressed: {
                parent.opacity = 1
                signalGenerator.period *= 2
                periodIndex++
                timer.restart()
                outputTerminals.itemAt(0).value = 1
                Activity.updateComponent(signalGenerator.index)
            }
            onReleased: {
                parent.opacity = 0
            }
        }
    }

    Image {
        source: Activity.url + "arrowDown.svg"
        height: 0.437 * parent.height
        width: 0.208 * parent.width
        sourceSize.height: height
        sourceSize.width: width
        property double posX: 0.6
        property double posY: 0.72
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        opacity: 0
        MouseArea {
            anchors.fill: parent
            anchors.centerIn: parent
            enabled: signalGenerator.period != 0.25
            onPressed: {
                parent.opacity = 1
                signalGenerator.period /= 2
                periodIndex--
                timer.restart()
                outputTerminals.itemAt(0).value = 1
                Activity.updateComponent(signalGenerator.index)
            }
            onReleased: {
                parent.opacity = 0
            }
        }
    }

    Rectangle {
        height: 0.625 * parent.height
        width: 0.35 * parent.width
        color: "#00000000"
        property double posX: 0.25
        property double posY: 0.5
        x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
        y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2
        GCText {
            id: value
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            minimumPointSize: 6
            font.pointSize: 32
            color: "#3f6f71"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: parent.height - 10
            width: parent.width - 10
            text: qsTr("%1 s").arg(signalGenerator.periodFraction[periodIndex])
        }
    }
}
