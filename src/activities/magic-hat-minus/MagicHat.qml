/* GCompris - MagicHat.qml
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "magic-hat.js" as Activity
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "minus"

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        property int starSize: Math.min((background.width - 10 * ApplicationInfo.ratio) / 14 ,
                                        (operationLayout.height - 10 * ApplicationInfo.ratio) / 12)

        signal start
        signal stop

        property var starColors : ["1", "2", "3"]

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: Activity.start(items, mode)
        onStop: Activity.stop()

        property bool vert: background.width >= (background.height - okButton.height)

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property int currentLevel: activity.currentLevel
            readonly property var levels: activity.datasetLoader.data
            property alias bonus: bonus
            property alias hat: theHat
            property alias introductionText: introText
            property var repeatersList:
                [repeaterFirstRow, repeaterSecondRow, repeaterAnswerRow]
        }

        Rectangle {
            id: introTextBG
            width: introText.width
            height: introText.height
            anchors.centerIn: introText
            color: "#373737"
            radius: 5 * ApplicationInfo.ratio
            visible: introText.visible
        }

        GCText {
            id: introText
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10 * ApplicationInfo.ratio
            }
            width: parent.width - 10 * ApplicationInfo.ratio
            height: (background.height - bar.height * 1.2) * 0.1
            fontSizeMode: Text.Fit
            minimumPointSize: 7
            fontSize: hugeSize
            font.bold: true
            color: "white"
            wrapMode: TextEdit.WordWrap
            horizontalAlignment: TextEdit.AlignHCenter
            text: qsTr("Click on the hat to begin the game")
        }

        Image {
            // The math operation
            id: operatorImage
            source: mode == "minus" ? Activity.url + "minus.svg" :
                                      Activity.url + "plus.svg"
            anchors.right: operationLayout.left
            anchors.rightMargin: 10
            width: background.starSize
            height: width
            sourceSize.width: width
            y: operationLayout.y + secondRow.y - height * 0.5
        }

        Grid {
            id: operationLayout
            anchors {
                top: introTextBG.bottom
                topMargin: 10
                horizontalCenter: background.horizontalCenter
                horizontalCenterOffset: operatorImage.width * 0.5
            }
            width: background.starSize * 12
            height: (background.height - bar.height * 1.2) * 0.7
            columns: 1
            Column {
                id: firstRow
                height: background.starSize * 4
                spacing: 5
                z: 10
                Repeater {
                    id: repeaterFirstRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 0
                        barIndex: index
                        width: operationLayout.width
                        backgroundColor: "grey"
                        starsColor: starColors[index]
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
                }
            }
            Column {
                id: secondRow
                height: background.starSize * 4
                spacing: 5
                z: 9
                Repeater {
                    id: repeaterSecondRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 1
                        barIndex: index
                        width: operationLayout.width
                        backgroundColor: "grey"
                        starsColor: starColors[index]
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
                }
            }

            Rectangle {
                width: (background.starSize + 5) * 10 - 5
                height: 5 * ApplicationInfo.ratio
                color: "white"
            }

            Rectangle {
                width: (background.starSize + 5) * 10 - 5
                height: 10 * ApplicationInfo.ratio
                opacity: 0
            }

            Column {
                id: answerRow
                height: background.starSize * 4
                spacing: 5
                Repeater {
                    id: repeaterAnswerRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 2
                        barIndex: index
                        width: operationLayout.width
                        backgroundColor: "#53b9c9"
                        starsColor: starColors[index]
                        authorizeClick: false
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Hat {
            id: theHat
            anchors {
                bottom: bar.top
                margins: 20 * ApplicationInfo.ratio
            }
            x: Math.max(20 * ApplicationInfo.ratio, operationLayout.x * 0.5 - width * 0.5)
            height: (background.height - bar.height * 1.2) * 0.2
            width: height
            starsSize: background.starSize
            audioEffects: activity.audioEffects
        }

        BarButton {
            id: okButton
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: (background.height - bar.height * 1.2) * 0.15
            sourceSize.width: width
            enabled: !bonus.isPlaying && theHat.state === "GuessNumber"
            onClicked: Activity.verifyAnswer()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
