/* GCompris - learn_decimals_addition.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml.Models
import "../learn_decimals/"

Learn_decimals {
    id: activity
    isAdditionMode: true

    instructionModel: ListModel {
        ListElement {
            instruction: qsTr("An addition with two decimal numbers is displayed. The bar with the arrow represents a full unit, and each square in it represents one tenth of this unit.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial6.qml"
        }
        ListElement {
            instruction: qsTr("Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the result of the addition, and click on the OK button to validate your answer.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial7.qml"
        }
        ListElement {
            instruction: qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial8.qml"
        }
    }
}
