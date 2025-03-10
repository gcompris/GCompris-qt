/* GCompris - WordAndClass.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *   Timothée Giet <animtim@gmail.com> (Graphics and layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12

import core 1.0
import "../../core"
import "grammar_analysis.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * A WordAndClass item display a word and below nothing or one or more grammatical classes symbols.
 * Spaces, punctuation and unwanted words are initialized only with wordText. Other properties are empty.
 * expected contains single class codes or merged (nou, vrb, nou+adj)
 *  if expected is empty, token frame is not displayed and not droppable
 *  else token frame is displayed, token is droppable but an empty (or "_") proposition is expected
 * proposition is made of merged proposals from each individual class
 * boxModel contains boxes for grammatical classes
 */

Item {
    id: wordClassItem
    property string wordText: ""            // Word, group of word, space or punctuation
    property string expected: ""            // Grammatical(s) class(es) expected
    property string proposition: ""         // Grammatical(s) class(es) proposed by user
    property int startPos: -1               // Number from this position
    property list<string> classList: []     // Splitted expected value
    property bool moveForward: true         // Move to next word after proposal (for keys navigation)
    property alias rowWords: rowWords
    property alias boxModel: boxModel
    property bool isSmallHeight: false

    width: Math.max(textView.width, rowWords.width) + GCStyle.tinyMargins
    height: textView.height + rowWords.height + GCStyle.baseMargins

    // Set proposal for grammatical class number idx
    function setProposal(idx: int, forward = true) {
        if (expected === "") return
        if (items.selectedClass === -1) return
        moveForward = forward
        Activity.animRunning = true
        rowWords.children[idx].imgSvg.state = "vanish"
        var proposal = items.goalModel.get(items.selectedClass).code
        if (proposal !== "eraser") {
            items.gridGoalTokens.children[items.selectedClass].imgSvg.state = "moveto"
            buildProposition()
        }
    }

    // Transition is finished. It time to set proposal and image.
    function endProposal(idx: int) {
        rowWords.children[idx].imgSvg.state = ""
        var proposal = items.goalModel.get(items.selectedClass).code
        if (proposal === "eraser") {
            proposal = "_"
            boxModel.set(idx, { "svgSource": "", "proposal": proposal })
        } else {
            boxModel.set(idx, { "svgSource": items.goalModel.get(items.selectedClass).image, "proposal": proposal })
        }
        buildProposition()
        if (moveForward)
            items.selectedBox = (items.selectedBox + 1) % Activity.boxCount
    }

    // Build global proposition with boxModel's proposals
    function buildProposition() {
        var props = []
        for (var i = 0; i < boxModel.count; i++) {
            props.push(boxModel.get(i).proposal)
        }
        proposition = props.join('+')
    }

    ListModel { id: boxModel }

    //--- Debugging zone.
    Rectangle {     // show presence of a word/punctuation/space in debug mode
        width: 2 * parent.width / 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 2
        color: "lightcoral"
        visible: items.debugActive
    }
    Text {          // show expected value
        text: wordClassItem.expected
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        opacity: 0.5
        visible: (wordClassItem.expected !== "") && (items.debugActive)
    }
    //--- End of debugging zone.

    Column {
        anchors.fill: parent
        spacing: GCStyle.tinyMargins
        Item {
            width: Math.max(textView.width, rowWords.width)
            height: textView.contentHeight
            anchors.horizontalCenter: parent.horizontalCenter
            GCText {        // Word display
                id: textView
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fontSize: wordClassItem.isSmallHeight ? tinySize : regularSize
                text: wordClassItem.wordText
            }
        }
        Row {               // Row of grammar classes (boxes for tokens)
            id: rowWords
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: GCStyle.tinyMargins
            layoutDirection: (Core.isLeftToRightLocale(items.locale)) ? Qt.LeftToRight : Qt.RightToLeft
            Repeater {
                model: boxModel
                Rectangle {
                    id: token
                    required property string svgSource
                    required property int order_
                    required property int index
                    required property bool boxExpected_
                    property int order: order_
                    property alias imgSvg: imgSvg
                    property bool boxExpected: boxExpected_
                    width: imgSvg.width + GCStyle.baseMargins
                    height: width
                    radius: GCStyle.tinyMargins
                    color: "transparent"
                    border.color: boxExpected ? GCStyle.blueBorder : "transparent"
                    border.width: (order === items.selectedBox)  ? GCStyle.thickBorder : GCStyle.thinnestBorder
                    visible: (wordClassItem.expected !== "")

                    Image {         //
                        id: imgSvg
                        source: (token.svgSource == "") ? "qrc:/gcompris/src/core/resource/empty.svg" : token.svgSource
                        width: (wordClassItem.expected == "") ? GCStyle.baseMargins : wordsArea.itemHeight
                        height: width
                        sourceSize.width: width
                        sourceSize.height: width
                        anchors.centerIn: parent
                        states: [
                            State {
                                name: ""
                                PropertyChanges { imgSvg { opacity: 1.0 } }
                            },
                            State {     // Token vanish when erased or replaced
                                name: "vanish"
                                PropertyChanges { imgSvg { opacity: 0.0 } }
                            }
                        ]
                        transitions: [
                            Transition {
                                to: "vanish"
                                reversible: false
                                SequentialAnimation {
                                    alwaysRunToEnd: true
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 250
                                    }
                                    ScriptAction {
                                        script: {
                                            var pos = items.boxIndexes[items.selectedBox].split('-')
                                            items.wordsFlow.children[pos[0]].endProposal(pos[1])
                                            Activity.animRunning = false
                                        }
                                    }
                                }
                            }
                        ]
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: (token.order !== -1)
                        onClicked: {
                            if (Activity.animRunning) return            // No click or key or drop during animation
                            items.selectedBox = order
                            items.keysOnTokens = false
                            setProposal(index, false)
                        }
                    }
                    SwingAnimation {
                        running: (!items.keysOnTokens) && (order === items.selectedBox)
                        amplitude: 4
                        loops: 1
                        target: token
                    }
                }
            }
        }
    }
    // Build boxModel from expected
    Component.onCompleted: {
        var prop = "_"
        boxModel.clear()
        classList = expected.split(/\+/)
        var currentOrder = wordClassItem.startPos
        for (var j = 0; j < classList.length; j++) {                    // Loop on merged classes
            var order_ = (classList[j] === "") ? -1 : currentOrder
            boxModel.append(        // Empty values until a GrammarToken is dropped
                        {
                            "svgSource" : "",
                            "proposal" : prop,
                            "boxExpected_": (classList[j] !== ""),
                            "order_": order_
                        })
            if (classList[j] !== "") currentOrder++
        }
        buildProposition()
        var regex = new RegExp(Activity.punctuation, "g"); // Build regular expression with punctuation
        var wordWithoutPunctuation = wordText.replace(regex,' ')  // Punctuation is replaced by spaces
        var wordWithoutPunctuationAndSpaces = wordWithoutPunctuation.replace(/\s+/,'').replace(/\s+/,'')

        if (wordWithoutPunctuation.trim() !== wordWithoutPunctuationAndSpaces)             // Check for spaces between words (it was parentheses).
          // We replace twice, one for the spaces before the word, one for the ones after
            wordText = "<u>" + wordText + "</u>"
    }
}
