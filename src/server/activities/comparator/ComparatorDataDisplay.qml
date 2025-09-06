/* GCompris - ComparatorDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
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
    height: details.height

    Column {
        id: details
        Repeater {
            model: lineView.jsonData.results

            InformationLine {
                required property var modelData
                width: lineView.width
                label: qsTr("Result:")
                info: modelData.leftNumber + " " + modelData.operator + " " + modelData.rightNumber
                showResult: true
                resultSuccess: modelData.correctAnswer
            }
        }
    }
}
