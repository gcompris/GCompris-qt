/* GCompris - DailyDisplay.qml, empty
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Basic
import "../singletons"

DefaultJsonDisplay {
    id: jsonDisplay
    jsonString: (index >= 0) ? JSON.stringify(resultModel.get(index)) : "{}"
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop
}
