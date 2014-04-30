/* GCompris - color_mix.qml
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
import QtQuick 2.1
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "color_mix.js" as Activity

ActivityBase {
    id: activity

    property bool modeRGB: false

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: background
        source: Activity.url + "background.jpg"
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
            property int maxSteps: 1
            property int targetColor1: 0
            property int targetColor2: 0
            property int targetColor3: 0
            property alias currentColor1: color1.currentStep
            property alias currentColor2: color2.currentStep
            property alias currentColor3: color3.currentStep
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
            width: 200
            radius: height / 10
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: "black"
            color: Activity.getColor(items.targetColor1, items.targetColor2,
                                     items.targetColor3)
        }

        Text {
            text: qsTr("Match the color")
            font.pointSize: 18
            horizontalAlignment: Text.AlignRight
            wrapMode: Text.WordWrap
            anchors.verticalCenter: target.verticalCenter
            anchors.right: target.left
            anchors.left: parent.left
            anchors.rightMargin: 20
        }

        Text {
            id: helpMessage
            text: ""
            font.pointSize: 16
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            anchors.verticalCenter: target.verticalCenter
            anchors.left: target.right
            anchors.right: parent.right
            anchors.leftMargin: 20
        }
        Rectangle {
            id: result
            height: 150
            width: height
            radius: height / 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: target.bottom
            anchors.topMargin: 20
            border.color: "black"
            color: Activity.getColor(items.currentColor1, items.currentColor2,
                                     items.currentColor3)
        }

        ColorChooser {
            id: color1
            hue: activity.modeRGB ? 0 : 300 / 360 /* red / magenta */
            maxSteps: items.maxSteps
            anchors.right: result.left
            anchors.rightMargin: 20
            anchors.verticalCenter: result.verticalCenter
        }

        ColorChooser {
            id: color2
            hue: activity.modeRGB ? 120 / 360 : 60 / 360 /* green / yellow */
            maxSteps: items.maxSteps
            anchors.horizontalCenter: result.horizontalCenter
            anchors.top: result.bottom
            anchors.topMargin: 20 + width / 2 - height / 2
            rotation: -90
        }

        ColorChooser {
            id: color3
            hue: activity.modeRGB ? 240 / 360 : 180 / 360 /* blue / cyan */
            maxSteps: items.maxSteps
            anchors.left: result.right
            anchors.leftMargin: 20
            anchors.verticalCenter: result.verticalCenter
            rotation: 180
        }

        BarButton {
            id: validate
            source: "qrc:/gcompris/src/core/resource/bar_ok.svgz"
            sourceSize.width: 66 * bar.barZoom
            visible: true
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            onClicked: {
                var message = ""
                if (activity.modeRGB) {
                    /* check RGB */
                    if (items.currentColor1 < items.targetColor1)
                        message += qsTr("Not enough red.\n")
                    else if (items.currentColor1 > items.targetColor1)
                        message += qsTr("Too much red.\n")

                    if (items.currentColor2 < items.targetColor2)
                        message += qsTr("Not enough green.\n")
                    else if (items.currentColor2 > items.targetColor2)
                        message += qsTr("Too much green.\n")

                    if (items.currentColor3 < items.targetColor3)
                        message += qsTr("Not enough blue.\n")
                    else if (items.currentColor3 > items.targetColor3)
                        message += qsTr("Too much blue.\n")
                } else {
                    /* check MCY */
                    if (items.currentColor1 < items.targetColor1)
                        message += qsTr("Not enough magenta.\n")
                    else if (items.currentColor1 > items.targetColor1)
                        message += qsTr("Too much magenta.\n")

                    if (items.currentColor2 < items.targetColor2)
                        message += qsTr("Not enough yellow.\n")
                    else if (items.currentColor2 > items.targetColor2)
                        message += qsTr("Too much yellow.\n")

                    if (items.currentColor3 < items.targetColor3)
                        message += qsTr("Not enough cyan.\n")
                    else if (items.currentColor3 > items.targetColor3)
                        message += qsTr("Too much cyan.\n")
                }
                helpMessage.text = message

                if (message === "") {
                    bonus.good("tux")
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
                value: help | home | previous | next
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
