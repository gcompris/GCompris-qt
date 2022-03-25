/* GCompris - wind.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Big refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"

Item {
    id: wind
    property alias power: windTransformer.power

    function stop() {
        windTimer.stop()
        cloud.started = false
        windTransformer.started = false
    }

    function stopTimer() {
        windTimer.stop();
    }

    Image {
        id: cloud
        opacity: 1
        source: activity.url + "wind/cloud_quiet.svg"
        width: parent.width * 0.225
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            top: parent.top
            topMargin: parent.width * 0.02
            leftMargin: parent.width * 0.764
        }
        property bool started: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                cloud.started = true
                windTimer.restart()
            }
        }
    }

    Image {
        id: cloudActive
        source: activity.url + "wind/cloud_blowing.svg"
        visible: cloud.started
        anchors.fill: cloud
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }

    Timer {
        id: windTimer
        interval: 30000
        running: false
        repeat: false
        onTriggered: cloud.started = false
    }

    Image {
        source: activity.url + (windTurbine.power ? "wind/wind_on.svg" : "wind/wind_off.svg")
        width: parent.width * 0.119
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.199
            leftMargin: parent.width * 0.733
        }
    }

    Image {
        source: activity.url + (windTransformer.power ? "wind/wind_power_on.svg" : "wind/wind_power_off.svg")
        width: parent.width * 0.065
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.28
            leftMargin: parent.width * 0.699
        }
    }

    Image {
        id: windTransformer
        source: activity.url + "transformer_off.svg"
        width: parent.width * 0.05
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.241
            leftMargin: parent.width * 0.726
        }
        property bool started: false
        property int power: started ? windTurbine.power : 0
        MouseArea {
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: parent.width * 1.2
            height: parent.height * 1.2
            enabled: parent.visible
            onClicked: {
                parent.started = !parent.started
            }
        }
    }

    Image {
        id: windTransformerOn
        source: activity.url + "transformer_on"
        visible: windTransformer.started
        anchors.fill: windTransformer
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        width: windvoltage.width * 1.1
        height: windvoltage.height * 1.1
        border.color: items.produceColorBorder
        radius: 5
        color: items.produceColor
        anchors {
            bottom: windTransformer.verticalCenter
            right: windTransformer.left
        }
        GCText {
            id: windvoltage
            anchors.centerIn: parent
            text: wind.power.toString() + "W"
            fontSize: smallSize * 0.5
        }
    }

    // Wind turbines
    WindTurbine {
        id: windTurbine
        width: parent.width * 0.054
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.126
            leftMargin: parent.width * 0.734
        }
        z: 55
        duration: 3200
        property int power: cloud.started ? 1500 : 0
    }
    WindTurbine {
        id: windTurbine2
        width: parent.width * 0.054
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.138
            leftMargin: parent.width * 0.778
        }
        z: 54
        duration: 3500
    }
    WindTurbine {
        id: windTurbine3
        width: parent.width * 0.054
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.15
            leftMargin: parent.width * 0.822
        }
        z: 53
        duration: 3100
    }
}
