/* GCompris - RequestPanel.qml
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
import "qrc:/gcompris/src/server/server.js" as Server

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
    property var arrows: ({ "": "", "+": "\uf0d7", "-": "\uf0d8" })

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
        if (linesModel.count)
            tableResult.contentY = 0
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

    ListView {
        id: topHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 26
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        model: requestPanel.actualColumns
        delegate: Button {
            text: Definitions.columnsLabel[modelData] + ((sort === modelData) ? " " + arrows[order] : "")
            width: Definitions.columnsSize[modelData]
            height: 24
            ToolTip.visible: hovered
            ToolTip.text: modelData
            ToolTip.delay: 1500
            onClicked: {
                if (sort !== modelData)
                    order = ""
                order = (order === "") ? order = "+" : (order === "+") ? order = "-" : order = "+"
                sort = (order !== "") ? modelData : ""
                sortTable()
            }
        }

        onContentXChanged: {
            tableResult.contentX = contentX
        }
    }

    TableView {
        id: tableResult
        clip: true
        anchors {
            top: topHeader.bottom
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        rowSpacing: 2
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar   { policy: ScrollBar.AsNeeded }
        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

        model: linesModel
        delegate: Item {
            property int lineIndex: index
            implicitHeight: 20
            implicitWidth: childrenRect.width

            Row {
                height: 20
                Repeater {
                    model: actualColumns
                    delegate: Rectangle {
                        height: 20
                        width: Definitions.columnsSize[modelData]
                        color: Style.selectedPalette.alternateBase
                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 3
                            horizontalAlignment: Definitions.columnsAlign[modelData]
                            text: ((modelData === undefined) || (linesModel.get(lineIndex) === undefined)) ? "" : linesModel.get(lineIndex)[modelData]
                            clip: true
                            color: Style.selectedPalette.text
                        }
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: lineArea.containsMouse ? Style.selectedPalette.accent : "transparent"
                opacity: 0.3
                MouseArea {
                    id: lineArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onDoubleClicked: {
                        viewSqlLineDialog.parentModel = linesModel
                        viewSqlLineDialog.lineIndex = lineIndex
                        viewSqlLineDialog.open()
                    }
                }
            }
        }

        onContentXChanged: {
            topHeader.contentX = contentX
        }
    }

    SqlLineDialog {
        id: viewSqlLineDialog
    }

    Component.onCompleted: {
        executeRequest()
    }
}
