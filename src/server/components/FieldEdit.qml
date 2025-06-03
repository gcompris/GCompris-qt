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
    property string value
    property var jsonValue: ({})
    property string choiceDefault: ""   // Default value set for choiceInput, comboInput
    property bool readOnly: false       // true for type model. Value is set by aModel.count

    Layout.fillWidth: true
    Layout.preferredHeight: 22
    Layout.margins: 3

    ListModel { id: arrayModel }        // Internal model for choiceInput, comboInput and stringsInput's popup

    // Returns the appropriate component according to proto.type
    function getComponent() {
        // console.warn(name, proto.type)
        switch (proto.type) {
        case "model":                                           // value is the number of elements of the sub model
            value = Qt.binding(function() { return aModel.get(modelIndex)[proto.name].count }) // Bind to be aware of aModel.count change
            readOnly = true
            return textInput
        case "string_array":                                    // value is a stringified array of elements
            value = aModel.get(modelIndex)[proto.name]
            jsonValue = JSON.parse(value)
            return stringsInput
        case "choice":
            value = proto.def                                   // value contains default values for choiceInput
            choiceDefault = aModel.get(modelIndex)[proto.name]  // current value in model
            stringToArrayModel()
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
        for (var i = 0; i < arrayModel.count; i++)
            if (arrayModel.get(i).content !== "")               // Don't save empty strings
                arr.push(arrayModel.get(i).content)
        jsonValue = arr
        value = JSON.stringify(arr)
        aModel.setProperty(modelIndex, proto.name, value)
    }

    // Build jsonValue and arrayModel from value
    function stringToArrayModel() {
        jsonValue = JSON.parse(value)
        arrayModel.clear()
        jsonValue.forEach((element, index) => { arrayModel.append({ "content" : element}) })
    }

    // Build arrayModel from range values
    function stringToRange() {
        jsonValue = JSON.parse(value)
        arrayModel.clear()
        var start = Number(jsonValue[0])
        var end = Number(jsonValue[1])
        for (var i= start; i <= end; i++)
            arrayModel.append({ "content" : String(i)})
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
            onTextChanged: if (enabled) aModel.setProperty(modelIndex, proto.name, text)
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
                onClicked: (button) => aModel.setProperty(modelIndex, proto.name, button.text)
            }
            Row {
                id: rowChoice
                Repeater {
                    id: rowRepeater
                    model: arrayModel
                    StyledCheckBox {
                        height: fieldEdit.height
                        scale: 0.75
                        ButtonGroup.group: choiceButtonGroup
                        text: content
                        checked: content === choiceDefault
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
                model: arrayModel
                onCurrentTextChanged: aModel.setProperty(modelIndex, proto.name, currentText)
                currentIndex: Master.findIndexInModel(arrayModel, function(item) { return item.content === choiceDefault })
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
                    enabled: (arrayModel.count < 11)
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Add to end")
                    onClicked: arrayModel.append({ "content": "" })
                }

                SmallButton {
                    height: fieldEdit.height
                    text: "\uf068"
                    enabled: (arrayModel.count > 0)
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Remove last")
                    onClicked: arrayModel.remove(arrayModel.count - 1)
                }

                Item { Layout.fillWidth: true }

                SmallButton {
                    id: cancelButton
                    height: fieldEdit.height
                    Layout.preferredWidth: 100
                    text: "Cancel"
                    onClicked: {
                        fieldEdit.forceActiveFocus()    // Restore focus before closing popup
                        stringsPopup.close()
                    }
                }

                SmallButton {
                    id: okButton
                    height: fieldEdit.height
                    Layout.preferredWidth: 100
                    text: "OK"
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
                        model: arrayModel
                        UnderlinedTextInput {
                            width: parent.width
                            height: fieldEdit.height
                            activeFocusOnTab: true
                            text: content
                            onTextChanged: arrayModel.setProperty(index, "content", text)
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
