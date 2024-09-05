/* GCompris - MenuPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

FoldablePanel {
    id: menuPanel
    handleOffset: 0
    icon1Source: "qrc:/gcompris/src/activities/sketch/resource/filesMenu.svg"
    icon2Source: ""

    onClose: {
        return
    }
}
