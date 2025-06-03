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
import QtQuick
import core 1.0
import "../../core"

Rectangle {
    id: header
    radius: GCStyle.halfMargins
    border.width: GCStyle.thinBorder
    border.color: "#a6d8ea"
    color: GCStyle.whiteBg
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
        width: parent.width - iconImage.width - GCStyle.baseMargins
        height: parent.height - GCStyle.baseMargins
        font.weight: Font.DemiBold
        minimumPointSize: 7
        fontSize: mediumSize
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        color: GCStyle.darkText
        text: header.headerText
    }

    Image {
        id: iconImage
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: textItem.contentWidth * 0.5
        height: header.headerIcon === "" ? 0 : Math.min(GCStyle.smallButtonHeight, textItem.height)
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
