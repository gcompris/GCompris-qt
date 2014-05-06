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
    source: Activity.url + (activity.modeRGB ? "flashlight.svgz" : "tube.svgz")
    z: 1

    property int maxSteps: 10
    property int currentStep: 0
    property alias hue: color.hue

    Image {
        id: intensity
        source: Activity.url + "flashlight2.svgz"
        sourceSize.height: parent.sourceSize.height
        z: 2
        visible: activity.modeRGB ? true : false

        Colorize {
            anchors.fill: parent
            source: parent
            hue: chooser.hue
            lightness: -(maxSteps - currentStep) / maxSteps
            saturation: 1
        }

        Image {
            source: Activity.url + "light.svgz"
            sourceSize.height: parent.sourceSize.height / 2
            anchors {
                left: parent.right
                leftMargin: -20 * ApplicationInfo.ratio
                verticalCenter: parent.verticalCenter
            }
            opacity: currentStep / maxSteps

            Colorize {
                anchors.fill: parent
                source: parent
                hue: chooser.hue
                lightness: -(maxSteps - currentStep) / maxSteps
                saturation: 1
            }
        }
    }

    Image {
        id: intensityBrush
        source: Activity.url + "brush.svgz"
        sourceSize.height: parent.sourceSize.height * 0.25 + currentStep / maxSteps * 15
        z: 2
        anchors {
            left: parent.right
            verticalCenter: parent.verticalCenter
        }
        visible: activity.modeRGB ? false : currentStep > 0
        fillMode: Image.PreserveAspectFit

        Colorize {
            anchors.fill: parent
            source: parent
            hue: chooser.hue
            lightness: 0
            saturation: 1
        }
    }

    Colorize {
        id: color
        anchors.fill: parent
        source: parent
        hue: 0.0
        saturation: 1
    }

    ColorButton {
        text: "+"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: parent.width * 0.2
        }
        onClicked: currentStep = Math.min(currentStep + 1, maxSteps)
    }

    ColorButton {
        text: "-"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: parent.width * 0.4
        }
        onClicked: currentStep = Math.max(currentStep - 1, 0)
    }
}
