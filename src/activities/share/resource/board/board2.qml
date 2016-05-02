/* GCompris
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
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
import QtQuick 2.0

/*  
    Level 7 to 9
    Numbers of kids are not given anymore in the left widget which forces kids to understand this part.
    No rest (no basket).
*/

QtObject {
    property variant levels : [
        {
            "instruction" : qsTr("Alice wants to equally share 3 candies between her friends. They are 3: One girl and two boys. Can you help her? Place first the children in the center, then drag the candies to each of them."),
            "totalBoys" : 2,
            "totalGirls" : 1,
            "totalCandies" : 3,
            "showCount": false,
            "forceShowBakset": false
        },
        {
            "instruction" : qsTr("Now, Alice wants to give 6 candies to her friends"),
            "totalBoys" : 2,
            "totalGirls" : 1,
            "totalCandies" : 6,
            "showCount": false,
            "forceShowBakset": false
        },
        {
            "instruction" : qsTr("Can you help Alice give 9 candies to her friends: one girl and two boys?"),
            "totalBoys" : 2,
            "totalGirls" : 1,
            "totalCandies" : 9,
            "showCount": false,
            "forceShowBakset": false
        },
        {
            "instruction" : qsTr("Alice has 12 candies left. She wants to give them all to her friends. Can you help her split the candies equally?"),
            "totalBoys" : 2,
            "totalGirls" : 1,
            "totalCandies" : 12,
            "showCount": false,
            "forceShowBakset": false
        }
    ]
}
