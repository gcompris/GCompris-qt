/* GCompris - calendar_dataset.js
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

// Contains the questions, answers and calendar configurations of every level.
// Add more levels by inserting questions and answers below.
// Days of weeks are indexed from 0 i.e (Sunday = 0, Monday = 1, Tuesday = 2, .... ..... .... , Saturday = 6)
// Months of year are indexed from 0 i.e (January = 0, February = 1, March = 2, .... ..... ...., December = 11)
//[
    //MODES
      // findMonthOnly --> For questions based on finding month only.
      // findYearMonthDay --> For questions based on finding year, month and day.
      // findDayOfWeek --> For questions based on finding day of week only.
      // findDay --> For questions based on finding day of a given month and year.
// ]

function get() {
    return [
                [ // Level 1
                 [ // Level 1 Configurations
                  {
                      "navigationBarVisible" : false,
                      "minimumDate": "2018-03-01",
                      "maximumDate": "2018-03-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "mode": "findDay"
                  }
                 ],
                 [ // Level 1 Questions
                  {
                      "question": qsTr("Select the 23rd"),
                      "answer": {"year": 2018, "month": 2, "day": 23}
                  },
                  {
                      "question": qsTr("Select the 1st"),
                      "answer": {"year": 2018, "month": 2, "day": 1}
                  },
                  {
                      "question": qsTr("Select the 16th"),
                      "answer": {"year": 2018, "month": 2, "day": 16}
                  },
                  {
                      "question": qsTr("Select the 28th"),
                      "answer": {"year": 2018, "month": 2, "day": 28}
                  },
                  {
                      "question": qsTr("Select the 11th"),
                      "answer": {"year": 2018, "month": 2, "day": 11}
                  },
                  {
                      "question": qsTr("Select the 20th"),
                      "answer": {"year": 2018, "month": 2, "day": 20}
                  }
                 ]

                ],

                [ // Level 2
                 [ // Level 2 Configurations
                  {
                      "navigationBarVisible" : false,
                      "minimumDate": "2018-03-01",
                      "maximumDate": "2018-03-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "mode": "findDayOfWeek"
                  }
                 ],
                 [ // Level 2  Questions
                  {
                      "question": qsTr("Which day of the week is the 4th of the given month?"),
                      "answer": {"dayOfWeek": 0}
                  },
                  {
                      "question": qsTr("Which day of the week is the 12th of the given month?"),
                      "answer": {"dayOfWeek": 1}
                  },
                  {
                      "question": qsTr("Which day of the week is the 20th of the given month?"),
                      "answer": {"dayOfWeek": 2}
                  },
                  {
                      "question": qsTr("Which day of the week is the 28th of the given month?"),
                      "answer": {"dayOfWeek": 3}
                  },
                  {
                      "question": qsTr("Which day of the week is the 22nd of the given month?"),
                      "answer": {"dayOfWeek": 4}
                  },
                  {
                      "question": qsTr("Which day of the week is the 16th of the given month?"),
                      "answer": {"dayOfWeek": 5}
                  },
                  {
                      "question": qsTr("Which day of the week is the 10th of the given month?"),
                      "answer": {"dayOfWeek": 6}
                  }
                 ]
                ],

                [ // Level 3
                 [ // Level 3 configurations
                  {
                      "navigationBarVisible": false,
                      "minimumDate": "2018-03-01",
                      "maximumDate": "2018-03-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "mode": "findDay"
                  }
                 ],

                 [ // Level 3 Questions
                  {
                      "question": qsTr("Select a Monday between days 1 and 7 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 5}
                  },
                  {
                      "question": qsTr("Select a Tuesday between days 8 and 16 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select a Wednesday between days 15 and 22 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 21}
                  },
                  {
                      "question": qsTr("Select a Thursday between days 26 and 31 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select a Friday between days 20 and 25 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 23}
                  },
                  {
                      "question": qsTr("Select a Saturday between days 13 and 23 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 17}
                  },
                  {
                      "question": qsTr("Select a Sunday between days 5 and 17 of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 11}
                  }
                 ]
                ],

                [ // level 4
                 [ // Level 4 Configurations
                  {
                      "navigationBarVisible" : false,
                      "minimumDate": "2018-03-01",
                      "maximumDate": "2018-03-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "mode": "findDay"
                  }
                 ],
                 [ // Level 4 Questions
                  {
                      "question": qsTr("Select the second day before the 15th of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select the fourth Sunday of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 25}
                  },
                  {
                      "question": qsTr("Select the day one week after 13th of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 20}
                  },
                  {
                      "question": qsTr("Select the fifth Thursday of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select the third day after 27th of the given month"),
                      "answer": {"year": 2018, "month": 2, "day": 30}
                  }
                 ]
                ],

                [ // Level 5
                 [ // Level 5 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 1,
                      "visibleYear": 2018,
                      "mode": "findMonthOnly"
                  }
                 ],
                 [ // Level 5 Questions
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
                ],

                [ // level 6
                 [ // Level 6 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2017-01-01",
                      "maximumDate": "2019-12-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "mode": "findYearMonthDay"
                  }

                 ],
                 [ // Level 6 Questions
                  {
                      "question": qsTr("Find the first Monday of January in the year 2019"),
                      "answer": {"year": 2019, "month": 0, "day": 7}
                  },
                  {
                      "question": qsTr("Find the second Wednesday of February in the year 2019"),
                      "answer": {"year": 2019, "month": 1, "day": 13}
                  },
                  {
                      "question": qsTr("Find the third Friday of March in the year 2019"),
                      "answer": {"year": 2019, "month": 2, "day": 15}
                  },
                  {
                      "question": qsTr("Find the fifth Sunday of April in the year 2018"),
                      "answer": {"year": 2018, "month": 3, "day": 29}
                  },
                  {
                      "question": qsTr("Find the fourth Tuesday of July in the year 2018"),
                      "answer": {"year": 2018, "month": 6, "day": 24}
                  },
                  {
                      "question": qsTr("Find the first Monday of August in the year 2018"),
                      "answer": {"year": 2018, "month": 7, "day": 6}
                  },
                  {
                      "question": qsTr("Find the third Thursday of September in the year 2017"),
                      "answer": {"year": 2017, "month": 8, "day": 21}
                  },
                  {
                      "question": qsTr("Find the fifth Sunday of October in the year 2017"),
                      "answer": {"year": 2017, "month": 9, "day": 29}
                  },
                  {
                      "question": qsTr("Find the second Friday of December in the year 2017"),
                      "answer": {"year": 2017, "month": 11, "day": 8}
                  }
                 ]
                ],

                [ // Level 7
                 [ // Level 7 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2017-01-01",
                      "maximumDate": "2019-12-31",
                      "visibleMonth": 1,
                      "visibleYear": 2018,
                      "mode": "findYearMonthDay"
                  }
                 ],
                 [ // Level 7 Questions
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
                      "question": qsTr("The sports competition was held on last Friday of September 2017.<br> Select the date of the sports competition on the calendar."),
                      "answer": {"year": 2017, "month": 8, "day": 29}
                  }
                 ]
                ]
            ]
}
