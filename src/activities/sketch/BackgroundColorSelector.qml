/* GCompris - BackgroundColorSelector.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Rectangle {
    id: backgroundSelector
    color: items.panelColor
    visible: false
    z: 1000
    property bool isDialog: true
    signal close
    signal start
    signal stop

    property alias newBackgroundColor: colorSelector.selectedColor

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Space || event.key === Qt.Key_Escape) {
            close();
        }
    }

    onStart: {
        backgroundSelector.forceActiveFocus();
        activity.Keys.enabled = false;
    }

    onClose: {
        activity.Keys.enabled = true;
    }

    GCText {
        id: colorsTitle
        text: qsTr("Background color")
        color: items.contentColor
        height: exitButton.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: exitButton.left
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    ColorSelector {
        id: colorSelector
        anchors.top: exitButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columnWidth: (parent.width - 5 * items.baseMargins) * 0.5
        lineHeight: toolsPanel.settingsLineHeight
        doubleLineHeight: toolsPanel.settingsDoubleLineHeight
        buttonSize: toolsPanel.modeButtonsSize

        palette:
            [Qt.rgba(1, 1, 1, 1), Qt.rgba(0.91, 0.47, 0.21, 1), Qt.rgba(0.91, 0.73, 0.21, 1),
            Qt.rgba(0.46, 0.82, 0.11, 1), Qt.rgba(0.11, 0.82, 0.82, 1), Qt.rgba(0.11, 0.55, 0.82, 1),
            Qt.rgba(0.8, 0.47, 0.84, 1), Qt.rgba(0.88, 0.44, 0.44, 1), Qt.rgba(0, 0, 0, 1)]

        defaultPalette:
            [Qt.rgba(1, 1, 1, 1), Qt.rgba(0.91, 0.47, 0.21, 1), Qt.rgba(0.91, 0.73, 0.21, 1),
            Qt.rgba(0.46, 0.82, 0.11, 1), Qt.rgba(0.11, 0.82, 0.82, 1), Qt.rgba(0.11, 0.55, 0.82, 1),
            Qt.rgba(0.8, 0.47, 0.84, 1), Qt.rgba(0.88, 0.44, 0.44, 1), Qt.rgba(0, 0, 0, 1)]
    }

    GCButtonCancel {
        id: exitButton
        onClose: {
            backgroundSelector.close()
        }
    }
}
