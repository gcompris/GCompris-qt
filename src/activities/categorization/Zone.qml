/* GCompris - Zone.qml
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "../../core"
import "categorization.js" as Activity


Flickable {
    id: flick
    contentWidth: zoneFlow.width
    contentHeight: zoneFlow.height

    clip: false
    interactive: (type == "words" ? true : false)
    flickableDirection: Flickable.VerticalFlick

    property alias repeater: repeater
    property alias model: zoneModel
    property alias spacing: zoneFlow.spacing

    Flow {
    id: zoneFlow
    spacing: 5
    width: categoryBackground.width/3
    height: repeater.contentHeight
    opacity: 1
    anchors.bottomMargin: 0.3 * zoneFlow.height

    ListModel {
        id: zoneModel
    }

    Repeater {
        id: repeater
        model: zoneModel
        Item {
            id: item
            width: (type == "words" && (items.hintDisplay == true)) ? middleScreen.width * 0.92 : middleScreen.width * 0.32
            height: (type == "words" && (items.hintDisplay == true)) ? categoryBackground.height * 0.1 : categoryBackground.height * 0.2
            visible: true
            opacity: 1

            Rectangle {
                id: wordBox
                color: "black"
                visible: type =="words" ? true : false
                width: parent.width
                height: parent.height
                z: 3
                focus: true
                radius: 10
                border.width: 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                GCText {
                    id: wordBoxText
                    text: name
                    anchors.fill: parent
                    anchors.bottom: parent.bottom
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    z: 3
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                DragList {
                    id: wordDrag
                    anchors.fill: parent
                }
            }
            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: horizontalLayout ? middleZone.width * 0.32 : middleZone.width * 0.48
                width: sourceSize.width
                height: sourceSize.width
                source: (type == "images") ? name : ''
                visible: type =="words" ? false : true
                DragList {
                    id: imageDrag
                    anchors.fill: parent
                }
            }
        }
    }
    }
}
