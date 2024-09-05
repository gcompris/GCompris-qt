/* GCompris - DarkCheckBox.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic
import "../../core"

CheckBox {
    id: checkBox
    width: parent.width

    focusPolicy: Qt.NoFocus

    indicator: Image {
        sourceSize.height: checkBox.height
        anchors.right: checkBox.right
        anchors.margins: items.baseMargins
        source:
        checkBox.checked ? "qrc:/gcompris/src/core/resource/apply_white.svg" :
        "qrc:/gcompris/src/core/resource/cancel_white.svg"
    }
    contentItem: GCText {
        color: items.contentColor
        anchors.right: indicator.left
        anchors.rightMargin: items.baseMargins
        anchors.left: checkBox.left
        anchors.top: undefined
        anchors.bottom: undefined
        anchors.verticalCenter: checkBox.verticalCenter
        height: checkBox.height * 0.5
        width: checkBox.width - indicator.width - items.baseMargins * 2
        text: checkBox.text
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
    }
}
