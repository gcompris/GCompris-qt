/* GCompris - ActivitiesView.qml
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

import GCompris 1.0
import "../singletons"
import "../components"
import "../panels"
import "../activities"
import "details"
import "qrc:/gcompris/src/server/server.js" as Server

Item {
    id: activitiesView
    property alias selector: selector
    property alias calendar: selector.calendar
    property int groupId: Master.groupFilterId
    property var userList: []
    property var activityList: []
    property string activityName: ""

    SplitView {
        id: splitActivitiesView
        anchors.fill: parent
        anchors.margins: 3

        SelectorPanel {
            id: selector
            SplitView.preferredWidth: minWidth
            SplitView.minimumWidth: minWidth
            SplitView.maximumHeight: parent.height

            calendar.onCalendarChanged: dailyReport.executeRequest()

            groupPane.onSelectionClicked: {
                if (pageStack.depth > 1)
                    pageStack.pop()
                groupId = modelId
                userList = []
                activityList = []
                activityName = ""
                pupilPane.currentChecked = -1
                if (groupId === -1) {
                    Master.unCheckModel(Master.groupModel, "group_checked")
                    Master.loadAllActivities(activityPane.foldModel)
                } else {
                    Master.filterUsers(pupilPane.foldModel, false)
                    Master.loadGroupActivities(activityPane.foldModel, groupId)
                }
                dailyReport.executeRequest()
            }

            pupilPane.onSelectionClicked: {
                if (pageStack.depth > 1)
                    pageStack.pop()
                Master.foldDownToList(pupilPane, userList, modelId, checked)
                activityName = ""
                activityPane.currentChecked = -1
                if (userList.length === 0) {
                    Master.loadAllActivities(activityPane.foldModel)
                    activityList = []
                } else {
                    Master.loadUserActivities(activityPane.foldModel, userList, activityList, true)
                }
                dailyReport.executeRequest()
            }

            activityPane.onSelectionClicked: {
                if (pageStack.depth > 1)
                    pageStack.pop()
                Master.foldDownToList(activityPane, activityList, modelId, checked)
                dailyReport.executeRequest()
            }
        }

        StackView {
            SplitView.fillWidth: true
            id: pageStack
            initialItem: DailyReport { id: dailyReport }
            clip: true
        }
    }
}
