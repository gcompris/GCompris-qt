/* GCompris - ResultIndicator.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

IconHolder {
    id: resultIndicator
    anchors.verticalCenter: parent.verticalCenter
    height: Style.lineHeight - Style.smallMargins
    width: height
    icon.source: resultSuccess ? "qrc:/gcompris/src/server/resource/icons/check-good.svg" :
        "qrc:/gcompris/src/server/resource/icons/check-bad.svg"

    required property bool resultSuccess
}
