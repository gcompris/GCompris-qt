/* GCompris - quiz.js
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
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var quizItems
var wordList
var remainingWords
var mode

// @return true if the quiz was ran
function init(loadedItems_, wordList_, mode_) {
    quizItems = loadedItems_
    wordList = wordList_
    mode = mode_

    quizItems.score.numberOfSubLevels = wordList.length

    if(mode == 3) {
        quizItems.imageFrame.visible = false
        // Remove words for which we don't have voice
        for (var j = 0; j < wordList.length ; j++) {
            if(!wordList[j].hasVoice) {
                wordList.splice(j, 1)
                j--;
            }
        }
    } else {
        quizItems.imageFrame.visible = true
    }

    // Bails out if we don't have enough words to play
    if(wordList.length < 2) {
        return false
    }

    quizItems.wordListView.forceActiveFocus()
    remainingWords = Core.shuffle(wordList).slice()
    nextQuiz();
    return true
}

function nextQuiz() {

    quizItems.score.currentSubLevel = quizItems.score.numberOfSubLevels - remainingWords.length + 1

    quizItems.goodWord = remainingWords.pop()

    var selectedWords = []
    selectedWords.push(quizItems.goodWord)

    // Pick 3 wrong words to complete the quiz
    for (var i = 0; i < wordList.length; i++) {
        if(wordList[i] !== quizItems.goodWord) {
            selectedWords.push(wordList[i])
        }
        if(selectedWords.length > 4)
            break
    }

    // Push the result in the model
    selectedWords = Core.shuffle(selectedWords);
    quizItems.wordListModel.clear();
    quizItems.wordListModel.append(selectedWords)

    quizItems.wordImage.changeSource(quizItems.goodWord.image)
    quizItems.buttonsBlocked = false
}

function nextSubLevelQuiz() {
    if(remainingWords.length === 0) {
        quizItems.bonus.good("smiley")
    } else {
        nextQuiz();
    }
}
