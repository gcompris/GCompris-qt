/* GCompris - Definitions.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma Singleton

import QtQuick

Item {
    readonly property var columnsLabel: ({
                                             "user_id": qsTr("User ID"),
                                             "user_name": qsTr("Name"),
                                             "users_name": qsTr("Names"),
                                             "user_password": qsTr("Password"),
                                             "users_id": qsTr("Users IDs"),
                                             "activity_id": qsTr("Activity Id"),
                                             "activity_name": qsTr("Activity"),
                                             "group_name": qsTr("Group"),
                                             "group_description": qsTr("Description"),
                                             "groups_name": qsTr("Groups"),
                                             "groups_id": qsTr("Groups IDs"),
                                             "result_datetime": qsTr("Date"),
                                             "result_success": qsTr("Success"),
                                             "result_duration": qsTr("Duration"),
                                             "result_data": qsTr("Data"),
                                             "result_day": qsTr("Date"),
                                             "count_activity": qsTr("Count"),
                                             "count_success": qsTr("Success"),
                                             "count_failed": qsTr("Failed"),
                                             "success_ratio": qsTr("Success ratio")
                                         })
    readonly property var columnsSize: ({
                                            "user_id": 80,
                                            "user_name": 150,
                                            "users_name": 500,
                                            "users_id": 300,
                                            "user_password": 200,
                                            "activity_id": 80,
                                            "activity_name": 250,
                                            "group_name": 130,
                                            "group_description": 200,
                                            "groups_name": 250,
                                            "groups_id": 150,
                                            "result_datetime": 150,
                                            "result_success": 80,
                                            "result_duration": 80,
                                            "result_data": 800,
                                            "result_day": 160,
                                            "count_activity": 100,
                                            "count_success": 80,
                                            "count_failed": 80,
                                            "success_ratio": 100
                                        })
    readonly property var columnsAlign: ({
                                             "user_id": Text.AlignHCenter,
                                             "user_name": Text.AlignLeft,
                                             "users_name": Text.AlignLeft,
                                             "users_id": Text.AlignLeft,
                                             "user_password": Text.AlignLeft,
                                             "activity_id": Text.AlignLeft,
                                             "activity_name": Text.AlignLeft,
                                             "group_name": Text.AlignLeft,
                                             "group_description": Text.AlignLeft,
                                             "groups_name": Text.AlignLeft,
                                             "groups_id": Text.AlignLeft,
                                             "result_datetime": Text.AlignLeft,
                                             "result_success": Text.AlignHCenter,
                                             "result_duration": Text.AlignHCenter,
                                             "result_data": Text.AlignLeft,
                                             "result_day": Text.AlignHCenter,
                                             "count_activity": Text.AlignHCenter,
                                             "count_success": Text.AlignHCenter,
                                             "count_failed": Text.AlignHCenter,
                                             "success_ratio": Text.AlignLeft
                                         })
}
