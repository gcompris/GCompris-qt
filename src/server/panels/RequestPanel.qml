/* GCompris - RequestPanel.qml
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
import "qrc:/gcompris/src/server/server.js" as Server

import "../components"
import "../singletons"
import "../dialogs"

Item {
    id: requestPanel
    property string request: ""
    property var wantedColumns: []
    property int count: linesModel.count
    property var actualColumns: []
    property alias linesModel: linesModel
    property bool dynamicRoles: false
    property string sort: ""
    property string order: ""

    ListModel { id: linesModel }

    function executeRequest() {
        sort = order = ""
        linesModel.clear()
        linesModel.dynamicRoles = dynamicRoles          // Important for AllData, model must be dynamic
        actualColumns = []                              // Columns must be hidden while updating model
        if (request !== "") {
            var jsonModel = JSON.parse(databaseController.selectToJson(request))
            for (var i = 0; i < jsonModel.length; i++) {    // loop on sql lines
                var line = {}
                for (var j = 0; j < wantedColumns.length; j++) {
                    if (wantedColumns[j] === "activity_name")
                        line[wantedColumns[j]] = jsonModel[i][wantedColumns[j]]
                    else
                        line[wantedColumns[j]] = jsonModel[i][wantedColumns[j]]
                }
                linesModel.append(line)
            }
            actualColumns = Array.from(wantedColumns)       // Restore columns when model is ready with a deep copy
        }
    }

    function sortTable() {
        if (linesModel.count === 0)
            return
        if (sort !== "") {
            switch (typeof linesModel.get(0)[sort]) {
            case "number":
                if (order === "-")
                    Master.mergeSortListModel(linesModel,  (a, b) => -Math.sign(a[sort] - b[sort]))
                else
                    Master.mergeSortListModel(linesModel,  (a, b) => Math.sign(a[sort] - b[sort]))
                break
            case "string":
                if (order === "-")
                    Master.mergeSortListModel(linesModel,  (a, b) => -(a[sort].localeCompare(b[sort])))
                else
                    Master.mergeSortListModel(linesModel,  (a, b) => (a[sort].localeCompare(b[sort])))
                break
            }
        }
    }

    Rectangle {  // Header with sort buttons
        id: sectionsHeader
        width: parent.width
        height: Style.lineHeight
        color: Style.selectedPalette.accent

        StyledSplitView {
            id: sectionsSplit
            width: parent.width - 10
            height: parent.height

            Repeater {
                id: sectionButtons
                model: requestPanel.actualColumns
                delegate: ColumnHeader {
                    text: Master.columnsLabel[modelData]
                    arrow: requestPanel.sort === modelData ? requestPanel.order : ""
                    SplitView.minimumWidth: Master.columnsSize[modelData] * 0.5
                    SplitView.preferredWidth: Master.columnsSize[modelData]
                    toolTipOnHover: true
                    toolTipText: modelData
                    onClicked: {
                        if (sort !== modelData) {
                            order = "";
                        }
                        order = (order === "") ? order = "+" : (order === "+") ? order = "-" : order = "+";
                        sort = (order !== "") ? modelData : "";
                        sortTable();
                    }
                }
            }
        }
    }

    Flickable {
        id: scrollLines
        width: parent.width
        anchors.top: sectionsHeader.bottom
        anchors.bottom: parent.bottom
        contentWidth: width
        contentHeight: lines.height
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            contentItem: Rectangle {
                implicitWidth: 6
                radius: width
                color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
            }
        }

        Column {
            id: lines
            width: parent.width
            height: childrenRect.height

            Repeater {
                model: linesModel
                delegate: AbstractButton {
                    id: lineButton
                    // property int lineIndex: index
                    required property int index
                    height: Style.lineHeight
                    width: lines.width - 10 // margin for the ScrollBar
                    hoverEnabled: true

                    property color textColor: hovered ?
                        Style.selectedPalette.highlightedText : Style.selectedPalette.text

                    Rectangle {
                        anchors.fill: parent
                        color: lineButton.pressed ? Style.selectedPalette.highlight :
                            (lineButton.hovered || lineButton.activeFocus ? Style.selectedPalette.alternateBase :
                            Style.selectedPalette.base)
                        border.width: lineButton.activeFocus && !lineButton.pressed ? 2 : 0
                        border.color: lineButton.textColor
                    }

                    Row {
                        height: Style.lineHeight
                        spacing: 6 // width of StyledSplitView handle

                        Repeater {
                            id: lineContentRepeater
                            model: actualColumns
                            delegate: DefaultLabel {
                                required property int index
                                required property string modelData
                                width: sectionButtons.itemAt(index).width
                                anchors.verticalCenter: parent.verticalCenter
                                color: lineButton.textColor
                                text: ((modelData === undefined) || (linesModel.get(lineButton.index) === undefined)) ? "" : linesModel.get(lineButton.index)[modelData]
                            }
                        }
                    }

                    onClicked: {
                        lineButton.focus = false;
                        viewSqlLineDialog.parentModel = linesModel;
                        viewSqlLineDialog.lineIndex = index;
                        viewSqlLineDialog.open();
                    }
                }
            }
        }
    }

    SqlLineDialog {
        id: viewSqlLineDialog
    }

    Component.onCompleted: {
        executeRequest()
    }
}
