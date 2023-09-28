/* GCompris - ExploreLevels.qml
*
* SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0
import QtQuick.Controls 2.12

import "../../core"
import "explore-level.js" as Activity

ActivityBase {
    id: activity

    property int numberOfLevels
    property string url
    property bool hasAudioQuestions
    property bool needsVoices: false

    onStart: focus = true
    onStop: {}

    isMusicalActivity: needsVoices

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        width: parent.width
        height: parent.height
        sourceSize.width: width
        sourceSize.height: height

        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false

        /* In order to accept any screen ratio the play area is always a 1000x1000
         * square and is centered in a big background image that is 3000x3000
         */

        Image {
            id: bg
            source: dataset.item.backgroundImage
            sourceSize.width: width
            sourceSize.height: width
            width: 3000 * background.playRatio
            height: width
            anchors.centerIn: parent
        }

        property int playX: (activity.width - playWidth) / 2
        property int playY: (activity.height - playHeight) / 2
        property int playWidth: Math.min(activity.height - (bar.height * 2.2), activity.width)
        property int playHeight: playWidth
        property double playRatio: playWidth / 1000

        focus: true

        signal start
        signal stop
        signal voiceDone

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items

            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property Item main: activity.main
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias progressbar: progressbar
            property alias dataModel: dataModel
            property alias dataset: dataset
            property alias instruction: instruction
            property alias descriptionPanel: descriptionPanel
            property bool hasAudioQuestions: activity.hasAudioQuestions
            property var questionOrder
            property var currentQuestion: items.dataset ? items.dataset.item.tab[items.questionOrder[progressbar.value]] : ""
            property bool bonusPlaying: false
        }

        Loader {
            id: dataset
            asynchronous: false
            onStatusChanged: {
                if (status == Loader.Ready) {
                    // create table of size N filled with numbers from 0 to N
                    items.questionOrder = Array.apply(null, {length: items.dataModel.count}).map(Number.call, Number)
                }
            }
        }

        onStart: {
            activity.audioVoices.done.connect(voiceDone)
            activity.audioEffects.done.connect(voiceDone)
            Activity.start(items, url, numberOfLevels)
            if(activity.needsVoices === true) {
                if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled)
                    background.audioDisabled = true
            }
        }
        onStop: { Activity.stop() }

        Keys.onEscapePressed: {
            descriptionPanel.visible ? descriptionPanel.closeDescriptionPanel() : home()
        }

        onVoiceDone: {
            if(items.bonusPlaying) {
                items.bonusPlaying = false;
                Activity.repeat();
            }
        }

        Repeater {
            id: dataModel
            model: dataset && dataset.item && dataset.item.tab ? dataset.item.tab.length : 0
            AnimalLevels {
                questionId: index
                source: dataset.item.tab[index].image
                x: Math.round(background.playX + background.playWidth * dataset.item.tab[index].x - width / 2)
                y: Math.round(background.playY + background.playHeight * dataset.item.tab[index].y - height / 2)
                width: Math.round(background.playWidth * dataset.item.tab[index].width)
                height: Math.round(background.playHeight * dataset.item.tab[index].height)
                title: dataset.item.tab[index].title
                description: dataset.item.tab[index].text
                imageSource: dataset.item.tab[index].image2
                question: dataset.item.tab[index].text2
                audio: dataset.item.tab[index].audio !== undefined ? dataset.item.tab[index].audio : ""
                Component.onCompleted: {
                    displayDescription.connect(displayDescriptionItem)
                }
            }
        }

        function displayDescriptionItem(animal) {
            descriptionPanel.title = animal.title
            descriptionPanel.description = animal.description
            descriptionPanel.imageSource = animal.imageSource
            descriptionPanel.visible = true
            descriptionPanel.showDescriptionPanel()
        }

        AnimalDescriptionLevels {
            id: descriptionPanel
            width: background.width
            height: background.height - bar.height * 1.2
            z: instruction.z + 1
        }

        Column {
            id: progress
            visible: items.score.currentSubLevel != 1
            anchors.bottom: bar.top
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: progressbar.height
            GCProgressBar {
                id: progressbar
                message: value + "/" + to
            }
        }

        Image {
            id: ok
            visible: progressbar.value === progressbar.to
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: questionText.height * 2
            fillMode: Image.PreserveAspectFit
            anchors.right: progress.left
            anchors.bottom: bar.top
            anchors.margins: 10 * ApplicationInfo.ratio
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.nextLevel()
            }
        }

        Row {
            id: row
            spacing: 10 * ApplicationInfo.ratio
            anchors.fill: parent
            anchors.margins: 10 * ApplicationInfo.ratio
            layoutDirection: leftCol.width === 0 ? Qt.RightToLeft : Qt.LeftToRight
            Column {
                id: leftCol
                spacing: 10 * ApplicationInfo.ratio

                Rectangle {
                    id: instruction
                    width: row.width - rightCol.width - 10 * ApplicationInfo.ratio
                    height: instructionText.height
                    color: "#CCCCCCCC"
                    radius: 10
                    border.width: 3
                    border.color: "black"

                    GCText {
                        id: instructionText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent.Center
                        color: "black"
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: (dataset.item && items.score.currentSubLevel - 1 != items.score.numberOfSubLevels  && items.score.currentSubLevel != 0) ? dataset.item.instructions[items.score.currentSubLevel - 1].text : ""
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: instruction.visible = false
                        enabled: instruction.visible
                    }
                }

                Rectangle {
                    id: question
                    width: row.width - rightCol.width - 10 * ApplicationInfo.ratio
                    height: questionText.height
                    color: '#CCCCCCCC'
                    radius: 10
                    border.width: 3
                    border.color: "black"
                    visible: items.score.currentSubLevel == 3 || (items.score.currentSubLevel == 2 && !items.hasAudioQuestions)
                    GCText {
                        id: questionText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent.Center
                        color: "black"
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: items.currentQuestion ? items.currentQuestion.text2 : ""
                    }
                }
            }

            Column {
                id: rightCol
                spacing: 10 * ApplicationInfo.ratio

                Score {
                    id: score
                    anchors {
                        bottom: undefined
                        right: undefined
                    }
                }

                BarButton {
                    id: repeatItem
                    source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
                    sourceSize.width: 60 * ApplicationInfo.ratio
                    anchors.right: parent.right
                    visible: items.score.currentSubLevel == 2 && activity.hasAudioQuestions //&& ApplicationSettings.isAudioVoicesEnabled
                    onClicked: {
                        if(!items.audioVoices.isPlaying()) {
                            Activity.repeat();
                        }
                    }
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
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }
        Bonus {
            id: bonus
        }

        Loader {
            id: audioNeededDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("This activity requires sound, so it will play some sounds even if the audio voices or effects are disabled in the main configuration.")
                button1Text: qsTr("Quit")
                button2Text: qsTr("Continue")
                onButton1Hit: activity.home();
                onClose: {
                    background.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
