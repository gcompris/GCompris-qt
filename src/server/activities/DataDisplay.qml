/* GCompris - Default DataDisplay.qml. Link to DefaultJsonDisplay.
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

DefaultJsonDisplay {
    id: jsonDisplay
    jsonString: (typeof result_data !== 'undefined') ? result_data : "{}"
}
