/* GCompris - numbers.js
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 *	 This program is free software; you can redistribute it and/or modify
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

/* Level description format:
 * 
 * Example: 
 * [
 * 	    [ //level1
 * 			2, 1, 2
 *		],
 *		[ //level2
 *			5, 1, 2
 *		]  
 * ] 
 *  
 * In the level1 the first element, 2, represents the number of bulbs 
 * The other numbers, 1 and 2 are the numbers that are to represented in the binary form.
 * 
*/

 function get() {
 	return [
 				[ //level1
 					2, 1, 2
 				],
 				[ //level 2
 					2, 1, 3
 				],
 				[ //level3
 					4, 4, 9, 13, 15
 				],
 				[ //level4
 					4, 5, 10, 14, 7
 				],
 				[ //level5
 					8, 57, 152, 248, 239
 				],
 				[ //level6
 					8, 58, 153, 240, 236
 				]
 			];
 }
