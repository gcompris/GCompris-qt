/* GCompris - WordAndClass.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

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

Rectangle {
    id: wordClassItem
    property string wordText: ""            // Word, group of word, space or punctuation
    property string expected: ""            // Grammatical(s) class(es) expected
    property string proposition: ""         // Grammatical(s) class(es) proposed by user
    property int startPos: -1               // Number from this position
    property var classList: []              // Splitted expected value
    property bool moveForward: true         // Move to next word after proposal (for keys navigation)
    property alias rowWords: rowWords
    property alias boxModel: boxModel

    color: "transparent"
    radius: 5
    width: Math.max(textView.width, rowWords.width) + 2
    height: textView.height + rowWords.height + 15

    // Set proposal for grammatical class number idx
    function setProposal(idx, forward = true) {
        if (expected === "") return
        if (items.selectedClass === -1) return
        moveForward = forward
        Activity.animRunning = true
        rowWords.children[idx].imgSvg.state = "vanish"
        var proposal = items.goalModel.get(items.selectedClass).code
        if (proposal !== "eraser") {
            items.rowGoalTokens.children[items.selectedClass].imgSvg.state = "moveto"
            buildProposition()
        }
    }

    // Transition is finished. It time to set proposal and image.
    function endProposal(idx) {
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
        text: expected
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        opacity: 0.5
        visible: (expected !== "") && (items.debugActive)
    }
    //--- End of debugging zone.

    Column {
        anchors.fill: parent
        spacing: 3
        Rectangle {
            color: "transparent"
            width: Math.max(textView.width, rowWords.width)
            height: textView.height
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 5
            GCText {        // Word display
                id: textView
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fontSize: regularSize
                text: wordText
            }
        }
        Row {               // Row of grammar classes (boxes for tokens)
            id: rowWords
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            layoutDirection: (Core.isLeftToRightLocale(items.locale)) ? Qt.LeftToRight : Qt.RightToLeft
            Repeater {
                model: boxModel
                Rectangle {
                    id: token
                    property int order: order_
                    property alias imgSvg: imgSvg
                    property bool boxExpected: boxExpected_
                    width: imgSvg.width + 10
                    height: imgSvg.height + 10
                    radius: 5
                    color: "transparent"
                    border.color: boxExpected ? "burlywood" : "transparent"
                    border.width: (order === items.selectedBox)  ? 4 : 1
                    visible: (expected !== "")
                    Rectangle {     // Draw a line under non expected classes in merged classes
                        height: 2
                        width: parent.width
                        anchors.bottom: parent.bottom
                        border.color: "burlywood"
                        border.width: 1
                        visible: !token.boxExpected
                    }

                    Image {         //
                        id: imgSvg
                        source: (svgSource == "") ? "qrc:/gcompris/src/core/resource/empty.svg" : svgSource
                        width: (expected == "") ? 10 : Activity.svgSize
                        height: Activity.svgSize
                        anchors.centerIn: parent
                        states: [
                            State {
                                name: ""
                                PropertyChanges { target: imgSvg; opacity: 1.0 }
                            },
                            State {     // Token vanish when erased or replaced
                                name: "vanish"
                                PropertyChanges { target: imgSvg; opacity: 0.0 }
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
                                        duration: items.animDuration
                                    }
                                    ScriptAction {
                                        script: {
                                            var pos = items.boxIndexes[items.selectedBox].split('-')
                                            items.flow.children[pos[0]].endProposal(pos[1])
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
                        enabled: (order !== -1)
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
        if (wordText.trim() !== wordText.replace(/\s+/,''))             // Check for spaces between words (it was parentheses)
            wordText = "<u>" + wordText + "</u>"
    }
}
