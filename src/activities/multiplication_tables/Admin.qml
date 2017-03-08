/* GCompris - Admin.qml
 *
 * Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
 *
 * Authors:
 *   Nitish Chauhan <nitish.nc18@gmail.com>
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

Flow {

    id: questionItem2
    property string url: "qrc:/gcompris/src/activities/multiplication_tables/resource/"
    property bool checkNOT: false
    property alias selectedQuestionText: checkBoxQuestion.text
    property alias questionChecked: checkBoxQuestion.checked

    CheckBox {
        id:checkBoxQuestion
        text: modelData
        checked: questionItem2.checkNOT

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
