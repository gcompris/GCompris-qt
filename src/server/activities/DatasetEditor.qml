/* GCompris - DatasetEditor.qml
 *
 * SPDX-FileCopyrightText: 2021-2025 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
/* This is the main editor page. Load specific activity ActivityEditor.qml if found. */
import QtQuick 2.12

import GCompris 1.0
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic
import QtQuick.Layouts

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
    property alias difficulty: cbDifficulty.currentIndex
    property string dataset_Content: ""
    property var currentActivity: null
    property int currentPage: 0

    anchors.centerIn: Overlay.overlay
    width: parent.width
    height: parent.height
    modal: true
    closePolicy: Popup.NoAutoClose

    function openDataEditor(activity, selectedDataset) {
        activityIndex = activity
        currentActivity=  Master.findObjectInModel(Master.allActivitiesModel, function(item) { return item.activity_id === activityIndex })
        if (selectedDataset === undefined) {
            label = qsTr("Create dataset")
            addMode = true
            activity_Name = currentActivity["activity_name"]
            datasetName.text = ""
            dataset_Objective = ""
            cbDifficulty.currentIndex = cbDifficulty.find(1)
            // dataset_Content = `import GCompris 1.0\n\nData {\n    objective: ""\n    difficulty: 1\n    data: []\n}`
            dataset_Content = `[]`
        }
        else {
            label = qsTr("Update dataset")
            addMode = false
            activity_Name = selectedDataset.activity_name
            dataset_Id = selectedDataset.dataset_id
            datasetName.text = selectedDataset.dataset_name
            dataset_Objective = selectedDataset.dataset_objective
            cbDifficulty.currentIndex = cbDifficulty.find(selectedDataset.dataset_difficulty)
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

        var difficulty = cbDifficulty.currentIndex + 1
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
                obj[elt.name] = JSON.parse(elt.def)[0]      // Select first element by default
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
                    if (obj[key] instanceof ListModel) {
                        js += indent.repeat(depth + 2) + `"${key}": ` +  listModelToJson(protoStack, obj[key], depth + 1)
                    } else if (prototype.type === "string_array") {
                        js += indent.repeat(depth + 2) + `"${key}": ` + obj[key] // string_array are deserialized
                    } else if (typeof obj[key] === "boolean") {
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
                if (prototype.type === "string_array") {
                    obj[prototype.name] = JSON.stringify(data[i][prototype.name])                           // string_array are serialized
                } else if (prototype.type === 'model') {
                    obj[prototype.name] = jsonToListModel(protoStack, data[i][prototype.name], depth + 1)   // Nested ListModel
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
        editorLoader.sourceUrl = file.exists(url) ? url : `NoEditor.qml`
    }

    onOpened: {
        datasetName.forceActiveFocus();
    }

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    File { id: file }

    RowLayout {
        id: headLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        ColumnLayout {
            Text {
                id: groupDialogText
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                Layout.topMargin: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                text: label
                font {
                    bold: true
                    pixelSize: 20
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                Text {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 20
                    text: qsTr("Activity name")
                    font.bold: true
                    font {
                        pixelSize: 15
                    }
                }

                Text {
                    id: activityName
                    text: currentActivity ? currentActivity.activity_title : ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    activeFocusOnTab: true
                }
            }

            RowLayout {
                Text {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 20
                    text: qsTr("Dataset name")
                    font.bold: true
                    font {
                        pixelSize: 15
                    }
                }

                UnderlinedTextInput {
                    id: datasetName
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    activeFocusOnTab: true
                }
            }

            RowLayout {
                Text {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 20
                    text: qsTr("Objective")
                    font.bold: true
                    font {
                        pixelSize: 15
                    }
                }

                UnderlinedTextInput {
                    id: datasetObjective
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    activeFocusOnTab: true
                }
            }

            RowLayout {
                Text {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 25
                    text: qsTr("Difficulty")
                    font.bold: true
                    font.pixelSize: 15
                }

                ComboBox {
                    id: cbDifficulty
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25
                    font.pixelSize: 15
                    model: [ 1, 2, 3, 4, 5, 6 ]
                }
            }

        }
    }

    TabBar {
        id: bar
        width: 360
        background: Rectangle { color: "transparent" }
        spacing: 3
        anchors.bottom: headLayout.bottom
        TabButton {
            text: qsTr("Editor")
            background: Rectangle { color: Style.colorButton; radius: 5; border.width: (currentPage === 0) ? 2 : 1}
            onClicked: currentPage = 0
        }
        TabButton {
            text: qsTr("Json")
            background: Rectangle { color: Style.colorButton; radius: 5; border.width: (currentPage === 1) ? 2 : 1 }
            onClicked: {
                if (editorLoader.sourceUrl !== "NoEditor.qml")
                    datasetContent.text = datasetEditor.listModelToJson(editorLoader.item.prototypeStack, editorLoader.item.mainModel)
                currentPage = 1
            }
        }
    }


    StackLayout {
        currentIndex: currentPage
        anchors.top: headLayout.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: okButtons.top
        anchors.margins: 5

        Loader {
            id: editorLoader
            property string sourceUrl: ""
            Layout.fillWidth: true
            Layout.fillHeight: true
            onSourceUrlChanged: {
                setSource(sourceUrl)
                currentPage = (sourceUrl !== "NoEditor.qml") ? 0 : 1
            }
            property string textActivityData_: dataset_Content
        }

        ScrollView {
            id: scrollDatasetContent
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            background: Rectangle { border.width: 1 }       // white background for json editor

            TextArea {
                id: datasetContent
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: dataset_Content
                font.pixelSize: 12
                readOnly: (editorLoader.sourceUrl === "NoEditor.qml") ? false : true
            }
        }
    }

    OkCancelButtons {
        id: okButtons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        onCancelled: datasetEditor.close()
        onValidated:  {
            if (editorLoader.sourceUrl !== "NoEditor.qml")
                datasetContent.text = datasetEditor.listModelToJson(editorLoader.item.prototypeStack, editorLoader.item.mainModel)
            saveDataset()
        }
    }

    // Keys.onEnterPressed: saveDataset()
    // Keys.onReturnPressed: saveDataset()
    // Keys.onEscapePressed: datasetEditor.close()
}
