/* GCompris - OkCancelButton.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"

Row {
    id: okCancelButtons
    spacing: Style.margins
    property string okText: qsTr("OK")
    property string cancelText: qsTr("Cancel")
    property alias cancelButton: cancelButton
    property alias okButton: okButton

    property int buttonsWidth: cancelButton.defaultWidth

    property bool cancelButtonEnabled: true
    property bool okButtonEnabled: true

    signal cancelled()
    signal validated()

    ViewButton {
        id: cancelButton
        width: okCancelButtons.buttonsWidth
        text: okCancelButtons.cancelText
        onClicked: okCancelButtons.cancelled()
        enabled: okCancelButtons.cancelButtonEnabled
    }
    ViewButton {
        id: okButton
        width: okCancelButtons.buttonsWidth
        text: okCancelButtons.okText
        onClicked: okCancelButtons.validated()
        enabled: okCancelButtons.okButtonEnabled
    }
}
