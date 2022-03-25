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
import QtQuick.Controls 2.12
import GCompris 1.0

ProgressBar {
    id: progressbar
    height: progressbarText.height
    width: bar.width

    property bool displayText: true
    property string message

    background: Rectangle {
        height: progressbar.height
        width: progressbar.width
    }
    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Rectangle {
            width: progressbar.visualPosition * parent.width
            height: parent.height
            radius: 2
            color: "lightblue"
        }
        GCText {
            id: progressbarText
            anchors.centerIn: parent
            visible: displayText
            fontSize: mediumSize
            font.bold: true
            color: "black"
            text: progressbar.message
        }
    }
}
