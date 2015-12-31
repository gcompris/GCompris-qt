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
	  [5, 4],
	  [2, 0],
	  [0, 1],
	  [1, 5],
	  [4, 3],
	  [3, 2],
	  [0, 11],
	  [1, 6],
	  [7, 5],
	  [3, 9],
	  [8, 4],
	  [2, 10],
	  [11, 9],
	  [7, 9],
	  [11, 7],
	  [6, 8],
	  [10, 8],
	  [6, 10]
	]
	property variant nodePositions : [
	  [0.26, 0.00],
	  [0.74, 0.00],
	  [0.00, 0.50],
	  [0.26, 1.00],
	  [0.74, 1.00],
	  [1.00, 0.50],
	  [0.62, 0.26],
	  [0.74, 0.50],
	  [0.62, 0.74],
	  [0.38, 0.74],
	  [0.26, 0.50],
	  [0.38, 0.26]
	]


}
