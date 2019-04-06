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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

/*
    Numbers of kids are not given anymore in the left widget.
    No rest (basket).
    Boy or Girl rectangles already contain a given number of pieces of candies.
*/

QtObject {
    property var levels : [
                {
            "instruction": qsTr("Help Jon split 9 pieces of candies between three boys and two girls. The rest will remain to Jon."),
            "totalBoys": 3,
            "totalGirls": 2,
            "totalCandies": 9,
            "showCount": false,
            "forceShowBasket": true,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Jon wants to share the rest of his pieces of candies with his brother and his sister. Can you split them equally, knowing that his brother already has two pieces of candies?"),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 6,
            "showCount": false,
            "forceShowBasket": true,
            "placedInGirls": 0,
            "placedInBoys": 2
        },
        {
            "instruction": qsTr("Help Tux split some pieces of candies to his friends: 9 pieces of candies to one boy and two girls."),
            "totalBoys": 1,
            "totalGirls": 2,
            "totalCandies": 13,
            "showCount": false,
            "forceShowBasket": true,
            "placedInGirls": 2,
            "placedInBoys": 0
        }
    ]
}
