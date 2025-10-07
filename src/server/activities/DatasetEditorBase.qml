/* GCompris - DatasetEditorBase.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

/**
* Common data for all editors.
*/
Item {
    required property string teacherInstructions

    function validateDataset() {
        return true;
    }
}
