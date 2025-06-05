/* GCompris - DefaultLabel.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../singletons"

// A text item with default style values.
// Usually one only needs to set its width and/or anchors (to have a defined width at least),
// and change its horizontalAlignment if needed.

Text {
    id: label
    color: Style.selectedPalette.text
    height: Style.textSize
    font.pixelSize: height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    fontSizeMode: Text.FixedSize
    elide: Text.ElideRight
}
