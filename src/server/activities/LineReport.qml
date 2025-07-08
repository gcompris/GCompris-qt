/* GCompris - LineReport.qml
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

import core 1.0

import "../singletons"
import "../components"

Item {
    id: lineReport
    property int userId: -1
    property int activityId: -1
    property string activityName: ""
    property string dayFilter: ""

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

    Item {
        id: topRow
        width: parent.width - Style.margins * 2
        height: Style.controlSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Style.margins

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Style.controlSize
            spacing: Style.margins

            ViewButton {
                width: 150
                height: Style.controlSize
                text: qsTr("Back")
                onClicked: lineReport.parent.pop()
            }
            ViewButton {
                width: 150
                height: Style.controlSize
                text: qsTr("Refresh")
                onClicked: lineReport.executeRequest()
            }

            DefaultLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Lines: %1").arg(resultModel.count)
                color: Style.selectedPalette.text
            }
        }
    }

    Item {
        id: reportTitle
        height: Style.lineHeight * 2
        width: topRow.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topRow.bottom

        Image {
            id: actiIcon
            source: (lineReport.activityName !== "") ?
            "qrc:/gcompris/src/activities/" + Master.allActivities[activityName]["icon"] : ""
            sourceSize.height: parent.height
        }

        DefaultLabel {
            id: actiName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: actiIcon.right
            anchors.leftMargin: Style.margins
            width: (parent.width -  2 * Style.margins - actiIcon.width) * 0.5
            font.bold: true
            text: (lineReport.activityName !== "") ?
            Master.allActivities[activityName]["title"] : ""
        }

        DefaultLabel {
            id: dateLabel
            width: actiName.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            font.bold: true
            text: new Date(lineReport.dayFilter).toLocaleDateString(Qt.locale())
        }
    }

    Flickable {
        id: scrollLines
        width: topRow.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: reportTitle.bottom
        anchors.bottom: parent.bottom
        contentWidth: width
        contentHeight: lines.height
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            contentItem: Rectangle {
                implicitWidth: 6
                radius: width
                color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
            }
        }

        Column {
            id: lines
            width: parent.width - 10 // margin for the ScrollBar
            height: childrenRect.height

            Repeater {
                model: resultModel
                delegate:  Rectangle {
                    id: lineRect
                    property string activity_line_name: Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === activity_id }).activity_name
                    height: Math.max(dataDisplay.height, infos.height) + 10
                    width: lines.width
                    color: Style.selectedPalette.alternateBase
                    radius: Style.defaultRadius
                    border.width: Style.defaultBorderWidth
                    border.color: Style.selectedPalette.accent
                    Rectangle {
                        anchors.top: lineView.top
                        anchors.left: lineView.left
                        anchors.margins: Style.defaultBorderWidth
                        width: 170
                        height: lineView.height - Style.defaultBorderWidth * 2
                        radius: Style.defaultRadius
                        color: result_success ? "green" : "red"
                        opacity: 0.2
                    }

                    Row {
                        id: lineView
                        anchors.fill: parent
                        spacing: Style.smallMargins
                        Column {        // Left side informations (level, date, success)
                            id: infos
                            height: childrenRect.height
                            width: 170
                            spacing: Style.smallMargins
                            anchors.verticalCenter: parent.verticalCenter
                            Row {
                                width: parent.width - Style.margins
                                height: Style.lineHeight
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: Style.smallMargins
                                DefaultLabel {
                                    id: userNameLabel
                                    width: parent.width - Style.smallMargins -
                                        resultDurationLabel.width
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.bold: true
                                    text: Master.findObjectInModel(Master.userModel, function(item) { return item.user_id === user_id }).user_name
                                }
                                DefaultLabel {
                                    id: resultDurationLabel
                                    width: Style.controlSize
                                    anchors.verticalCenter: parent.verticalCenter
                                    horizontalAlignment: Text.AlignRight
                                    text: qsTr("%1s").arg(result_duration)
                                }
                            }

                            Row {
                                width: parent.width - Style.margins
                                height: Style.lineHeight
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: Style.smallMargins
                                DefaultLabel {
                                    id: levelLabel
                                    width: (parent.width - parent.spacing) * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                    horizontalAlignment: Text.AlignLeft
                                    text: qsTr("Level: <b>%1</b>").arg(JSON.parse(result_data).level)
                                }
                                DefaultLabel {
                                    id: resultDateLabel
                                    width: levelLabel.width
                                    anchors.verticalCenter: parent.verticalCenter
                                    horizontalAlignment: Text.AlignRight
                                    text: result_datetime.slice(-8)
                                }
                            }
                        }

                        Loader {    // Load default DataDisplay or individual activity DataDisplay
                            id: dataDisplay
                            width: parent.width - parent.spacing * 3 -
                                infos.width - activityNameLabel.width
                            anchors.verticalCenter: parent.verticalCenter
                            source: {
                                var url = `${Master.activityBaseUrl}/${lineRect.activity_line_name}/DataDisplay.qml`
                                return file.exists(url) ? url : `${Master.activityBaseUrl}/DataDisplay.qml`
                            }
                            property var jsonData_: (typeof result_data !== 'undefined') ? JSON.parse(result_data) : ({})
                        }
                    }

                    DefaultLabel {
                        id: activityNameLabel
                        width: 170
                        anchors.right: lineView.right
                        anchors.rightMargin: Style.smallMargins
                        anchors.verticalCenter: parent.verticalCenter
                        text: Master.allActivities[lineRect.activity_line_name].title
                        horizontalAlignment: Text.AlignRight
                        visible: activityName === ""
                    }
                }
            }
        }
    }
}
