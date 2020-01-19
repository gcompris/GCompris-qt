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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0

import "colormix.js" as Activity
import "."

Image {
    id: chooser
    z: 1

    property int maxSteps: 10
    property int currentStep: 0
    property string brushHue

    Image {
        id: intensityScreen
        source: activity.modeRGB ? Activity.url + "flashlight2" + brushHue + ".svg" : "qrc:/gcompris/src/core/resource/empty.svg"
        sourceSize.height: parent.sourceSize.height
        sourceSize.width: parent.sourceSize.width
        z: 2
        opacity: currentStep / maxSteps
        visible: activity.modeRGB
    }

    Image {
        id: intensityBrush
        source: Activity.url + (activity.modeRGB ? 
                    "light" + brushHue + ".svg" : "brush" + brushHue + ".svg")
        sourceSize.height: parent.sourceSize.height * 0.25 + currentStep / maxSteps * 15
        z: 2
        anchors {
            left: parent.right
            leftMargin: activity.modeRGB ? -20 * ApplicationInfo.ratio : 0
            verticalCenter: parent.verticalCenter
        }
        opacity: activity.modeRGB ? currentStep / maxSteps * 2 : 1
        visible: currentStep > 0
        fillMode: Image.PreserveAspectFit        
    }

    ColorButton {
        source: Activity.url + "plus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: parent.width * 0.25
        }
        onClicked: currentStep = Math.min(currentStep+1, maxSteps)
    }

    ColorButton {
        source: Activity.url + "minus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: parent.width * 0.4
        }
        onClicked: currentStep = Math.max(currentStep-1, 0)
    }
}
