/* GCompris - LetterInWord.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *               2016 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *               2020 Timothée Giet <animtim@gmail.com>

 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Click on Letter - Qt Quick port)
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Adapt Click on Letter to make Letter in which word)
 *   Timothée Giet <animtim@gmail.com> (Refactoring, fixes and improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtGraphicalEffects 1.0
import GCompris 1.0
import "../../core"
import "letter-in-word.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: Activity.resUrl + "hillside.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        focus: true

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false

        signal start
        signal stop
        signal voiceError

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item activityPage: activity
            property int currentLevel: activity.currentLevel
            property alias background: background
            property alias wordsModel: wordsModel
            property int currentLetterCase: ApplicationSettings.fontCapitalization
            property int currentMode: normalModeWordCount
            readonly property int easyModeWordCount: 5
            readonly property int normalModeWordCount: 11
            property GCAudio audioVoices: activity.audioVoices
            property alias parser: parser
            property alias animateX: animateX
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias locale: background.locale
            property alias questionItem: questionItem
            property alias englishFallbackDialog: englishFallbackDialog
            property string question
        }

        onStart: {
            activity.audioVoices.error.connect(voiceError)
            Activity.start(items);
        }

        onStop: Activity.stop()

        onWidthChanged: {
                animateX.restart();
        }

        onHeightChanged: {
                animateX.restart();
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onLoadData: {
                if(activityData && activityData["locale"] && activityData["locale"] !== "system") {
                    background.locale = activityData["locale"];
                }
                else {
                    background.locale = Core.resolveLocale(background.locale)
                }
                if(activityData && activityData["savedLetterCase"]) {
                    items.currentLetterCase = activityData["savedLetterCase"];
                }
                if(activityData && activityData["savedMode"]) {
                    items.currentMode = activityData["savedMode"];
                }
            }
            onStartActivity: {
                background.stop();
                background.start();
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig);
            }
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
        }

        Bonus {
            id: bonus
            interval: 100
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel);
            }
        }

        Item {
            id: planeText
            width: plane.width
            height: plane.height
            x: -width
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            Image {
                id: plane
                anchors.centerIn: planeText
                anchors.top: parent.top
                source: Activity.resUrl + "plane.svg"
                sourceSize.height: repeatItem.width
            }

            GCText {
                id: questionItem

                anchors {
                    right: planeText.right
                    rightMargin: 2 * plane.width / 3
                    verticalCenter: planeText.verticalCenter
                    bottomMargin: 10 * ApplicationInfo.ratio
                }
                fontSize: hugeSize
                font.weight: Font.DemiBold
                color: "#2a2a2a"
                text: items.question
            }

            PropertyAnimation {
                id: animateX
                target: planeText
                properties: "x"
                from: -planeText.width
                //to:background.width/2 - planeText.width/2
                to: bar.level <= 2 ? background.width/3.7 : background.width
                duration: bar.level <= 2 ? 5500: 11000
                //easing.type: Easing.OutQuad
                easing.type: bar.level <= 2 ? Easing.OutQuad: Easing.OutInCirc
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg"
            sourceSize.width: 80 * ApplicationInfo.ratio
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
            }
            onClicked:{
                if(!audioVoices.isPlaying()) {
                    Activity.playLetter(Activity.currentLetter);
                    animateX.restart();
                }
            }
        }

        Keys.onSpacePressed: wordsView.currentItem.select();
        Keys.onTabPressed: repeatItem.clicked();
        Keys.onEnterPressed: ok.clicked();
        Keys.onReturnPressed: ok.clicked();
        Keys.onRightPressed: wordsView.moveCurrentIndexRight();
        Keys.onLeftPressed: wordsView.moveCurrentIndexLeft();
        Keys.onDownPressed: wordsView.moveCurrentIndexDown();
        Keys.onUpPressed: wordsView.moveCurrentIndexUp();

        ListModel {
            id: wordsModel
        }

        property int itemWidth: Core.fitItems(wordsView.width, wordsView.height, wordsView.count);

        GridView {
            id: wordsView
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: ok.left
            anchors.top: planeText.bottom
            anchors.topMargin: 0
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: bar.height * 0.5
            cellWidth: background.itemWidth
            cellHeight: background.itemWidth
            bottomMargin: 10 * ApplicationInfo.ratio
            clip: false
            interactive: false
            layoutDirection: Qt.LeftToRight
            currentIndex: -1
            highlight: gridHighlight
            highlightFollowsCurrentItem: true
            keyNavigationWraps: true
            model: wordsModel
            delegate: Card {
                width: background.itemWidth
                height: background.itemWidth - 10 * ApplicationInfo.ratio
                Connections {
                    target: bonus
                    onStart: {
                        mouseActive = false;
                    }
                    onStop: {
                        mouseActive = true;
                    }
                }
            }
        }

        Component {
            id: gridHighlight
            Rectangle {
                width: background.itemWidth
                height: background.itemWidth
                color:  "#AAFFFFFF"
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: repeatItem.width
            height: width
            sourceSize.width: width
            anchors {
                right: parent.right
                rightMargin: 3 * ApplicationInfo.ratio
                bottom: wordsView.bottom
            }
            onClicked: Activity.checkAnswer();
        }

        JsonParser {
            id: parser
            onError: console.error("Letter-in-word: Error parsing JSON: " + msg);
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: {
                    background.englishFallback = false;
                    Core.checkForVoices(activity);
                }
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
