/* GCompris - Tutorial3.qml
 *
 * SPDX-FileCopyrightText: 2019 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../../core"

Rectangle {
    id: tutorialRectangle
    anchors.fill: parent
    color: "#80FFFFFF"

    GCText {
        id: odd
        text: qsTr("For example: 15, 19, 51, 65, 103, 119, 169, 185, 505, 533, 701, 799, 845, 897, 1001. All of these numbers are odd numbers as they do not leave a remainder of 0 when divided by 2.")
        fontSizeMode: Text.Fit
        fontSize: mediumSize
        anchors.left: tutorialRectangle.left
        anchors.leftMargin: parent.height * 0.01
        color: "black"
        horizontalAlignment: Text.AlignLeft
        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap
        z: 2
    }
}
