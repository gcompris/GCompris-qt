/* GCompris - CollapseButton.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../singletons"

SmallButton {
    id: collapseButton
    width: visible ? height : 0
    checkable: true
    checked: true
    icon.source: "qrc:/gcompris/src/server/resource/icons/dark_dropdownArrow.svg"
    rotation: checked ? 0 : 90
}
