/* GCompris - GrammarToken.qml
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

// A GrammarToken item display a symbolic image for grammatical classes and the full class name below
Rectangle {
    id: token
    property string classCode: ""           // Grammatical class code (nou, vrb etc...)
    property string className: ""           // Grammatical class full name (Noun, Verb etc...)
    property string svgName: ""             // Grammatical class svg image
    property alias imgSvg: imgSvg
    width: imgSvg.width + 15
    height: imgSvg.height + txtClass.height +20
    radius: 5
    color: (items.selectedClass === index) ? "burlywood" : "transparent"

    Column {
        anchors.fill: parent
        spacing: 2
        topPadding: 4
        bottomPadding: 4
        Image {     // Display class image
            id: imgSvg
            width: Activity.svgSize
            height: Activity.svgSize
            sourceSize.width: width
            sourceSize.height: height
            x: (parent.width - width) / 2    // x, y are not anchored to be moved by transition
            y: 0
            source: (svgName == "") ? "" : svgName
            states: [
                State {
                    name: "moveto"
                    PropertyChanges {
                        target: imgSvg
                        x: {
                            var pos = items.boxIndexes[items.selectedBox].split('-')
                            return mapFromItem(items.flow.children[pos[0]].rowWords.children[pos[1]].imgSvg, 0, 0).x
                        }
                        y: {
                            var pos = items.boxIndexes[items.selectedBox].split('-')
                            return mapFromItem(items.flow.children[pos[0]].rowWords.children[pos[1]].imgSvg, 0, 0).y
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
                        NumberAnimation { properties: "x,y"; duration: items.animDuration }
                        ScriptAction { script: { imgSvg.state = "" } }
                    }
                }
            ]
        }
        GCText {    // Display class name
            id: txtClass
            width: parent.width
            height: 12
            fontSize: 5
            text: className
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }
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
