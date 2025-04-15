/* GCompris - learn_quantities.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml.Models
import "../learn_decimals/"

Learn_decimals {
    id: activity
    isQuantityMode: true

    instructionModel: ListModel {
        ListElement {
            instruction: qsTr("A quantity is requested. The arrow allows to select up to 10 oranges.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial1.qml"
        }
        ListElement {
            instruction: qsTr("Drag the arrow to select a number of oranges, and drag the selected oranges to the empty area. Repeat these steps until the number of oranges corresponds to the requested quantity. Then click on the OK button to validate your answer.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial2.qml"
        }
    }
}
