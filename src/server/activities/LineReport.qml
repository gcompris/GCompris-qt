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
            sourceSize.height: parent.height * 0.9
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -height * 0.05 // little offset up as all icons have an empty area at the top
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
        width: topRow.width + Style.margins
        anchors.left: topRow.left
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
            spacing: Style.tinyMargins

            Repeater {
                model: resultModel
                delegate:  Rectangle {
                    id: lineRect
                    required property int user_id
                    required property int activity_id
                    required property bool result_success
                    required property var result_data
                    required property int result_duration
                    required property string result_datetime
                    property string activity_line_name: Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === activity_id }).activity_name
                    height: Math.max(dataDisplay.height, infos.height)
                    width: lines.width
                    color: Style.selectedPalette.alternateBase
                    radius: Style.defaultRadius
                    border.width: Style.defaultBorderWidth
                    border.color: Style.selectedPalette.accent

                    Row {
                        id: lineView
                        anchors.fill: parent
                        anchors.margins: Style.defaultBorderWidth
                        spacing: Style.smallMargins

                        Rectangle {  // Left side informations (name, level, date, success)
                            id: infosArea
                            width: infos.width + Style.margins * 2 + radius
                            height: parent.height
                            radius: Style.defaultRadius - Style.defaultBorderWidth
                            color: lineRect.result_success ? "#1600FF00" : "#16FF0000"

                            Rectangle {
                                id: radiusMask
                                width: infosArea.radius * 2
                                height: parent.height
                                anchors.horizontalCenter: parent.right
                                color: Style.selectedPalette.alternateBase
                            }

                            Column {
                                id: infos
                                x: Style.margins
                                anchors.verticalCenter: parent.verticalCenter

                                property int maxWidth: lineView.width * 0.5 - Style.margins * 2 - infosArea.radius

                                Item {
                                    height: Style.lineHeight
                                    width: childrenRect.width
                                    DefaultLabel {
                                        id: userNameLabel
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        font.bold: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: Master.findObjectInModel(Master.userModel, function(item) { return item.user_id === lineRect.user_id }).user_name
                                    }
                                }

                                // visible only in Charts (pupils mode)
                                Item {
                                    height: Style.lineHeight
                                    width: childrenRect.width
                                    visible: activityName === ""
                                    DefaultLabel {
                                        id: activityNameLabel
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.bold: true
                                        text: Master.allActivities[lineRect.activity_line_name].title
                                    }
                                }

                                Row {
                                    height: Style.lineHeight
                                    width: childrenRect.width
                                    spacing: Style.margins

                                    DefaultLabel {
                                        id: levelLabel
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Level: <b>%1</b>").arg(JSON.parse(lineRect.result_data).level)
                                    }

                                    ResultIndicator {
                                        resultSuccess: lineRect.result_success
                                    }
                                }

                                Item {
                                    height: Style.lineHeight
                                    width: Math.max(fakeResultDurationLabel.width, resultDurationLabel.width)
                                    DefaultLabel {
                                        id: resultDurationLabel
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        anchors.verticalCenter: parent.verticalCenter
                                        //: Result duration in seconds. Example: "Duration: 25s"
                                        text: qsTr("Duration: %1s").arg(lineRect.result_duration)
                                    }

                                    // Used to provide max width space for resultDurationLabel
                                    DefaultLabel {
                                        id: fakeResultDurationLabel
                                        visible: false
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        anchors.verticalCenter: parent.verticalCenter
                                        //: Result duration in seconds. Example: "Duration: 25s"
                                        text: qsTr("Duration: %1s").arg("0000")
                                    }
                                }

                                Item {
                                    height: Style.lineHeight
                                    width: childrenRect.width
                                    DefaultLabel {
                                        id: resultDateTimeLabel
                                        width: Math.min(implicitWidth, infos.maxWidth)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: lineRect.result_datetime.slice(-8)
                                    }
                                }
                            }
                        }

                        Loader {    // Load default DataDisplay or individual activity DataDisplay
                            id: dataDisplay
                            width: parent.width - parent.spacing * 2 - infosArea.width
                            anchors.verticalCenter: parent.verticalCenter
                            clip: true
                            source: {
                                var url = `${Master.activityBaseUrl}/${lineRect.activity_line_name}/DataDisplay.qml`
                                return file.exists(url) ? url : `${Master.activityBaseUrl}/DataDisplay.qml`
                            }
                            property var jsonData_: (typeof lineRect.result_data !== 'undefined') ? JSON.parse(lineRect.result_data) : ({})
                            property bool resultSuccess_: lineRect.result_success
                        }
                    }
                }
            }
        }
    }
}
