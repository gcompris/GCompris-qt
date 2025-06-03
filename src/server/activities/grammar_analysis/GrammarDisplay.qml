/* GCompris - GrammarDisplay.qml for grammar_analysis
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import "../../singletons"

Flow {
    id: wordsFlow
    required property var jsonData
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 5
    Repeater {
        id: wordRepeater
        model: wordsFlow.jsonData.sentence      // loop on words from the sentence
        delegate: Column {
            id: wordColumn
            required property string modelData
            required property int index
            property var expected: wordsFlow.jsonData.expected
            property var proposal: wordsFlow.jsonData.proposal
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: Style.mediumLineHeight
                font.pixelSize: Style.mediumTextSize
                text: wordColumn.modelData
                color: Style.selectedPalette.text
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: Style.mediumLineHeight
                font.pixelSize: Style.mediumTextSize
                text: wordColumn.proposal[wordColumn.index]
                color: (wordColumn.expected[wordColumn.index] === wordColumn.proposal[wordColumn.index]) ? "green" : "red"
            }
        }
    }
}
