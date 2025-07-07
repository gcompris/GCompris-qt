/* GCompris - ActivitiesView.qml
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

import core 1.0
import "../components"
import "../singletons"
import "../panels"
import "../activities"
import "qrc:/gcompris/src/server/server.js" as Server

Item {
    id: activitiesView
    property alias selector: selector
    property alias calendar: selector.calendar
    property int groupId: Master.groupFilterId
    property var userList: []
    property var activityList: []
    property string activityName: ""

    StyledSplitView {
        id: splitActivitiesView
        anchors.fill: parent

        SelectorPanel {
            id: selector
            SplitView.preferredWidth: minWidth
            SplitView.minimumWidth: minWidth
            SplitView.maximumHeight: parent.height

            calendar.onCalendarChanged: dailyReport.executeRequest()

            groupPane.onSelectionClicked: (modelId, checked) => {
                if (pageStack.depth > 1)
                    pageStack.pop()
                activitiesView.groupId = modelId
                activitiesView.userList = []
                activitiesView.activityList = []
                activitiesView.activityName = ""
                pupilPane.currentChecked = -1
                if (activitiesView.groupId === -1) {
                    Master.unCheckModel(Master.groupModel, "group_checked")
                    Master.loadAllActivities(activityPane.foldModel)
                } else {
                    Master.filterUsers(pupilPane.foldModel, false)
                    Master.loadGroupActivities(activityPane.foldModel, activitiesView.groupId)
                }
                dailyReport.executeRequest()
            }

            pupilPane.onSelectionClicked: (modelId, checked) => {
                if (pageStack.depth > 1)
                    pageStack.pop()
                Master.foldDownToList(pupilPane, activitiesView.userList, modelId, checked)
                activitiesView.activityName = ""
                activityPane.currentChecked = -1
                if (activitiesView.userList.length === 0) {
                    Master.loadAllActivities(activityPane.foldModel)
                    activityList = []
                } else {
                    Master.loadUserActivities(activityPane.foldModel, userList, activityList, true)
                }
                dailyReport.executeRequest()
            }

            activityPane.onSelectionClicked: (modelId, checked) => {
                if (pageStack.depth > 1)
                    pageStack.pop()
                Master.foldDownToList(activityPane, activitiesView.activityList, modelId, checked)
                dailyReport.executeRequest()
            }
        }

        StackView {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            id: pageStack
            initialItem: DailyReport { id: dailyReport }
            clip: true
        }
    }
}
