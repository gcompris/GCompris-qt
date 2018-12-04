/* GCompris - find_the_day_dataset.js
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

// Contains the questions, answers and calendar configurations of every level.
// Add more levels by inserting questions and answers below.
// Days of weeks are indexed from 0 i.e (Sunday = 0, Monday = 1, Tuesday = 2, .... ..... .... , Saturday = 6)
// Months of year are indexed from 0 i.e (January = 0, February = 1, March = 2, .... ..... ...., December = 11)

//MODES
// findMonthOnly --> For questions based on finding month only.
// findYearMonthDay --> For questions based on finding year, month and day.
// findDayOfWeek --> For questions based on finding day of week only.
// findDay --> For questions based on finding day of a given month and year.


function get() {
    return [
                [ // Level 1
                 [ // Level 1 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 7,
                      "visibleYear": 2018,
                      "mode": "findYearMonthDay"
                  }
                 ],
                 [ // Level 1 Questions
                  {
                      "question": qsTr("Find the date 13 days after May 3."),
                      "answer": {"year": 2018, "month": 4, "day": 16}
                  },
                  {
                      "question": qsTr("Find the date 7 days after October 1."),
                      "answer": {"year": 2018, "month": 9, "day": 8}
                  },
                  {
                      "question": qsTr("Find the date 31 days after July 12."),
                      "answer": {"year": 2018, "month": 7, "day": 12}
                  },
                  {
                      "question": qsTr("Find the date two weeks after November 27."),
                      "answer": {"year": 2018, "month": 11, "day": 11}
                  },
                  {
                      "question": qsTr("Find the date 19 days before September 1."),
                      "answer": {"year": 2018, "month": 7, "day": 13}
                  },
                  {
                      "question": qsTr("Find the date 5 days before December 8."),
                      "answer": {"year": 2018, "month": 11, "day": 3}
                  }
                 ]

                ],

                [ // Level 2
                 [ // Level 2 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 7,
                      "visibleYear": 2018,
                      "mode": "findDayOfWeek"
                  }
                 ],
                 [ // Level 2  Questions
                  {
                      "question": qsTr("Find day of week 3 days after December 5."),
                      "answer": {"dayOfWeek": 6}
                  },
                  {
                      "question": qsTr("Find day of week 12 days before November 12."),
                      "answer": {"dayOfWeek": 3}
                  },
                  {
                      "question": qsTr("Find day of week 32 days after January 5."),
                      "answer": {"dayOfWeek": 2}
                  },
                  {
                      "question": qsTr("Find day of week 5 days after February 23."),
                      "answer": {"dayOfWeek": 3}
                  },
                  {
                      "question": qsTr("Find day of week 17 days before August 16."),
                      "answer": {"dayOfWeek": 1}
                  }

                 ]
                ],

                [ // Level 3
                 [ // Level 3 configurations
                  {
                      "navigationBarVisible": true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 7,
                      "visibleYear": 2018,
                      "mode": "findYearMonthDay"
                  }
                 ],

                 [ // Level 3 Questions
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
                ],

                [ // level 4
                 [ // Level 4 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 7,
                      "visibleYear": 2018,
                      "mode": "findDayOfWeek"
                  }
                 ],
                 [ // Level 4 Questions
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
                ],

                [ // level 5
                 [ // Level 5 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 7,
                      "visibleYear": 2018,
                      "mode": "findYearMonthDay"
                  }
                 ],
                 [ // Level 5 Questions
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
                ]
            ]
}
