/* GCompris - SqlLineDialog.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12

import "../singletons"
import "../components"

Popup {
    id: viewSqlLineDialog
    property string title: qsTr("Line details")
    property var parentModel: null
    property int lineIndex: 0
    property int labelWidth: 150
    property int infoWidth: 400

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
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            Layout.fillWidth: true
            height: 40
            horizontalAlignment: Text.AlignHCenter
            text: title
            font.bold: true
            font.pixelSize: 20
        }

        Repeater {
            model: recordModel
            delegate: InformationLine {
                Layout.fillWidth: true
                height: 20
                label: name_
                info: value_
            }
        }

        Rectangle {
            Layout.fillWidth: true;
            height: 1;
            color: "black"
            visible: dataModel.count ? true : false
        }

        Repeater {
            model: dataModel
            delegate: InformationLine {
                Layout.fillWidth: true
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
                height: 40
                Layout.alignment: Qt.AlignHCenter
                enabled: lineIndex > 0
                opacity: (lineIndex > 0) ? 1.0 : 0.1
                onClicked: {
                    if (lineIndex > 0) lineIndex--
                    updateModels()
                }
            }

            Text {
                Layout.preferredWidth: 100
                height: 40
                horizontalAlignment: Text.AlignHCenter
                text: parentModel ? String(lineIndex + 1) + " / " + String(parentModel.count) : ""
                font.bold: true
                font.pixelSize: 20
            }

            ViewButton {
                text: qsTr(">")
                Layout.preferredWidth: 100
                height: 40
                Layout.alignment: Qt.AlignHCenter
                enabled: parentModel ? lineIndex < parentModel.count - 1 : false
                opacity: parentModel ? (lineIndex < parentModel.count - 1) ? 1.0 : 0.1 : 0.1
                onClicked: {
                    if (lineIndex < parentModel.count - 1) lineIndex++
                    updateModels()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 0
            }

            ViewButton {
                text: qsTr("Close")
                Layout.preferredWidth: 100
                height: 40
                Layout.alignment: Qt.AlignHCenter
                onClicked: viewSqlLineDialog.close()
            }
        }

        Keys.onReturnPressed: viewSqlLineDialog.close()
        Keys.onEscapePressed: viewSqlLineDialog.close()
    }
}
