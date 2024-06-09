/* GCompris - Default DataDisplay.qml. Link to DefaultJsonDisplay.
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

DefaultJsonDisplay {
    id: jsonDisplay
    jsonString: (typeof result_data !== 'undefined') ? result_data : "{}"
}
