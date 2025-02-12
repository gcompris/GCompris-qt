/* GCompris - DailyReport.qml
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
import QtQuick.Layouts 1.15

import "../singletons"

ColumnLayout {
    id: dailyReport
    property alias resultModel: resultModel
    property string sort: ""        // sort column
    property string order: ""       // ascending + or descending -
    property var arrows: ({ "": "", "+": "\uf0d7", "-": "\uf0d8" })
    spacing: 3

    function executeRequest() {
        sort = order = ""
        resultModel.clear()
        nameDisplay.text = ""
        if (groupId !== -1) {
            var group = Master.findObjectInModel(Master.groupModel, function(item) { return item.group_id === groupId })
            nameDisplay.text = group.group_name
        } else
            nameDisplay.text = qsTr("All groups")

        // sum(duration) must apply only if success is true.
        var sumRequest = `CASE WHEN result_success=1 THEN result_duration WHEN result_success=0 THEN 0 END`

        var clauses = []
        clauses.push(`result_.activity_id=activity_.activity_id`)
        if (userList.length === 0) {
            if (groupId !== -1)
                clauses.push(`result_.user_id IN (SELECT user_id FROM group_user_ WHERE group_id=${groupId})`)
        } else {
            clauses.push(`result_.user_id in (` + userList.join(",") + `)`)
        }
        clauses.push(`result_.user_id=user_.user_id`)
        if (activityList.length !== 0)
            clauses.push(`result_.activity_id in (` + activityList.join(",") + `)`)

        var start = selector.calendar.strDateToSql('20240101')       // Beginning of time for GCompris-Server. Nothing older.
        var end = selector.calendar.strDateToSql(new Date().toLocaleString(selector.calendar.locale, 'yyyyMMdd'))
        if (selector.calendar.startDate !== "") {
            start = selector.calendar.strDateToSql(selector.calendar.startDate)
            end = selector.calendar.strDateToSql(selector.calendar.endDate)
        }
        start = start.replace(' 00:00:00', '')
        end = end.replace(' 00:00:00', '')
        if (selector.calendar.startDate !== "")
            clauses.push(`result_day BETWEEN '${start}' AND '${end}'`)

        var request = `SELECT result_.user_id, result_.activity_id, activity_name, user_.user_name
        , date(result_datetime) AS result_day, count(result_.activity_id) AS count_activity
        , avg(result_success) AS success_ratio, sum(${sumRequest}) AS sum_duration
        FROM result_, activity_, user_ WHERE `
            + clauses.join(' AND ') + ` GROUP BY result_day, result_.activity_id, result_.user_id ORDER BY result_day`

//        console.warn(request, "\n")
        Master.modelFromRequest(resultModel, request)
    }

    function sortTable(key) {
        if (!resultModel.count) return
        if (sort !== key) order = ""
        sort = key
        order = (order === "") ? order = "+" : (order === "+") ? order = "-" : order = "+"
        switch (typeof resultModel.get(0)[key]) {
        case "number":
            if (order === "-")
                Master.mergeSortListModel(resultModel, (a, b) => -Math.sign(a[key] - b[key]))
            else
                Master.mergeSortListModel(resultModel, (a, b) => Math.sign(a[key] - b[key]))
            break
        case "string":
            if (key === "activity_name") {  // Sort on activity translation
                if (order === "-")
                    Master.mergeSortListModel(resultModel
                    , (a, b) => -(Master.allActivities[a[key]].title.localeCompare(Master.allActivities[b[key]].title)))
                else
                    Master.mergeSortListModel(resultModel
                    , (a, b) => (Master.allActivities[a[key]].title.localeCompare(Master.allActivities[b[key]].title)))
            } else {
                if (order === "-")
                    Master.mergeSortListModel(resultModel, (a, b) => -(a[key].localeCompare(b[key])))
                else
                    Master.mergeSortListModel(resultModel, (a, b) => (a[key].localeCompare(b[key])))
            }
            break
        }
    }

    ListModel { id: resultModel }

    Rectangle {     // Page header
        Layout.fillWidth: true
        Layout.minimumHeight: Style.activityHeaderHeight
        Layout.maximumHeight: Style.activityHeaderHeight
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        Layout.topMargin: 5
        Layout.preferredWidth: lines.width
        color: "white"
        radius: 3
        border.width: 1
        border.color: "black"
        RowLayout {     // Page header (user and activity names, activity icon)
            anchors.fill: parent
            spacing: 5

            Text {
                id: nameDisplay
                Layout.leftMargin: 5
                text: ""
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
            }

            Text {
                id: dateLabel
                Layout.preferredWidth: 250
                Layout.leftMargin: 15
                text: (calendar.title === qsTr("Calendar")) ? "" : calendar.title
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                clip: true
            }

            Text {
                id: actiName
                Layout.fillWidth: true
                text: (activityName !== "") ? Master.allActivities[activityName]["title"] : ""
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                clip: true
            }

            Image {
                Layout.preferredWidth: Style.activityHeaderHeight
                Layout.preferredHeight: Style.activityHeaderHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.rightMargin: 5
                source: (activityName !== "") ? "qrc:/gcompris/src/activities/" + Master.allActivities[activityName]["icon"] : ""
                sourceSize.width: 100
                sourceSize.height: 100
            }

        }
    }

    Rectangle {     // Columns header with sort buttons
        Layout.fillWidth: true
        Layout.preferredHeight: Style.tableHeaderHeight
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        clip: true
        RowLayout {     // List header, columns names
            id: header
            anchors.fill: parent
            height: parent.height
            spacing: 2

            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["user_name"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: Definitions.columnsLabel["user_name"] + ((sort === "user_name") ? " " + arrows[order] : "")
                onClicked: dailyReport.sortTable("user_name")
            }
            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["result_day"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: Definitions.columnsLabel["result_day"] + ((sort === "result_day") ? " " + arrows[order] : "")
                onClicked: dailyReport.sortTable("result_day")
            }
            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["activity_name"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: Definitions.columnsLabel["activity_name"] + ((sort === "activity_name") ? " " + arrows[order] : "")
                onClicked: dailyReport.sortTable("activity_name")
            }
            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["count_activity"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: qsTr("Count") + ((dailyReport.sort === "count_activity") ? " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("count_activity")
            }
            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["result_duration"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: qsTr("Time") + ((dailyReport.sort === "sum_duration") ? " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("sum_duration")
            }
            RoundButton {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: resultModel.count + " " + qsTr("lines")
            }

            RoundButton {
                Layout.preferredWidth: Definitions.columnsSize["success_ratio"]
                Layout.preferredHeight: Style.tableHeaderHeight
                radius: 1
                font.pixelSize: Style.defaultPixelSize
                text: qsTr("Ratio") + ((dailyReport.sort === "success_ratio") ? " " + dailyReport.order : "")
                onClicked: dailyReport.sortTable("success_ratio")
            }
        }
    }

    Component {
        id: lineReport
        LineReport {}
    }

    ScrollView {
        id: scrollLines
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        ListView {      // Request rows
            id: lines
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: scrollLines.contentWidth
            model: resultModel
            spacing: Style.linesSpacing
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: Control {
                id: dailyLine
                height: 26
                width: lines.width
                hoverEnabled: true
                Rectangle {
                    anchors.fill: parent
                    color: dailyLine.hovered ? "lightgray" : "white"
                    RowLayout {
                        id: infos
                        anchors.fill: parent
                        spacing: 2
                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["user_name"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            leftPadding: 5
                            text: user_name
                        }
                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["result_day"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            leftPadding: 5
                            text: new Date(result_day).toLocaleDateString(Qt.locale())
                        }
                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["activity_name"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            leftPadding: 10
                            text: Master.allActivities[activity_name]["title"]
                        }
                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["count_activity"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            text: count_activity
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["result_duration"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            text: {
                                var date = new Date(0)
                                date.setSeconds(sum_duration)
                                var timeString = date.toISOString().substring(11, 19)
                                return timeString
                            }
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.leftMargin: 5
                            Layout.preferredHeight: 20
                            border.width: 1
                            border.color: "black"
                            Rectangle {
                                width: (parent.width * success_ratio) -2
                                height: parent.height - 2
                                x: 1
                                y: 1
                                color: Style.colorHeaderPane
                            }
                        }

                        Text {
                            Layout.preferredWidth: Definitions.columnsSize["success_ratio"]
                            Layout.preferredHeight: 20
                            font.pixelSize: Style.defaultPixelSize
                            rightPadding: 5
                            text: parseFloat(success_ratio * 100).toFixed(2)+" %"
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(lineReport, { userId: user_id, activityId: activity_id, activityName: activity_name, dayFilter: result_day })
                        pageStack.currentItem.executeRequest()
                    }
                }
            }
        }
    }
}
