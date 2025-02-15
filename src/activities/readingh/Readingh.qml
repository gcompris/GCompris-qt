/* GCompris - readingh.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (graphics and improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "readingh.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int speedSetting: 5
    /* mode of the activity, "readingh" (horizontal) or "readingv" (vertical):*/
    property string mode: "readingh"

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "reading-bg.svg"
        signal start
        signal stop
        sourceSize.width: parent.width
        fillMode: Image.Stretch

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // system locale by default
        property string locale: "system"

        property int baseMargins: 10 * ApplicationInfo.ratio
        property bool isHorizontalLayout: activityBackground.width >= activityBackground.height

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias wordDropTimer: wordDropTimer
            property alias locale: activityBackground.locale
            property alias iAmReady: iAmReady
            property alias answerButtonFound: answerButtonFound
            property alias answerButtonNotFound: answerButtonNotFound
            property alias answerButtonsFlow: answerButtonsFlow
            property alias wordDisplayRepeater: wordDisplayRepeater
            property string textToFind
            property int currentIndex
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    activityBackground.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale);
                }
                if(activityData && activityData["speedSetting"]) {
                    activity.speedSetting = activityData["speedSetting"];
                }
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
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
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }

        Item {
            id: mainArea
            anchors.fill: activityBackground
            anchors.bottomMargin: bar.height * 1.2
            anchors.topMargin: activityBackground.baseMargins
            anchors.leftMargin: activityBackground.baseMargins
            anchors.rightMargin: activityBackground.baseMargins
        }

        states: [
            State {
                id: horizontalLayout
                when: activityBackground.isHorizontalLayout
                PropertyChanges {
                    wordDisplayListBg {
                        anchors.margins: activityBackground.baseMargins
                        width: 0.45 * mainArea.width
                    }
                }
                AnchorChanges {
                    target: wordDisplayListBg
                    anchors.top: mainArea.top
                    anchors.bottom: mainArea.bottom
                }
                PropertyChanges {
                    wordToFindBoxBg {
                        anchors.margins: activityBackground.baseMargins
                        width: mainArea.width * 0.45
                        height: mainArea.height * 0.3
                    }
                }
                AnchorChanges {
                    target: wordToFindBoxBg
                    anchors.horizontalCenter: buttonsArea.horizontalCenter
                    anchors.top: mainArea.top
                }
                PropertyChanges {
                    buttonsArea {
                        height: wordDisplayListBg.height * 0.5
                    }
                }
                AnchorChanges {
                    target: buttonsArea
                    anchors.top: wordToFindBoxBg.bottom
                    anchors.left: wordDisplayListBg.right
                    anchors.right: activityBackground.right
                    anchors.bottom: score.top
                    anchors.verticalCenter: undefined
                }
            },
            State {
                id: verticalLayout
                when: !activityBackground.isHorizontalLayout
                PropertyChanges {
                    wordDisplayListBg {
                        anchors.margins: activityBackground.baseMargins
                    }
                }
                AnchorChanges {
                    target: wordDisplayListBg
                    anchors.top: wordToFindBoxBg.bottom
                    anchors.bottom: score.top
                    anchors.left: mainArea.left
                    anchors.right: mainArea.right
                }
                PropertyChanges {
                    wordToFindBoxBg {
                        anchors.margins: 0
                        width: mainArea.width - 4 * activityBackground.baseMargins
                        height: mainArea.height * 0.2
                    }
                }
                AnchorChanges {
                    target: wordToFindBoxBg
                    anchors.horizontalCenter: mainArea.horizontalCenter
                    anchors.top: mainArea.top
                }
                PropertyChanges {
                    buttonsArea {
                        height: wordDisplayListBg.height * 0.5
                    }
                }
                AnchorChanges {
                    target: buttonsArea
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: wordDisplayListBg.left
                    anchors.right: wordDisplayListBg.right
                    anchors.verticalCenter: wordDisplayListBg.verticalCenter
                }
            }
        ]

        Rectangle {
            id: wordDisplayListBgShadow
            color: "#50000000"
            width: wordDisplayListBg.width
            height: wordDisplayListBg.height
            x: wordDisplayListBg.x + 2 * ApplicationInfo.ratio
            y: wordDisplayListBg.y + 2 * ApplicationInfo.ratio
        }

        Rectangle {
            id: wordDisplayListBg
            color: "#F2F2F2"
            anchors.top: mainArea.top
            anchors.left: mainArea.left
            anchors.margins: activityBackground.baseMargins
            width: 0.45 * mainArea.width
            height: mainArea.height
        }

        Flow {
            id: wordDisplayList
            spacing: 20
            anchors.fill: wordDisplayListBg
            anchors.margins: activityBackground.baseMargins
            flow: mode == "readingh" ? Flow.LeftToRight : Flow.TopToBottom
            layoutDirection: Core.isLeftToRightLocale(locale) ? Qt.LeftToRight : Qt.RightToLeft

            Repeater {
                id: wordDisplayRepeater
                model: Activity.words
                property int idToHideBecauseOverflow: 0
                delegate: GCText {
                    text: modelData
                    color: "#373737"
                    opacity: iAmReady.visible ? false : (index == items.currentIndex ? 1 : 0)

                    onOpacityChanged: {
                    /* Handle case where we go over the image
                    On these cases, we hide all above items to restart to 0
                    As we don't replay the same level and always replace the model,
                    we do not care about restoring visible to true */
                        if((x+width > wordDisplayList.width) ||
                           (y+height > wordDisplayList.height)) {
                            var i = wordDisplayRepeater.idToHideBecauseOverflow;
                            for(; i < index; ++i) {
                                if(wordDisplayRepeater.itemAt(i)) {
                                    wordDisplayRepeater.itemAt(i).visible = false
                                }
                            }
                            wordDisplayRepeater.idToHideBecauseOverflow = i
                        }
                    }
                }
            }
        }

        Rectangle {
            color: "#50000000"
            width: wordToFindBoxBg.width
            height: wordToFindBoxBg.height
            x: wordToFindBoxBg.x + 2 * ApplicationInfo.ratio
            y: wordToFindBoxBg.y + 2 * ApplicationInfo.ratio
            radius: activityBackground.baseMargins
        }
        Rectangle {
            id: wordToFindBoxBg
            color: "#E8E8E8"
            anchors.horizontalCenter: buttonsArea.horizontalCenter
            anchors.top: mainArea.top
            anchors.margins: activityBackground.baseMargins
            width: mainArea.width * 0.45
            height: mainArea.height * 0.3
            radius: activityBackground.baseMargins
        }
        Rectangle {
            color: "transparent"
            anchors.fill: wordToFindBoxBg
            anchors.margins: activityBackground.baseMargins
            border.width: 2 * ApplicationInfo.ratio
            border.color: "#87A6DD"
            radius: activityBackground.baseMargins
        }

        GCText {
            id: wordToFindBox
            text: qsTr("<font color=\"#373737\">Check if the word<br/></font><b><font color=\"#315AAA\">%1</font></b><br/><font color=\"#373737\">is displayed</font>").arg(items.textToFind)
            color: "#373737"
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: wordToFindBoxBg
            anchors.topMargin: 1.2 * activityBackground.baseMargins
            anchors.bottomMargin: 1.2 * activityBackground.baseMargins
            anchors.leftMargin: 2 * activityBackground.baseMargins
            anchors.rightMargin: 2 * activityBackground.baseMargins
            fontSizeMode: Text.Fit
        }

        Score {
            id: score
            anchors.right: mainArea.right
            anchors.bottom: mainArea.bottom
            anchors.margins: activityBackground.baseMargins
        }

        Item {
            id: buttonsArea
            anchors.top: wordToFindBoxBg.bottom
            anchors.left: wordDisplayListBg.right
            anchors.right: activityBackground.right
            anchors.bottom: score.top
            anchors.margins: 10 * ApplicationInfo.ratio
        }

        ReadyButton {
            id: iAmReady
            onClicked: Activity.run()
            anchors.centerIn: buttonsArea
            theme: "light"
        }

        Rectangle {
            color: "#313131"
            width: answerButtonsFlow.width + activityBackground.baseMargins * 2
            height: answerButtonsFlow.height + activityBackground.baseMargins * 2
            anchors.centerIn: answerButtonsFlow
            visible: !activityBackground.isHorizontalLayout && answerButtonsFlow.visible
        }

        GCSoundEffect {
            id: goodAnswerEffect
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerEffect
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Flow {
            id: answerButtonsFlow
            width: Math.min(250 * ApplicationInfo.ratio, buttonsArea.width)
            height: Math.min(120 * ApplicationInfo.ratio, buttonsArea.height * 0.5)
            anchors.centerIn: buttonsArea
            visible: false
            AnswerButton {
                id : answerButtonFound
                width: parent.width
                height: parent.height * 0.5
                textLabel: qsTr("Yes, I saw it!")
                isCorrectAnswer: Activity.words ? Activity.words.indexOf(items.textToFind) != -1 : false
                onCorrectlyPressed: Activity.nextSubLevel()
                onIncorrectlyPressed: Activity.retrySubLevel()
                blockAllButtonClicks: items.buttonsBlocked
                onPressed: {
                    items.buttonsBlocked = true
                    if(isCorrectAnswer) {
                        goodAnswerEffect.play();
                        score.currentSubLevel += 1;
                        score.playWinAnimation();
                    } else {
                        badAnswerEffect.play();
                    }
                }
            }

            AnswerButton {
                id : answerButtonNotFound
                width: parent.width
                height: answerButtonFound.height
                textLabel: qsTr("No, it was not there!")
                isCorrectAnswer: !answerButtonFound.isCorrectAnswer
                onCorrectlyPressed: Activity.nextSubLevel()
                onIncorrectlyPressed: Activity.retrySubLevel()
                blockAllButtonClicks: items.buttonsBlocked
                onPressed: {
                    items.buttonsBlocked = true
                    if(isCorrectAnswer) {
                        goodAnswerEffect.play();
                        score.currentSubLevel += 1;
                        score.playWinAnimation();
                    } else {
                        badAnswerEffect.play();
                    }
                }
            }
        }

        Wordlist {
            id: wordlist
            defaultFilename: Activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: (msg) => console.log("Reading: Wordlist error: " + msg);
        }

        Timer {
            id: wordDropTimer
            repeat: true
            interval: items.currentIndex == -1 ? 100 : 5000 / speedSetting;
            onTriggered: Activity.dropWord();
        }

    }

}
