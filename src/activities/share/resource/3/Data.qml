/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   shivam828787@gmail.com <email.shivam828787@gmail.com>
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
import GCompris 1.0

Data {
    objective: qsTr("Maximum 30 candies and 6 kids, possible rest.")
    difficulty: 5
    // NOTE: don't put maxBoys or maxGirls less than 1,
    // and don't make maxBoys + maxGirls more than maximum kids (6 here)
    data:  [
        [
            {
                "randomisedInputData": true,
                "maxBoys": 1,
                "maxGirls": 3,
                "maxCandies": 6,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 10,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 12,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 16,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 16,
                "alreadyPlaced": false
            }
        ],
        [
            {
                "randomisedInputData": true,
                "maxBoys": 1,
                "maxGirls": 3,
                "maxCandies": 6,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 10,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 14,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 16,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 18,
                "alreadyPlaced": false
            }
        ],
        [
            {
                "randomisedInputData": true,
                "maxBoys": 1,
                "maxGirls": 4,
                "maxCandies": 10,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 3,
                "maxCandies": 14,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 2,
                "maxCandies": 18,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 3,
                "maxCandies": 22,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 26,
                "alreadyPlaced": false
            }
        ],
        [
            {
                "randomisedInputData": true,
                "maxBoys": 1,
                "maxGirls": 3,
                "maxCandies": 10,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 2,
                "maxGirls": 2,
                "maxCandies": 14,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 18,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 22,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 26,
                "alreadyPlaced": false
            }
        ],
        [
            {
                "randomisedInputData": true,
                "maxBoys": 1,
                "maxGirls": 5,
                "maxCandies": 12,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 16,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 20,
                "alreadyPlaced": true
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 24,
                "alreadyPlaced": false
            },
            {
                "randomisedInputData": true,
                "maxBoys": 3,
                "maxGirls": 3,
                "maxCandies": 30,
                "alreadyPlaced": true
            }
        ]
    ]
}
