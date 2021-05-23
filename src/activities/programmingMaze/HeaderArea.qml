/* GCompris - HeaderArea.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"

Rectangle {
    id: header
    width: background.width * 0.4
    height: background.height / 10
    radius: 8 * ApplicationInfo.ratio
    border.width: 2 * ApplicationInfo.ratio
    border.color: "#a6d8ea"
    color: "#ffffff"
    opacity: headerOpacity

    property real headerOpacity
    property string headerText

    signal clicked

    GCText {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: parent.width
        height: parent.height
        fontSizeMode: Font.DemiBold
        minimumPointSize: 7
        fontSize: mediumSize
        wrapMode: Text.WordWrap
        color: "#2e2f2f"
        text: header.headerText
    }

    MouseArea {
        anchors.fill: parent
        onClicked: header.clicked()
    }
}
