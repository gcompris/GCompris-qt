/* GCompris - ComparatorText.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"

GCText {
    readonly property color selectedColor: "blue"
    readonly property color unselectedColor: "black"

    height: items.sizeOfElement
    width: items.sizeOfElement
    font.bold: currentlySelected === true
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    fontSizeMode: Text.Fit
    color: currentlySelected === true ? selectedColor : unselectedColor
}
