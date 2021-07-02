/* GCompris - ColumnRepresent.qml
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
    id: columnRepresentation
    visible: !background.horizontalLayout
    width: parent.width * 0.1
    height: parent.height * 0.8
    anchors.top: parent.top
    anchors.topMargin: 15 * ApplicationInfo.ratio

    property bool isFirstColumn
    property alias model: column.model

    Column {
        id: column
        anchors.fill: parent

        property alias model: columnRepeater.model
        Repeater {
            id: columnRepeater

            Rectangle {
                width: parent.width
                height: parent.height * 0.1
                color: indicateSquareUnitColor()
                border.color: "black"
                border.width: 2

                function indicateSquareUnitColor() {
                    if(tutorialBase.isSubtractionMode && (tutorialBase.isRepresentationShown || index >= 5) && !isFirstColumn) {
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
