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
// Months oy year are indexed from 0 i.e (January = 0, February = 1, March = 2, .... ..... ...., December = 11)

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
                      "question": qsTr("What Day Of Week Is On Date 4 Of Given Month"),
                      "answer": {"dayOfWeek": 0}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 12 Of Given Month"),
                      "answer": {"dayOfWeek": 1}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 20 Of Given Month"),
                      "answer": {"dayOfWeek": 2}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 28 Of Given Month"),
                      "answer": {"dayOfWeek": 3}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 22 Of Given Month"),
                      "answer": {"dayOfWeek": 4}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 16 Of Given Month"),
                      "answer": {"dayOfWeek": 5}
                  },
                  {
                      "question": qsTr("What Day Of The Week Is On Date 10 Of Given Month"),
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
                      "question": qsTr("Select A Date Having Monday Between Date 1 And 7 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 5}
                  },
                  {
                      "question": qsTr("Select A Date Having Tuesday Between Date 8 And 16 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select A Date Having Wednesday Between Date 15 And 22 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 21}
                  },
                  {
                      "question": qsTr("Select A Date Having Thursday Between Date 26 And 31 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select A Date Having Friday Between Date 20 And 25 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 23}
                  },
                  {
                      "question": qsTr("Select A Date Having Saturday Between Date 13 And 23 Of Given Month."),
                      "answer": {"year": 2018, "month": 2, "day": 17}
                  },
                  {
                      "question": qsTr("Select A Date Having Sunday Between Date 5 And 17 Of Given Month."),
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
                      "question": qsTr("Select 2nd Day Before 15th Of Given Month"),
                      "answer": {"year": 2018, "month": 2, "day": 13}
                  },
                  {
                      "question": qsTr("Select Fourth Sunday Of Given Month"),
                      "answer": {"year": 2018, "month": 2, "day": 25}
                  },
                  {
                      "question": qsTr("Select Date One Week After 13th Of Given Month"),
                      "answer": {"year": 2018, "month": 2, "day": 20}
                  },
                  {
                      "question": qsTr("Select Fifth Thursday Of Given Month"),
                      "answer": {"year": 2018, "month": 2, "day": 29}
                  },
                  {
                      "question": qsTr("Select 4th Day After 27th Of Given Month"),
                      "answer": {"year": 2018, "month": 2, "day": 31}
                  }
                 ]
                ],

                [ // level 5
                 [ // Level 5 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2018-12-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }

                 ],
                 [ // Level 5 Questions
                  {
                      "question": qsTr("Find The First Monday Of January Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 0, "day": 1}
                  },
                  {
                      "question": qsTr("Find The Second Wednesday Of April Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 3, "day": 11}
                  },
                  {
                      "question": qsTr("Find The Third Friday Of May Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 4, "day": 18}
                  },
                  {
                      "question": qsTr("Find The Fifth Saturday Of June Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 5, "day": 30}
                  },
                  {
                      "question": qsTr("Find The Fourth Tuesday Of July Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 6, "day": 24}
                  },
                  {
                      "question": qsTr("Find The First Monday Of August Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 7, "day": 6}
                  },
                  {
                      "question": qsTr("Find The Third Thursday Of September Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 8, "day": 20}
                  },
                  {
                      "question": qsTr("Find The Fifth Wednesday Of October Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 9, "day": 31}
                  },
                  {
                      "question": qsTr("Find The Second Friday Of December Month Of Year 2018"),
                      "answer": {"year": 2018, "month": 11, "day": 14}
                  }
                 ]
                ],

                [ // Level 6
                 [ // Level 6 Configurations
                  {
                      "navigationBarVisible" : true,
                      "minimumDate": "2018-01-01",
                      "maximumDate": "2019-12-31",
                      "visibleMonth": 2,
                      "visibleYear": 2018,
                      "answerChoiceVisible": false,
                      "okButtonVisible": true,
                  }
                 ],
                 [ // Level 6 Questions
                  {
                      "question": qsTr("Columbus Day Is Celebrated On The Second Monday Of October. Find The Date Of Columbus Day In 2018"),
                      "answer": {"year": 2018, "month": 9, "day": 8}
                  },
                  {
                      "question": qsTr("Braille Day Is Celebrated One Day Before January 5. Find The Date Of Braille Day in 2018"),
                      "answer": {"year": 2018, "month": 0, "day": 4}
                  },
                  {
                      "question": qsTr("Mark's Birthday Is On March 4. His Party Is Exactly Two Weeks Later. Find The Date Of His Party in 2018"),
                      "answer": {"year": 2018, "month": 2, "day": 18}
                  },
                  {
                      "question": qsTr("Mother's Day Falls On The Second Sunday In May. Find The Date Of Mother's Day In 2018"),
                      "answer": {"year": 2018, "month": 4, "day": 13}
                  },
                  {
                      "question": qsTr("Sports Competition Will Be Held On Last Friday of September 2018. Select The Date Of Sports Competition On Calendar Given Below"),
                      "answer": {"year": 2018, "month": 8, "day": 28}
                  }
                 ]
                ]
            ]

}
