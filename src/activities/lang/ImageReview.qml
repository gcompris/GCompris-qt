/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "lang.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: imageReview
    anchors.fill: parent

    property alias category: categoryText.text
    property int wordListIndex // This is the current sub list of words
    property var word: rootItem.opacity == 1 ? items.wordList[wordListIndex][score.currentSubLevel - 1] : undefined
    // miniGames is list of miniGames
    // first element is Activity name,
    // second element is mode of miniGame
    // third element is the qml to load
    property var miniGames: [
        ["QuizActivity", 1, "Quiz.qml"],
        ["QuizActivity", 2, "Quiz.qml"],
        ["QuizActivity", 3, "Quiz.qml"],
        ["SpellActivity", 1, "SpellIt.qml"]
    ]
    property var currentMiniGame
    property var loadedItems
    property bool started: rootItem.opacity == 1

    // Start at last wordListIndex
    function start() {
        initLevel(wordListIndex)
    }

    // Start the image review at wordList sublesson
    function initLevel(wordListIndex_) {
        wordListIndex = wordListIndex_
        score.currentSubLevel = 1
        score.numberOfSubLevels = items.wordList[wordListIndex].length
        focus = true
        forceActiveFocus()
        miniGameLoader.source = ""
        currentMiniGame = -1
        rootItem.opacity = 1
    }

    function restoreMinigameFocus() {
        miniGameLoader.item.restoreFocus();
    }

    function stop() {
        focus = false
        rootItem.opacity = 0
        wordImage.changeSource('')
        wordText.changeText('')
        repeatItem.visible = false
    }

    onWordChanged: {
        if(word) {
            if (Activity.playWord(word.voice)) {
                word['hasVoice'] = true
                repeatItem.visible = true
            } else {
                word['hasVoice'] = false
                repeatItem.visible = false
            }
            wordImage.changeSource(word.image)
            wordText.changeText(word.translatedTxt)
        }
    }

    //    Cheat codes to access mini games directly
    // Note: miniGame 2 (quiz on mode 3) can start only if at least the audio of 2 words
    // have been played on ImageReview step, else it skips to miniGame 3. So make sure
    // to view all the words on first step before loading miniGame 2.
    Keys.onPressed: {
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_1)) {
            initLevel(wordListIndex)
            event.accepted = true
        }
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_2)) {
            startMiniGame(0)
            event.accepted = true
        }
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_3)) {
            startMiniGame(1)
            event.accepted = true
        }
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_4)) {
            startMiniGame(2)
            event.accepted = true
        }
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_5)) {
            startMiniGame(3)
            event.accepted = true
        }
    }

    Keys.onEscapePressed: {
        Activity.launchMenuScreen()
    }

    Keys.onLeftPressed: {
        if( score.currentSubLevel > 1 ) {
            imageReview.prevWord()
            event.accepted = true
        }
    }
    Keys.onRightPressed: {
        imageReview.nextWord()
        event.accepted = true
    }
    Keys.onSpacePressed: {
        imageReview.nextWord()
        event.accepted = true
    }
    Keys.onEnterPressed: {
        imageReview.nextWord()
        event.accepted = true
    }
    Keys.onReturnPressed: {
        imageReview.nextWord()
        event.accepted = true
    }
    Keys.onTabPressed: {
        repeatItem.clicked()
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            Activity.launchMenuScreen()
        }
    }

    Item {
        id: rootItem
        anchors.fill: parent
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: 200 } }

        Rectangle {
            id: categoryTextbg
            parent: rootItem
            width: Math.min(imageFrame.width + 8, imageBg.width * 1.5)
            height: 42 * ApplicationInfo.ratio
            color: "#AAFFFFFF"
            radius: 16
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: rootItem.top
                topMargin: 4 * ApplicationInfo.ratio
            }

            GCText {
                id: categoryText
                fontSizeMode: Text.Fit
                fontSize: mediumSize
                font.weight: Font.DemiBold
                width: parent.width - 8
                height: parent.height - 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                anchors.centerIn: parent
            }
        }

        Item {
            id: imageFrame
            parent: rootItem
            width: (parent.width - previousWordButton.width * 2) * 0.8
            height: (parent.height - categoryTextbg.height - wordTextbg.height - bar.height * 1.1) * 0.8
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: categoryTextbg.bottom
                margins: 10 * ApplicationInfo.ratio
            }
            z: 11

            Rectangle {
                id: imageBg
                color: "#E0E0F7"
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: width * 0.1
                border.color: "#373737"
                border.width: ApplicationInfo.ratio
            }

            Image {
                id: wordImage
                // Images are not svg
                width: imageBg.height * 0.9
                height: width
                anchors.centerIn: parent

                property string nextSource
                function changeSource(nextSource_) {
                    nextSource = nextSource_
                    animImage.restart()
                }

                SequentialAnimation {
                    id: animImage
                    PropertyAnimation {
                        target: wordImage
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    PropertyAction {
                        target: wordImage
                        property: "source"
                        value: wordImage.nextSource
                    }
                    PropertyAnimation {
                        target: wordImage
                        property: "opacity"
                        to: 1
                        duration: 100
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: rootItem.opacity == 1
                    onClicked: Activity.playWord(word.voice)
                }
            }
        }

        Item {
            id: previousButtonArea
            anchors.left: rootItem.left
            anchors.top: imageFrame.top
            anchors.bottom: imageFrame.bottom
            width: (rootItem.width - imageBg.width) * 0.5

            Image {
                id: previousWordButton
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg";
                width: 36 * ApplicationInfo.ratio
                sourceSize.width: width
                visible: score.currentSubLevel > 1 ? true : false
                anchors.centerIn: parent

                MouseArea {
                    anchors.centerIn: parent
                    width: parent.width * 3
                    height: parent.height * 2
                    onClicked: imageReview.prevWord()
                }
            }
        }

        Item {
            id: nextButtonArea
            anchors.right: rootItem.right
            anchors.top: imageFrame.top
            anchors.bottom: imageFrame.bottom
            width: previousButtonArea.width

            Image {
                id: nextWordButton
                source: "qrc:/gcompris/src/core/resource/bar_next.svg";
                width: previousWordButton.width
                sourceSize.width: width
                anchors.centerIn: parent

                MouseArea {
                    anchors.centerIn: parent
                    width: parent.width * 3
                    height: parent.height * 2
                    onClicked: imageReview.nextWord();
                }
            }
        }

        Rectangle {
            id: wordTextbg
            parent: rootItem
            width: Math.min(imageFrame.width + 8, imageBg.width * 2)
            height: 64 * ApplicationInfo.ratio
            color: "#AAFFFFFF"
            radius: 16
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: imageFrame.bottom
                margins: 10 * ApplicationInfo.ratio
            }

            GCText {
                id: wordText
                text: ""
                fontSizeMode: Text.Fit
                fontSize: largeSize
                font.weight: Font.DemiBold
                width: parent.width - 8
                height: parent.height - 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent
                color: "#373737"

                property string nextWord
                function changeText(nextWord_) {
                    nextWord = nextWord_
                    animWord.restart()
                }

                SequentialAnimation {
                    id: animWord
                    PropertyAnimation {
                        target: wordText
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    PropertyAction {
                        target: wordText
                        property: "text"
                        value: wordText.nextWord
                    }
                    PropertyAnimation {
                        target: wordText
                        property: "opacity"
                        to: 1
                        duration: 100
                    }
                }
            }
        }

        BarButton {
            id: repeatItem
            parent: rootItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: Math.min(categoryTextbg.x, 84 * ApplicationInfo.ratio) - 2 * anchors.margins

            z: 12
            anchors {
                top: parent.top
                left: parent.left
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: Activity.playWord(imageReview.word.voice)
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Score {
            id: score
            parent: rootItem
        }
    }
    Loader {
        id: miniGameLoader
        width: parent.width
        height: parent.height
        anchors.fill: parent
        asynchronous: false
    }

    function nextPressed() {
        if(currentMiniGame === 0) {
            nextSubLevel()
        }
    }

    function nextWord() {
        ++score.currentSubLevel;

        if(score.currentSubLevel == score.numberOfSubLevels + 1) {
            nextMiniGame()
        }
    }

    function prevWord() {
        --score.currentSubLevel
    }

    function startMiniGame(miniGameIndex) {
        currentMiniGame = miniGameIndex
        var mode = miniGames[miniGameIndex][1];
        var itemToLoad = miniGames[miniGameIndex][2];

        // Starting a minigame we don't want pending voices to play
        Activity.clearVoiceQueue()

        // preparing the wordList
        var wordList = Core.shuffle(items.wordList[wordListIndex]).slice()

        miniGameLoader.source = itemToLoad;
        var loadedItems = miniGameLoader.item

        rootItem.opacity = 0
        focus = false

        // Initiate the loaded item mini game
        // Some Mini Games may not start because they miss voices
        // In this case we try the next one
        if(!loadedItems.init(loadedItems, wordList, mode))
            nextMiniGame()
    }

    //called by a miniGame when it is won
    function nextMiniGame() {
        if(currentMiniGame < miniGames.length - 1) {
            startMiniGame(++currentMiniGame)
        } else {
            Activity.markProgress()
            if(wordListIndex < items.wordList.length - 1) {
                initLevel(wordListIndex + 1)
            } else {
                Activity.launchMenuScreen()
                miniGameLoader.source = ""
            }
        }
    }
}
