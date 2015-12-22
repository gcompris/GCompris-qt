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

   property int numNodes: 4
   property int numEdges: 5
   property variant edgeList:[
          [0, 1], [0, 3], [1, 2], [1, 3], [2, 3]
        ]
   property variant nodePositions : [
        [0, 0.5], [0.5, 0], [1, 0.5], [0.5, 1]
    ]

}
