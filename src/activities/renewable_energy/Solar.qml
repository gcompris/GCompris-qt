/* GCompris - solar.qml
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
    id: solar
    property alias power: solarTransformer.power

    function stop() {
        solarTransformer.started = false
        solarPanel.started = false
    }

    Image {
        id: panelPower
        source: activity.url + "solar/" + (solarPanel.power ? "solar_wire_on.svg" : "solar_wire_off.svg")
        width: parent.width * 0.103
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.346
            leftMargin: parent.width * 0.783
        }
    }

    Image {
        id: solarPower
        source: activity.url + "solar/" + (solarTransformer.power ? "solar_power_on.svg" : "solar_power_off.svg")
        width: parent.width * 0.098
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.448
            leftMargin: parent.width * 0.78
        }
    }

    Image {
        id: solarTransformer
        source: activity.url + "transformer_off.svg"
        width: parent.width * 0.05
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.417
            leftMargin: parent.width * 0.866
        }
        property bool started: false
        property int power: started ? solarPanel.power : 0
        MouseArea {
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: parent.width * 1.2
            height: parent.height * 1.2
            onClicked: parent.started = !parent.started
        }
    }

    Image {
        id: solarTransformerOn
        visible: solarTransformer.started
        source: activity.url + "transformer_on.svg"
        anchors.fill: solarTransformer
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        width: solar_info.width * 1.1
        height: solar_info.height * 1.1
        border.color: items.produceColorBorder
        radius: 5
        color: items.produceColor
        anchors {
            left: solarTransformer.horizontalCenter
            bottom: solarTransformer.top
        }
        GCText {
            id: solar_info
            fontSize: smallSize * 0.5
            anchors.centerIn: parent
            text: solar.power.toString() + "W"
        }
    }

    Image {
        id: solarPanel
        source: activity.url + "solar/solar_panel_off.svg"
        width: parent.width * 0.093
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.326
            leftMargin: parent.width * 0.771
        }
        property bool started: false
        property int power: started && items.sunIsUp ? 1000 : 0
        MouseArea {
            anchors.fill: parent
            onClicked: parent.started = !parent.started
        }
    }

    Image {
        id: solarPanelOn
        visible: solarPanel.power
        source: activity.url + "solar/solar_panel_on.svg"
        anchors.fill: solarPanel
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
    }
}
