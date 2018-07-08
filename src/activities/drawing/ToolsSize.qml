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
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import GCompris 1.0
import "../../core"
import "drawing.js" as Activity

Item {
    id: toolsSize
    width: items.foldablePanels.mainPanel.width * 0.30
    height: items.foldablePanels.mainPanel.height * 0.35

    Button {
        style: GCButtonStyle { theme: "light" }
        text: qsTr("Import an image")
        width: parent.width
        anchors.bottom: stampSizeslider.top
        anchors.bottomMargin: background.width > background.height ? 50 : 30
        visible: items.toolSelected === "stamp"
        onClicked: {
            items.fileDialog.open()
            console.log("Opened file Dialog")
        }
    }

    GCSlider {
        id: stampSizeslider
        width: parent.width
        anchors.centerIn: parent
        anchors.topMargin: 50
        value: 180
        minimumValue: 1
        maximumValue: canvas.height
        onValueChanged: items.toolsMode.activeStampHeight = value
        stepSize: 80
        visible: items.toolSelected === "stamp"
    }

    GCSlider {
        id: slider
        width: parent.width
        anchors.centerIn: parent
        value: items.sizeS
        minimumValue: 2
        maximumValue: 24
        onValueChanged: items.sizeS = value
        stepSize: 2
        visible: items.toolSelected !== "stamp"
    }

    GCText {
        width: background.width > background.height ? opacitySlider.width / 3 : opacitySlider.width / 2
        anchors.horizontalCenter: slider.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.top: slider.bottom
        anchors.topMargin: 10
        fontSize: tinySize
        color: "white"
        text: "Size"
        visible: items.toolSelected === "stamp"
    }

    Row {
        id: thicknessRow
        spacing: slider.width / 4.6
        x: slider.x
        anchors.bottom: slider.top
        visible: items.toolSelected !== "stamp"

        Thickness { lineSize: 0.13 }
        Thickness { lineSize: 0.66 }
        Thickness { lineSize: 1.00 }
        Thickness { lineSize: 1.60 }
    }
}
