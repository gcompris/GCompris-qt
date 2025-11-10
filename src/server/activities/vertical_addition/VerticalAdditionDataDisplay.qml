/* GCompris - VerticalAdditionDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: lineView
    required property var jsonData
    height: details.height + Style.bigMargins

    required property string operator

    Column {
        id: details
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            id: numberRepeater
            model: lineView.jsonData.numbers

            delegate: MathNumber {
                required property int index
                required property var modelData
                numberValue: modelData
                lineIndex: index
                digitCount: modelData.length
                operator: lineView.operator
            }
        }
    }

    Column {
        id: resultDetails
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: details.right
        MathNumber {
            numberValue: lineView.jsonData.resultNumber
            lineIndex: 1 // so we display the operator =
            digitCount: lineView.jsonData.resultNumber.length
            operator: "="
        }
    }
}
