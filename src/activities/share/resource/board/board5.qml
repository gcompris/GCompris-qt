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
    Numbers of kids are not given anymore in the left widget.
    No rest (basket).
    Boy or Girl rectangles already contain a given number of pieces of candy.
*/

QtObject {
    property var levels : [
                {
            "instruction": qsTr("Bob wants to give 5 pieces of candy to his friends: two boys and one girl, his girlfriend already has one candy. Can you help him equally split the pieces of candy so that each friend will have the same amount of pieces of candy?"),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 6,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 1,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Harry wants to equally share 8 pieces of candy between his friends: one boy and two girls. Place the children in center, then drag the pieces of candy to each of them so that each of them has an equal number of pieces of candy."),
            "totalBoys": 1,
            "totalGirls": 2,
            "totalCandies": 9,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 1
        },
        {
            "instruction": qsTr("Can you now give 6 of Harry's pieces of candy to his friends?"),
            "totalBoys": 1,
            "totalGirls": 2,
            "totalCandies": 8,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 2
        }
    ]
}
