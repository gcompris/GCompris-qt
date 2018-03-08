/* GCompris - solar.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
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
import "../../core"

Item {
    id: solar
    property alias power: solarTransformer.power

    function stop() {
        solarTransformer.started = false
        solarPanel.started = false
    }

    Image {
        id: solarTransformer
        source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
        sourceSize.width: parent.width * 0.05
        height: parent.height * 0.08
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.38
            rightMargin: parent.width * 0.11
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
        source: activity.url + "left.svg"
        sourceSize.width: solarTransformer.width / 2
        sourceSize.height: solarTransformer.height / 2
        anchors {
            top: solarPanel.top
            left:solarTransformer.left
            leftMargin: solarTransformer.width
            topMargin: solarTransformer.height
        }
        Rectangle {
            width: solar_info.width * 1.1
            height: solar_info.height * 1.1
            border.color: "black"
            radius: 5
            color: items.produceColor
            anchors {
                left: parent.right
            }
            GCText {
                id: solar_info
                fontSize: smallSize * 0.5
                anchors.centerIn: parent
                text: solar.power.toString() + "W"
            }
        }
    }

    Image {
        id: solarPower
        source: activity.url + "solar/" + (solarTransformer.power ? "solarpoweron.svg" : "solarpoweroff.svg")
        sourceSize.width: parent.width
        anchors.fill: parent
    }

    Image {
        id: solarPanel
        source: activity.url + "solar/" + (power ? "solarpanelon.svg" : "solarpaneloff.svg")
        sourceSize.width: parent.width * 0.07
        height: parent.height * 0.09
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.31
            rightMargin: parent.width * 0.14
        }
        property bool started: false
        property int power: started && items.sunIsUp ? 1000 : 0
        MouseArea {
            anchors.fill: parent
            onClicked: parent.started = !parent.started
        }
    }

    Image {
        id: panelPower
        source: activity.url + "solar/" + (solarPanel.power ? "panelpoweron.svg" : "panelpoweroff.svg")
        sourceSize.width: parent.width
        anchors.fill: parent
    }
}
