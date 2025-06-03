/* GCompris - SelectorPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.15

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
        Layout.maximumHeight: collapseButton.checked ?  monthHeight : lineHeight
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

        FoldDownRadio {
            id: groupPane
            title: qsTr("Groups")
            foldModel: Master.groupModel
            indexKey: "group_id"
            nameKey: "group_name"
            checkKey: "group_checked"
            activated: selectorPanel.withGroups
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: selectorPanel.withGroups && (!selectorPanel.withActivities && !selectorPanel.withPupils)
            onSelectionClicked: (modelId) => {
                Master.groupFilterId = modelId
                Master.filterUsers(selectorUserModel, false)
            }
        }

        FoldDownCheck {
            id: pupilPane
            title: qsTr("Pupils")
            foldModel: selectorUserModel
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            activated: selectorPanel.withPupils
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: selectorPanel.withPupils && (!selectorPanel.withActivities)
        }

        FoldDownCheck {
            id: activityPane
            title: qsTr("Activities")
            foldModel: selectorActivityModel
            indexKey: "activity_id"
            nameKey: "activity_name"
            checkKey: "activity_checked"
            titleKey: "activity_title"
            delegateName: "checkActivity"
            activated: selectorPanel.withActivities
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: selectorPanel.withActivities
        }

    }
}
