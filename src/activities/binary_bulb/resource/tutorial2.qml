/* GCompris - tutorial2.qml
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0 

import "../../../core"

Rectangle {
    anchors.fill: parent
    color: "#80FFFFFF"
    
    Image {
        id: transistorImage
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            bottom: parent.verticalCenter
            margins: GCStyle.baseMargins
        }
        source: "transistor.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.height: height
    }

    GCText {
        id: leftText
        anchors {
            left: parent.left
            bottom: parent.bottom
            top: transistorImage.bottom
            margins: GCStyle.baseMargins
        }
        width: (parent.width - 4 * GCStyle.baseMargins) * 0.25
        text: "0"
        fontSize: 48
        fontSizeMode: Text.Fit
        color: GCStyle.darkerText
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    GCText {
        id: rightText
        anchors {
            right: parent.right
            bottom: parent.bottom
            top: transistorImage.bottom
            margins: GCStyle.baseMargins
        }
        width: leftText.width
        text: "1"
        fontSize: 48
        fontSizeMode: Text.Fit
        color: GCStyle.darkerText
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}
