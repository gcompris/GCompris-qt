/* GCompris - colormix.qml
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

import "../../core"
import "colormix.js" as Activity

ActivityBase {
    id: activity

    property bool modeRGB: false

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: background
        source: Activity.url + (modeRGB ? "background.svg" : "background2.svg")
        sourceSize.width: Math.max(parent.width, parent.height)
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property int maxSteps: 1
            property int targetColor1: 0
            property int targetColor2: 0
            property int targetColor3: 0
            property alias currentColor1: color1.currentStep
            property alias currentColor2: color2.currentStep
            property alias currentColor3: color3.currentStep
            property int margins: 20
            property int chooserHeight: Math.min(background.height * 0.2,
                                                 background.width * 0.2)
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        Rectangle {
            id: target
            height: width / 2
            width: parent.width / 5
            radius: height / 10
            anchors {
                top: parent.top
                topMargin: items.margins
                horizontalCenter: parent.horizontalCenter
            }
            border.color: "#2a2a2a"
            border.width: 0
            color: Activity.getColor(items.targetColor1, items.targetColor2,
                                     items.targetColor3)
        }

        GCText {
            text: qsTr("Match the color")
            fontSize: 18
            color: "#2a2a2a"
            horizontalAlignment: Text.AlignRight
            wrapMode: Text.WordWrap
            anchors {
                top: target.top
                right: target.left
                left: parent.left
                rightMargin: items.margins
            }
        }

        GCText {
            id: helpMessage
            text: ""
            fontSize: mediumSize
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            anchors {
                top: target.top
                left: target.right
                right: parent.right
                leftMargin: items.margins
            }
        }
        Rectangle {
            id: result
            height: width
            width: target.width * 0.75
            radius: height / 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: target.bottom
                topMargin: (background.height - items.chooserHeight * 4) / 2
            }
            border.color: "#2a2a2a"
            border.width: 0
            color: Activity.getColor(items.currentColor1, items.currentColor2,
                                     items.currentColor3)
        }

        ColorChooser {
            id: color1
            brushHue: activity.modeRGB ? "-r" : "-m" /* red / magenta */
            source: Activity.url + (activity.modeRGB ? "flashlight-red.svg" : "tube-magenta.svg")
            sourceSize.height: items.chooserHeight
            maxSteps: items.maxSteps
            anchors {
                right: result.left
                rightMargin: items.margins
                verticalCenter: result.verticalCenter
            }
        }

        ColorChooser {
            id: color2
            brushHue: activity.modeRGB ? "-g" : "-y" /* green / yellow */
            source: Activity.url + (activity.modeRGB ? "flashlight-green.svg" : "tube-yellow.svg")
            sourceSize.height: items.chooserHeight
            maxSteps: items.maxSteps
            anchors {
                horizontalCenter: result.horizontalCenter
                top: result.bottom
                topMargin: items.margins + width / 2 - height / 2
            }
            rotation: -90
        }

        ColorChooser {
            id: color3
            brushHue: activity.modeRGB ? "-b" : "-c" /* blue / cyan */
            source: Activity.url + (activity.modeRGB ? "flashlight-blue.svg" : "tube-cyan.svg")
            sourceSize.height: items.chooserHeight
            maxSteps: items.maxSteps
            anchors {
                left: result.right
                leftMargin: items.margins
                verticalCenter: result.verticalCenter
            }
            rotation: 180
        }

        Score {
            id: score
            x: parent.width * 0.25
            y: parent.height * 0.65
            anchors.right: undefined
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 10
        }

        BarButton {
            id: validate
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 66 * bar.barZoom
            visible: true
            anchors {
                right: parent.right
                rightMargin: items.margins
                top: color3.bottom
                topMargin: items.margins
            }
            onClicked: {
                var message = ""
                if (activity.modeRGB) {
                    /* check RGB */
                    if (items.currentColor1 < items.targetColor1)
                        message += qsTr("Not enough red") + "\n"
                    else if (items.currentColor1 > items.targetColor1)
                        message += qsTr("Too much red") + "\n"

                    if (items.currentColor2 < items.targetColor2)
                        message += qsTr("Not enough green") + "\n"
                    else if (items.currentColor2 > items.targetColor2)
                        message += qsTr("Too much green") + "\n"

                    if (items.currentColor3 < items.targetColor3)
                        message += qsTr("Not enough blue") + "\n"
                    else if (items.currentColor3 > items.targetColor3)
                        message += qsTr("Too much blue") + "\n"
                } else {
                    /* check MCY */
                    if (items.currentColor1 < items.targetColor1)
                        message += qsTr("Not enough magenta") + "\n"
                    else if (items.currentColor1 > items.targetColor1)
                        message += qsTr("Too much magenta") + "\n"

                    if (items.currentColor2 < items.targetColor2)
                        message += qsTr("Not enough yellow") + "\n"
                    else if (items.currentColor2 > items.targetColor2)
                        message += qsTr("Too much yellow") + "\n"

                    if (items.currentColor3 < items.targetColor3)
                        message += qsTr("Not enough cyan") + "\n"
                    else if (items.currentColor3 > items.targetColor3)
                        message += qsTr("Too much cyan") + "\n"
                }
                helpMessage.text = message

                if (message === "") {
                    bonus.good("gnu")
                    helpMessage.text = ""
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
