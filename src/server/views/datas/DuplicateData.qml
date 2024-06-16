/* GCompris - DuplicateData.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Basic
import "../../singletons"
import "../../components"
import "../../panels"

Item {
    id: pupilsData
    property int groupId: Master.groupFilterId
    property var userList: []
    property var activityList: []
    property var randomDate: null
    anchors.margins: 2

    function executeRequest() {
        reqView.request = ""
        var clauses = []
        if (userList.length === 0) {
            if (groupId !== -1)
                clauses.push(`user_id IN (SELECT user_id FROM group_user_ WHERE group_id=${groupId})`)
        } else {
            clauses.push(`user_id in (` + userList.join(",") + `)`)
        }
        if (activityList.length !== 0)
            clauses.push(`activity_id in (` + activityList.join(",") + `)`)
        if (selector.calendar.startDate !== "") {
            var start = selector.calendar.strDateToSql(selector.calendar.startDate)
            var end = selector.calendar.strDateToSql(selector.calendar.endDate).replace('00:00:00', '23:59:59')
            clauses.push(`result_datetime BETWEEN '${start}' AND '${end}'`)
        }
        if (clauses.length)
            reqView.request = `SELECT * FROM _all_users_activities WHERE ` + clauses.join(" AND ") + ` ORDER BY result_datetime`
//        if (reqView.request !== "") console.warn(reqView.request)
        reqView.executeRequest()
    }

    function newRandomDate() {
        var start = new Date(2024, 0, 1)
        var end = new Date()
        var startHour = 8
        var endHour =  22
        randomDate = new Date(+start + Math.random() * (end - start));
        var hour = startHour + Math.random() * (endHour - startHour) | 0;
        randomDate.setHours(hour);
        dateText.text = randomDate.toLocaleDateString(Qt.locale(), 'yyyy-MM-dd') +
                        randomDate.toLocaleTimeString(Qt.locale(), ' hh:mm:ss')
    }

    function duplicateData() {
        var destUser = Master.userModel.get(allPupilPane.currentChecked)
        var dateFirst = new Date(reqView.linesModel.get(0).result_datetime)
        var timeDiff = randomDate.getTime() - dateFirst.getTime()
        var nowDate = new Date()
        var nbAdded = 0

        for (var i = 0; i < reqView.linesModel.count; i++) {
            var line = JSON.parse(JSON.stringify(reqView.linesModel.get(i)))
            var date = new Date(line.result_datetime)
            date.setTime(date.getTime() + timeDiff);
            if (date > nowDate) {
                console.warn("Exit from the future duplicating data.")
                break
            }
            line["user_id"] = destUser["user_id"]
            line["result_datetime"] = date.toLocaleDateString(Qt.locale(), 'yyyy-MM-dd') + date.toLocaleTimeString(Qt.locale(), ' hh:mm:ss')
            delete line["user_name"]
            delete line["activity_name"]
            line.result_data = line.result_data.replace(/'/g, "\\'")
            var request = `INSERT INTO result_ (user_id, activity_id, result_datetime, result_success, result_duration, result_data)
            VALUES (${line.user_id}, ${line.activity_id}, "${line.result_datetime}",
                    ${line.result_success}, ${line.result_duration}, '${line.result_data}')`
            if (databaseController.doRequest(request) === 0)    // Add duplicate data into database
                nbAdded++
        }
        lastAction.text = nbAdded + " lines duplicated"
        newRandomDate()
    }

    function deleteData() {
        var nbDeleted = 0
        for (var i = 0; i < reqView.linesModel.count; i++) {
            var line = JSON.parse(JSON.stringify(reqView.linesModel.get(i)))
            var request = `DELETE FROM result_
            WHERE user_id=${line.user_id} AND activity_id=${line.activity_id} AND result_datetime='${line.result_datetime}'`
            if (databaseController.doRequest(request) === 0)    // Delete selected data from database
                nbDeleted++
        }
        lastAction.text = nbDeleted + " lines deleted"
        executeRequest()
    }

    Rectangle {
        anchors.fill: parent
        color: Style.colorBackground

        SplitView {
            anchors.fill: parent

            SelectorPanel {
                id: selector
                SplitView.preferredWidth: minWidth
                SplitView.minimumWidth: minWidth
                SplitView.maximumHeight: parent.height

                calendar.onCalendarChanged: pupilsData.executeRequest()

                groupPane.onSelectionClicked: (modelId, checked) => {
                    groupId = modelId
                    userList = []
                    activityList = []
                    if (groupId === -1) {
                        Master.unCheckModel(Master.groupModel, "group_checked")
                        Master.loadAllActivities(activityPane.foldModel)
                    } else {
                        Master.filterUsers(pupilPane.foldModel, false)
                        Master.loadGroupActivities(activityPane.foldModel, groupId)
                    }
                    pupilsData.executeRequest()
                }

                pupilPane.onSelectionClicked: (modelId, checked) => {
                    Master.foldDownToList(pupilPane, userList, modelId, checked)
                    activityName = ""
                    activityPane.currentChecked = -1
                    if (userList.length === 0) {
                        Master.loadAllActivities(activityPane.foldModel)
                        activityList = []
                    } else {
                        Master.loadUserActivities(activityPane.foldModel, userList, activityList, true)
                    }
                    pupilsData.executeRequest()
                }

                activityPane.onSelectionClicked: (modelId, checked) => {
                    Master.foldDownToList(activityPane, activityList, modelId, checked)
                    pupilsData.executeRequest();
                }
            }

            RequestPanel {
                id: reqView
                SplitView.fillWidth: true
                request: ""
                wantedColumns: [ "user_name", "activity_name", "result_datetime", "result_duration", "result_success"]
            }

            Rectangle {
                id: buttonsColumn
                SplitView.preferredWidth: 250
                SplitView.minimumWidth: 250
                SplitView.maximumWidth: 300
                SplitView.fillHeight: true
                color: Style.colorBackground
                enabled: serverRunning

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 5

                    Rectangle {
                        Layout.fillWidth: true
                        height: Style.defaultLineHeight
                        color: Style.colorHeaderPane
                        radius: 5
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            text: qsTr("Commands")
                            color: enabled ? "black": "gray"
                        }
                    }

                    Text {
                        id: dateText
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.defaultLineHeight
                        horizontalAlignment: Text.AlignHCenter
                        color: enabled ? "black": "gray"
                    }

                    ViewButton {
                        id: newRandomDateButton
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 5
                        width: 200
                        text: qsTr("Random date")
                        onClicked: newRandomDate()
                    }

                    ViewButton {
                        id: duplicateButton
                        Layout.alignment: Qt.AlignHCenter
                        width: 200
                        text: qsTr("Duplicate")
                        enabled: (reqView.count && (allPupilPane.currentChecked !== -1)) ? true : false
                        opacity: enabled ? 1.0 : 0.5
                        onClicked: {
                            errorDialog.message = [qsTr("You are about to duplicate datas"), qsTr("No action now")]
                            errorDialog.open()
//                            duplicateData()
                        }
                    }

                    ViewButton {
                        id: deleteButton
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 5
                        width: 200
                        text: qsTr("Delete")
                        enabled: reqView.count ? true : false
                        opacity: reqView.count ? 1.0 : 0.5
                        onClicked: {
                            errorDialog.message = [qsTr("You are about to delete datas"), qsTr("No action now")]
                            errorDialog.open()
//                            deleteData()
                        }
                    }

                    Text {
                        id: lastAction
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    FoldDownRadio {
                        id: allPupilPane
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width
                        Layout.bottomMargin: 10
                        title: qsTr("Copy to")
                        foldModel: Master.userModel
                        indexKey: "user_id"
                        nameKey: "user_name"
                        checkKey: "user_checked"
                        collapsable: false
                    }
                }
            }

        }
    }
    Component.onCompleted: newRandomDate()
}
