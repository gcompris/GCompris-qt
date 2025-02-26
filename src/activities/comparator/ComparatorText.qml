/* GCompris - ComparatorText.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"

GCText {
    font.bold: currentlySelected === true
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    fontSizeMode: Text.Fit
    color: GCStyle.darkText
}
