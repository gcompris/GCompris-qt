/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Ashutosh Singh <ashutoshas2610@gmail.com>
 *
 * Authors:
 *   Ashutosh Singh <ashutoshas2610@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../learn_decimals"
LearnQuantityEditor {
    textActivityData: textActivityData_

    subPrototype: ListModel {
        property bool multiple: true
        // inputType is inserted in the global Component.onCompleted function.
        // We cannot implement "choice" directly as ListElement due to the fact
        // that the values are variables and only static values are accepted
        //ListElement { name: "inputType"; label: qsTr("Input Type"); type: "choice"; def: '["Fixed", "Range"]' }
        ListElement { name: "fixedValue"; label: qsTr("Fixed Number"); type: "boundedDecimal"; def: "0"; decimalRange:'[0,60]'; stepSize: 1; decimals: 0 }
        ListElement { name: "minValue"; label: qsTr("Minimum Value"); type: "boundedDecimal"; def: "0"; decimalRange:'[0,60]'; stepSize: 1; decimals: 0 }
        ListElement { name: "maxValue"; label: qsTr("Maximum Value"); type: "boundedDecimal"; def: "0"; decimalRange:'[0,60]'; stepSize: 1; decimals:0 }
    }
}
