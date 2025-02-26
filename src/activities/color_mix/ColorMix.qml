/* GCompris - colormix.qml
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"
import "colormix.js" as Activity

ActivityBase {
    id: activity

    property bool modeRGB: false

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: activityBackground
        source: Activity.url + (modeRGB ? "background.svg" : "background2.svg")
        sourceSize.width: width
        sourceSize.height: height
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property bool buttonsBlocked: false
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

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        Rectangle {
            id: target
            height: width * 0.4
            width: Math.min(parent.width * 0.2, GCStyle.bigButtonHeight)
            radius: GCStyle.halfMargins
            anchors {
                top: parent.top
                topMargin: GCStyle.baseMargins
                horizontalCenter: parent.horizontalCenter
            }
            border.width: GCStyle.thinBorder
            border.color: GCStyle.grayBorder
            color: Activity.getColor(items.targetColor1, items.targetColor2,
                                     items.targetColor3)
        }

        GCText {
            text: qsTr("Match the color")
            color: GCStyle.darkerText
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            anchors {
                top: target.top
                bottom: target.bottom
                right: target.left
                left: parent.left
                rightMargin: GCStyle.baseMargins
                leftMargin: GCStyle.baseMargins
            }
        }

        Rectangle {
            color: "#80FFFFFF"
            anchors.centerIn: helpMessage
            width: helpMessage.contentWidth + GCStyle.baseMargins * 2
            height: helpMessage.contentHeight + GCStyle.baseMargins
            visible: helpMessage.text != ""
        }

        GCText {
            id: helpMessage
            text: ""
            color: GCStyle.darkerText
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors {
                top: color1.bottom
                left: layoutArea.left
                right: color2.left
                bottom: layoutArea.bottom
                margins: GCStyle.baseMargins
            }
        }

        Item {
            id: layoutArea
            anchors.top: target.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bar.top
            anchors.margins: GCStyle.baseMargins
            anchors.topMargin: target.height
        }

        Rectangle {
            id: result
            height: width
            width: Math.min(layoutArea.width * 0.2, layoutArea.height * 0.33) - GCStyle.baseMargins
            radius: height * 0.5
            anchors.top: layoutArea.top
            anchors.horizontalCenter: layoutArea.horizontalCenter
            border.width: GCStyle.thinBorder
            border.color: GCStyle.grayBorder
            color: Activity.getColor(items.currentColor1, items.currentColor2,
                                     items.currentColor3)
        }

        ColorChooser {
            id: color1
            brushHue: activity.modeRGB ? "-r" : "-m" /* red / magenta */
            source: Activity.url + (activity.modeRGB ? "flashlight-red.svg" : "tube-magenta.svg")
            height: result.width
            maxSteps: items.maxSteps
            anchors {
                right: result.left
                rightMargin: GCStyle.baseMargins
                verticalCenter: result.verticalCenter
            }
        }

        ColorChooser {
            id: color2
            brushHue: activity.modeRGB ? "-g" : "-y" /* green / yellow */
            source: Activity.url + (activity.modeRGB ? "flashlight-green.svg" : "tube-yellow.svg")
            height: result.width
            maxSteps: items.maxSteps
            anchors {
                horizontalCenter: result.horizontalCenter
                top: result.bottom
                topMargin: GCStyle.baseMargins + height * 0.5
            }
            rotation: -90
        }

        ColorChooser {
            id: color3
            brushHue: activity.modeRGB ? "-b" : "-c" /* blue / cyan */
            source: Activity.url + (activity.modeRGB ? "flashlight-blue.svg" : "tube-cyan.svg")
            height: result.width
            maxSteps: items.maxSteps
            anchors {
                left: result.right
                leftMargin: GCStyle.baseMargins
                verticalCenter: result.verticalCenter
            }
            rotation: 180
        }

        Score {
            id: score
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: undefined
            anchors.margins: GCStyle.baseMargins
            currentSubLevel: 0
            numberOfSubLevels: 10
            onStop: Activity.nextSubLevel()
        }

        BarButton {
            id: validate
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            visible: true
            enabled: !items.buttonsBlocked
            anchors {
                right: parent.right
                rightMargin: GCStyle.baseMargins
                verticalCenter: layoutArea.verticalCenter
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
                    items.buttonsBlocked = true
                    items.score.currentSubLevel += 1
                    items.score.playWinAnimation()
                    winSound.play()
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
            level: items.currentLevel + 1
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
