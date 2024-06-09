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
        activated: withCalendar
        Layout.minimumHeight: Style.defaultLineHeight
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
            color: SplitHandle.pressed ? "darksalmon"
                : (SplitHandle.hovered ? Qt.lighter("goldenrod", 1.1) : "goldenrod")
        }

        FoldDownRadio {
            id: groupPane
            title: qsTr("Groups")
            foldModel: Master.groupModel
            indexKey: "group_id"
            nameKey: "group_name"
            checkKey: "group_checked"
            activated: withGroups
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: withGroups && (!withActivities && !withPupils)
            onSelectionClicked: {
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
            activated: withPupils
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: withPupils && (!withActivities)
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
            activated: withActivities
            SplitView.preferredHeight: 8 * lineHeight
            SplitView.minimumHeight: lineHeight
            SplitView.fillHeight: withActivities
        }

    }
}
