/* GCompris - GCCheckButton.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0


Rectangle {
    id: gcCheckButton
    color: "#33ffffff"
    border.color: GCStyle.whiteBorder
    border.width: GCStyle.thinnestBorder

    property bool checked: false
    property alias text: buttonText.text

    signal clicked

    onClicked: {
        checked = !checked;
    }

    Rectangle {
        id: checkBoxBorder
        height: Math.min(parent.height - GCStyle.baseMargins, GCStyle.smallButtonHeight)
        width: height
        radius: height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: GCStyle.halfMargins
        color: "transparent"
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.whiteBorder


        Image {
            source: "qrc:/gcompris/src/core/resource/apply.svg"
            visible: gcCheckButton.checked
            anchors.fill: parent
            anchors.margins: GCStyle.halfMargins
            sourceSize.width: width
            sourceSize.height: height
        }

    }

    GCText {
        id: buttonText
        anchors {
            left: checkBoxBorder.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: GCStyle.baseMargins
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            gcCheckButton.clicked();
        }
    }
}
