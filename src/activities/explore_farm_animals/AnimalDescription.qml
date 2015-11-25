/* GCompris - AnimalDescription.qml
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
    MouseArea {
        anchors.fill: parent
        onPressed: parent.close()
    }

    property alias title: heading.text
    property alias description: descriptionText.text
    property alias imageSource: animalImage.source

    property bool horizontalLayout: background.width > background.height

    GCText {
        id: heading
        fontSize: largeSize
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.DemiBold
        anchors.centerIn: parent.Center
        color: "#2a2a2a"
        width: parent.width
        height: if(rectangleDesc.horizontalLayout) parent.height * 0.2
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
    }

    Image {
        id: animalImage
        sourceSize.width: if(rectangleDesc.horizontalLayout) parent.width * 0.5
        sourceSize.height: if(!rectangleDesc.horizontalLayout) parent.height * 0.3
        fillMode: Image.PreserveAspectFit
        anchors {
            top: rectangleDesc.horizontalLayout ? heading.bottom : descriptionText.bottom
            horizontalCenter: rectangleDesc.horizontalLayout ? undefined : heading.horizontalCenter
            left: rectangleDesc.horizontalLayout ? parent.left : undefined
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
            right: parent.right
            rightMargin: 30 * ApplicationInfo.ratio
            left: rectangleDesc.horizontalLayout ? animalImage.right : parent.left
            leftMargin: 30 * ApplicationInfo.ratio
        }
        color: "#2a2a2a"
        width: rectangleDesc.horizontalLayout ? parent.width * 0.45 : parent.width
        height: rectangleDesc.horizontalLayout ? parent.height * 0.5 : parent.height * 0.3
        wrapMode: Text.WordWrap
    }

    // The cancel button
    GCButtonCancel {
        onClose: parent.close()
    }

    function close() {
        rectangleDesc.visible = false;
        if (Activity.isComplete()) {
            Activity.items.bonus.good("flower");
            Activity.nextLevel();
        }
    }

}
