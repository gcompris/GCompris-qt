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
    Numbers of kids are not given anymore in the left widget which forces kids to understand this part.
    No rest (basket).
*/

QtObject {
    property var levels : [
        {
            "instruction": qsTr("Alice wants to equally share 3 pieces of candy between 3 of her friends: one girl and two boys. Can you help her? First, place the children in the center, then drag the pieces of candy to each of them."),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 3,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Now, Alice wants to give 6 pieces of candy to her friends"),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 6,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Can you help Alice give 9 pieces of candy to her friends: one girl and two boys?"),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 9,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Alice has 12 pieces of candy left. She wants to give them all to her friends. Can you help her split the pieces of candy equally?"),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 12,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        }
    ]
}
