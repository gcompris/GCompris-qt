/* GCompris - OrderingNumbersDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Emmanuel Charruau <allon@gcompris.net>
 *
 * Authors:
 *    Emmanuel Charruau <allon@gcompris.net>
 *
 *    SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import core 1.0
import "../../components"
import "../../singletons"
import "../../../core"

Item {
    id: lineItem
    required property var jsonData
    required property bool resultSuccess
    height: details.height + Style.hugeMargins
    width: childrenRect.width + Style.margins

    // Show sort order mode: ascending or descending
    DefaultLabel {
        id: directionText
        width: Style.controlSize
        height: Style.controlSize
        text: lineItem.jsonData.sortDirection === "ascending" ? "<i><b>&gt;</b></i>" : "<i><b>&lt;</b></i>"
        fontSizeMode: Text.Fit
        font.bold: true
        y: details.y
    }

    Column {
        id: details
        x: directionText.width + Style.margins
        y: Style.bigMargins
        spacing: Style.smallMargins
        height: childrenRect.height
        width: childrenRect.width


        // Expected Order
        Row {
            spacing: Style.smallMargins

            DefaultLabel {
                id: expectedLabel
                text: qsTr("Expected: ")
                color: "white"
                width: expectedLabel.implicitWidth + 2 * Style.margins
            }
            Repeater {
                model: lineItem.jsonData.expectedOrder
                delegate: Rectangle {
                    required property var modelData
                    property int digitWidth: Style.bigControlSize * 0.75
                    property int digitHeight: Style.controlSize * 0.75

                    width: digitWidth
                    height: digitHeight

                    color: "#FFFFFF"
                    border.color: "#A1CBD9"
                    border.width: Style.defaultBorderWidth
                    radius: Style.defaultBorderWidth

                    DefaultLabel {
                        text: modelData
                        anchors.centerIn: parent
                        width: parent.width * 0.5
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        color: Style.selectedPalette.text
                    }
                }
            }
        }

        // User answer
        Row {
            spacing: Style.smallMargins

            DefaultLabel {
                id: answeredLabel
                text: qsTr("Answered: ")
                font.bold: true
                color: "white"
                width: answeredLabel.implicitWidth + 2 * Style.margins
            }
            Repeater {
                model: lineItem.jsonData.currentOrder
                delegate: Rectangle {
                    required property var modelData
                    property int digitWidth: Style.bigControlSize * 0.75
                    property int digitHeight: Style.controlSize * 0.75

                    width: digitWidth
                    height: digitHeight

                    color: "#FFFFFF"
                    border.color: "#A1CBD9"
                    border.width: Style.defaultBorderWidth
                    radius: Style.defaultBorderWidth

                    DefaultLabel {
                        text: modelData
                        anchors.centerIn: parent
                        width: parent.width * 0.5
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        color: Style.selectedPalette.text
                    }
                }
            }
        }


    }
}