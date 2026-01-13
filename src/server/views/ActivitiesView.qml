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
    width: parent.width
    height: parent.height

    property alias selector: selector
    property alias calendar: selector.calendar
    property var userList: []
    property var activityList: []

    onVisibleChanged: {
        if(visible) {
            initView();
        }
    }

    function initView() {
        // activityList is always kept for convenience, as activities result are not displayed anyway if there is none for selected group/users
        initUserList();

        updateActivityPaneModel();

        dailyReport.executeRequest();
    }

    function updateActivityPaneModel() {
        if(Master.groupFilterId === -1 && userList.length === 0) {
            Master.loadActivitiesWithData(selector.activityPane.foldModel, activityList, true)
        } else if(userList.length === 0) {
            Master.loadGroupActivities(selector.activityPane.foldModel, Master.groupFilterId, activityList, true)
        } else  {
            Master.loadUserActivities(selector.activityPane.foldModel, userList, activityList, true)
        }
    }

    function initUserList() {
        // user list should be cleared every time when changing group
        userList = [];
        var pupilPaneCount = Master.filteredUserModel.count;
        if(selector.pupilPane.currentChecked === -2) {
            Master.foldDownToList(selector.pupilPane, activitiesView.userList, -2, true)
        } else {
            for(var i = 0; i < pupilPaneCount; i++) {
                var model_data = Master.filteredUserModel.get(i);
                if(model_data["user_checked"] === true) {
                    Master.foldDownToList(selector.pupilPane, activitiesView.userList, model_data["user_id"], true);
                }
            }
        }
    }

    StyledSplitView {
        id: splitActivitiesView
        anchors.fill: parent

        Connections {
            target: Master
            function onDataAddedToUser(user, activityName) {
                Master.loadUserActivities(selector.activityPane.foldModel, activitiesView.userList, activitiesView.activityList, true)
                dailyReport.executeRequest()
            }
        }

        SelectorPanel {
            id: selector
            SplitView.preferredWidth: minWidth
            SplitView.minimumWidth: minWidth
            SplitView.maximumHeight: parent.height

            calendar.onCalendarChanged: dailyReport.executeRequest()

            groupPane.onSelectionClicked: (modelId, checked) => {
                if(!visible) {
                    return;
                }
                if (pageStack.depth > 1) {
                    pageStack.pop();
                }
                Master.setGroupFilterId(modelId);
                activitiesView.initView()
                dailyReport.executeRequest();
            }

            pupilPane.onSelectionClicked: (modelId, checked) => {
                if(!visible) {
                    return;
                }
                if (pageStack.depth > 1) {
                    pageStack.pop();
                }
                Master.foldDownToList(pupilPane, activitiesView.userList, modelId, checked);
                activitiesView.updateActivityPaneModel();
                dailyReport.executeRequest();
            }

            activityPane.onSelectionClicked: (modelId, checked) => {
                if(!visible) {
                    return;
                }
                if (pageStack.depth > 1) {
                    pageStack.pop();
                }
                Master.foldDownToList(activityPane, activitiesView.activityList, modelId, checked);
                dailyReport.executeRequest();
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
