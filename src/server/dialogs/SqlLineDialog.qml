/* GCompris - SqlLineDialog.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import "../singletons"
import "../components"

Popup {
    id: sqlLineDialog
    property string title: qsTr("Line details")
    property var parentModel: null
    property int lineIndex: 0

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ListModel { id: recordModel }
    ListModel { id: dataModel }

    function updateModels() {
        var lineData = parentModel.get(lineIndex)
        if (lineData) {
            recordModel.clear()
            dataModel.clear()
            for (var key in lineData) {
                // when linesModel.dynamicRoles is true, lineData contains an objectName and some functions to avoid
                if (key === "objectName")
                    continue
                if (typeof lineData[key] === "function")
                    continue
                if (key !== "result_data") {
                    recordModel.append({ "name_": Definitions.columnsLabel[key], "value_": String(lineData[key]) })
                } else {
                    var dataObj = JSON.parse(lineData["result_data"])
                    for (var kkey in dataObj) {
                        dataModel.append({ name_: kkey, value_: String(dataObj[kkey]) })
                    }
                }
            }
        }
    }

    onAboutToShow: updateModels()

    background: Rectangle {
        color: Style.selectedPalette.alternateBase
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            horizontalAlignment: Text.AlignHCenter
            text: sqlLineDialog.title
            font.bold: true
            font.pixelSize: 20
            color: Style.selectedPalette.text
        }

        Repeater {
            model: recordModel
            delegate: InformationLine {
                Layout.fillWidth: true
                labelWidth: 150
                infoWidth: 400
                height: 20
                label: name_
                info: value_
            }
        }

        Rectangle {
            Layout.fillWidth: true;
            Layout.preferredHeight: 1;
            color: "black"
            visible: dataModel.count ? true : false
        }

        Repeater {
            model: dataModel
            delegate: InformationLine {
                Layout.fillWidth: true
                labelWidth: 150
                infoWidth: 400
                height: 20
                label: name_
                info: value_
            }
        }

        Rectangle {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
            color: "transparent"
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            ViewButton {
                text: qsTr("<")
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                enabled: sqlLineDialog.lineIndex > 0
                opacity: (sqlLineDialog.lineIndex > 0) ? 1.0 : 0.1
                onClicked: {
                    if (sqlLineDialog.lineIndex > 0) sqlLineDialog.lineIndex--
                    sqlLineDialog.updateModels()
                }
            }

            Text {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                horizontalAlignment: Text.AlignHCenter
                text: sqlLineDialog.parentModel ? String(sqlLineDialog.lineIndex + 1) + " / " + String(sqlLineDialog.parentModel.count) : ""
                font.bold: true
                font.pixelSize: 20
                color: Style.selectedPalette.text
            }

            ViewButton {
                text: qsTr(">")
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                enabled: sqlLineDialog.parentModel ? sqlLineDialog.lineIndex < sqlLineDialog.parentModel.count - 1 : false
                opacity: sqlLineDialog.parentModel ? (sqlLineDialog.lineIndex < sqlLineDialog.parentModel.count - 1) ? 1.0 : 0.1 : 0.1
                onClicked: {
                    if (sqlLineDialog.lineIndex < sqlLineDialog.parentModel.count - 1) lineIndex++
                    updateModels()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 0
            }

            ViewButton {
                text: qsTr("Close")
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                onClicked: sqlLineDialog.close()
            }
        }

        Keys.onReturnPressed: sqlLineDialog.close()
        Keys.onEscapePressed: sqlLineDialog.close()
    }
}
