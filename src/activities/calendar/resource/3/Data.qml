/* GCompris - Data.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../../../core"

Dataset {
    objective: qsTr("Calendar Questions involving several months")
    difficulty: 2
    data: [
    {
       "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-12-31",
        "visibleMonth": 1,
        "visibleYear": 2018,
        "mode": "findMonthOnly",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
             {
                "question": qsTr("Find the month starting a Thursday and having 28 days"),
                "answer": {"month": [1]}
            },
            {
                "question": qsTr("Find a month starting a Monday and having 31 days"),
                "answer": {"month": [0, 9]}
            },
            {
                "question": qsTr("Find the month between June and August"),
                "answer": {"month": [6]}
            },
            {
                "question": qsTr("Find a month starting a Saturday"),
                "answer": {"month": [8, 11]}
            },
            {
                "question": qsTr("Find a month having 30 days"),
                "answer": {"month": [3, 5, 8, 10]}
            }
        ]
    },    
    {
       "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2019-12-31",
        "visibleMonth": 10,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": false,
        "questionAnswers": {
            "length": 5,
            "maxOffset": 90
        }
    },
    {
       "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2019-12-31",
        "visibleMonth": 10,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": false,
        "questionAnswers": {
            "length": 5,
            "maxOffset": 120
        }
    },
    {
      "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2019-12-31",
        "visibleMonth": 10,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Find the first Monday of January month of year 2019"),
                "answer": {"year": 2019, "month": 0, "day": 7}
            },
            {
                "question": qsTr("Find the second Wednesday of February month of year 2019"),
                "answer": {"year": 2019, "month": 1, "day": 13}
            },
            {
                "question": qsTr("Find the third Friday of March month of year 2019"),
                "answer": {"year": 2019, "month": 2, "day": 15}
            },
            {
                "question": qsTr("Find the fifth Sunday of April month of year 2018"),
                "answer": {"year": 2018, "month": 3, "day": 29}
            },
            {
                "question": qsTr("Find the fourth Tuesday of July month of year 2018"),
                "answer": {"year": 2018, "month": 6, "day": 24}
            },
            {
                "question": qsTr("Find the first Monday of August month of year 2018"),
                "answer": {"year": 2018, "month": 7, "day": 6}
            },
            {
                "question": qsTr("Find the third Thursday of September month of year 2017"),
                "answer": {"year": 2017, "month": 8, "day": 21}
            },
            {
                "question": qsTr("Find the fifth Sunday of October month of year 2017"),
                "answer": {"year": 2017, "month": 9, "day": 29}
            },
            {
                "question": qsTr("Find the second Friday of December month of year 2017"),
                "answer": {"year": 2017, "month": 11, "day": 8}
            }
        ]
    }
    ]
}
