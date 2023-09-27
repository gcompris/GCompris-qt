/* GCompris - BrailleAlphabets.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "braille_alphabets.js" as Activity
import "questions.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        signal start
        signal stop
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: {
            if(bonus.isPlaying || score.isWinAnimationPlaying) {
                return
            }
            if(first_screen.visible) {
                // If return, we hide the screen
                first_screen.visible = false;
                return;
            }
            var keyValue;
            switch(event.key)
            {
            case Qt.Key_1:
                keyValue = 1;
                break;
            case Qt.Key_2:
                keyValue = 2;
                break;
            case Qt.Key_3:
                keyValue = 3;
                break;
            case Qt.Key_4:
                keyValue = 4;
                break;
            case Qt.Key_5:
                keyValue = 5;
                break;
            case Qt.Key_6:
                keyValue = 6;
                break;
            }
            if(keyValue)
                playableChar.switchState(keyValue);
            if(event.key === Qt.Key_Space)
                braille_map.clicked();
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            property string instructions
            property alias playableChar: playableChar
            property alias score: score
            property bool brailleCodeSeen
            property bool levelComplete: false
        }

        onStart: {
            first_screen.visible = true
            Activity.start(items, dataset)
        }
        onStop: { Activity.stop() }


        ListModel {
            id: containerModel
        }

        Image {
            id: charList
            y: 20 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            source: Activity.url + "top_back.svg"
            sourceSize.width: parent.width * 0.94
            visible: items.brailleCodeSeen

            Row {
                id: row
                spacing: 10 * ApplicationInfo.ratio
                anchors.centerIn: charList
                anchors.horizontalCenterOffset: 5

                Repeater {
                    id: cardRepeater
                    model: containerModel

                    // workaround for https://bugreports.qt.io/browse/QTBUG-72643 (qml binding with global variable in Repeater do not work)
                    property alias rowSpacing: row.spacing
                    Item {
                        id: inner
                        height: charList.height * 0.9
                        width: (charList.width - containerModel.count * cardRepeater.rowSpacing)/ containerModel.count

                        Rectangle {
                            id: rect1
                            width:  charList.width / 13
                            height: ins.height
                            border.width: 0
                            border.color: "black"
                            color: "#a5cbd9"

                            BrailleChar {
                                id: ins
                                width: parent.width * 0.9
                                anchors.centerIn: parent
                                clickable: false
                                brailleChar: letter
                            }
                        }

                        GCText {
                            text: letter
                            font.weight: Font.DemiBold
                            color: "#2a2a2a"
                            font.pointSize: NaN  // need to clear font.pointSize explicitly
                            font.pixelSize: rect1.width * 0.5
                            anchors {
                                top: rect1.bottom
                                topMargin: 4 * ApplicationInfo.ratio
                                horizontalCenter: rect1.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        Image {
            id: playableCharBg
            anchors {
                top: charList.bottom
                topMargin: 10 * ApplicationInfo.ratio
            }
            verticalAlignment: Image.AlignTop
            x: 10 * ApplicationInfo.ratio
            source: Activity.url + "char_background.svg"
            sourceSize.width: playableChar.width * 1.8
            height: (playableChar.height  + playableCharDisplay.height) * 1.2

            BrailleChar {
                id: playableChar
                clickable: true
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 20 * ApplicationInfo.ratio
                }
                width: Math.min(background.width * 0.18, background.height * 0.2)
                isLetter: true
                onBrailleCharChanged: {
                    if(brailleChar === Activity.getCurrentLetter()) {
                        particles.burst(40);
                        Activity.goodAnswer();
                    }
                }
            }

            GCText {
                id: playableCharDisplay
                font.pointSize: NaN  // need to clear font.pointSize explicitly
                font.pixelSize: Math.max(playableChar.width * 0.4, 24)
                font.weight: Font.DemiBold
                color: "#2a2a2a"
                text: playableChar.brailleChar
                anchors {
                    top: playableChar.bottom
                    topMargin: 4 * ApplicationInfo.ratio
                    horizontalCenter: playableChar.horizontalCenter
                }
            }
        }

        Rectangle {
            id: instructionsArea
            height: parent.height * 0.3
            width: parent.width / 1.1
            anchors {
                top: charList.bottom
                topMargin: 10 * ApplicationInfo.ratio
                left: playableCharBg.right
                leftMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
            }
            color: "#55333333"
            border.width: 0
            radius: 5

            GCText {
                id: questionItem
                anchors.centerIn: parent
                fontSize: largeSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "black"
                color: "white"
                width: parent.width * 0.94
                height: parent.height * 0.94
                wrapMode: Text.WordWrap

                function initQuestion() {
                    playableChar.clearLetter()
                    text = Activity.getCurrentTextQuestion()
                    if(items.instructions)
                        text += "\n" + items.instructions
                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
            }
        }

        ParticleSystemStarLoader {
            id: particles
            clip: false
        }

        FirstScreen {
            id: first_screen
        }

        Score {
            id: score
            anchors {
                top: instructionsArea.bottom
                left: instructionsArea.horizontalCenter
                bottom: braille_map.top
                bottomMargin: 30 * ApplicationInfo.ratio
            }
            visible: !(dialogMap.visible || first_screen.visible)
            onStop: if(!items.levelComplete) Activity.nextQuestion();
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BrailleMap {
            id: dialogMap
            // Make is non visible or we get some rendering artefacts before
            // until it is created
            visible: false
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: first_screen.visible ? help | home : help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: braille_map
            source: Activity.url + "target.svg"
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            sourceSize.width: 66 * bar.barZoom
            visible: true
            onClicked: {
                dialogMap.visible = true
                displayDialog(dialogMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}

