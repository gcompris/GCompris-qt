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
import "."

Image {
    id: chooser
    z: 1

    property int maxSteps: 10
    property int currentStep: 0
    property real hue

    Image {
        id: intensityScreen
        source: Activity.url + "flashlight2.svg"
        sourceSize.height: parent.sourceSize.height
        z: 2
        visible: false
    }

    Colorize {
        anchors.fill: intensityScreen
        source: intensityScreen
        hue: chooser.hue
        lightness: -(maxSteps - currentStep) / maxSteps
        saturation: 1
        visible: activity.modeRGB ? true : false
    }

    Image {
        id: intensityLight
        source: Activity.url + "light.svg"
        sourceSize.height: intensityScreen.sourceSize.height / 2
        visible: false
        anchors {
            left: intensityScreen.right
            leftMargin: -20 * ApplicationInfo.ratio
            verticalCenter: intensityScreen.verticalCenter
        }
        opacity: currentStep / maxSteps
    }

    Colorize {
        anchors.fill: intensityLight
        source: intensityLight
        hue: chooser.hue
        lightness: -(maxSteps - currentStep) / maxSteps
        saturation: 1
        visible: intensityScreen.visible
    }

    Image {
        id: intensityBrush
        source: Activity.url + (activity.modeRGB ? "light.svg" : "brush.svg")
        sourceSize.height: parent.sourceSize.height * 0.25 + currentStep / maxSteps * 15
        z: 2
        anchors {
            left: parent.right
            leftMargin: activity.modeRGB ? -20 * ApplicationInfo.ratio : 0
            verticalCenter: parent.verticalCenter
        }
        visible: false
        fillMode: Image.PreserveAspectFit        
    }

    Colorize {
        anchors.fill: intensityBrush
        source: intensityBrush
        hue: chooser.hue
        lightness: 0
        saturation: 1
        visible: currentStep > 0
    }

    ColorButton {
        source: Activity.url + "plus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: parent.width * 0.2
        }
    }

    ColorButton {
        source: Activity.url + "minus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: parent.width * 0.3
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: point1 } ]
        z: 4
        property real startX
        property int initialStep: 0

        onPressed: {
            startX = point1.x
            if(startX > parent.width / 2)
                currentStep = Math.max(currentStep + 1, 0)
            else
                currentStep = Math.max(currentStep - 1, 0)
            initialStep = currentStep
        }

        onTouchUpdated: {
            currentStep = initialStep + (point1.x - startX) / (20 * ApplicationInfo.ratio)
            currentStep = Math.min(currentStep, maxSteps)
            currentStep = Math.max(currentStep, 0)
            activity.audioEffects.play('qrc:/gcompris/src/activities/redraw/resource/brush.wav')
        }
    }

}
