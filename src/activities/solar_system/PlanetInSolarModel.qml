/* GCompris - PlanetInSolarModel.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
import "../../core"
import "solar_system.js" as Activity

Item {
    id: planetItem
    width: background.itemWidth
    height: width

    property string planetImageSource
    property string planetName

    GCText {
        id: planetNameText
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        fontSizeMode: Text.Fit
        font.pointSize: NaN                   // need to clear font.pointSize explicitly
        font.pixelSize: parent.width * 0.18
        color: "white"
        text: planetName
    }

    Image {
        id: planetImage
        anchors.top: planetNameText.bottom
        anchors.topMargin: parent.width * 0.05
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: parent.width / 1.5
        fillMode: Image.PreserveAspectCrop
        source: planetImageSource

        states: [
            State {
                name: "clicked"
                when: mouseArea.pressed
                PropertyChanges {
                    target: planetImage
                    scale: 0.7
                }
            },
            State {
                name: "hover"
                when: mouseArea.containsMouse
                PropertyChanges {
                    target: planetImage
                    scale: 1.2
                }
            }
        ]

        Behavior on scale { NumberAnimation { duration: 70 } }

        MouseArea {
            id: mouseArea
            anchors.fill: planetImage
            enabled: !message.visible
            hoverEnabled: ApplicationInfo.isMobile ? false : true
            onClicked: Activity.showQuizScreen(index)
        }
    }
}
