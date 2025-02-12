/* GCompris - DatasetDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.2

import GCompris 1.0

import "../singletons"
import "../components"

Popup {
    id: datasetDialog

    property string label: "To be modified in calling element."
    property bool textInputReadOnly: false
    property int activityIndex
    property bool addMode: true     // modify mode when false
    // Database columns
    property int modelIndex: 0      // index in Master.userModel
    property int dataset_Id: 0
    property string dataset_Name: ""
    property string dataset_Objective: ""
    property int difficulty: 1
    property string dataset_Content: ""

    anchors.centerIn: Overlay.overlay
    width: parent.width
    height: parent.height
    modal: true
    closePolicy: Popup.CloseOnEscape

    function openDatasetDialog(activity, selectedDataset) {
        if(activity != -1) {
            activityIndex = activity
        }
        else {
            // In case we are editing a dataset without activity selected
            activityIndex = selectedDataset.activity_id
        }
        if(selectedDataset === undefined) {
            addMode = true
        }
        else {
            addMode = false
        }
        editorLoader.item.initialize(selectedDataset);
        open()
    }

    function saveDataset() {
        var data = editorLoader.item.getData();
        if (data.name === "") {
            errorDialog.message = [ qsTr("Dataset name is empty") ]
            errorDialog.open()
            return
        }

        var difficulty = data.difficulty
        if (difficulty < 1 || difficulty > 6) {
            errorDialog.message = [ qsTr("Difficulty should be between 1 and 6") ]
            errorDialog.open()
            return
        }

        if (addMode) {
            // Add to database the user
            dataset_Id = Master.createDataset(data.name, activityIndex, data.objective, difficulty, data.content)
            if (dataset_Id !== -1)
                datasetDialog.close()
        } else {
            if (Master.updateDataset(dataset_Id, data.name, data.objective, difficulty, data.content))
                datasetDialog.close();
        }
    }

    onClosed: Master.filterDatasets(activityIndex, true)

    onOpened: {
        editorLoader.item.forceActiveFocus();
    }

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }
    File { id: file }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Loader {
            id: editorLoader
            anchors.fill: parent
            source: {
                var activity = Master.getActivityName(activityIndex);
                print(activity)
                var url = `${Master.activityBaseUrl}/${activity}/ActivityEditor.qml`
                return file.exists(url) ? url : `${Master.activityBaseUrl}/ActivityEditor.qml`
            }
        }

        OkCancelButtons {
            onCancelled: datasetDialog.close()
            onValidated: saveDataset()
        }

        Keys.onEnterPressed: saveDataset()
        Keys.onReturnPressed: saveDataset()
        Keys.onEscapePressed: datasetDialog.close()
    }
}
