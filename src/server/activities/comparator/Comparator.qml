/* GCompris - DataDisplay.qml for comparator
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick 2.15

import "../../components"

Item {
    id: lineView
    required property var jsonData
    property int labelWidth: 130        // used by InformationLine
    height: details.height

    Column {
        id: details
        Repeater {
            model: lineView.jsonData.results
            InformationLine {
                required property var modelData
                label: qsTr("Result")
                info: modelData.leftNumber + " " + modelData.operator + " " + modelData.rightNumber
                textColor: (modelData.correctAnswer) ? "green" : "red"
                infoText.font.bold: true
            }
        }
    }
}
