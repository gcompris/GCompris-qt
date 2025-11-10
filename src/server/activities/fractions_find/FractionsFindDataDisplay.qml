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

        Item {
            width: lineItem.width / 3
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            DefaultLabel {
                id: expectedLine
                text: qsTr("Expected:")
                anchors.verticalCenter: parent.verticalCenter
            }
            DefaultLabel {
                id: expectedNumerator
                text: lineItem.jsonData.numeratorToFind
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: expectedFractionBar.bottom
                anchors.bottomMargin: Style.margins
            }
            Rectangle {
                id: expectedFractionBar
                width: expectedNumerator.width * 2
                height: Style.defaultBorderWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            DefaultLabel {
                id: expectedDenominator
                text: lineItem.jsonData.denominatorToFind
                height: expectedNumerator.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: expectedFractionBar.bottom
                anchors.topMargin: Style.margins
            }
        }
        Item {
            width: lineItem.width / 3
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            DefaultLabel {
                id: actualLine
                text: qsTr("Actual:")
                anchors.verticalCenter: parent.verticalCenter
            }
            DefaultLabel {
                id: actualNumerator
                text: lineItem.jsonData.numeratorValue
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: actualSeparator.bottom
                anchors.bottomMargin: Style.margins
           }
            Rectangle {
                id: actualSeparator
                width: actualNumerator.width * 2
                height: Style.defaultBorderWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            DefaultLabel {
                id: actualDenominator
                text: lineItem.jsonData.denominatorValue
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: actualSeparator.bottom
                anchors.topMargin: Style.margins
            }
        }
    }
}
