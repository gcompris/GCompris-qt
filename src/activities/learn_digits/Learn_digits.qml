/* GCompris - learn_digits.qml
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
import "learn_digits.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        signal scoreStop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias circlesLine: circlesLine
            property alias fileId: fileId
            property alias locale: background.locale
            property int answer: 0
            property int question: 0
            property int circlesModel: 3
            property var questionsArray: []
            property var questionsLeft: []
            property bool inputLocked: false
            property var levels: activity.datasetLoader.data
        }
        property string locale: ApplicationSettings.locale
        property bool isHorizontal: layoutArea.width >= layoutArea.height

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Item {
            id: questionArea
            anchors.top: layoutArea.top
            anchors.bottom: layoutArea.verticalCenter
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
        }

        Item {
            id: textArea
            width: questionArea.width * 0.3
            height: questionArea.height * 0.8
            anchors.centerIn: questionArea
        }
        GCText {
            id: questionText
            width: textArea.width
            height: textArea.height
            anchors.centerIn: textArea
            horizontalAlignment : Text.AlignHCenter
            verticalAlignment : Text.AlignVCenter
            text: items.question
            minimumPointSize: 12
            fontSize: 1024
            fontSizeMode: Text.Fit
            font.bold: true
            color: "#d2611d"
            style: Text.Outline
            styleColor: "white"
        }
        Item {
            id: scoreArea
            width: textArea.width
            height: textArea.height
            anchors.left: textArea.right
            Score {
                id: score
                width: parent.width * 0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.bottom: undefined
                currentSubLevel: 0
                numberOfSubLevels: 10
                onStop: {
                    if(!bonus.isPlaying)
                        Activity.initQuestion();
                        items.inputLocked = false;
                }
            }
            BarButton {
                id: okButton
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: score.left
                anchors.rightMargin: 0.2 * height
                height: score.height;
                width: height
                sourceSize.height: height
                sourceSize.width: height
                enabled: !items.inputLocked
                onClicked: Activity.checkAnswer();
            }
        }

        Rectangle {
            id: circlesBackground
            color: "#D0FFFFFF"
            anchors.top: layoutArea.verticalCenter
            anchors.bottom: layoutArea.bottom
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            anchors.margins: 10 * ApplicationInfo.ratio
            radius: anchors.margins
        }
        Item {
            id: circlesArea
            property int itemWidth: background.isHorizontal ?
                                        Math.min(circlesBackground.width / (items.circlesModel + 1), circlesBackground.height * 0.9):
                                        Math.min(circlesBackground.height / (items.circlesModel + 1), circlesBackground.width * 0.9)
            width: isHorizontal ? itemWidth * items.circlesModel : itemWidth
            height: isHorizontal ? itemWidth : itemWidth * items.circlesModel
            anchors.centerIn: circlesBackground
            Repeater {
                id: circlesLine
                model: items.circlesModel
                Item {
                    id: circleComponent
                    width: circlesArea.itemWidth
                    height: width
                    x: isHorizontal ? width * index : 0
                    y: isHorizontal ? 0 : width * index
                    property bool isFilled: false
                    Rectangle {
                        id: circle
                        anchors.centerIn: parent
                        border.color: "#373737"
                        border.width: 5 * ApplicationInfo.ratio
                        color: "#00ffffff"
                        width: parent.width * 0.9
                        height: width
                        radius: width * 0.5
                    }
                    MouseArea {
                        id: circleInput
                        anchors.fill: parent
                        onClicked: {
                            if(!parent.isFilled) {
                                ++items.answer;
                                circle.color = "#ffd2611d";
                            } else {
                                --items.answer;
                                circle.color = "#00ffffff";
                            }
                            parent.isFilled = !parent.isFilled
                        }
                    }
                }
            }
        }

        File {
            id: fileId
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onStartActivity: {
                background.stop();
                background.start()
            }

            onClose: home()
        }


        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: Activity.previousLevel();
            onNextLevelClicked: Activity.nextLevel();
            onHomeClicked: activity.home();
            onActivityConfigClicked: displayDialog(dialogActivityConfig);
        }

        Bonus {
            id: bonus
            onStop: items.inputLocked = false;
            Component.onCompleted: win.connect(Activity.nextLevel);
        }
    }

}
