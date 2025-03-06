/* GCompris - CellDelegate.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"
import "gnumch-equality.js" as Activity

Item {
    id: cellDelegate

    required property string number1
    required property string number2
    required property string operator
    required property bool show

    function setText() {
        if (activity.type == "primes" || activity.type == "factors"|| activity.type == "multiples") {
            number2 = ""
            operator = ""
        }
    }

    focus: false
    Component.onCompleted: setText()

    GCText {
        id: numberText

        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        style: Text.Outline
        styleColor: GCStyle.whiteBorder
        visible: cellDelegate.show
        color: GCStyle.darkText
        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: 28
        maximumLineCount: 1
        text: cellDelegate.number1 + cellDelegate.operator + cellDelegate.number2
    }
}
