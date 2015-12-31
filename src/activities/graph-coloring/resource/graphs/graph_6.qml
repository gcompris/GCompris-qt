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

   property int minColor: 4
   property variant edgeList: [
	  [0, 8],
	  [0, 4],
	  [3, 6],
	  [10, 3],
	  [2, 11],
	  [7, 2],
	  [9, 1],
	  [5, 1],
	  [0, 1],
	  [1, 2],
	  [4, 6],
	  [8, 9],
	  [10, 11],
	  [0, 3],
	  [3, 2],
	  [8, 11],
	  [10, 9],
	  [4, 7],
	  [5, 7],
	  [6, 5],
	  [6, 9],
	  [10, 5],
	  [4, 11],
	  [8, 7]
	]
	property variant nodePositions : [
	  [0.00, 0.00],
	  [1.00, 0.00],
	  [1.00, 1.00],
	  [0.00, 1.00],
	  [0.32, 0.42],
	  [0.74, 0.42],
	  [0.32, 0.63],
	  [0.74, 0.63],
	  [0.42, 0.32],
	  [0.63, 0.32],
	  [0.42, 0.74],
	  [0.63, 0.74]
	]


}
