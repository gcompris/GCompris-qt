/* GCompris
 *
 * Copyright (C) 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 * Authors:
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
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
import QtQuick 2.0

QtObject {

   property int minColor: 3
   property variant edgeList:[
          [0,1], [1,2], [2,3], [3,4], [4,0], [5,7],
          [7,9], [9,6], [6,8], [8,5], [0,5], [1,6],
          [2,7], [3,8], [4,9]
        ]
   property variant nodePositions : [
        [0.5,0], [0.90,0.35], [0.80,0.80],
        [0.20, 0.80], [0.10, 0.35], [0.5,0.20],
        [0.75,0.45], [0.65, 0.65], [0.35, 0.65], [0.25, 0.45]
    ]

}
