/* GCompris - LineReport.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
// pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import core 1.0

import "../singletons"
import "../components"

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
        Layout.preferredHeight:30
        ViewButton {
            Layout.preferredWidth: 100
            Layout.preferredHeight:26
            text: qsTr("Back")
            onClicked: lineReport.parent.pop()
        }
        ViewButton {
            Layout.preferredWidth: 100
            Layout.preferredHeight:26
            text: qsTr("Refresh")
            onClicked: lineReport.executeRequest()
        }

        Text {
            text: resultModel.count + " " + qsTr("lines")
            color: Style.selectedPalette.text
        }

        Item {
            Layout.fillWidth: true
        }
        Text {
            Layout.rightMargin: 15
            text: lineReport.activityName
            opacity: 0.4
            color: Style.selectedPalette.text
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: Style.bigLineHeight
        Layout.maximumHeight: Style.bigLineHeight
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        Layout.topMargin: 5
        Layout.preferredWidth: lines.width
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
                color: Style.selectedPalette.text
            }

            Text {
                id: dateLabel
                Layout.preferredWidth: 230
                Layout.leftMargin: 20
                text: new Date(lineReport.dayFilter).toLocaleDateString(Qt.locale())
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                clip: true
                color: Style.selectedPalette.text
            }

            Text {
                id: actiName
                Layout.fillWidth: true
                text: (lineReport.activityName !== "") ? Master.allActivities[activityName]["title"] : ""
                font.pixelSize: 18
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                clip: true
                color: Style.selectedPalette.text
            }

            Image {
                Layout.preferredWidth: Style.bigLineHeight
                Layout.preferredHeight: Style.bigLineHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.rightMargin: 5
                source: (lineReport.activityName !== "") ? "qrc:/gcompris/src/activities/" + Master.allActivities[activityName]["icon"] : ""
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
            spacing: 0
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: Rectangle {
                id: lineRect
                property string activity_line_name: Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === activity_id }).activity_name
                height: Math.max(dataDisplay.height, infos.height) + 10
                width: lines.width
                color: "white"
                radius: 3
                border.width: 1
                border.color: Style.selectedPalette.accent
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
                        Layout.preferredWidth: 170
                        RowLayout {
                            width: parent.width
                            height: Style.lineHeight
                            Text {
                                Layout.fillWidth: true
                                font.pixelSize: Style.textSize
                                text: Master.findObjectInModel(Master.userModel, function(item) { return item.user_id === user_id }).user_name
                                // font.underline: true
                                color: Style.selectedPalette.text
                            }
                            Text {
                                Layout.preferredWidth: 25
                                font.pixelSize: Style.textSize
                                Layout.preferredHeight: 20
                                horizontalAlignment: Text.AlignRight
                                text: qsTr("%1s").arg(result_duration)
                                color: Style.selectedPalette.text
                            }
                        }

                        RowLayout {
                            width: parent.width
                            height: Style.lineHeight
                            Text {
                                Layout.preferredWidth: 75
                                Layout.preferredHeight: 20
                                font.pixelSize: Style.textSize
                                text: qsTr("Level: <b>%1</b>").arg(JSON.parse(result_data).level)
                                horizontalAlignment: Text.AlignLeft
                                color: Style.selectedPalette.text
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20
                                font.pixelSize: Style.textSize
                                text: result_datetime.slice(-8)
                                horizontalAlignment: Text.AlignRight
                                color: Style.selectedPalette.text
                            }
                        }
                    }

                    Loader {    // Load default DataDisplay or individual activity DataDisplay
                        id: dataDisplay
                        Layout.fillWidth: true
                        Layout.leftMargin: 5
                        Layout.alignment: Qt.AlignTop
                        source: {
                            var url = `${Master.activityBaseUrl}/${lineRect.activity_line_name}/DataDisplay.qml`
                            return file.exists(url) ? url : `${Master.activityBaseUrl}/DataDisplay.qml`
                        }
                        property var jsonData_: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
                    }
                }

                Text {
                    anchors.top: lineView.top
                    anchors.right: lineView.right
                    anchors.rightMargin: 5
                    color: Style.selectedPalette.text
                    height: 20
                    text: Master.allActivities[lineRect.activity_line_name].title
                    horizontalAlignment: Text.AlignRight
                    visible: activityName === ""
                }

            }
        }
    }
}
