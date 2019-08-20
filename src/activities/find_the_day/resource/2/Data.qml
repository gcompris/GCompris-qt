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
    objective: qsTr("Find the date less than two month away")
    difficulty: 5
    data: [
    {
       "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-03-31",
        "visibleMonth": 1,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": false,
        "questionAnswers": {
            "length": 5,
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
            "maxOffset": 30
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
            "maxOffset": 45
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
            "maxOffset": 60
        }
    },
    {
        "navigationBarVisible": true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-12-31",
        "visibleMonth": 7,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Find the date 2 weeks and 3 days after January 12."),
                "answer": {"year": 2018, "month": 0, "day": 29}
            },
            {
                "question": qsTr("Find the date 3 weeks and 2 days after March 22."),
                "answer": {"year": 2018, "month": 3, "day": 14}
            },
            {
                "question": qsTr("Find the date 5 weeks and 6 days after October 5."),
                "answer": {"year": 2018, "month": 10, "day": 15}
            },
            {
                "question": qsTr("Find the date 1 week and 1 day before August 8."),
                "answer": {"year": 2018, "month": 6, "day": 31}
            },
            {
                "question": qsTr("Find the date 2 weeks and 5 days before July 2."),
                "answer": {"year": 2018, "month": 5, "day": 13}
            }
        ]
    }
    ]
}
