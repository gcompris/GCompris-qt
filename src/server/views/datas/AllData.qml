/* GCompris - AllData.qml
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

import "../../singletons"
import "../../panels"
import "../../components"

Item {
    id: allData
    width: parent.width
    height: parent.height

    function setRequest(i) {
        switch (i) {
        case 0 :
            reqView.request = "select * from _all_users_activities"
            reqView.wantedColumns = [ "user_name", "activity_name", "result_datetime", "result_success", "result_duration", "result_data"]
            break;
        case 1 :
            reqView.request = "select * from _user_activity_result"
            reqView.wantedColumns = [ "user_name", "activity_name", "count_activity", "count_success", "count_failed"]
            break;
        case 2 :
            reqView.request = "select * from _all_groups"
            reqView.wantedColumns = [ "group_name", "user_name", "user_password"]
            break;
        case 3 :
            reqView.request = "select * from _all_users_activities where result_success=0"
            reqView.wantedColumns = [ "user_name", "activity_name", "result_datetime", "result_data"]
            break;
        case 4 :
            reqView.request = "select * from _user_groups"
            reqView.wantedColumns = [ "user_id", "user_name", "groups_id", "groups_name"]
            break;
        case 5 :
            reqView.request = "select * from _group_users"
            reqView.wantedColumns = [ "group_name", "users_id", "group_description", "users_name"]
            break;
        case 6 :
            reqView.request = "SELECT * FROM _daily_activities"
            reqView.wantedColumns = [ "activity_name", "result_day", "count_activity" ]
            break;
        case 7 :
            reqView.request = "SELECT * FROM _daily_ratios"
            reqView.wantedColumns = [ "result_day", "user_name", "activity_name", "count_activity", "success_ratio" ]
            break;
        }
        reqView.sort = ""
        reqView.executeRequest()
    }

    Row {
        id: selectionRow
        x: Style.smallMargins
        height: Style.lineHeight
        spacing: Style.margins

        DefaultLabel {
            text: qsTr("Available requests")
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledComboBox {
            id: what
            width: 250
            model: [ qsTr("All users activities"), qsTr("Pupils activities"), qsTr("All groups"), qsTr("Failed activities"),
                qsTr("User's groups"), qsTr("Group's users"), qsTr("Daily activities"), qsTr("Daily ratios") ]
            onCurrentIndexChanged: allData.setRequest(currentIndex)
        }

        SmallButton {
            text: "\uf021"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: reqView.executeRequest()
        }

        DefaultLabel {
            //: Number of lines
            text: qsTr("%1 lines").arg(reqView.count)
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
        }
    }
    DefaultLabel {
        text: reqView.request
        anchors {
            left: selectionRow.right
            right: parent.right
            margins: Style.margins
            verticalCenter: selectionRow.verticalCenter
        }
    }

    RequestPanel {
        id: reqView
        dynamicRoles: true      // required here because columns change with each request
        anchors {
            top: selectionRow.bottom
            topMargin: Style.margins
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
    }

    Component.onCompleted: setRequest(what.currentIndex)
}
