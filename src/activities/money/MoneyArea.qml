/* GCompris - MoneyArea.qml
 *
 * Copyright (C) 2018 Smit S. Patil <smit17av@gmial.com>
 *
 * Authors:
 *   Smit S. Patil <smit17av@gmail.com>
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

import "../../core"
import "money.js" as Activity

Rectangle {
    id: moneyAreaBody
    height: (columnLayout.itemHeight + 10) * columnLayout.nbLines
    width: columnLayout.width
    color: "#55333333"
    border.color: "black"
    border.width: 2
    radius: 5

    property alias pocketModel: pocketModel
    property alias answer: pocket
    signal transaction(int index)

    Flow {
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.fill: parent
        spacing: 10

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: parent.width * 0.05
                easing.type: Easing.InOutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                easing.type: Easing.InOutQuad
            }
        }

        Repeater {
            id: pocket
            model: ListModel { id: pocketModel }
            Image {
                source: Activity.url + img
                sourceSize.height: columnLayout.itemHeight
                height: columnLayout.itemHeight

                property bool selected: false

                MultiPointTouchArea {
                    anchors.fill: parent
                    onReleased: moneyAreaBody.transaction(index)
                }

                Rectangle{
                    width: parent.width * 1.1
                    height: parent.height * 1.1
                    color: "#88111111"
                    anchors.centerIn : parent
                    radius: 5
                    visible: selected
                    z: -1
                }
            }
        }
    }
}
