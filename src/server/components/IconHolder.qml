/* GCompris - IconHolder.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

// A disabled button with no background, only used to load icons to be themed automatically with icon.color
Button {
    width: Style.lineHeight
    height: Style.lineHeight
    padding: 0
    icon.height: height
    icon.width: height
    icon.color: Style.selectedPalette.text
    enabled: false
    background: null
}
