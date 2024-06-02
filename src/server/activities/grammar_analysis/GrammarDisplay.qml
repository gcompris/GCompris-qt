/* GCompris - GrammarDisplay.qml for grammar_analysis
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.15

import "../../singletons"
import "../../components"
import "../../panels"

Flow {
    id: wordsFlow
    property var jsonData: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
    height: childrenRect.height
    spacing: 5
    Repeater {
        model: jsonData.sentence
        delegate: Column {
            property var expected: JSON.parse(result_data).expected
            property var proposal: JSON.parse(result_data).proposal
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 20
                text: modelData
                font.pixelSize: 16
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 20
                text: proposal[index]
                color: (expected[index] === proposal[index]) ? "green" : "red"
                font.pixelSize: 16
            }
        }
    }
}
