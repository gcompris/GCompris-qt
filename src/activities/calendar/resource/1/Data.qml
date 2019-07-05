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

/*
Contains the questions, answers and calendar configurations of every level.
Add more levels by inserting questions and answers below.
Days of weeks are indexed from 0 i.e (Sunday = 0, Monday = 1, Tuesday = 2, .... ..... .... , Saturday = 6)
Months of year are indexed from 0 i.e (January = 0, February = 1, March = 2, .... ..... ...., December = 11)
If questions are provided explicitly field questionAnswers contains an array of questions and answers and
if they are not provided, then questionAnswers field contains parameter length signifying the number of questions, and optional
parameter maxOffset for questions where the user has to find date some days ahead of the given date.
[
    //MODES
      // findMonthOnly --> For questions based on finding month only.
      // findYearMonthDay --> For questions based on finding year, month and day.
      // findDayOfWeek --> For questions based on finding day of week only.
      // findDay --> For questions based on finding day of a given month and year.
 ]
*/

Dataset {
    objective: qsTr("Calendar Questions for a single month")
    difficulty: 1
    data: [
    {
        "navigationBarVisible" : false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDay",
        "questionsExplicitlyGiven": false,
        "questionAnswers": {
            "length": 5
        }
    },
    {
        "navigationBarVisible" : false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Select day 23"),
                "answer": {"year": 2018, "month": 2, "day": 23}
            },
            {
                "question": qsTr("Select day 1"),
                "answer": {"year": 2018, "month": 2, "day": 1}
            },
            {
                "question": qsTr("Select day 16"),
                "answer": {"year": 2018, "month": 2, "day": 16}
            },
            {
                "question": qsTr("Select day 28"),
                "answer": {"year": 2018, "month": 2, "day": 28}
            },
            {
                "question": qsTr("Select day 11"),
                "answer": {"year": 2018, "month": 2, "day": 11}
            },
            {
                "question": qsTr("Select day 20"),
                "answer": {"year": 2018, "month": 2, "day": 20}
            }
        ]
    },
    {
        "navigationBarVisible" : false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDayOfWeek",
        "questionsExplicitlyGiven": false,
        "questionAnswers": {
            "length": 7
        }
    },
    {
        "navigationBarVisible" : false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDayOfWeek",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("What day of week is the 4th of given month?"),
                "answer": {"dayOfWeek": 0}
            },
            {
                "question": qsTr("What day of the week is the 12th of given month?"),
                "answer": {"dayOfWeek": 1}
            },
            {
                "question": qsTr("What day of the week is the 20th of given month?"),
                "answer": {"dayOfWeek": 2}
            },
            {
                "question": qsTr("What day of the week is the 28th of given month?"),
                "answer": {"dayOfWeek": 3}
            },
            {
                "question": qsTr("What day of the week is the 22nd of given month?"),
                "answer": {"dayOfWeek": 4}
            },
            {
                "question": qsTr("What day of the week is the 16th of given month?"),
                "answer": {"dayOfWeek": 5}
            },
            {
                "question": qsTr("What day of the week is the 10th of given month?"),
                "answer": {"dayOfWeek": 6}
            }
        ]
    },
    {
        "navigationBarVisible": false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Select a Monday between days 1 and 7 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 5}
            },
            {
                "question": qsTr("Select a Tuesday between days 8 and 16 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 13}
            },
            {
                "question": qsTr("Select a Wednesday between days 15 and 22 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 21}
            },
            {
                "question": qsTr("Select a Thursday between days 26 and 31 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 29}
            },
            {
                "question": qsTr("Select a Friday between days 20 and 25 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 23}
            },
            {
                "question": qsTr("Select a Saturday between days 13 and 23 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 17}
            },
            {
                "question": qsTr("Select a Sunday between days 5 and 17 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 11}
            }
        ]
    },
    {
        "navigationBarVisible" : false,
        "minimumDate": "2018-03-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Select a Monday between days 1 and 7 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 5}
            },
            {
                "question": qsTr("Select a Tuesday between days 8 and 16 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 13}
            },
            {
                "question": qsTr("Select a Wednesday between days 15 and 22 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 21}
            },
            {
                "question": qsTr("Select a Thursday between days 26 and 31 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 29}
            },
            {
                "question": qsTr("Select a Friday between days 20 and 25 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 23}
            },
            {
                "question": qsTr("Select a Saturday between days 13 and 23 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 17}
            },
            {
                "question": qsTr("Select a Sunday between days 5 and 17 of given month"),
                "answer": {"year": 2018, "month": 2, "day": 11}
            }
        ]
    }
    ]
}
