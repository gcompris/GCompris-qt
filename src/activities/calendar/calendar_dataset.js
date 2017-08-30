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

// Contains the questions and answers asked in every level.
// Add more levels by inserting questions and answers below.
// Add configurations of calendar for every level in levelConfigData.js

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
                 [
                     {
                         "question": qsTr("Select Date 23"),
                         "answer": 23
                     },
                     {
                         "question": qsTr("Select Date 1"),
                         "answer": 1
                     },
                     {
                         "question": qsTr("Select Date 16"),
                         "answer": 16
                     },
                     {
                         "question": qsTr("Select Date 28"),
                         "answer": 28
                     },
                     {
                         "question": qsTr("Select Date 11"),
                         "answer": 11
                     },
                     {
                         "question": qsTr("Select Date 20"),
                         "answer": 20
                     }
                 ]

                ],

                [ // Level 2
                 [ // Level 2 configurations
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

                 [
                     {
                         "question": qsTr("Select A Date Having Monday"),
                         "answer": 1//{"year": 2018, "month": 2, "day: "}
                     },
                     {
                         "question": qsTr("Select A Date Having Tuesday"),
                         "answer": 2
                     },
                     {
                         "question": qsTr("Select A Date Having Wednesday"),
                         "answer": 3
                     },
                     {
                         "question": qsTr("Select A Date Having Thursday"),
                         "answer": 4
                     },
                     {
                         "question": qsTr("Select A Date Having Friday"),
                         "answer": 5
                     },
                     {
                         "question": qsTr("Select A Date Having Saturday"),
                         "answer": 6
                     },
                     {
                         "question": qsTr("Select A Date Having Sunday"),
                         "answer": 0
                     }
                 ]
                ],


                [ // level 3
                 [ // Level 3 Configurations
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
                 [
                     {
                         "question": qsTr("Find The January Month Of Year 2018"),
                         "answer": 2018
                     },
                     {
                         "question": qsTr("Find The April Month Of Year 2018"),
                         "answer": 2021
                     },
                     {
                         "question": qsTr("Find The May Month Of Year 2018"),
                         "answer": 2022
                     },
                     {
                         "question": qsTr("Find The June Month Of Year 2018"),
                         "answer": 2023
                     },
                     {
                         "question": qsTr("Find The July Month Of Year 2018"),
                         "answer": 2024
                     },
                     {
                         "question": qsTr("Find The August Month Of Year 2018"),
                         "answer": 2025
                     },
                     {
                         "question": qsTr("Find The September Month Of Year 2018"),
                         "answer": 2026
                     },
                     {
                         "question": qsTr("Find The October Month Of Year 2018"),
                         "answer": 2027
                     },
                     {
                         "question": qsTr("Find The December Month Of Year 2018"),
                         "answer": 2029
                     },
                     {
                         "question": qsTr("Find The Month Between January and March Within Year 2018"),
                         "answer": 2019
                     }
                 ]
                ],

                [ // Level 4
                 [ // Level 4 Configurations
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
                 [
                     {
                         "question": qsTr("What Day Of Week Is On Date 4 Of Given Month"),
                         "answer": 0
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 12 Of Given Month"),
                         "answer": 1
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 20 Of Given Month"),
                         "answer": 2
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 28 Of Given Month"),
                         "answer": 3
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 22 Of Given Month"),
                         "answer": 4
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 16 Of Given Month"),
                         "answer": 5
                     },
                     {
                         "question": qsTr("What Day Of The Week Is On Date 10 Of Given Month"),
                         "answer": 6
                     }
                 ]
                ],
                [ // level 5
                 [ // Level 5 Configurations
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
                 [
                     {
                         "question": qsTr("Select 2nd Day Before 15th Of Given Month"),
                         "answer": 13
                     },
                     {
                         "question": qsTr("Select Fourth Sunday Of Given Month"),
                         "answer": 25
                     },
                     {
                         "question": qsTr("Select Date One Week After 13th Of Given Month"),
                         "answer": 20
                     },
                     {
                         "question": qsTr("Select Fifth Thursday Of Given Month"),
                         "answer": 29
                     },
                     {
                         "question": qsTr("Select 4th Day After 27th Of Given Month"),
                         "answer": 31
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
                 [
                     {
                         "question": qsTr("Columbus Day Is Celebrated On The Second Monday Of October. Find The Date Of Columbus Day In 2018"),
                         "answer": 2027
                     },
                     {
                         "question": qsTr("Braille Day Is Celebrated One Day Before January 5. Find The Date Of Braille Day in 2019"),
                         "answer": 2028
                     },
                     {
                         "question": qsTr("Mark's Birthday Is On March 4. His Party Is Exactly Two Weeks Later. Find The Date Of His Party in 2018"),
                         "answer": 2036
                     },
                     {
                         "question": qsTr("Mother's Day Falls On The Second Sunday In May. Find The Date Of Mother's Day In 2018"),
                         "answer": 2031
                     },
                     {
                         "question": qsTr("Sports Competition Will Be Held On Last Friday of September 2018. Select The Date Of Sports Competition On Calendar Given Below"),
                         "answer": 2051
                     }
                 ]
                ]
            ]

}
