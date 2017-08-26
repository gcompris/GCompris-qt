/* GCompris - levelConfigData.js
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   "Amit Sagtani" <asagtani06@gmail.com>
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

// Contains calendar configurations for differeent levels.
// Add configurations for new level below.

function getConfig() {
    return [
                [ // Level 1 configurations
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
                [ // Level 2 Configurations
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
                ]
            ]
}
