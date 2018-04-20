/* GCompris
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

/*
    Numbers of kids are given in the left widget which eases kid work.
    No rest (basket).
*/

QtObject {
    property var levels : [
        {
            "instruction": qsTr("Paul wants to equally share 2 pieces of candy between 2 of his friends: one girl and one boy. Can you help him? First, place the children in center, then drag the pieces of candy to each of them."),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 2,
            "showCount": true,
            "forceShowBasket": "false",
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Now he wants to give 4 pieces of candy to his friends."),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 4,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Can you now give 6 of Paul's pieces of candy to his friends?"),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 6,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0

        },
        {
            "instruction": qsTr("Paul has only 10 pieces of candy left. He eats 2 pieces of candy and he gives the rest to his friends. Can you help him equally split the 8 remaining pieces of candy?"),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 8,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        }
    ]
}
