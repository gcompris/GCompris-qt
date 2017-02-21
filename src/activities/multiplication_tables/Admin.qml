/* GCompris - Admin.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import "multiplication_tables.js" as Activity
import "multiplicationtables_dataset.js" as Dataset
import "../../core"
import GCompris 1.0

Grid {

    id: admin_id
    spacing : 30
    columns: 10
    property alias checkBoxesRepeater: repeaterCheckBox

    Repeater {

         id : repeaterCheckBox
         model:Activity.allQuestions

    CheckBox {
        id:checkBoxQuestion
        text: modelData
        style: CheckBoxStyle {
            indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 7
                    border.color: control.activeFocus ? "#4f6ac9" : "#2a3b90"
                    border.width: 3
                    Rectangle {
                        visible: control.checked
                        color: "#555"
                        border.color: "#333"
                        radius: 3
                        anchors.margins: 9
                        anchors.fill: parent
                    }
            }
        }
    }
}
}
