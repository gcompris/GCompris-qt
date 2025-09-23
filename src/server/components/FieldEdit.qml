/* GCompris - FieldEdit.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import "../singletons"

Item  {
    id: fieldEdit

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

    Layout.fillWidth: true
    Layout.preferredHeight: 22
    Layout.margins: 3

    ListModel { id: arrayModel }        // Internal model for choiceInput
    ListModel { id: stringModel }        // Internal model for stringsInput's popup and comboInput popup

    // Returns the appropriate component according to proto.type
    function getComponent() {

        switch (proto.type) {
        case "model":                                           // value is the number of elements of the sub model
            value = Qt.binding(function() { return aModel.get(modelIndex)[proto.name].count }) // Bind to be aware of aModel.count change
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
            width: 350
            height: fieldEdit.height
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
            Layout.fillWidth: false
            Layout.preferredWidth: 350
            Layout.preferredHeight: fieldEdit.height

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
            width: 15
            height: fieldEdit.height
            scale: 0.7
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
                height: fieldEdit.height
                text: "\uf044"
                onClicked: stringsPopup.open()
            }
            UnderlinedTextInput {
                id: inputField
                width: 350
                height: fieldEdit.height
                activeFocusOnTab: true
                text: (typeof value === "undefined") ? "?" : jsonValue.toString()
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
            height: fieldEdit.height
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
                        height: fieldEdit.height
                        scale: 0.75
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
        Item {
            height: fieldEdit.height
            width: childrenRect.width
            ComboBox {
                width: 200
                height: fieldEdit.height
                font.pixelSize: Style.textSize
                model: stringModel
                onCurrentTextChanged: aModel.setProperty(modelIndex, proto.name, currentText)
                currentIndex: Master.findIndexInModel(stringModel, function(item) { return item.content === choiceDefault })
                Component.onCompleted: if (choiceDefault === value) // if choiceDefault contains default values, it hasn't been initialized
                                           currentIndex = 0

            }
        }
    }

    // Popup window for string_array edition
    Popup {
        id: stringsPopup
        width: 420
        height: 350
        anchors.centerIn: Overlay.overlay
        clip: true
        modal: true
        closePolicy: Popup.NoAutoClose
        focus: true

        onOpened: stringToArrayModel()

        background: Rectangle {
            color: Style.selectedPalette.alternateBase
            radius: 5
            border.color: "darkgray"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 5
            Text {
                // width: parent.width
                height: fieldEdit.height
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: proto.label
            }

            RowLayout {
                // width: parent.width
                // width: 400
                Layout.fillWidth: true

                SmallButton {
                    height: fieldEdit.height
                    text: "\uf067"
                    enabled: (stringModel.count < 11)
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Add to end")
                    onClicked: stringModel.append({ "content": "" })
                }

                SmallButton {
                    height: fieldEdit.height
                    text: "\uf068"
                    enabled: (stringModel.count > 0)
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Remove last")
                    onClicked: stringModel.remove(stringModel.count - 1)
                }

                Item { Layout.fillWidth: true }

                SmallButton {
                    id: cancelButton
                    height: fieldEdit.height
                    Layout.preferredWidth: 100
                    text: qsTr("Cancel")
                    onClicked: {
                        fieldEdit.forceActiveFocus()    // Restore focus before closing popup
                        stringsPopup.close()
                    }
                }

                SmallButton {
                    id: okButton
                    height: fieldEdit.height
                    Layout.preferredWidth: 100
                    text: qsTr("Ok")
                    onClicked: {
                        arrayModelToStringArray()
                        fieldEdit.forceActiveFocus()    // Restore focus before closing popup
                        stringsPopup.close()
                    }
                }
            }

            ScrollView {
                id: stringsScroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 2
                clip: true

                ColumnLayout {
                    id: stringsView
                    property int current: -1
                    width: parent.width
                    spacing: 2

                    Repeater {
                        model: stringModel
                        UnderlinedTextInput {
                            width: parent.width
                            height: fieldEdit.height
                            activeFocusOnTab: true
                            text: content
                            onTextChanged: stringModel.setProperty(index, "content", text)
                        }
                    }
                }
            }

            Keys.onReturnPressed: okButton.clicked()
            Keys.onEscapePressed: cancelButton.clicked()
        }
    }

    RowLayout {
        Text {      // Display label
            Layout.preferredWidth: 150
            height: fieldEdit.height
            verticalAlignment: Text.AlignBottom
            text: fieldEdit.proto.label
            font.bold: true
            font.pixelSize: Style.textSize
            color: enabled ? "black" : "gray"
        }

        Loader {
            Component.onCompleted: {                // Load appropriate component
                sourceComponent = getComponent()    // sourceComponent must not be set as a binding to avoid binding loops
            }
        }
    }
}
