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
    There is a rest (basket).
*/

QtObject {
    property var levels : [
        {
            "instruction": qsTr("Michael wants to equally share 5 pieces of candy between 2 of his friends: one girl and one boy. Can you help him? First, place the children in center, then drag the pieces of candy to each of them!"),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 5,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Helen has 3 friends: one boy and two girls. She wants to give them 7 pieces of candy. Help her split the pieces of candy between her friends!"),
            "totalBoys": 1,
            "totalGirls": 2,
            "totalCandies": 7,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Michelle has 9 pieces of candy and wants to split them with two brothers and two sisters. Help her share the pieces of candy!"),
            "totalBoys": 2,
            "totalGirls": 2,
            "totalCandies": 9,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Thomas wants to share his 11 pieces of candy with his friends: three boys and one girl. Can you help him?"),
            "totalBoys": 3,
            "totalGirls": 1,
            "totalCandies": 11,
            "showCount": false,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        }
    ]
}
