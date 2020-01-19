/* GCompris - HeaderArea.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../core"

Rectangle {
    id: header
    width: background.width * 0.4
    height: background.height / 10
    radius: 8 * ApplicationInfo.ratio
    border.width: 2 * ApplicationInfo.ratio
    border.color: "#a6d8ea"
    color: "#ffffff"
    opacity: headerOpacity

    property real headerOpacity
    property string headerText

    signal clicked

    GCText {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: parent.width
        height: parent.height
        fontSizeMode: Font.DemiBold
        minimumPointSize: 7
        fontSize: mediumSize
        wrapMode: Text.WordWrap
        color: "#2e2f2f"
        text: header.headerText
    }

    MouseArea {
        anchors.fill: parent
        onClicked: header.clicked()
    }
}
