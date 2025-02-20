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
import core 1.0
import "../../core"
import "braille_alphabets.js" as Activity
import "questions.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset.get()

    pageComponent: Image {
        id: activityBackground
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

        Keys.onPressed: (event) => {
            if(items.buttonsBlocked) {
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
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias clickSound: clickSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            property string instructions
            property alias playableChar: playableChar
            property alias score: score
            property bool brailleCodeSeen
            property bool buttonsBlocked: false
        }

        onStart: {
            first_screen.visible = true
            Activity.start(items, dataset)
        }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: clickSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        ListModel {
            id: containerModel
        }
        
        Item {
            id: layoutArea
            anchors.fill: activityBackground
            anchors.bottomMargin: bar.height * 1.3
        }

        Rectangle {
            id: charList
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            anchors.margins: GCStyle.baseMargins
            radius: GCStyle.baseMargins
            height: Math.min(120 * ApplicationInfo.ratio, layoutArea.height * 0.3)
            visible: items.brailleCodeSeen
            color: "#a5cbd9"

            Row {
                id: row
                spacing: GCStyle.baseMargins
                anchors.centerIn: charList

                Repeater {
                    id: cardRepeater
                    model: containerModel

                    // workaround for https://bugreports.qt.io/browse/QTBUG-72643 (qml binding with global variable in Repeater do not work)
                    property alias rowSpacing: row.spacing
                    Item {
                        id: inner
                        height: charList.height - 2 * GCStyle.baseMargins
                        width: (charList.width - containerModel.count * cardRepeater.rowSpacing)/ containerModel.count

                        BrailleChar {
                            id: ins
                            width: Math.min(parent.height * 0.5, parent.width)
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            clickable: false
                            brailleChar: letter
                        }
                        Item {
                            anchors.top: ins.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            GCText {
                                text: letter
                                font.weight: Font.DemiBold
                                color: GCStyle.darkerText
                                width: parent.width
                                height: parent.height
                                fontSizeMode: Text.Fit
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: playableCharBg
            anchors {
                top: charList.bottom
                left: layoutArea.left
                margins: GCStyle.baseMargins
            }
            color: "#d3e6ed"
            border.color: "#a5cbd9"
            border.width: GCStyle.midBorder
            radius: GCStyle.baseMargins
            width: playableChar.width * 1.5 + 2 * GCStyle.baseMargins
            height: (playableChar.height  + playableCharDisplayArea.height) + 3 * GCStyle.baseMargins

            BrailleChar {
                id: playableChar
                clickable: true
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: GCStyle.baseMargins
                }
                width: Math.min(layoutArea.width * 0.18, layoutArea.height * 0.2)
                isLetter: true
                onBrailleCharClicked: {
                    if(brailleChar === Activity.getCurrentLetter()) {
                        particles.burst(40);
                        Activity.goodAnswer();
                    } else {
                        clickSound.play()
                    }
                }
            }
            Item {
                id: playableCharDisplayArea
                height: playableChar.height * 0.3
                width: parent.width
                anchors.top: playableChar.bottom
                anchors.topMargin: GCStyle.baseMargins
                GCText {
                    id: playableCharDisplay
                    font.weight: Font.DemiBold
                    color: GCStyle.darkerText
                    text: playableChar.brailleChar
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: instructionsArea
            anchors {
                top: charList.bottom
                left: playableCharBg.right
                right: layoutArea.right
                bottom: braille_map.top
                margins: GCStyle.baseMargins
            }
            color: "#aae4f9"
            radius: GCStyle.halfMargins

            GCText {
                id: questionItem
                anchors.centerIn: parent
                fontSize: largeSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                color: GCStyle.darkerText
                width: parent.width - GCStyle.baseMargins
                height: parent.height - GCStyle.halfMargins
                wrapMode: Text.WordWrap
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
                verticalCenter: braille_map.verticalCenter
                right: braille_map.left
                rightMargin: GCStyle.baseMargins
                left: undefined
                top: undefined
                bottom: undefined
            }
            visible: !first_screen.visible
            onStop: Activity.nextQuestion();
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BrailleMap {
            id: dialogMap
            // Make it non visible or we get some rendering artefacts before
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
            source: Activity.url + "braille_button.svg"
            anchors {
                right: layoutArea.right
                bottom: layoutArea.bottom
                margins: GCStyle.baseMargins
            }
            width: GCStyle.bigButtonHeight
            visible: !first_screen.visible
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

