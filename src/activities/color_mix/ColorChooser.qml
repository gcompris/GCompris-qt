/* GCompris - ColorChooser.qml
*
* Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
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
import QtQuick 2.0
import QtGraphicalEffects 1.0

import GCompris 1.0

import "colormix.js" as Activity

Image {
    id: chooser
    source: Activity.url + (activity.modeRGB ? "flashlight.svgz" : "tube.svg")
    sourceSize.height: 100 * ApplicationInfo.ratio
    z:1

    property int maxSteps: 10
    property int currentStep: 0
    property alias hue: color.hue

    Image {
        id: intensity
        source: Activity.url + "flashlight2.svgz"
        sourceSize.height: parent.sourceSize.height
        visible: activity.modeRGB
        anchors.fill: parent
        z:2
        Colorize {
            anchors.fill: parent
            source: parent
            hue: chooser.hue
            lightness: -(maxSteps - currentStep) / maxSteps
            saturation: 1
        }
    }

    Rectangle {
        anchors {
            left: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: parent.sourceSize.height / 4* currentStep/maxSteps
        width: parent.sourceSize.height / 2
        visible: !activity.modeRGB
        color: Activity.getColorFromHsl(chooser.hue, 1, 0.5)
    }

    Colorize {
        id: color
        anchors.fill: parent
        source: parent
        hue: 0.0
        saturation: 1
    }

    Rectangle {
        id: up
        height: parent.height / 4
        width: height
        z:3
        radius: width / 2
        border.color: "black"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: parent.width * 0.2
        }

        Text {
            id: upText
            anchors.centerIn: parent
            text: "+"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: Math.max(parent.height * 0.8, 10)
        }

        MouseArea {
            anchors.centerIn: parent
            height: 2*parent.height
            width: 2*parent.width
            onClicked: currentStep = Math.min(currentStep + 1, maxSteps)
        }
    }

    Rectangle {
        id: down
        height: up.height
        width: height
        z:3
        radius: width / 2
        border.color: "black"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: parent.width * 0.4
        }

        Text {
            id: downText
            anchors.centerIn: parent
            text: "-"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: upText.font.pointSize
        }

        MouseArea {
            anchors.centerIn: parent
            height: 2*parent.height
            width: 2*parent.width
            onClicked: currentStep = Math.max(currentStep - 1, 0)
        }
    }
}
