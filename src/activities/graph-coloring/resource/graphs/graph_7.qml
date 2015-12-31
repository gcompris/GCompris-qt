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
   property variant edgeList: [
    [5, 1],
    [5, 0],
    [0, 3],
    [0, 1],
    [0, 2],
    [2, 4],
    [2, 1],
    [3, 4],
    [3, 2],
    [4, 1],
    [5, 4],
    [5, 3]
  ]
  property variant nodePositions : [
    [0.75, 0.00],
    [0.75, 1.00],
    [1.00, 0.50],
    [0.25, 0.00],
    [0.25, 1.00],
    [0.00, 0.50]
  ]


}
