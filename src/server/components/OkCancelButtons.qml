/* GCompris - OkCancelButton.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import QtQuick.Controls.Basic
import QtQuick.Layouts 1.2
import "../singletons"
import "../components"

Rectangle {
    id: okCancelButtons
    property string okText: qsTr("OK")
    property string cancelText: qsTr("Cancel")
    property alias cancelButton: cancelButton
    property alias okButton: okButton

    signal cancelled()
    signal validated()

    Layout.fillWidth: true
    height: okButton.height + 5
    color: "transparent"

    Row {
        spacing: 30
        anchors.centerIn: parent
        ViewButton {
            id: cancelButton
            text: cancelText
            onClicked: cancelled()
        }
        ViewButton {
            id: okButton
            text: okText
            onClicked: validated()
        }
    }
}
