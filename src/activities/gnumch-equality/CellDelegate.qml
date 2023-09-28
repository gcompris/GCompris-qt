/* GCompris - CellDelegate.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "gnumch-equality.js" as Activity

Item {
    property Component delegate: cellDelegate

    Component {
        id: cellDelegate
        Item {
            id: cellRectangle

            property string num1: number1
            property string num2: number2
            property string operator: Activity.operator

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
                color: "#373737"

                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: 28
                maximumLineCount: 1

                text: num1 + operator + num2
            }
        }
    }
}
