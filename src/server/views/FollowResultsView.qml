/* GCompris - FollowResultView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.12

import "../components"
import "../../core"
import "."

Item {
    property var currentData
    property var currentDataPerDay
    property var currentSelectedPoint: undefined

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: headerText.height
        color: Style.colourBackground
        Text {
            id: headerText
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.StyledText
            text: qsTr("Follow Results view")
        }
    }

    ListView {
        anchors.top: header.bottom
        anchors.bottom: commandBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        model: currentData
        headerPositioning: ListView.OverlayHeader
        header: Item {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 30
            Text {
                text: currentSelectedPoint ? qsTr("Result for %1").arg(new Date(parseInt((currentSelectedPoint))).toLocaleDateString()) : qsTr("All results")
            }
        }
        delegate: Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: new Date(modelData.date) + ": " + modelData.goodAnswer
            color: modelData.goodAnswer ? "green": "red"
        }
    }

    // Week selector below the chart
    Rectangle {
        id: weekSelector
        anchors.top: chartView.bottom
        anchors.horizontalCenter: chartView.horizontalCenter
        height: 40
        width: chartView.width
        color: "#f2f2f2"

        property int currentWeek: 1
        BarButton {
            id: previousWeek
            height: parent.height * 0.8
            width: previousWeek.height
            sourceSize.height: previousWeek.height
            sourceSize.width: previousWeek.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.height * 0.1
            source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
            rotation: 90
            onClicked: {
                chartView.showPreviousWeek();
            }
        }
        GCText {
            id: dateText
            text: qsTr("%1 - %2").arg(chartXAxis.min.toLocaleDateString('en-GB')).arg(chartXAxis.max.toLocaleDateString('en-GB'))
            color: "#373737"
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: previousWeek.right
            anchors.leftMargin: 2
            anchors.right: nextWeek.left
            anchors.rightMargin: 2
        }
        BarButton {
            id: nextWeek
            height: previousWeek.height
            width: nextWeek.height
            sourceSize.height: nextWeek.height
            sourceSize.width: nextWeek.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: previousWeek.anchors.leftMargin
            source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
            rotation: 270
            onClicked: {
                chartView.showNextWeek();
            }
        }
    }

    ChartView {
        id: chartView
        width: 400
        height: 300
        theme: ChartView.ChartThemeLight
        antialiasing: true
        visible: currentDataPerDay != undefined
        ValueAxis {
            id: chartYAxis
            min: 0
            max: 100
            titleFont.pointSize: 10
        }

        DateTimeAxis {
            id: chartXAxis
            format: "dd/MM" // https://doc.qt.io/qt-5/qdatetime.html#toString-2
            tickCount: 7 // One per day
            //labelsColor: "white"
            gridVisible: false
            lineVisible: true
            titleText: qsTr("Date (dd/MM)")
            titleFont.pointSize: 10
        }
        LineSeries {
            id: lineSeries
            name: qsTr("Good answers ratio")
            axisX: chartXAxis
            axisY: chartYAxis
            /*onPointAdded: {
                print("point added", index, at(index).x, at(index).y)
            }*/

            onClicked: {
                print("point clicked", point.x, point.y)
                    
                var closestPoint;

                // currentDataPerDay indices are sorted
                // We look for the closest one below and above, and we take the small difference
                for(var index in currentDataPerDay) {
                    if(index > point.x) {
                        if((index - point.x) < (point.x - closestPoint)) {
                            closestPoint = index;
                        }
                        continue;
                    }
                    closestPoint = index;
                }
                // We unselect the previous point if we select the same one
                if(currentSelectedPoint == closestPoint) {
                    currentSelectedPoint = undefined;
                    return;
                }

                currentSelectedPoint = closestPoint;
                print("closest point clicked", currentSelectedPoint, currentDataPerDay[currentSelectedPoint])
            }
        }

        function addDaysToDate(dateToUpdate, daysToAdd) {
            var date = dateToUpdate;
            date.setDate(date.getDate()+daysToAdd);
            return date;
        }
        function showPreviousWeek() {
            chartXAxis.max = chartXAxis.min;
            chartXAxis.min = addDaysToDate(chartXAxis.min, -7);
        }
        function showNextWeek() {
            chartXAxis.min = chartXAxis.max;
            chartXAxis.max = addDaysToDate(chartXAxis.max, 7);
        }
    }

    Connections {
        target: masterController.ui_navigationController
        onGoShowPupilActivitiesDataDialog: selectResultsDialog.open()
    }

    SelectResultsDialog {
        id: selectResultsDialog

        label: qsTr("Select a pupil, the activity and the range")

        onAccepted: {
            console.log("selected", pupilName, activityName)
            // todo fetch from database. At some point, do we want a local cache?
            var results = masterController.getActivityData(pupilName, activityName)
            var dataInArray = new Array();
            var dataInChart = {};
            for(var index in results) {
                var result = JSON.parse(results[index]);

                // Only get the YYMMDD of the date
                var date = result.date - result.date % (1000*60*60*24);
                var currentDataForThisDate = dataInChart[date];
                if(currentDataForThisDate == null) {
                    currentDataForThisDate = {"goodAnswer": 0, "totalAnswer": 0};
                }
                currentDataForThisDate["totalAnswer"] = currentDataForThisDate["totalAnswer"]+1;
                currentDataForThisDate["goodAnswer"] = (result.goodAnswer ? currentDataForThisDate.goodAnswer + 1: currentDataForThisDate.goodAnswer);
                dataInChart[date] = currentDataForThisDate;
                // Push global data (for text)
                dataInArray.push(result);
            }
            currentDataPerDay = dataInChart;
            print(JSON.stringify(currentDataPerDay));
            for(var index in currentDataPerDay) {
                lineSeries.append(parseInt(index), 100*currentDataPerDay[index].goodAnswer/currentDataPerDay[index].totalAnswer);

                // Probably optimisable, we select the min/max date being the latest week with result
                chartXAxis.min = new Date(parseInt(index - index % (1000*60*60*24*7)));
                chartXAxis.max = new Date(parseInt(index));
            }
            currentData = dataInArray;
            selectResultsDialog.close()
        }
    }

    CommandBar {
        id: commandBar
        commandList: masterController.ui_commandController.ui_followResultViewContextCommands
    }
}
