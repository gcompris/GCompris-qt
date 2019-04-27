/* GCompris - Tutorial1.qml
 *
 * Copyright (C) 2019 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../../core"

Rectangle {
    id: tutorialRectangle
    anchors.fill: parent
    color: "#80FFFFFF"

    GCText {
        id: remainder
        text: qsTr("The remainder is the amount \"left over\" after dividing the given number with the other number.\n If 6 is divided by 2 the result is 3 and the remainder is 0.\n If 7 is divided by 2 the result is 3 and the remainder is 1.")
        fontSizeMode: Text.Fit
        fontSize: mediumSize
        anchors.left: tutorialRectangle.left
        anchors.leftMargin: parent.height * 0.01
        color: "black"
        horizontalAlignment: Text.AlignLeft
        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap
        z: 2
    }
}
