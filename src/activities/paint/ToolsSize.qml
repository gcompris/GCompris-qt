/* GCompris - ToolsSize.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
import QtQuick.Controls 1.5
import GCompris 1.0
import "../../core"
import "paint.js" as Activity

Item {
    id: toolsSize
    width: background.width > background.height ? background.width * 0.50 : background.width * 0.75
    height: background.height * 0.35

    anchors.centerIn: parent

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        radius: 10
        color: "grey"
    }

    Rectangle {
        id: container
        z: 1501
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        opacity: 0.9
        radius: 10
        border.width: 2
        border.color: "white"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#fff" }
            GradientStop { position: 0.9; color: "#fff" }
            GradientStop { position: 1.0; color: "#ddd" }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: console.log("Clicked on Grid")
        }

        GCSlider {
            id: slider
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30
            value: items.sizeS
            minimumValue: 2
            maximumValue: 24
            onValueChanged: items.sizeS = value
            stepSize: 2
        }

        Row {
            spacing: slider.width / 4.6
            x: slider.x
            anchors.bottom: slider.top

            Thickness { lineSize: 0.13 }
            Thickness { lineSize: 0.66 }
            Thickness { lineSize: 1.00 }
            Thickness { lineSize: 1.60 }
        }
    }

    GCButtonCancel {
        id: buttonCancel
        width: background.width > background.height ? 60 * ApplicationInfo.ratio : 50 * ApplicationInfo.ratio
        height: width
        z: 1600
        onClose: {
            toolsSize.visible = false
        }
    }
}
