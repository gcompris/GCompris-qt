/* GCompris - CellDelegate.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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

import "../../core"

Item {
    property Component delegate: cellDelegate

    Component {
        id: cellDelegate
        Rectangle {
            id: cellRectangle

            property string num1: number1
            property string num2: number2
            property string operator: activity.operator

            function setText() {
                if (activity.type == "equality" || activity.type == "inequality") {

                } else if (activity.type == "primes" ||
                           activity.type == "factors"||
                           activity.type == "multiples") {
                    num2 = ""
                    operator = ""
                }
            }

            width: grid.cellWidth
            height: grid.cellHeight
            border.color: "black"
            border.width: 2
            radius: 5
            color: "transparent"
            focus: false
            Component.onCompleted: setText()

            GCText {
                id: numberText

                anchors.fill: parent
                anchors.margins: ApplicationInfo.ratio * 5

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                style: Text.Outline
                styleColor: "white"
                visible: show

                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: 28
                maximumLineCount: 1

                text: num1 + operator + num2
            }
        }
    }
}
