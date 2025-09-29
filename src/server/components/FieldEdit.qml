/* GCompris - FieldEdit.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Item  {
    id: fieldEdit

    property int minWidth: 200
    property int maxWidth: 200 // set this on instances to optimize width, used to calculate maxWidth of Components.

    readonly property int componentMaxWidth: Math.max(200, maxWidth - fieldLabel.width - 2 * Style.margins)

    // required property. Must be assigned at the time of creation
    required property string name

    // Mandatory properties inherited from FieldEdit's parent. Console warnings are triggered if these values are not set
    readonly property ListModel aPrototype: parent.currentPrototype
    readonly property ListModel aModel: parent.currentModel
    readonly property int modelIndex: parent.modelIndex

    // Other properties, initialized with previous properties. Should not be set.
    readonly property var proto: Master.findObjectInModel(aPrototype, function(item) { return item.name === name })
    property var value
    property var jsonValue: ({})
    property string choiceDefault: ""   // Default value set for choiceInput, comboInput
    property bool readOnly: false       // true for type model. Value is set by aModel.count
    property bool acceptChange:true
    signal fieldValueChanged(string fieldName, var newValue, int modelIndex)

    width: childrenRect.width
    height: childrenRect.height

    ListModel { id: arrayModel }        // Internal model for choiceInput
    ListModel { id: stringModel }        // Internal model for stringsInput's popup and comboInput popup

    // Returns the appropriate component according to proto.type
    function getComponent() {

        switch (proto.type) {
        case "model":                                           // value is the number of elements of the sub model
            // Bind to be aware of aModel.count change, with a check to avoid warnings on deletion
            value = Qt.binding(function() { return aModel.get(modelIndex) ? aModel.get(modelIndex)[proto.name].count : null })
            readOnly = true
            return textInput
        case "string_array":                                    // value is a stringified array of elements
            value = aModel.get(modelIndex)[proto.name]
            stringToArrayModel()
            return stringsInput
        case "choice":
            // choice is a ListModel where each element contains
            // a "datasetValue" and a "displayedValue"
            choiceDefault = aModel.get(modelIndex)[proto.name]
            arrayModel.clear()
            for(var i = 0; i < proto["values"].count; ++ i) {
                arrayModel.append(proto["values"].get(i))
            }
            return choiceInput
        case "comboInt":
            value = proto.def                                   // value contains value range for comboInput
            choiceDefault = aModel.get(modelIndex)[proto.name]  // current value in model
            jsonValue = JSON.parse(value)
            stringToRange()
            return comboInput
        case "boolean":
            value = proto.def                                   // value contains boolean
            jsonValue = JSON.parse(value)
            return boolInput
        case "boundedDecimal":
            value = aModel.get(modelIndex)[proto.name]          // value is a decimal number
            parseDecimalConfig()
            return decimalsTextInput
        case "string":
        case "int":
        default:
            value = aModel.get(modelIndex)[proto.name]          // value is a litteral string or int
            return textInput
        }
    }

    // Build jsonValue and value from arrayModel
    function arrayModelToStringArray() {
        var arr = []
        for (var i = 0; i < stringModel.count; i++) {
            if (stringModel.get(i).content !== "") {              // Don't save empty strings
                arr.push(stringModel.get(i).content)
            }
        }
        jsonValue = arr
        value = JSON.stringify(arr)
        aModel.setProperty(modelIndex, proto.name, value)
    }

    // Build jsonValue and arrayModel from value
    function stringToArrayModel() {
        jsonValue = JSON.parse(value)
        stringModel.clear()
        jsonValue.forEach((element, index) => { stringModel.append({ "content" : element}) })
    }

    // Build arrayModel from range values
    function stringToRange() {
        jsonValue = JSON.parse(value)
        stringModel.clear()
        var start = Number(jsonValue[0])
        var end = Number(jsonValue[1])
        for (var i= start; i <= end; i++)
            stringModel.append({ "content" : String(i)})
    }

    function parseDecimalConfig() {
        jsonValue.range = JSON.parse(proto.decimalRange)
        jsonValue.stepSize = parseInt(proto.stepSize)
        jsonValue.decimals = parseInt(proto.decimals)
    }

    // Component for string, int and model.count
    Component {
        id: textInput
        UnderlinedTextInput {
            id: inputField
            width: readOnly ? textInput.contentWidth + 2 * Style.margins : fieldEdit.componentMaxWidth
            activeFocusOnTab: true
            defaultText: (typeof value === "undefined") ? "?" : value
            clip: true
            readOnlyText: readOnly
            enabled: !readOnly
            onTextChanged: {
                if (enabled) aModel.setProperty(modelIndex, proto.name, text) }
        }
    }
    Component {
        id: decimalsTextInput
        SpinBox {
            id: spinBox
            editable: true
            width: 350
            height: fieldEdit.height

            contentItem: TextInput {
                z: 2
                text: spinBox.textFromValue(spinBox.value, spinBox.locale)
                font: spinBox.font
                color: spinBox.palette.text
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                validator: DoubleValidator {
                    bottom: jsonValue.range[0]
                    top: jsonValue.range[1]
                    decimals: jsonValue.decimals
                    notation: DoubleValidator.StandardNotation
                }
            }

            property int decimals: jsonValue.decimals   //how many decimals places we want
            property real realValue: value / Math.pow(10, decimals) // 15-> 1.5
            readonly property int decimalFactor: Math.pow(10, decimals) // 15/decimal factor -> 1.5
            property real prevValue: realValue
            from: jsonValue.range[0] * decimalFactor
            to: jsonValue.range[1]  * decimalFactor
            stepSize: jsonValue.stepSize
            value: fieldEdit.value ? Math.round(parseFloat(fieldEdit.value) * decimalFactor) : 0
            textFromValue: function(value, locale) {
                return Number(value / decimalFactor).toLocaleString(locale, 'f', spinBox.decimals)
            }
            valueFromText: function(text, locale) {
                return Math.round(Number.fromLocaleString(locale, text) * decimalFactor)
            }

            onRealValueChanged: {
                if (aModel && typeof modelIndex !== "undefined") {
                    fieldEdit.fieldValueChanged(proto.name, realValue.toFixed(decimals), modelIndex)

                    //  check if parent accepted the change
                    if (!fieldEdit.acceptChange) {
                        // revert to previous value when acceptChange set to false
                        value = Math.round(prevValue * decimalFactor)
                        return
                    }

                    // change accepted ,update model and store new prevValue
                    aModel.setProperty(modelIndex, proto.name, realValue.toFixed(decimals))
                    prevValue = realValue
                }
            }
        }
    }
    // Component for boolean
    Component {
        id: boolInput
        StyledCheckBox {
            checked: jsonValue
            onCheckedChanged: aModel.setProperty(modelIndex, proto.name, checked)
        }
    }

    // Component for string_array
    Component {
        id: stringsInput
        Row {
            property alias text: inputField.text
            SmallButton {
                id: popupButton
                text: "\uf044"
                onClicked: stringsPopup.open()
            }
            UnderlinedTextInput {
                id: inputField
                width: fieldEdit.componentMaxWidth - popupButton.width
                activeFocusOnTab: true
                defaultText: (typeof value === "undefined") ? "?" : jsonValue.toString()
                clip: true
                readOnlyText: true
                onTextChanged: textInput.select(0,0)    // Scroll text left for long lines
            }
        }
    }

    // Component for choice
    Component {
        id: choiceInput
        Item {
            height: childrenRect.height
            width: childrenRect.width
            ButtonGroup {
                id: choiceButtonGroup
                buttons: rowRepeater.children
                exclusive: true
                onClicked: (button) => aModel.setProperty(modelIndex, proto.name, button.datasetValue)
            }
            Row {
                id: rowChoice
                Repeater {
                    id: rowRepeater
                    model: arrayModel
                    StyledCheckBox {
                        required property string datasetValue
                        required property string displayedValue
                        ButtonGroup.group: choiceButtonGroup
                        text: displayedValue
                        checked: datasetValue === choiceDefault
                    }
                }
            }
        }
    }

    // Component for comboInt
    Component {
        id: comboInput
        StyledComboBox {
            width: 200
            font.pixelSize: Style.textSize
            model: stringModel
            onCurrentTextChanged: aModel.setProperty(modelIndex, proto.name, currentText)
            currentIndex: Master.findIndexInModel(stringModel, function(item) { return item.content === choiceDefault })
            Component.onCompleted: {
                if(choiceDefault === value) { // if choiceDefault contains default values, it hasn't been initialized
                    currentIndex = 0;
                }
            }
        }
    }

    // Popup window for string_array edition
    Popup {
        id: stringsPopup
        width: 500
        height: 600
        anchors.centerIn: Overlay.overlay
        clip: true
        modal: true
        closePolicy: Popup.NoAutoClose
        focus: true

        onOpened: stringToArrayModel()

        background: Rectangle {
            color: Style.selectedPalette.base
            radius: Style.defaultRadius
            border.color: Style.selectedPalette.accent
            border.width: Style.defaultBorderWidth
        }

        Item {
            anchors.fill: parent
            focus: true

            Keys.onReturnPressed: okButtons.validated()
            Keys.onEscapePressed: okButtons.cancelled()

            Column {
                id: topColumn
                width: parent.width
                height: childrenRect.height
                spacing: Style.margins

                Item {
                    height: Style.lineHeight
                    width: parent.width

                    DefaultLabel {
                        anchors.centerIn: parent
                        text: proto.label
                    }
                }

                Row {
                    anchors.left: parent.left

                    SmallButton {
                        text: "\uf067"
                        enabled: (stringModel.count < 11)
                        toolTipOnHover: true
                        toolTipText: qsTr("Add an entry")
                        onClicked: {
                            stringModel.append({ "content": "" });
                            // Give focus to added line
                            stringRepeater.itemAt(stringModel.count - 1).focus = true;
                        }
                    }

                    SmallButton {
                        text: "\uf068"
                        enabled: (stringModel.count > 0)
                        toolTipOnHover: true
                        toolTipText: qsTr("Remove last entry")
                        onClicked: stringModel.remove(stringModel.count - 1)
                    }
                }
            }

            Rectangle {
                id: flickableBg
                color: "#00000000"
                border.color: Style.selectedPalette.accent
                border.width: Style.defaultBorderWidth
                anchors {
                    top: topColumn.bottom
                    bottom: okButtons.top
                    left: parent.left
                    right: parent.right
                    topMargin: Style.margins
                    bottomMargin: Style.margins
                }
            }

            StyledFlickable {
                id: stringsFlickable
                anchors.fill: flickableBg
                anchors.margins: Style.margins
                anchors.rightMargin: 0
                clip: true
                contentWidth: stringsView.width
                contentHeight: stringsView.height

                Column {
                    id: stringsView
                    property int current: -1
                    width: stringsFlickable.width - 10
                    spacing: Style.smallMargins

                    Repeater {
                        id: stringRepeater
                        model: stringModel

                        UnderlinedTextInput {
                            width: parent.width
                            activeFocusOnTab: true
                            defaultText: content
                            onTextChanged: stringModel.setProperty(index, "content", text)
                        }
                    }
                }
            }

            OkCancelButtons {
                id: okButtons
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                }
                buttonsWidth: (width - spacing) * 0.5
                onCancelled: {
                    fieldEdit.forceActiveFocus();    // Restore focus before closing popup
                    stringsPopup.close();
                }
                onValidated:  {
                    arrayModelToStringArray();
                    fieldEdit.forceActiveFocus();    // Restore focus before closing popup
                    stringsPopup.close();
                }
            }
        }
    } // End of PopUp

    // Actual content
    Row {
        height: Style.lineHeight
        width: childrenRect.width
        spacing: Style.margins

        DefaultLabel {      // Display label
            id: fieldLabel
            anchors.verticalCenter: parent.verticalCenter
            text: fieldEdit.proto.label
            opacity: enabled ? 1 : 0.5
        }

        Loader {
            Component.onCompleted: {                // Load appropriate component
                sourceComponent = getComponent()    // sourceComponent must not be set as a binding to avoid binding loops
            }
        }
    }
}
