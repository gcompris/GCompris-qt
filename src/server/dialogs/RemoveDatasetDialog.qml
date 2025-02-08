/* GCompris - RemoveDatasetDialog.qml
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
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12

import "../singletons"
import "../components"

Popup {
    id: removeDatasetDialog

    property string datasetName
    property int datasetId
    property int activityId

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    signal datasetRemoved()

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    function validateDialog() {
        Master.deleteDataset(removeDatasetDialog.datasetId)
        Master.filterDatasets(activityId, false)
        datasetRemoved()
    }

    onAboutToShow: {
        for(var i = 0 ; i < Master.filteredDatasetModel.count ; i ++) {
            var dataset = Master.filteredDatasetModel.get(i)
            if (dataset.dataset_checked === true) {
                datasetId = dataset.dataset_id
                datasetName = dataset.dataset_name
                activityId = dataset.activity_id
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            id: deleteDatasetText
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            Layout.preferredWidth: parent.width * 2/3
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Are you sure you want to remove the following dataset from the database?")
            font {
                bold: true
                pixelSize: 20
            }
        }

        Rectangle {
            id: datasetsNamesTextRectangle
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: "gray"
            border.width: 1

            Text {
                text: removeDatasetDialog.datasetName
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        OkCancelButtons {
            onCancelled: removeDatasetDialog.close()
            onValidated: {
                removeDatasetDialog.validateDialog()
                removeDatasetDialog.close()
            }
        }
    }
}
