/* GCompris - RemoveDatasetDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: removeDatasetDialog

    property string datasetName
    property int datasetId
    property int activityId

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    signal datasetRemoved()

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
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

    Item {
        id: focusItem
        anchors.fill: parent

        DefaultLabel {
            id: titleText
            width: parent.width
            height: implicitHeight
            font.pixelSize: Style.textSize
            font.bold: true
            wrapMode: Text.WordWrap
            text: qsTr("Are you sure you want to delete the following dataset from the database?")
        }

        Rectangle {
            id: datasetNameBgq
            width: parent.width
            anchors.top: titleText.bottom
            anchors.bottom: bottomButtons.top
            anchors.margins: Style.margins
            color: Style.selectedPalette.alternateBase

            DefaultLabel {
                width: parent.width
                height: implicitHeight
                font.pixelSize: Style.textSize
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                text: removeDatasetDialog.datasetName
            }
        }

        OkCancelButtons {
            id: bottomButtons
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: removeDatasetDialog.close();
            onValidated: {
                removeDatasetDialog.validateDialog();
                removeDatasetDialog.close();
            }
        }

        Keys.onReturnPressed: bottomButtons.validated();
        Keys.onEscapePressed: bottomButtons.cancelled();
    }
}
