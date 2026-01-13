/* GCompris - ChartsView.qml
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

import "../components"
import "../singletons"
import "../panels"
import "charts"

Item {
    id: chartsView
    width: parent.width
    height: parent.height

    property alias calendar: selector.calendar
    property var userList: []
    property var activityList: []

    function popStacks() {
        if (activitiesChartStack.depth > 1)
            activitiesChartStack.pop()
        if (usersChartStack.depth > 1)
            usersChartStack.pop()
    }

    onVisibleChanged: {
        if(visible) {
            initView();
        }
    }

    function initView() {
        chartsView.popStacks()
        // pupils chart need to init activityList with current selection
        initUserList();
        selector.refreshCurrentResults();
    }

    function initUserList() {
        // user list should be cleared every time when changing group
        userList = [];
        var pupilPaneCount = Master.filteredUserModel.count;
        if(selector.pupilPane.currentChecked === -2) {
            Master.foldDownToList(selector.pupilPane, chartsView.userList, -1, false)
        } else {
            for(var i = 0; i < pupilPaneCount; i++) {
                var model_data = Master.filteredUserModel.get(i);
                if(model_data["user_checked"] === true) {
                    Master.foldDownToList(selector.pupilPane, chartsView.userList, model_data["user_id"], true);
                }
            }
        }
    }

    StyledSplitView {
        id: chartsSplitView
        anchors.fill: parent

        Connections {
            target: Master
            function onDataAddedToUser(user, activityName) {
                selector.refreshCurrentResults();
            }
        }

        SelectorPanel {
            id: selector
            withGroups: bar.currentIndex === 1
            withPupils: bar.currentIndex === 1
            withActivities: bar.currentIndex === 0
            SplitView.preferredWidth: minWidth
            SplitView.minimumWidth: minWidth
            SplitView.maximumHeight: parent.height
            activityPane.foldModel: Master.activityWithDataModel

            calendar.onCalendarChanged: chartsContainer.children[bar.currentIndex].currentItem.executeRequest()

            groupPane.onSelectionClicked: (modelId) => {
                if(!visible) {
                    return;
                }
                chartsView.popStacks();
                Master.setGroupFilterId(modelId);
                Master.foldDownToList(pupilPane, chartsView.userList, -1, false);
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }

            pupilPane.onSelectionClicked: (modelId, checked) => {
                if(!visible) {
                    return;
                }
                chartsView.popStacks()
                Master.foldDownToList(pupilPane, chartsView.userList, modelId, checked)
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }

            activityPane.onSelectionClicked: (modelId, checked) => {
                if(!visible) {
                    return;
                }
                chartsView.popStacks();
                Master.foldDownToList(activityPane, chartsView.activityList, modelId, checked);
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }
            function refreshCurrentResults() {
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }
        }

        Item {
            id: midItem
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            SplitView.minimumWidth: chartsSplitView.width * 0.3

            TabBar {
                id: bar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Style.margins
                background: Item {}
                spacing: Style.margins
                currentIndex: 0

                StyledTabButton {
                    text: qsTr("Activities")
                    onClicked: {
                        bar.currentIndex = 0;
                        selector.refreshCurrentResults();
                    }
                }
                StyledTabButton {
                    text: qsTr("Pupils")
                    onClicked: {
                        bar.currentIndex = 1;
                        selector.refreshCurrentResults();
                    }
                }
            }

            TabContainer {
                id: chartsContainer
                anchors {
                    top: bar.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                currentIndex: bar.currentIndex

                StackView {
                    id: activitiesChartStack
                    anchors.fill: parent
                    initialItem: ActivitiesChart { id: activitiesChart }
                    clip: true
                }

                StackView {
                    id: usersChartStack
                    anchors.fill: parent
                    initialItem: PupilsChart { id: pupilsChart }
                    clip: true
                    visible: false
                }
            }
        }
    }
}
