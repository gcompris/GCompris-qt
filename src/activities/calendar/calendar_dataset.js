/* GCompris - calendar_dataset.js
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
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

// Contains the questions, answers and calendar configurations of every level.
// Add more levels by inserting questions and answers below.
// Days of weeks are indexed from 0 i.e (Sunday = 0, Monday = 1, Tuesday = 2, .... ..... .... , Saturday = 6)
// Months of year are indexed from 0 i.e (January = 0, February = 1, March = 2, .... ..... ...., December = 11)

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
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }
                 ],
                 [ // Level 1 Questions
                  {
                      "question": qsTr("Select Date 23"),
                      "answer": {"year": 2018, "month": 2, "day": 23}
                  },
                  {
                      "question": qsTr("Select Date 1"),
                      "answer": {"year": 2018, "month": 2, "day": 1}
                  },
                  {
                      "question": qsTr("Select Date 16"),
                      "answer": {"year": 2018, "month": 2, "day": 16}
                  },
                  {
                      "question": qsTr("Select Date 28"),
                      "answer": {"year": 2018, "month": 2, "day": 28}
                  },
                  {
                      "question": qsTr("Select Date 11"),
                      "answer": {"year": 2018, "month": 2, "day": 11}
                  },
                  {
                      "question": qsTr("Select Date 20"),
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
                      "answerChoiceVisible": true,
                      "okButtonVisible": false,
                  }
                 ],
                 [ // Level 2  Questions
                  {
                      "question": qsTr("What day of week is on Date 4 of given month"),
                      "answer": {"dayOfWeek": 0}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 12 of given month"),
                      "answer": {"dayOfWeek": 1}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 20 of given month"),
                      "answer": {"dayOfWeek": 2}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 28 of given month"),
                      "answer": {"dayOfWeek": 3}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 22 of given month"),
                      "answer": {"dayOfWeek": 4}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 16 of given month"),
                      "answer": {"dayOfWeek": 5}
                  },
                  {
                      "question": qsTr("What day of the week is on Date 10 of given month"),
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
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }
                 ],

                 [ // Level 3 Questions
                  {
                      "question": qsTr("Select a Date having Monday between Date 1 and 7 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 5}
                  },
                  {
                      "question": qsTr("Select a Date having Tuesday between Date 8 and 16 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select a Date having Wednesday between Date 15 and 22 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 21}
                  },
                  {
                      "question": qsTr("Select a Date having Thursday between Date 26 and 31 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select a Date having Friday between Date 20 and 25 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 23}
                  },
                  {
                      "question": qsTr("Select a Date having Saturday between Date 13 and 23 of given month."),
                      "answer": {"year": 2018, "month": 2, "day": 17}
                  },
                  {
                      "question": qsTr("Select a Date having Sunday between Date 5 and 17 of given month."),
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
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }
                 ],
                 [ // Level 4 Questions
                  {
                      "question": qsTr("Select 2nd Day before 15th Of given month"),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select fourth Sunday of given month"),
                      "answer": {"year": 2018, "month": 2, "day": 25}
                  },
                  {
                      "question": qsTr("Select Date one Week after 13th of given month"),
                      "answer": {"year": 2018, "month": 2, "day": 20}
                  },
                  {
                      "question": qsTr("Select fifth Thursday of given month"),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select 4th day after 27th of given month"),
                      "answer": {"year": 2018, "month": 2, "day": 31}
                  }
                 ]
                ],

                [ // level 5
                 [ // Level 5 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2017-01-01",
                      "maximumDate": "2019-12-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }

                 ],
                 [ // Level 5 Questions
                  {
                      "question": qsTr("Find the first Monday of January month of year 2019."),
                      "answer": {"year": 2019, "month": 0, "day": 7}
                  },
                  {
                      "question": qsTr("Find the second Wednesday of February month of year 2019."),
                      "answer": {"year": 2019, "month": 1, "day": 13}
                  },
                  {
                      "question": qsTr("Find the third Friday of March month of year 2019."),
                      "answer": {"year": 2019, "month": 2, "day": 15}
                  },
                  {
                      "question": qsTr("Find the fifth Sunday of April month of year 2018."),
                      "answer": {"year": 2018, "month": 3, "day": 29}
                  },
                  {
                      "question": qsTr("Find the fourth Tuesday of July month of year 2018."),
                      "answer": {"year": 2018, "month": 6, "day": 24}
                  },
                  {
                      "question": qsTr("Find the first Monday of August month of year 2018"),
                      "answer": {"year": 2018, "month": 7, "day": 6}
                  },
                  {
                      "question": qsTr("Find the third Thursday of September month of year 2017."),
                      "answer": {"year": 2017, "month": 8, "day": 21}
                  },
                  {
                      "question": qsTr("Find the fifth Sunday of October month of year 2017."),
                      "answer": {"year": 2017, "month": 9, "day": 29}
                  },
                  {
                      "question": qsTr("Find the second Friday of December month of year 2017."),
                      "answer": {"year": 2017, "month": 11, "day": 8}
                  }
                 ]
                ],

                [ // Level 6
                 [ // Level 6 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2017-01-01",
                      "maximumDate": "2019-12-31",
                      "visibleMonth": 1,
                      "visibleYear": 2018,
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }
                 ],
                 [ // Level 6 Questions
                  {
                      "question": qsTr("Columbus Day is celebrated on the second monday of October. Find the date of Columbus Day in 2018."),
                      "answer": {"year": 2018, "month": 9, "day": 8}
                  },
                  {
                      "question": qsTr("Braille Day is celebrated one day before January 5. Find the date of Braille Day in 2018."),
                      "answer": {"year": 2018, "month": 0, "day": 4}
                  },
                  {
                      "question": qsTr("Mark's birthday is on March 4. His party is exactly two weeks later. Find the date of his party in 2018."),
                      "answer": {"year": 2018, "month": 2, "day": 18}
                  },
                  {
                      "question": qsTr("Mother's Day falls on the second Sunday in May. Find the date of Mother's Day in 2018."),
                      "answer": {"year": 2018, "month": 4, "day": 13}
                  },
                  {
                      "question": qsTr("Sports competition will be held on last Friday of September 2018. Select the date of sports competition on the calendar."),
                      "answer": {"year": 2018, "month": 8, "day": 28}
                  }
                 ]
                ]
    ]
}
