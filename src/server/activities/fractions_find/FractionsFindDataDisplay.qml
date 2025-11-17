/* GCompris - FractionsFindDataDisplay.qml
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
    id: lineItem
    required property var jsonData
    height: details.height

    Row {
        id: details
        spacing: Style.margins

        DefaultLabel {
            id: expectedLine
            text: qsTr("Expected:")
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            width: childrenRect.width
            height: childrenRect.height
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.smallMargins

            DefaultLabel {
                id: expectedNumerator
                text: lineItem.jsonData.numeratorToFind
                anchors.horizontalCenter: expectedFractionBar.horizontalCenter
            }
            Rectangle {
                id: expectedFractionBar
                width: Math.max(expectedNumerator.width, expectedDenominator.width) + Style.bigMargins
                height: Style.defaultBorderWidth
            }
            DefaultLabel {
                id: expectedDenominator
                text: lineItem.jsonData.denominatorToFind
                anchors.horizontalCenter: expectedFractionBar.horizontalCenter
            }
        }

        Item {
            width: Style.margins
            height: 1
        }

        DefaultLabel {
            id: actualLine
            text: qsTr("Answer:")
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            width: childrenRect.width
            height: childrenRect.height
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.smallMargins

            DefaultLabel {
                id: actualNumerator
                text: lineItem.jsonData.numeratorValue
                anchors.horizontalCenter: actualSeparator.horizontalCenter
           }
            Rectangle {
                id: actualSeparator
                width: Math.max(actualNumerator.width, actualDenominator.width) + Style.bigMargins
                height: Style.defaultBorderWidth
            }
            DefaultLabel {
                id: actualDenominator
                text: lineItem.jsonData.denominatorValue
                anchors.horizontalCenter: actualSeparator.horizontalCenter
            }
        }
    }
}
