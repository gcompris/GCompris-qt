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

        palette: ["#ffffff","#e87836","#e8ba36","#75d11c","#1cd1d1","#1c8cd1","#cc78d6","#e07070","#000000"]
        defaultPalette: ["#ffffff","#e87836","#e8ba36","#75d11c","#1cd1d1","#1c8cd1","#cc78d6","#e07070","#000000"]
    }

    GCButtonCancel {
        id: exitButton
        onClose: {
            backgroundSelector.close();
        }
    }
}
