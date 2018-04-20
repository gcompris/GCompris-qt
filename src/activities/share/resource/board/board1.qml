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
    There is a rest (basket)
*/

QtObject {
    property var levels : [
        {
            "instruction": qsTr("George wants to equally share 3 pieces of candy between 2 of his friends: one girl and one boy. Can he equally split the pieces of candy between his friends? First, place the children in center, then drag the pieces of candy to each of them. Be careful, a rest will remain!"),
            "totalBoys": 1,
            "totalGirls": 1,
            "totalCandies": 3,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("Maria wants to equally share 5 pieces of candy between 3 of her friends: one girl and two boys. Can she equally split the pieces of candy between her friends? First, place the children in center, then drag the pieces of candy to each of them. Be careful, a rest will remain!"),
            "totalBoys": 2,
            "totalGirls": 1,
            "totalCandies": 5,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction": qsTr("John wants to equally share 10 pieces of candy between 3 of his friends: one boy and two girls. Can he equally split the pieces of candy between his friends? First, place the children in center, then drag the pieces of candy to each of them."),
            "totalBoys": 1,
            "totalGirls": 2,
            "totalCandies": 10,
            "showCount": true,
            "forceShowBasket": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        }
    ]
}
