/* GCompris - GCProgressBar.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import core 1.0

ProgressBar {
    id: progressbar
    height: progressbarText.height
    width: bar.width

    property bool displayText: true
    property string message
    property int borderSize: GCStyle.thinnestBorder

    background: Rectangle {
        height: progressbar.height
        width: progressbar.width
        color: GCStyle.lightBg
        border.color: GCStyle.whiteBorder
        border.width: borderSize
    }
    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Rectangle {
            x: GCStyle.thinnestBorder
            y: GCStyle.thinnestBorder
            width: progressbar.visualPosition * parent.width - GCStyle.thinnestBorder * 2
            height: parent.height - GCStyle.thinnestBorder * 2
            color: GCStyle.highlightColor
        }
        GCText {
            id: progressbarText
            anchors.centerIn: parent
            visible: displayText
            fontSize: smallSize
            font.bold: true
            color: GCStyle.darkText
            text: progressbar.message
        }
    }
}
