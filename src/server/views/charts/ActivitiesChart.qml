/* GCompris - ActivitiesChart.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtCharts 2.12

import "../../singletons"
import "../../activities"

Item {
    id: activitiesChart
    anchors.margins: 2

    function executeRequest() {
        if (!databaseController.isDatabaseLoaded())
            return
        var names = []
        var allNames = []
        for (var i = 0; i < Master.allActivitiesModel.count; i++) {
            var line = Master.allActivitiesModel.get(i)
            if (line.activity_checked)
                names.push(line.activity_name)
            allNames.push(line.activity_name)
        }
        if (names.length === 0) // if none is selected, select all
            names = allNames

        var clauses = []
        if (activityList.length !== 0)
            clauses.push(`activity_id in (` + activityList.join(",") + `)`)

        var start = calendar.strDateToSql('20240101')       // Beginning of time for GCompris-Teachers. Nothing older.
        var end = calendar.strDateToSql(new Date().toLocaleString(calendar.locale, 'yyyyMMdd'))
        if (calendar.startDate !== "") {
            start = calendar.strDateToSql(calendar.startDate)
            end = calendar.strDateToSql(calendar.endDate)
        }
        start = start.substr(0, 10)
        end = end.substr(0, 10)
        clauses.push(`result_day BETWEEN '${start}' AND '${end}'`)
        var request =`SELECT * FROM _daily_activities WHERE ` + clauses.join(" AND ")
//        console.warn(request)

        var jsonModel = JSON.parse(databaseController.selectToJson(request))
        mySeries.axisX.clear()
        mySeries.clear()
        var spots = {}
        for (i = 0; i < jsonModel.length; i++) {
            if (!spots.hasOwnProperty(jsonModel[i].result_day))     // Create a spot for this day, if it doesn't exist
                spots[jsonModel[i].result_day] = {}
            spots[jsonModel[i].result_day][jsonModel[i].activity_name] = jsonModel[i].count_activity
        }

        var valuesLength = Object.keys(spots).length
        var values = {}
        for (i = 0; i < names.length; i++)
            values[names[i]] = new Array(valuesLength).fill(0)      // Prepare one array of zeros for each activity name

        var position = 0

        for (var [key, value] of Object.entries(spots).sort()) {   // Replace some zeros with activity count
            for (var [key_, value_] of Object.entries(value)) {
                values[key_][position] = value_
            }
            position++
        }

        for (var [activity, vals] of Object.entries(values)) {      // BarSets are created in this loop
            mySeries.append(activity, vals)
        }

        var max = 10    // Find maximum value to scale graph
        for (i = 0; i < valuesLength; i++) {
            var colMax = 0
            for (var [activity, vals] of Object.entries(values))
                colMax += vals[i]
            max = Math.max(max, colMax)
        }
        mySeries.axisX.categories = Object.keys(spots).sort()       // Set axis
        mySeries.axisY.min = 0
        mySeries.axisY.max = (Math.floor(max / 10) + 1) * 10
    }

    Rectangle {
        anchors.fill: parent
        color: Style.colorBackground

        Component {
            id: lineReport
            LineReport {}
        }

        ChartView {
            anchors.fill: parent
            title: "Daily activities chart"
            legend.alignment: Qt.AlignBottom
            antialiasing: true

            StackedBarSeries {
                id: mySeries
                axisX: BarCategoryAxis {
                    labelsAngle: -90
                }
                onClicked: (index, barset) => {
//                    console.warn("Click:", index, barset.label)
                    activitiesChart.parent.push(lineReport
                                    , { userId: -1
                                        , activityId: Master.findObjectInModel(Master.allActivitiesModel, function(item) { return item.activity_name === barset.label }).activity_id
                                        , activityName: barset.label
                                        , dayFilter: mySeries.axisX.categories[index]
                                    })
                    activitiesChart.parent.currentItem.executeRequest()
                }
                onHovered: (status, index, barset) => helpText.text = status ? mySeries.axisX.categories[index] + "   " + Master.allActivities[barset.label].title : ""
            }
            Text {
                id: helpText
                x: 10
                y: 10
            }
        }
    }

    Component.onCompleted: {
        executeRequest()
    }
}
