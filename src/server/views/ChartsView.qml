/* GCompris - ChartsView.qml
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
import "../panels"
import "charts"

Item {
    id: chartsView
    property alias calendar: selector.calendar
    property var userList: []
    property var activityList: []

    function popStacks() {
        if (activitiesChartStack.depth > 1)
            activitiesChartStack.pop()
        if (usersChartStack.depth > 1)
            usersChartStack.pop()
    }

    SplitView {
        anchors.fill: parent

        SelectorPanel {
            id: selector
            withGroups: bar.currentIndex === 1
            withPupils: bar.currentIndex === 1
            withActivities: bar.currentIndex === 0
            SplitView.preferredWidth: minWidth
            SplitView.minimumWidth: minWidth
            SplitView.maximumHeight: parent.height
            activityPane.foldModel: Master.allActivitiesModel

            calendar.onCalendarChanged: chartLayout.children[bar.currentIndex].currentItem.executeRequest()

            groupPane.onSelectionClicked: {
                chartsView.popStacks()
                Master.foldDownToList(pupilPane, chartsView.userList, -1, false)
                chartLayout.children[bar.currentIndex].currentItem.executeRequest();
            }

            pupilPane.onSelectionClicked: (modelId, checked) => {
                chartsView.popStacks()
                Master.foldDownToList(pupilPane, chartsView.userList, modelId, checked)
                chartLayout.children[bar.currentIndex].currentItem.executeRequest();
            }

            activityPane.onSelectionClicked: (modelId, checked) => {
                chartsView.popStacks()
                Master.foldDownToList(activityPane, chartsView.activityList, modelId, checked)
                chartLayout.children[bar.currentIndex].currentItem.executeRequest();
            }
        }

        Item {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            TabBar {
                id: bar
                anchors.top: parent.top
                TabButton {
                    text: qsTr("Activities")
                }
                TabButton {
                    text: qsTr("Pupils")
                }
            }

            StackLayout {
                id: chartLayout
                anchors.top: bar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                currentIndex: bar.currentIndex

                StackView {
                    id: activitiesChartStack
                    SplitView.fillWidth: true
                    initialItem: ActivitiesChart { id: activitiesChart }
                    clip: true
                }

                StackView {
                    id: usersChartStack
                    SplitView.fillWidth: true
                    initialItem: PupilsChart { id: pupilsChart }
                    clip: true
                }

            }
        }
    }
}
