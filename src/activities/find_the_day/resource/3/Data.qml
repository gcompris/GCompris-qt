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
    objective: qsTr("Find the date several months away")
    difficulty: 6
    data: [
    {
       "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-12-31",
        "visibleMonth": 0,
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
            "maxOffset": 60
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
            "maxOffset": 90
        }
    },
    {
        "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-12-31",
        "visibleMonth": 7,
        "visibleYear": 2018,
        "mode": "findDayOfWeek",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Find day of week 5 months and 2 days after July 3."),
                "answer": {"dayOfWeek": 3}
            },
            {
                "question": qsTr("Find day of week 2 months and 4 days after October 8."),
                "answer": {"dayOfWeek": 3}
            },
            {
                "question": qsTr("Find day of week 1 month and 3 days before December 28."),
                "answer": {"dayOfWeek": 0}
            },
            {
                "question": qsTr("Find day of week 8 months and 7 days after February 28."),
                "answer": {"dayOfWeek": 0}
            },
            {
                "question": qsTr("Find day of week 3 months and 3 days before September 15."),
                "answer": {"dayOfWeek": 2}
            }
        ]
    },
    {
        "navigationBarVisible" : true,
        "minimumDate": "2018-01-01",
        "maximumDate": "2018-12-31",
        "visibleMonth": 7,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Find the date 2 months, 1 week and 5 days after January 12."),
                "answer": {"year": 2018, "month": 2, "day": 24}
            },
            {
                "question": qsTr("Find the date 3 months, 2 weeks and 1 day after August 23."),
                "answer": {"year": 2018, "month": 11, "day": 8}
            },
            {
                "question": qsTr("Find the date 5 months, 3 weeks and 2 days after March 20."),
                "answer": {"year": 2018, "month": 8, "day": 12}
            },
            {
                "question": qsTr("Find the date 1 month 1 week and 1 day before September 10."),
                "answer": {"year": 2018, "month": 7, "day": 2}
            },
            {
                "question": qsTr("Find the date 2 months, 1 week and 8 days before April 7."),
                "answer": {"year": 2018, "month": 0, "day": 23}
            }
        ]
    }
    ]
}
