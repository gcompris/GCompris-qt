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
    objective: qsTr("Calendar Questions involving 2 months")
    difficulty: 5
    data: [
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
        "maximumDate": "2018-12-31",
        "visibleMonth": 2,
        "visibleYear": 2018,
        "mode": "findDayOfWeek",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("What day of week is 30 days after 10 March?"),
                "answer": {"dayOfWeek": 1}
            },
            {
                "question": qsTr("What day of the week is 40 days after 15 July?"),
                "answer": {"dayOfWeek": 5}
            },
            {
                "question": qsTr("What day of the week is 20 days after 1 June?"),
                "answer": {"dayOfWeek": 5}
            },
            {
                "question": qsTr("What day of the week is 60 days after 10 April?"),
                "answer": {"dayOfWeek": 6}
            },
            {
                "question": qsTr("What day of the week is 10 days after 15 December?"),
                "answer": {"dayOfWeek": 2}
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
            "maxOffset": 60
        }
    },
    {
       "navigationBarVisible" : true,
        "minimumDate": "2017-01-01",
        "maximumDate": "2019-12-31",
        "visibleMonth": 1,
        "visibleYear": 2018,
        "mode": "findYearMonthDay",
        "questionsExplicitlyGiven": true,
        "questionAnswers": [
            {
                "question": qsTr("Human Rights Day is celebrated five days after December 5.<br> Find the date of Human Rights Day in 2017."),
                "answer": {"year": 2017, "month": 11, "day": 10}
            },
            {
                "question": qsTr("Braille Day is celebrated one day before January 5.<br> Find the date of Braille Day in 2018"),
                "answer": {"year": 2018, "month": 0, "day": 4}
            },
            {
                "question": qsTr("Mark's birthday is on November 4. In 2017 his party was exactly two weeks later.<br> Find the date of his party in 2017"),
                "answer": {"year": 2017, "month": 10, "day": 18}
            },
            {
                "question": qsTr("International Women's Day is celebrated two days before March 10.<br> Find the date of International Women's Day in 2018."),
                "answer": {"year": 2018, "month": 2, "day": 8}
            },
            {
                "question": qsTr("Sports competition was held on last Friday of September 2017.<br> Select the date of sports competition on the calendar."),
                "answer": {"year": 2017, "month": 8, "day": 29}
            }
        ]
    }
    ]
}
