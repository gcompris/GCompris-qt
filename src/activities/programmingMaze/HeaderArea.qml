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
import QtQuick 2.12
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
    property string headerIcon: ""

    signal clicked

    GCText {
        id: textItem
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -iconImage.width * 0.5
        width: parent.width - iconImage.width
        height: parent.height
        fontSizeMode: Font.DemiBold
        minimumPointSize: 7
        fontSize: mediumSize
        wrapMode: Text.WordWrap
        color: "#2e2f2f"
        text: header.headerText
    }

    Image {
        id: iconImage
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: textItem.contentWidth * 0.5
        height: header.headerIcon === "" ? 0 : header.height * 0.6
        width: height
        sourceSize.height: height
        source: header.headerIcon === "" ? "qrc:/gcompris/src/core/resource/empty.svg" :
        "qrc:/gcompris/src/activities/programmingMaze/resource/" + header.headerIcon + ".svg"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: header.clicked()
    }
}
