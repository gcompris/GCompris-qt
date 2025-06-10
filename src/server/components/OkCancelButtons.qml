/* GCompris - OkCancelButton.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
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

    signal cancelled()
    signal validated()

    ViewButton {
        id: cancelButton
        text: okCancelButtons.cancelText
        onClicked: okCancelButtons.cancelled()
    }
    ViewButton {
        id: okButton
        text: okCancelButtons.okText
        onClicked: okCancelButtons.validated()
    }
}
