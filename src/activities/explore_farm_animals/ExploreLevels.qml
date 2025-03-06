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
import core 1.0

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
        id: activityBackground
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
            width: 3000 * activityBackground.playRatio
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
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property Item main: activity.main
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias progressbar: progressbar
            property alias errorRectangle: errorRectangle
            property alias dataModel: dataModel
            property alias dataset: dataset
            property alias descriptionPanel: descriptionPanel
            property bool hasAudioQuestions: activity.hasAudioQuestions
            property var questionOrder
            property var currentQuestion: ""
            property alias okButton: okButton
            property bool bonusPlaying: false
            property bool buttonsBlocked: false
            property bool descriptionBonusDone: false
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
            Activity.start(items, url, numberOfLevels)
            if(activity.needsVoices === true) {
                if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled)
                    activityBackground.audioDisabled = true
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

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 3 * GCStyle.baseMargins - score.width
            panelHeight: 50 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: (-score.width - GCStyle.baseMargins) * 0.5
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: (dataset.item && items.score.currentSubLevel - 1 != items.score.numberOfSubLevels  && items.score.currentSubLevel != 0) ? dataset.item.instructions[items.score.currentSubLevel - 1].text : ""
            color: GCStyle.lightBg
            border.color: GCStyle.blueBorder
            border.width: GCStyle.thinBorder
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.mediumSize
        }

        GCTextPanel {
            id: questionPanel
            panelWidth: instructionPanel.panelWidth
            panelHeight: instructionPanel.panelHeight
            anchors.horizontalCenter: instructionPanel.horizontalCenter
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: items.currentQuestion ? items.currentQuestion.text2 : ""
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.mediumSize
            color: GCStyle.lighterBg
            border.color: GCStyle.lightGrayBorder
            visible: items.score.currentSubLevel == 3 || (items.score.currentSubLevel == 2 && !items.hasAudioQuestions)

        }

        Score {
            id: score
            z: 1
            isScoreCounter: false
            anchors {
                bottom: undefined
                right: parent.right
                top: parent.top
                margins: GCStyle.baseMargins
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            width: Math.min(GCStyle.bigButtonHeight, score.width)
            anchors.top: score.bottom
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            visible: items.score.currentSubLevel == 2 && activity.hasAudioQuestions //&& ApplicationSettings.isAudioVoicesEnabled
            onClicked: {
                if(!items.audioVoices.isPlaying()) {
                    Activity.repeat();
                }
            }
        }

        Repeater {
            id: dataModel
            model: dataset && dataset.item && dataset.item.tab ? dataset.item.tab.length : 0
            AnimalLevels {
                questionId: index
                source: dataset.item.tab[index].image
                x: Math.round(activityBackground.playX + activityBackground.playWidth * dataset.item.tab[index].x - width / 2)
                y: Math.round(activityBackground.playY + activityBackground.playHeight * dataset.item.tab[index].y - height / 2)
                width: Math.round(activityBackground.playWidth * dataset.item.tab[index].width)
                height: Math.round(activityBackground.playHeight * dataset.item.tab[index].height)
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
            width: activityBackground.width
            height: activityBackground.height - bar.height * 1.2
            z: instructionPanel.z + 1
        }

        Score {
            id: progressbar
            visible: items.score.currentSubLevel != 1
            anchors.bottom: bar.top
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            onStop: Activity.nextSubSubLevel();
        }

        Image {
            id: okButton
            visible: false
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: GCStyle.bigButtonHeight
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.bottom: progressbar.top
            anchors.margins: GCStyle.baseMargins
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.nextLevel()
            }
        }

        ErrorRectangle {
            id: errorRectangle
            width: 0
            height: 0
            imageSize: GCStyle.smallButtonHeight
            function releaseControls() {
                items.buttonsBlocked = false;
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
            onWin: {
                if(progressbar.visible)
                    Activity.nextLevel();
                else {
                    okButton.visible = true;
                    items.buttonsBlocked = false;
                }
            }
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
                    activityBackground.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
