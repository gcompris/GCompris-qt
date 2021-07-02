/* GCompris - RowRepresent.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

import "../../../core"
import "../"

Item {
    id: rowRepresentation
    visible: background.horizontalLayout
    width: parent.width * 0.6
    height: parent.height * 0.13
    anchors.horizontalCenter: parent.horizontalCenter

    property bool isFirstRow
    property alias model: row.model

    Row {
        id: row
        anchors.fill: parent

        property alias model: rowRepeater.model

        Repeater {
            id: rowRepeater

            Rectangle {
                width: parent.width * 0.1
                height: parent.height
                color: indicateSquareUnitColor()
                border.color: "black"
                border.width: 2

                function indicateSquareUnitColor() {
                    if(tutorialBase.isSubtractionMode && (tutorialBase.isRepresentationShown || index >= 5) && !isFirstRow) {
                      return "transparent";
                    }
                    else {
                      return "#87cefa";
                    }
                }
            }
        }
    }
}
