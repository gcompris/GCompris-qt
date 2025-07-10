/* GCompris - SelectorPanel.qml
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

import "../singletons"
import "../components"

Column {
    id: selectorPanel
    property alias calendar: calendarPane
    property alias groupPane: groupPane
    property alias pupilPane: pupilPane
    property alias activityPane: activityPane
    property bool withGroups: true
    property bool withPupils: true
    property bool withActivities: true
    property bool withCalendar: true
    readonly property int minWidth: Style.textSize * 18

    function removeGroups()     { splitter.removeItem(groupPane) }
    function removePupils()     { splitter.removeItem(pupilPane) }
    function removeActivities() { splitter.removeItem(activityPane) }

    ListModel { id: selectorUserModel }
    ListModel { id: selectorActivityModel }

    CalendarPane {
        id: calendarPane
        activated: selectorPanel.withCalendar
    }

    StyledSplitView {
        id: splitter
        width: parent.width
        height: parent.height - calendarPane.height

        orientation: Qt.Vertical

        FoldDown {
            id: groupPane
            title: qsTr("Groups")
            foldModel: Master.groupModel
            indexKey: "group_id"
            nameKey: "group_name"
            checkKey: "group_checked"
            delegateName: "radio"
            filterVisible: false
            collapsable: true
            activated: selectorPanel.withGroups
            SplitView.preferredHeight: 8 * Style.lineHeight
            SplitView.minimumHeight: Style.lineHeight
            SplitView.fillHeight: selectorPanel.withGroups && (!selectorPanel.withActivities && !selectorPanel.withPupils)
            onSelectionClicked: (modelId) => {
                Master.groupFilterId = modelId
                Master.filterUsers(selectorUserModel, false)
            }
        }

        FoldDown {
            id: pupilPane
            title: qsTr("Pupils")
            foldModel: selectorUserModel
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "check"
            filterVisible: true
            collapsable: true
            activated: selectorPanel.withPupils
            SplitView.preferredHeight: 8 * Style.lineHeight
            SplitView.minimumHeight: Style.lineHeight
            SplitView.fillHeight: selectorPanel.withPupils && (!selectorPanel.withActivities)
        }

        FoldDown {
            id: activityPane
            title: qsTr("Activities")
            foldModel: selectorActivityModel
            indexKey: "activity_id"
            nameKey: "activity_name"
            checkKey: "activity_checked"
            titleKey: "activity_title"
            delegateName: "checkActivity"
            filterVisible: true
            collapsable: true
            activated: selectorPanel.withActivities
            SplitView.preferredHeight: 8 * Style.lineHeight
            SplitView.minimumHeight: Style.lineHeight
            SplitView.fillHeight: selectorPanel.withActivities
        }
    }
}
