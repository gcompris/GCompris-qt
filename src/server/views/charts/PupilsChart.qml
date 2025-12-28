/* GCompris - PupilsChart.qml
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
import QtCharts
import "../../components"
import "../../singletons"
import "../../activities"

Item {
    id: pupilsChart
    anchors.margins: 2
    property string activityName: ""
    // initially hidden to avoid glitch visual while it's initialized.
    visible: false

    function executeRequest() {
        if (!databaseController.isDatabaseLoaded())
            return

//        console.warn(userList)
        var clauses = []
        clauses.push(`user_.user_id=result_.user_id`)
        if (userList.length !== 0)
            clauses.push(`user_.user_id in (` + userList.join(",") + `)`)

        var start = calendar.strDateToSql('20240101')       // Beginning of time for GCompris-Teachers. Nothing older.
        var end = calendar.strDateToSql(new Date().toLocaleString(calendar.locale, 'yyyyMMdd'))
        if (calendar.startDate !== "") {
            start = calendar.strDateToSql(calendar.startDate)
            end = calendar.strDateToSql(calendar.endDate)
        }
        start = start.substr(0, 10)
        end = end.substr(0, 10)
        clauses.push(`result_day BETWEEN '${start}' AND '${end}'`)
        var request =`SELECT user_.user_id, user_name
            , substr(result_datetime,0,11) AS result_day
            , count(result_.activity_id) AS count_activity
            FROM result_, user_ WHERE ` + clauses.join(" AND ") + ` GROUP BY result_.user_id, result_day`
//        console.warn(request)

        var jsonModel = JSON.parse(databaseController.selectToJson(request))

        mySeries.axisX.clear()
        mySeries.clear()
        var spots = {}
        for (var i = 0; i < jsonModel.length; i++) {
            if (!spots.hasOwnProperty(jsonModel[i].result_day))     // Create a spot for this day, if it doesn't exist
                spots[jsonModel[i].result_day] = {}
            spots[jsonModel[i].result_day][jsonModel[i].user_id] = jsonModel[i].count_activity
        }

        var valuesLength = Object.keys(spots).length
        var values = {}
        for (i = 0; i < userList.length; i++)
            values[userList[i]] = new Array(valuesLength).fill(0)      // Prepare one array of zeros for each user

        if (userList.length) {
            var position = 0
            for (var [key, value] of Object.entries(spots).sort()) {   // Replace some zeros with user count
                for (var [key_, value_] of Object.entries(value)) {
                    values[key_][position] = value_
                }
                position++
            }
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

    Component {
        id: lineReport
        LineReport {}
    }

    ChartView {
        anchors.fill: parent
        title: qsTr("User activities chart")
        legend.alignment: Qt.AlignBottom
        antialiasing: true
        backgroundRoundness: 0
        theme: Style.isDarkTheme ? ChartView.ChartThemeDark : ChartView.ChartThemeLight

        StackedBarSeries {
            id: mySeries
            axisX: BarCategoryAxis {
                labelsAngle: -90
            }

            onClicked: (index, barset) => {
//                    console.warn("Click:", index, barset.label)
                pupilsChart.parent.push(lineReport
                                , { userId: Number(barset.label)
                                    , activityId: -1
                                    , activityName: ""
                                    , dayFilter: mySeries.axisX.categories[index]
                                })
                pupilsChart.parent.currentItem.executeRequest()
            }

            onHovered: (status, index, barset) => {
                var user = Master.findObjectInModel(selector.pupilPane.foldModel
                                                    , function(item) { return item.user_id === Number(barset.label) })
                helpText.text = status ? mySeries.axisX.categories[index] + "   " + user.user_name : ""
            }
        }
        DefaultLabel {
            id: helpText
            x: Style.margins
            y: Style.margins
        }
        // workaround for a glitchy white pixel on top-left corner (visible mostly on dark theme)
        Rectangle {
            x: 0
            y: 0
            width: 2
            height: 2
            color: Style.selectedPalette.base
        }
    }

    Component.onCompleted: {
        visible = true;
        executeRequest();
    }
}
