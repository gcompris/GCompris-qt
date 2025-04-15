/* GCompris - learn_decimals_subtractions.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml.Models
import "../learn_decimals/"

Learn_decimals {
    id: activity
    isSubtractionMode: true

    instructionModel: ListModel {
        ListElement {
            instruction: qsTr("A subtraction with two decimal numbers is displayed. Below it, the first number from the subtraction is represented with bars. One bar represents a full unit, and each square in it represents one tenth of this unit.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial3.qml"
        }
        ListElement {
            instruction: qsTr("Click on the squares to subtract them and display the result of the operation, and click on the OK button to validate your answer.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial4.qml"
        }
        ListElement {
            instruction: qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer.")
            instructionQml: "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial5.qml"
        }
    }
}
