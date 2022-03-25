/* GCompris - Tutorial2.qml
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
        id: even
        text: qsTr("For example: 12, 38, 52, 68, 102, 118, 168, 188, 502, 532, 700, 798, 842, 892, 1000. All of these numbers are even numbers as they leave a remainder of 0 when divided by 2.")
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
