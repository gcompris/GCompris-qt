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

    property string labelText: ""

    indicator: Image {
        sourceSize.height: checkBox.height * 0.8
        anchors.right: checkBox.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: GCStyle.halfMargins
        source: checkBox.checked ? "qrc:/gcompris/src/core/resource/apply_white.svg" :
            "qrc:/gcompris/src/core/resource/cancel_white.svg"
    }
    GCText {
        color: GCStyle.contentColor
        anchors.right: indicator.left
        anchors.rightMargin: GCStyle.halfMargins
        anchors.left: checkBox.left
        anchors.verticalCenter: checkBox.verticalCenter
        height: checkBox.height * 0.5
        text: checkBox.labelText
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
    }
}
