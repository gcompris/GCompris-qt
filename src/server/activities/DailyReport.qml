/* GCompris - DailyReport.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../components"
import "../singletons"

Column {
    id: dailyReport
    property alias resultModel: resultModel
    property string sort: ""        // sort column
    property string order: ""       // ascending + or descending -
    property var arrows: ({ "": "", "+": "\uf0d7", "-": "\uf0d8" })

    function executeRequest() {
        sort = order = ""
        resultModel.clear()
        headerTitle.groupTitle = ""
        if (groupId !== -1) {
            var group = Master.findObjectInModel(Master.groupModel, function(item) { return item.group_id === groupId })
            headerTitle.groupTitle = group.group_name
        } else
            headerTitle.groupTitle = qsTr("All groups")

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

        var start = selector.calendar.strDateToSql('20240101')       // Beginning of time for GCompris-Teachers. Nothing older.
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

    Rectangle {
        id: header
        width: parent.width
        height: Style.lineHeight
        color: Style.selectedPalette.base
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.accent

        Row {
            anchors {
                left: parent.left
                right: parent.right
                margins: Style.margins
            }
            height: parent.height
            spacing: Style.margins

            DefaultLabel {
                id: headerTitle
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                //: Group name first, then Date range, with a space between them. Example: "Group Name 01/07/2025-08/07/2025"
                text: calendarTitle != "" ? qsTr("%1 %2").arg(groupTitle).arg(calendarTitle) :
                        groupTitle

                property string groupTitle: ""
                property string calendarTitle: (calendar.title === qsTr("Calendar")) ? "" : calendar.title
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

            property int minSectionWidth: Math.min(width / 14, Style.controlSize * 2)
            property int defaultNameWidth: width / 5 - 6 // -6 for the StyledSplitView handle
            property int defaultNumberWidth: width / 10 - 6

            SmallButton {
                id: userNameButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNameWidth
                neutralBorderWidth: 0
                text: Definitions.columnsLabel["user_name"] +
                    ((dailyReport.sort === "user_name") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("user_name")
            }
            SmallButton {
                id: dateButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNameWidth
                neutralBorderWidth: 0
                text: Definitions.columnsLabel["result_day"] +
                    ((dailyReport.sort === "result_day") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("result_day")
            }
            SmallButton {
                id: activityNameButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNameWidth
                neutralBorderWidth: 0
                text: Definitions.columnsLabel["activity_name"] +
                    ((dailyReport.sort === "activity_name") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("activity_name")
            }
            SmallButton {
                id: activityCountButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNumberWidth
                neutralBorderWidth: 0
                text: qsTr("Count") +
                    ((dailyReport.sort === "count_activity") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("count_activity")
            }
            SmallButton {
                id: timeButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNumberWidth
                neutralBorderWidth: 0
                text: qsTr("Time") +
                    ((dailyReport.sort === "sum_duration") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("sum_duration")
            }
            SmallButton {
                id: successRatioButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNumberWidth
                neutralBorderWidth: 0
                text: qsTr("Ratio") +
                    ((dailyReport.sort === "success_ratio") ?
                        " " + dailyReport.arrows[dailyReport.order] : "")
                onClicked: dailyReport.sortTable("success_ratio")
            }
            SmallButton {
                id: linesButton
                SplitView.minimumWidth: sectionsSplit.minSectionWidth
                SplitView.preferredWidth: sectionsSplit.defaultNumberWidth
                SplitView.fillWidth: true
                neutralBorderWidth: 0
                //: Number of result lines
                text: qsTr("Lines: %1").arg(resultModel.count)
            }
        }
    }

    Component {
        id: lineReport
        LineReport {}
    }

    Flickable {
        id: scrollLines
        width: parent.width
        height: parent.height - header.height - sectionsHeader.height
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
                model: resultModel
                delegate: AbstractButton {
                    id: dailyLine
                    height: Style.lineHeight
                    width: lines.width - 10 // margin for the ScrollBar
                    hoverEnabled: true

                    property color textColor: hovered ?
                        Style.selectedPalette.highlightedText : Style.selectedPalette.text

                    Rectangle {
                        anchors.fill: parent
                        color: dailyLine.pressed ? Style.selectedPalette.highlight :
                            (dailyLine.hovered || dailyLine.activeFocus ? Style.selectedPalette.alternateBase :
                            Style.selectedPalette.base)
                        border.width: dailyLine.activeFocus && !dailyLine.pressed ? 2 : 0
                        border.color: dailyLine.textColor
                    }

                    Row {
                        id: infos
                        x: Style.tinyMargins
                        width: sectionsSplit.width - Style.smallMargins
                        height: parent.height
                        spacing: 6 // width of StyledSplitView handle
                        DefaultLabel {
                            width: userNameButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            text: user_name
                        }
                        DefaultLabel {
                            width: dateButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            text: new Date(result_day).toLocaleDateString(Qt.locale())
                        }
                        DefaultLabel {
                            width: activityNameButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            text: Master.allActivities[activity_name]["title"]
                        }
                        DefaultLabel {
                            width: activityCountButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            text: count_activity
                        }
                        DefaultLabel {
                            width: timeButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            text: {
                                var date = new Date(0)
                                date.setSeconds(sum_duration)
                                var timeString = date.toISOString().substring(11, 19)
                                return timeString
                            }
                        }
                        DefaultLabel {
                            width: successRatioButton.width
                            anchors.verticalCenter: parent.verticalCenter
                            color: dailyLine.textColor
                            //: Success ratio, example: "50 %"
                            text: qsTr("%1 %").arg(parseFloat(success_ratio * 100).toFixed(2))
                        }
                        Rectangle {
                            width: linesButton.width - 4
                            height: Style.textSize
                            anchors.verticalCenter: parent.verticalCenter
                            border.width: 1
                            border.color: Style.selectedPalette.accent
                            color: "red" // wrong answer ratio
                            Rectangle {
                                width: (parent.width * success_ratio) - 2
                                height: parent.height - 2
                                x: 1
                                y: 1
                                color: "green" // good answer ratio
                            }
                        }
                    }

                    onClicked: {
                        pageStack.push(lineReport, { userId: user_id, activityId: activity_id, activityName: activity_name, dayFilter: result_day });
                        pageStack.currentItem.executeRequest();
                    }
                }
            }
        }
    }
}
