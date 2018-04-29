/* GCompris - numbers.js
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
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

function get() {
    return [
                { //level1
                    "bulbCount": 2,
                    "numbersToBeConverted": [3],
                    "enableHelp": true
                },
                { //level 2
                    "bulbCount": 2,
                    "numbersToBeConverted": [1, 2],
                    "enableHelp": false
                },
                { //level3
                    "bulbCount": 4,
                    "numbersToBeConverted": [4, 9, 13, 15],
                    "enableHelp": true
                },
                { //level4
                    "bulbCount": 4,
                    "numbersToBeConverted": [5, 10, 14, 7],
                    "enableHelp": false
                },
                { //level5
                    "bulbCount": 8,
                    "numbersToBeConverted": [57, 152, 248, 239, 89, 101],
                    "enableHelp": true
                },
                { //level6
                    "bulbCount": 8,
                    "numbersToBeConverted": [58, 153, 240, 236, 231, 255],
                    "enableHelp": false
                }
    ];
}
