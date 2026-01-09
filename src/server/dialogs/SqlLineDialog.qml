/* GCompris - SqlLineDialog.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
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
import "../components"

Popup {
    id: sqlLineDialog
    property string title: qsTr("Line details")
    property var parentModel: null
    property int lineIndex: 0
    width: 600
    height: 500
    anchors.centerIn: Overlay.overlay
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    onOpened: {
        focusItem.forceActiveFocus();
    }

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
                    recordModel.append({ "name_": Master.columnsLabel[key], "value_": String(lineData[key]) })
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
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    Item {
        id: focusItem
        anchors.fill: parent

        Keys.onReturnPressed: sqlLineDialog.close()
        Keys.onEscapePressed: sqlLineDialog.close()

        DefaultLabel {
            id: title
            width: parent.width
            text: sqlLineDialog.title
            font.bold: true
        }

        Rectangle {
            anchors.fill: scrollLines
            color: Style.selectedPalette.alternateBase
        }

        Flickable {
            id: scrollLines
            width: parent.width
            anchors.top: title.bottom
            anchors.bottom: bottomRow.top
            anchors.margins: Style.margins
            contentWidth: width
            contentHeight: lines.height
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            ScrollBar.vertical: ScrollBar {
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: width
                    visible: scrollLines.contentHeight > scrollLines.height
                    color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                }
            }

            Column {
                id: lines
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Style.margins
                    rightMargin: Style.margins + 10 // 10 for scrollBar area
                }

                Repeater {
                    model: recordModel
                    delegate: InformationMultiLine {
                        width: parent.width
                        label: name_
                        info: value_
                    }
                }

                Rectangle {
                    width: parent.width
                    height: Style.defaultBorderWidth
                    color: Style.selectedPalette.accent
                    visible: dataModel.count ? true : false
                }

                Repeater {
                    model: dataModel
                    delegate: InformationMultiLine {
                        width: parent.width
                        label: name_
                        info: value_
                    }
                }
            }
        }

        Row {
            id: bottomRow
            anchors {
                bottom: parent.bottom
                left: parent.left
            }

            SmallButton {
                icon.source: "qrc:/gcompris/src/server/resource/icons/up.svg"
                rotation: 270
                enabled: sqlLineDialog.lineIndex > 0
                onClicked: {
                    if(sqlLineDialog.lineIndex > 0) {
                        sqlLineDialog.lineIndex--;
                        sqlLineDialog.updateModels();
                    }
                }
            }

            DefaultLabel {
                anchors.verticalCenter: parent.verticalCenter
                width: maxWidthRef.advanceWidth + Style.bigMargins
                text: sqlLineDialog.parentModel ? String(sqlLineDialog.lineIndex + 1) + " / " + String(sqlLineDialog.parentModel.count) : ""
                font.bold: true

                TextMetrics {
                    id: maxWidthRef
                    font.pixelSize: Style.textSize
                    text: sqlLineDialog.parentModel ? String(sqlLineDialog.parentModel.count) + " / " + String(sqlLineDialog.parentModel.count) : ""
                }
            }

            SmallButton {
                icon.source: "qrc:/gcompris/src/server/resource/icons/up.svg"
                rotation: 90
                enabled: sqlLineDialog.parentModel ? sqlLineDialog.lineIndex < sqlLineDialog.parentModel.count - 1 : false
                onClicked: {
                    if(sqlLineDialog.lineIndex < sqlLineDialog.parentModel.count - 1) {
                        lineIndex++;
                        updateModels();
                    }
                }
            }
        }

        SmallButtonText {
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            text: qsTr("Close")
            onClicked: {
                sqlLineDialog.close();
            }
        }
    }
}
