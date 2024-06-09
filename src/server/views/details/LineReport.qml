/* GCompris - LineReport.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GCompris 1.0
import "../../singletons"
import "../../components"
import "../../panels"

ColumnLayout {
    id: lineReport
    property int userId: -1
    property int activityId: -1
    property string activityName: ""
    property string dayFilter: ""
    spacing: 0

    function executeRequest() {
        resultModel.clear()
        var clauses = []
        if (activityId !== -1)
            clauses.push(`activity_id=${activityId}`)
        if (userId !== -1)
            clauses.push(`user_id=${userId}`)
        var user = Master.findObjectInModel(Master.userModel, function(item) { return item.user_id === userId })
//        title.text = user.user_name
        var request = `SELECT *, date(result_datetime) AS result_day FROM result_ WHERE ` + clauses.join(" AND ")
        if (dayFilter !== "")
            request += ` AND result_day='${dayFilter}'`
        request += ` ORDER BY result_datetime`
//        console.warn(request)
        Master.modelFromRequest(resultModel, request)
    }

    File { id: file }

    ListModel { id: resultModel }

    RowLayout {
        Layout.leftMargin: 10
        Button {
            text: qsTr("Back")
            onClicked: lineReport.parent.pop()
        }
        Button {
            text: qsTr("Refresh")
            onClicked: executeRequest()
        }
        Text {
            text: resultModel.count + " " + qsTr("lines")
        }

        Item {
            Layout.fillWidth: true
        }
        Text {
            Layout.rightMargin: 15
            text: activityName
            opacity: 0.4
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: Style.activityHeaderHeight
        Layout.maximumHeight: Style.activityHeaderHeight
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        Layout.topMargin: 5
        width: lines.width
        color: "white"
        radius: 3
        clip: true
        border.width: 1
        border.color: "black"
        RowLayout {     // Page header (user and activity names, activity icon)
            anchors.fill: parent
            spacing: 5

            Text {
                id: title
                Layout.leftMargin: 5
                text: ""
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
            }

            Text {
                id: dateLabel
                Layout.preferredWidth: 230
                Layout.leftMargin: 20
                text: new Date(dayFilter).toLocaleDateString(Qt.locale())
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                clip: true
            }

            Text {
                id: actiName
                Layout.fillWidth: true
                text: (activityName !== "") ? Master.allActivities[activityName]["title"] : ""
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                clip: true
            }

            Image {
                Layout.preferredWidth: Style.activityHeaderHeight
                Layout.preferredHeight: Style.activityHeaderHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.rightMargin: 5
                source: (activityName !== "") ? "qrc:/gcompris/src/activities/" + Master.allActivities[activityName]["icon"] : ""
                sourceSize.width: 100
                sourceSize.height: 100
            }

        }
    }

    ScrollView {
        id: scrollLines
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        ListView {
            id: lines
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: scrollLines.contentWidth
            model: resultModel
            spacing: Style.linesSpacing
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: Rectangle {
                property string activity_line_name: Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === activity_id }).activity_name
                height: Math.max(dataDisplay.height, infos.height) + 10
                width: lines.width
                color: "white"
                radius: 3
                border.width: 1
                border.color: "lightgray"
                Rectangle {
                    anchors.top: lineView.top
                    anchors.left: lineView.left
                    anchors.margins: 3
                    width: 175
                    height: lineView.height - 6
                    radius: 3
                    color: result_success ? Qt.lighter("palegreen", 1.3) : Qt.lighter("lightcoral", 1.4)
                }

                RowLayout {
                    id: lineView
                    anchors.fill: parent
                    spacing: 5
                    Column {        // Left side informations (level, date, success)
                        id: infos
                        Layout.margins: 5
                        Layout.alignment: Qt.AlignTop
                        width: 170
                        RowLayout {
                            width: parent.width
                            Text {
                                Layout.fillWidth: true
                                text: Master.findObjectInModel(Master.userModel, function(item) { return item.user_id === user_id }).user_name
                                font.underline: true
                            }
                            Text {
                                Layout.preferredWidth: 25
                                height: 20
                                horizontalAlignment: Text.AlignRight
                                text: qsTr("%1s").arg(result_duration)
                            }
                        }
                        RowLayout {
                            width: parent.width
                            Text {
                                Layout.preferredWidth: 75
                                height: 20
                                text: qsTr("Level: <b>%1</b>").arg(JSON.parse(result_data).level)
                                horizontalAlignment: Text.AlignLeft
                            }
                            Text {
                                Layout.fillWidth: true
                                height: 20
                                text: result_datetime.slice(-8)
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }

                    Loader {    // Load default DataDisplay or individual activity DataDisplay
                        id: dataDisplay
                        Layout.fillWidth: true
                        Layout.leftMargin: 5
                        Layout.alignment: Qt.AlignTop
                        source: {
                            var url = `${Master.activityBaseUrl}/${activity_line_name}/DataDisplay.qml`
                            return file.exists(url) ? url : `${Master.activityBaseUrl}/DataDisplay.qml`
                        }
                    }
                }

                Text {
                    anchors.top: lineView.top
                    anchors.right: lineView.right
                    anchors.rightMargin: 5
                    color: "gray"
                    height: 20
                    text: Master.allActivities[activity_line_name].title
                    horizontalAlignment: Text.AlignRight
                    visible: activityName === ""
                }

            }
        }
    }
}
