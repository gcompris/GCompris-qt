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
    Numbers of kids are given in the left widget which eases kid work.
    There is a rest (basket)
*/

QtObject {
    property variant levels : [
        {
            "instruction" : qsTr("George wants to equally share 3 candies between his friends. They are 2. One girl and one boy. Can he equally split the candies to his friends? Place first the children in center, then drag the candies to each of them. Be careful, a rest will remain!"),
            "totalBoys" : 1,
            "totalGirls" : 1,
            "totalCandies" : 3,
            "showCount": true,
            "forceShowBakset": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction" : qsTr("Maria wants to equally share 5 candies between her friends. They are 3. One girl and two boys. Can she equally split the candies to her friends? Place first the children in center, then drag the candies to each of them. Be careful, a rest will remain!"),
            "totalBoys" : 2,
            "totalGirls" : 1,
            "totalCandies" : 5,
            "showCount": true,
            "forceShowBakset": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        },
        {
            "instruction" : qsTr("John wants to equally share 10 candies between his friends. They are 3. One boy and two girls. Can he equally split the candies to his friends? Place first the children in center, then drag the candies to each of them."),
            "totalBoys" : 1,
            "totalGirls" : 2,
            "totalCandies" : 10,
            "showCount": true,
            "forceShowBakset": false,
            "placedInGirls": 0,
            "placedInBoys": 0
        }
    ]
}
