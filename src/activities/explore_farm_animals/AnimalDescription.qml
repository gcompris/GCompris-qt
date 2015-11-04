/* GCompris - AnimalDescription.qml
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
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

import QtQuick 2.2
import GCompris 1.0

import "../../core"
import "explore.js" as Activity

Rectangle {
    id: rectangleDesc
    radius: 30
    border.width: 5
    border.color: "black"

    width: activity.width
    height: activity.height

    property alias title: heading.text
    property alias description: descriptionText.text
    property alias imageSource: animalImage.source

    GCText {
        id: heading
        fontSize: largeSize
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        anchors.centerIn: parent.Center
        color: "#2a2a2a"
        width: parent.width
        height: parent.height * 0.2
        wrapMode: Text.WordWrap
    }

    Image {
        id: animalImage
        sourceSize.width: parent.width * 0.5
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignTop
        anchors {
            top: heading.bottom
            topMargin: 30 * ApplicationInfo.ratio
            bottom: parent.bottom
            bottomMargin: 60 * ApplicationInfo.ratio
            left: parent.left
            leftMargin:  30 * ApplicationInfo.ratio
        }
    }

    GCText {
        id: descriptionText
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignJustify
        anchors {
            top: heading.bottom
            topMargin: 30 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: animalImage.right
            leftMargin: 30 * ApplicationInfo.ratio
        }
        color: "#2a2a2a"
        width: parent.width * 0.45
        height: parent.height * 0.5
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: rectangleDesc.width * 0.3
        height: rectangleDesc.height * 0.3
        radius: 5
        anchors {
            top: descriptionText.bottom
            topMargin: 30 * ApplicationInfo.ratio
            horizontalCenter: rectangleDesc.horizontalCenter
        }
        GCText {
            id: bottom_text
            text: qsTr("Back to the main page.")
            fontSizeMode: Text.Fit
            font.weight: Font.Bold
            anchors.fill: parent
            color: "#2a2a2a"
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onPressed: {
                rectangleDesc.visible = false;
                if (Activity.isComplete()) {
                    Activity.items.bonus.good("flower");
                    Activity.nextLevel();
                }
            }
        }
    }

    SequentialAnimation {
        running: true
        NumberAnimation { target: rectangleDesc; property: "x"; to: 0; duration: 800 }
        NumberAnimation { target: rectangleDesc; property: "x"; to: 50 ; duration: 100 }
        NumberAnimation { target: rectangleDesc; property: "x"; to: 0; duration: 400 }

    }
}
