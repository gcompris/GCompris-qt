/* GCompris - SelectorPanel.qml
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
import QtQuick.Layouts

import "../singletons"
import "../components"

ColumnLayout {
    id: selectorPanel
    property alias calendar: calendarPane
    property alias groupPane: groupPane
    property alias pupilPane: pupilPane
    property alias activityPane: activityPane
    property bool withGroups: true
    property bool withPupils: true
    property bool withActivities: true
    property bool withCalendar: true
    readonly property int minWidth: 266

    function removeGroups()     { splitter.removeItem(groupPane) }
    function removePupils()     { splitter.removeItem(pupilPane) }
    function removeActivities() { splitter.removeItem(activityPane) }

    ListModel { id: selectorUserModel }
    ListModel { id: selectorActivityModel }

    CalendarPane {
        id: calendarPane
        activated: selectorPanel.withCalendar
        Layout.minimumHeight: Style.lineHeight
        Layout.preferredHeight: monthHeight
        Layout.maximumHeight: collapseButton.checked ? monthHeight : Style.lineHeight
        Layout.fillWidth: true
    }

    SplitView {
        id: splitter
        Layout.fillHeight: true
        Layout.fillWidth: true
        orientation: Qt.Vertical

        handle: Rectangle {
            implicitWidth: 4
            implicitHeight: 6
            color: SplitHandle.pressed ? Style.selectedPalette.highlight :
                                        Style.selectedPalette.accent
        }

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
