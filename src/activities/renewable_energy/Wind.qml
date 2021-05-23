/* GCompris - wind.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"

Item {
    id: wind
    property alias power: windTransformer.power

    function stop() {
        cloud.started = false
        windTransformer.started = false
    }

    Image {
        id: cloud
        opacity: 1
        source: activity.url + "wind/" + (started ? "cloud_fury.svg" :"cloud_quiet.svg")
        sourceSize.width: parent.width * 0.20
        sourceSize.height: parent.height * 0.10
        anchors {
            right: parent.right
            top: parent.top
            topMargin: 0.02 * parent.height
            rightMargin: 0.05 * parent.width
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

    Timer {
        id: windTimer
        interval: 30000
        running: false
        repeat: false
        onTriggered: cloud.started = false
    }

    Image {
        id: windTransformer
        source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
        sourceSize.width: parent.width * 0.035
        height: parent.height * 0.06
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.2
            rightMargin: parent.width * 0.18
        }
        property bool started: false
        property int power: started ? windTurbine.power : 0
        MouseArea {
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: 70 * ApplicationInfo.ratio
            height: width
            onClicked: {
                parent.started = !parent.started
            }
        }
    }

    Image {
        sourceSize.width: windTransformer.width / 2
        sourceSize.height: windTransformer.height / 2
        source: activity.url + "down.svg"
        anchors {
            bottom: windTransformer.top
            right: parent.right
            rightMargin: parent.width*0.20
        }

        Rectangle {
            width: windvoltage.width * 1.1
            height: windvoltage.height * 1.1
            border.color: "black"
            radius: 5
            color: items.produceColor
            anchors {
                bottom: parent.top
                right: parent.right
            }
            GCText {
                id: windvoltage
                anchors.centerIn: parent
                text: wind.power.toString() + "W"
                fontSize: smallSize * 0.5
            }
        }
    }


    Image {
        source: activity.url + (windTurbine.power ? "wind/windturbineon.svg" : "wind/windturbineoff.svg")
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
    }

    Image {
        source: activity.url + (windTransformer.power ? "wind/windpoweron.svg" : "wind/windpoweroff.svg")
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
    }

    // Wind turbines
    WindTurbine {
        id: windTurbine
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.17
            rightMargin: parent.width * 0.05
        }
        z: 55
        duration: 3200
        property int power: cloud.started ? 1500 : 0
    }
    WindTurbine {
        id: windTurbine2
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.15
            rightMargin: parent.width * 0.1
        }
        z: 54
        duration: 3500
    }
    WindTurbine {
        id: windTurbine3
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.12
            rightMargin: parent.width * 0.15
        }
        z: 53
        duration: 3100
    }
}
