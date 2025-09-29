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

    StyledSplitView {
        id: chartsSplitView
        anchors.fill: parent

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

            groupPane.onSelectionClicked: {
                chartsView.popStacks()
                Master.foldDownToList(pupilPane, chartsView.userList, -1, false)
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }

            pupilPane.onSelectionClicked: (modelId, checked) => {
                chartsView.popStacks()
                Master.foldDownToList(pupilPane, chartsView.userList, modelId, checked)
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }

            activityPane.onSelectionClicked: (modelId, checked) => {
                chartsView.popStacks()
                Master.foldDownToList(activityPane, chartsView.activityList, modelId, checked)
                chartsContainer.children[bar.currentIndex].currentItem.executeRequest();
            }
        }

        Item {
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
                    onClicked: bar.currentIndex = 0;
                }
                StyledTabButton {
                    text: qsTr("Pupils")
                    onClicked: bar.currentIndex = 1;
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
