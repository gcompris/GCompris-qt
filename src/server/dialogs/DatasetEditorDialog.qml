/* GCompris - DatasetEditorDialog.qml
 *
 * SPDX-FileCopyrightText: 2021-2025 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
/* This is the main editor page. Load specific activity ActivityEditor.qml if found. */
import QtQuick

import core 1.0
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: datasetEditor
    property string label: "To be set by calling component."
    property bool textInputReadOnly: false
    property int activityIndex
    property bool addMode: true     // modify mode when false
    // Database columns
    property int modelIndex: 0      // index in Master.userModel
    property int dataset_Id: 0
    property string dataset_Name: ""
    property string activity_Name: ""
    property alias dataset_Objective: datasetObjective.text
    property alias difficulty: difficultySelector.currentIndex
    property alias dataset_Content: datasetContent.text
    property var currentActivity: null
    property string currentActivityTitle: currentActivity ? currentActivity.activity_title : ""
    property string noEditorPath: `${Master.activityBaseUrl}/NoEditor.qml`

    parent: Overlay.overlay
    width: Overlay.overlay.width
    height: Overlay.overlay.height
    modal: true
    closePolicy: Popup.NoAutoClose

    function openDataEditor(activity, selectedDataset) {
        activityIndex = activity
        currentActivity = Master.findObjectInModel(Master.allActivitiesModel, function(item) { return item.activity_id === activityIndex })
        if (selectedDataset === undefined) {
            label = qsTr("Create dataset")
            addMode = true
            activity_Name = currentActivity["activity_name"]
            datasetName.text = ""
            dataset_Objective = ""
            difficultySelector.currentIndex = 0 // difficulty 1 by default
            // dataset_Content = `import core 1.0\n\nData {\n    objective: ""\n    difficulty: 1\n    data: []\n}`
            dataset_Content = `[]`
        }
        else {
            label = qsTr("Update dataset")
            addMode = false
            activity_Name = selectedDataset.activity_name
            dataset_Id = selectedDataset.dataset_id
            datasetName.text = selectedDataset.dataset_name
            dataset_Objective = selectedDataset.dataset_objective
            difficultySelector.currentIndex = selectedDataset.dataset_difficulty - 1 // index is difficulty - 1
            dataset_Content = selectedDataset.dataset_content
        }
        open()
    }

    function saveDataset() {
        if (datasetName.text === "") {
            errorDialog.message = [ qsTr("Dataset name is empty") ]
            errorDialog.open()
            return
        }

        var difficulty = difficultySelector.currentIndex + 1
        if (difficulty < 1 || difficulty > 6) {
            errorDialog.message = [ qsTr("Difficulty should be between 1 and 6") ]
            errorDialog.open()
            return
        }

        if (addMode) {
            // Add the dataset to database
            dataset_Id = Master.createDataset(datasetName.text, activityIndex, datasetObjective.text, difficulty, datasetContent.text)
            if (dataset_Id !== -1)
                datasetEditor.close()
        } else {
            if (Master.updateDataset(dataset_Id, datasetName.text, datasetObjective.text, difficulty, datasetContent.text))
                datasetEditor.close();
        }
    }

    // Create empty object with default values according to prototype. To be added in a ListModel
    function createFromPrototype(aPrototype) {
        var obj = {}
        for (var i = 0; i < aPrototype.count; i++) {
            var elt = aPrototype.get(i)
            switch (elt.type) {
            case "boolean":
                obj[elt.name] = (elt.def === "true")
                break
            case "string":
                obj[elt.name] = elt.def
                break
            case "model":
                obj[elt.name] = Qt.createQmlObject(`import QtQuick\nListModel {}`, datasetEditor)
                break
            case "string_array":
                obj[elt.name] = elt.def
                break
            case "choice":
                obj[elt.name] = elt.values.get(0)["datasetValue"]      // Select first element by default
                break
            default:
                obj[elt.name] = elt.def
                break
            }
        }
        return obj
    }

    // Convert nested ListModels from aModel into a json string. According to prototypes found in stack for each depth
    // Prototype is used for string_array type special processing
    function listModelToJson(protoStack, aModel, depth = 0) {
        var js = ""
        var indent = "    "
        if ((aModel instanceof ListModel) || (typeof aModel === "object")) {
            js += " [\n"
            for (var i = 0; i < aModel.count; i++) {
                js += indent.repeat(depth + 1) + "{\n"
                var obj = aModel.get(i)
                for (var key in obj) {
                    var prototype = Master.findObjectInModel(protoStack[depth], function(item) { return item.name === key })
                    if (prototype.type === "choice") {
                        js += indent.repeat(depth + 2) + `"${key}": "${obj[key]}"`
                    } else if (obj[key] instanceof ListModel) {
                        js += indent.repeat(depth + 2) + `"${key}": ` +  listModelToJson(protoStack, obj[key], depth + 1)
                    } else if (prototype.type === "number_array") {
                        // We convert all string elements to numbers
                        var result = JSON.stringify(JSON.parse(obj[key]).map(Number));
                        js += indent.repeat(depth + 2) + `"${key}": ` + result
                    } else if (prototype.type === "string_array") {
                        js += indent.repeat(depth + 2) + `"${key}": ` + obj[key] // string_array are deserialized
                    } else if (typeof obj[key] === "boolean") {
                        js += indent.repeat(depth + 2) + `"${key}": ${obj[key]}`
                    } else if (prototype.type === "boundedDecimal" || prototype.type === "int" || prototype.type === "comboInt" || prototype.type === "real") {
                        js += indent.repeat(depth + 2) + `"${key}": ${obj[key]}`
                    } else {
                        js += indent.repeat(depth + 2) + `"${key}": "${obj[key]}"`
                    }
                    js += ",\n"
                }
                js = js.slice(0, -2)    // Remove last ",\n"
                js += "\n" + indent.repeat(depth + 1) + "},\n"
            }
            if (aModel.count)
                js = js.slice(0, -2)    // Remove last ",\n"
            js += "\n" + indent.repeat(depth) + "]"
        }
        return js
    }

    // Create nested ListModel from javascript array. String arrays are serialized
    // A prototype is used for string_array and array types special processing
    function jsonToListModel(protoStack, data, depth = 0) {
        var model = Qt.createQmlObject(`import QtQuick\nListModel {}`, datasetEditor)
        for (var i = 0; i < data.length; i++) {
            var obj = {}
            for (var j = 0; j < protoStack[depth].count; j++) {
                var prototype = protoStack[depth].get(j)
                if (prototype.type === "choice") {
                    obj[prototype.name] = data[i][prototype.name]
                } else if (prototype.type === "number_array") {
                    var result = JSON.parse(`[${data[i][prototype.name]}]`).map(String);
                    obj[prototype.name] = JSON.stringify(result)                           // string_array are serialized
                } else if (prototype.type === "string_array") {
                    obj[prototype.name] = JSON.stringify(data[i][prototype.name])                           // string_array are serialized
                } else if (prototype.type === 'model') {
                    obj[prototype.name] = jsonToListModel(protoStack, data[i][prototype.name], depth + 1)   // Nested ListModel
                } else if (prototype.type === "boundedDecimal" || prototype.type === "int" || prototype.type === "comboInt" || prototype.type === "real") {
                    obj[prototype.name] = String(data[i][prototype.name])
                } else if (typeof data[i][prototype.name] !== 'undefined') {
                    obj[prototype.name] = data[i][prototype.name]
                } else {
                    obj[prototype.name] = ""
                }
            }
            model.append(obj)
        }
        return model
    }

    onClosed: {
        editorLoader.sourceUrl = ""     // force next time to reload editor with new textActivityData
        dataset_Content = ""
        if (!addMode)
            Master.filterDatasets(activityIndex, true)
    }

    onAboutToShow: {
        var url = `${Master.activityBaseUrl}/${activity_Name}/ActivityEditor.qml`
        editorLoader.sourceUrl = file.exists(url) ? url : datasetEditor.noEditorPath
    }

    onOpened: {
        datasetName.forceActiveFocus();
    }

    background: Rectangle {
        color: Style.selectedPalette.base
    }

    File { id: file }

    // used for instructions and for invalid dataset warnings
    Popup {
        id: instructionPanel
        anchors.centerIn: Overlay.overlay
        width: parent.width
        height: parent.height
        visible: false
        background: Rectangle {
            color: Style.selectedPalette.base
            radius: Style.defaultRadius
            border.width: Style.defaultBorderWidth
            border.color: Style.selectedPalette.accent
        }
        modal: true

        readonly property string warningText: qsTr("INVALID DATASET")

        function setInstructionText(_isInstructions, _content) {
            if(_isInstructions) {
                instructionTitle.text = datasetEditor.currentActivityTitle;
            } else {
                instructionTitle.text = warningText;
            }
            instructionContent.text = _content;
        }

        onOpened: {
            closePopupButton.forceActiveFocus();
        }

        onClosed: {
            instructionsButton.forceActiveFocus();
        }

        StyledFlickable {
            id: instructionFlickable
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: closePopupButton.top
                bottomMargin: Style.margins
            }

            Item {
                id: instructionTitleItem
                height: Style.lineHeight
                width: instructionFlickable.width
                DefaultLabel {
                    id: instructionTitle
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }

            Text {
                id: instructionContent
                anchors.top: instructionTitleItem.bottom
                anchors.topMargin: Style.margins
                width: instructionFlickable.width - Style.margins
                wrapMode: Text.Wrap
                color: Style.selectedPalette.text
                font.pixelSize: Style.textSize
            }
        }

        OkCancelButtons {
            id: closePopupButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            cancelButton.visible: false
            onValidated: instructionPanel.close();
            focus: true

            Keys.onPressed: (event) => {
                if(event.key == Qt.Key_Enter || event.key == Qt.Key_Return || event.key == Qt.Key_Space || event.key == Qt.Key_Escape) {
                    event.accepted = true;
                    instructionPanel.close();
                }
            }
        }
    }

    Column {
        id: mainColumn
        width: parent.width
        spacing: Style.smallMargins

        Item {
            width: parent.width
            height: Style.lineHeight

            DefaultLabel {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Style.margins
                    verticalCenter: parent.verticalCenter
                }
                height: Style.textSize
                color: Style.selectedPalette.text
                font.bold: true
                text: datasetEditor.label
            }
        }

        Item {
            width: parent.width
            height: infoContentColumn.height

            TabBar {
                id: tabSelector
                background: Item {}
                spacing: Style.margins
                anchors.bottom: parent.bottom

                StyledTabButton {
                    text: qsTr("Editor")
                }
                StyledTabButton {
                    text: qsTr("Raw JSON")
                    onClicked: {
                        if(editorLoader.sourceUrl !== datasetEditor.noEditorPath) {
                            datasetContent.text = datasetEditor.listModelToJson(editorLoader.item.prototypeStack,
                                                      editorLoader.item.mainModel);
                        }
                    }
                }
            }

            Column {
                id: infoLabelColumn
                spacing: Style.smallMargins

                property int maxWidth: mainColumn.width * 0.3

                anchors {
                    left: tabSelector.right
                    margins: Style.margins
                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Activity name")
                        font.bold: true
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Dataset name")
                        font.bold: true
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Goal")
                        font.bold: true
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Difficulty")
                        font.bold: true
                    }
                }
            }

            Column {
                id: infoContentColumn

                anchors {
                    left: infoLabelColumn.right
                    right: parent.right
                    leftMargin: Style.margins
                }
                spacing: Style.smallMargins

                Item {
                    height: Style.lineHeight
                    width: infoContentColumn.width

                    DefaultLabel {
                        width: infoContentColumn.width
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        text: datasetEditor.currentActivityTitle
                    }
                }

                UnderlinedTextInput {
                    id: datasetName
                    width: parent.width
                    activeFocusOnTab: true
                    focus: true
                    defaultText: ""
                    // Prevent specific characters in the filename and only 40 characters max:
                    // <, :, ", /, >, |, ?, *, \, ', [, ], + 
                    validator: RegularExpressionValidator { regularExpression: /^[^<:"\/>|?\*\\'\[\]\+]{0,40}/ }
                }

                UnderlinedTextInput {
                    id: datasetObjective
                    width: parent.width
                    activeFocusOnTab: true
                    focus: true
                    defaultText: ""
                }

                StyledComboBox {
                    id: difficultySelector
                    width: parent.width
                    model: [ 1, 2, 3, 4, 5, 6 ]
                }
            }
        }
    }

    TabContainer {
        currentIndex: tabSelector.currentIndex
        anchors.top: mainColumn.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: okButtons.top
        anchors.topMargin: Style.margins
        anchors.bottomMargin: Style.margins

        Loader {
            id: editorLoader
            property string sourceUrl: ""
            width: parent.width
            height: parent.height
            onSourceUrlChanged: {
                setSource(sourceUrl);
                tabSelector.currentIndex = (sourceUrl !== datasetEditor.noEditorPath) ? 0 : 1;
            }
            property string textActivityData_: dataset_Content
        }


        StyledFlickable {

            TextArea.flickable: TextArea {
                id: datasetContent
                clip: true
                background: Rectangle {
                    color: Style.selectedPalette.alternateBase
                }
                color: Style.selectedPalette.text
                font.pixelSize: Style.textSize
                readOnly: (editorLoader.sourceUrl === datasetEditor.noEditorPath) ? false : true
            }
        }
    }

    ViewButton {
        id: instructionsButton
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: Math.min(defaultWidth, parent.width / 3 - Style.margins)
        text: qsTr("Instructions")
        visible: editorLoader.sourceUrl !== datasetEditor.noEditorPath
        onClicked: {
            if(editorLoader.item.teacherInstructions != "") {
                instructionPanel.setInstructionText(true, editorLoader.item.teacherInstructions);
            } else {
                instructionPanel.setInstructionText(true, qsTr("No specific instructions for this editor."));
            }
            instructionPanel.open();
        }
    }

    OkCancelButtons {
        id: okButtons
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        buttonsWidth: instructionsButton.width
        width: buttonsWidth * 2 + spacing
        onCancelled: datasetEditor.close()
        onValidated:  {
            if(editorLoader.item.validateDataset()) {
                if(editorLoader.sourceUrl !== datasetEditor.noEditorPath) {
                    datasetContent.text = datasetEditor.listModelToJson(editorLoader.item.prototypeStack, editorLoader.item.mainModel);
                }
                saveDataset();
            }
        }
    }

    // Keys.onEnterPressed: saveDataset()
    // Keys.onReturnPressed: saveDataset()
    // Keys.onEscapePressed: datasetEditor.close()
}
