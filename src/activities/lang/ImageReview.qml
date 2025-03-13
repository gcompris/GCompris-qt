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
import core 1.0

import "../../core"
import "lang.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: imageReview
    anchors.fill: parent

    property Item bonusItem
    property alias categoryText: categoryTextPanel.textItem
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
        imageReview.bonusItem.haltBonus()
        initLevel(wordListIndex)
    }

    // Start the image review at wordList sublesson
    function initLevel(wordListIndex_: int) {
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
        wordTextPanel.changeText('')
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
            wordTextPanel.changeText(word.translatedTxt)
        }
    }

    //    Cheat codes to access mini games directly
    // Note: miniGame 2 (quiz on mode 3) can start only if at least the audio of 2 words
    // have been played on ImageReview step, else it skips to miniGame 3. So make sure
    // to view all the words on first step before loading miniGame 2.
    Keys.onPressed: (event) => {
        if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_1)) {
            initLevel(wordListIndex)
            event.accepted = true
        } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_2)) {
            startMiniGame(0)
            event.accepted = true
        } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_3)) {
            startMiniGame(1)
            event.accepted = true
        } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_4)) {
            startMiniGame(2)
            event.accepted = true
        } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_5)) {
            startMiniGame(3)
            event.accepted = true
            // end of Cheat codes
        } else if(!started) {
            return;
        } else if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
            Activity.launchMenuScreen()
            event.accepted = true
        } else if(event.key === Qt.Key_Left) {
            if(score.currentSubLevel > 1) {
                imageReview.prevWord()
                event.accepted = true
            }
        } else if(event.key === Qt.Key_Right ||
            event.key === Qt.Key_Space ||
            event.key === Qt.Key_Enter ||
            event.key === Qt.Key_Return) {
            imageReview.nextWord()
            event.accepted = true
        } else if(event.key === Qt.Key_Tab) {
            repeatItem.clicked()
        }
    }


    Item {
        id: rootItem
        anchors.fill: parent
        anchors.margins: GCStyle.baseMargins
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: 200 } }

        GCTextPanel {
            id: categoryTextPanel
            panelWidth: parent.width - 4 * GCStyle.baseMargins - 2 * GCStyle.bigButtonHeight
            panelHeight: Math.min(GCStyle.bigButtonHeight, parent.height * 0.15)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "#aaffffff"
            border.width: 0
            textItem.color: GCStyle.darkText
        }

        Item {
            id: imageFrame
            width: Math.min(categoryTextPanel.panelWidth,
                            parent.height - categoryTextPanel.height - wordTextPanel.height - bar.height * 1.2 - 2 * GCStyle.baseMargins)
            height: width
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: categoryTextPanel.bottom
                margins: GCStyle.baseMargins
            }
            z: 11

            Rectangle {
                id: imageBg
                color: "#E0E0F7"
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
                radius: GCStyle.baseMargins
                border.color: GCStyle.darkBorder
                border.width: GCStyle.thinnestBorder
            }

            Image {
                id: wordImage
                // Images are not svg
                width: imageBg.width - 2 * GCStyle.baseMargins
                height: width
                anchors.centerIn: parent

                property string nextSource
                function changeSource(nextSource_: string) {
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
            anchors.right: imageFrame.left
            anchors.rightMargin: GCStyle.baseMargins

            Image {
                id: previousWordButton
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg";
                width: GCStyle.smallButtonHeight
                sourceSize.width: width
                visible: score.currentSubLevel > 1 ? true : false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                MouseArea {
                    anchors.centerIn: parent
                    enabled: rootItem.opacity == 1
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
            anchors.left: imageFrame.right
            anchors.leftMargin: GCStyle.baseMargins

            Image {
                id: nextWordButton
                source: "qrc:/gcompris/src/core/resource/bar_next.svg";
                width: previousWordButton.width
                sourceSize.width: width
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                MouseArea {
                    anchors.centerIn: parent
                    enabled: rootItem.opacity == 1
                    width: parent.width * 3
                    height: parent.height * 2
                    onClicked: imageReview.nextWord();
                }
            }
        }

        Item {
            id: wordTextArea
            anchors.top: imageFrame.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height * 1.2


            GCTextPanel {
                id: wordTextPanel
                panelWidth: parent.width
                panelHeight: 64 * ApplicationInfo.ratio
                fixedHeight: true
                hideIfEmpty: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: GCStyle.baseMargins
                color: "#aaffffff"
                border.width: 0
                textItem.color: GCStyle.darkText

                property string nextWord
                function changeText(nextWord_: string) {
                    nextWord = nextWord_
                    animWord.restart()
                }

                SequentialAnimation {
                    id: animWord
                    PropertyAnimation {
                        target: wordTextPanel
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    ScriptAction {
                        script: wordTextPanel.textItem.text = wordTextPanel.nextWord
                    }
                    PropertyAnimation {
                        target: wordTextPanel
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
            width: GCStyle.bigButtonHeight
            z: 12
            anchors {
                top: parent.top
                left: parent.left
            }
            onClicked: Activity.playWord(imageReview.word.voice)
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Score {
            id: score
            parent: rootItem
            isScoreCounter: false
        }
    }
    Loader {
        id: miniGameLoader
        anchors.fill: parent
        asynchronous: false
    }

    function nextPressed() {
        if(currentMiniGame === 0) {
            nextSubLevel()
        }
    }

    function nextWord() {
        if(score.currentSubLevel < score.numberOfSubLevels) {
            ++score.currentSubLevel
        } else if(score.currentSubLevel == score.numberOfSubLevels) {
            nextMiniGame()
        }
    }

    function prevWord() {
        --score.currentSubLevel
    }

    function startMiniGame(miniGameIndex: int) {
        currentMiniGame = miniGameIndex
        var mode = miniGames[miniGameIndex][1];
        var itemToLoad = miniGames[miniGameIndex][2];

        // Starting a minigame we don't want pending voices to play
        Activity.clearVoiceQueue()

        // preparing the wordList
        var wordList = Core.shuffle(items.wordList[wordListIndex]).slice()

        miniGameLoader.source = itemToLoad;
        var loadedItems = miniGameLoader.item
        loadedItems.bonus = imageReview.bonusItem

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
