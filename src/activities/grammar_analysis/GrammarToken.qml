/* GCompris - GrammarToken.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *   Timothée Giet <animtim@gmail.com> (Graphics and layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import core 1.0
import "../../core"
import "grammar_analysis.js" as Activity

// A GrammarToken item display a symbolic image for grammatical classes and the full class name below
Rectangle {
    id: token
    property string classCode: ""           // Grammatical class code (nou, vrb etc...)
    property string className: ""           // Grammatical class full name (Noun, Verb etc...)
    property string svgName: ""             // Grammatical class svg image
    property alias imgSvg: imgSvg
    width: 1
    height: 1
    radius: GCStyle.tinyMargins
    color: (items.selectedClass === index) ? "#8087A6DD" : "transparent" // "#8087A6DD" is GCStyle.blueBorder with half opacity

    Image {     // Display class image
        id: imgSvg
        width: height
        height: parent.height - txtClass.height - 2 * GCStyle.tinyMargins
        sourceSize.width: height
        sourceSize.height: height
        x: (parent.width - width) * 0.5    // x, y are not anchored to be moved by transition
        y: GCStyle.tinyMargins
        source: (token.svgName == "") ? "" : token.svgName
        states: [
        State {
            name: "moveto"
            PropertyChanges {
                imgSvg {
                    x: {
                        var pos = items.boxIndexes[items.selectedBox].split('-')
                        return mapFromItem(items.wordsFlow.children[pos[0]].rowWords.children[pos[1]].imgSvg, 0, 0).x
                    }
                    y: {
                        var pos = items.boxIndexes[items.selectedBox].split('-')
                        return mapFromItem(items.wordsFlow.children[pos[0]].rowWords.children[pos[1]].imgSvg, 0, 0).y
                    }
                }
            }
        }
        ]

        transitions: [
        Transition {
            to: "moveto"
            reversible: false
            SequentialAnimation {
                alwaysRunToEnd: true
                NumberAnimation { properties: "x,y"; duration: 250 }
                ScriptAction { script: { imgSvg.state = "" } }
            }
        }
        ]
    }
    GCText {    // Display class name
        id: txtClass
        width: parent.width - GCStyle.baseMargins
        height: parent.height * 0.4
        fontSize: smallSize
        minimumPointSize: tinySize
        fontSizeMode: Text.Fit
        text: token.className
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GCStyle.tinyMargins
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.Wrap
    }

    SwingAnimation {
        running: (items.keysOnTokens) && (items.selectedClass === index)
        amplitude: 4
        loops: 1
        target: token
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (Activity.animRunning) return            // No click or key during animation
            items.selectedClass = index
            items.keysOnTokens = true
        }
    }

}
