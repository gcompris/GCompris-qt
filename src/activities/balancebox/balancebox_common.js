/* GCompris - balancebox_common.js
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
var EMPTY   = 0x0000;
var NORTH   = 0x0001;
var EAST    = 0x0002;
var SOUTH   = 0x0004;
var WEST    = 0x0008;
// all the following are mutually exclusive:
var START   = 0x0010;
var GOAL    = 0x0020;
var HOLE    = 0x0040;
var CONTACT = 0x0080;

var baseUrl = "qrc:/gcompris/src/activities/balancebox/resource";

function validateLevels(doc)
{
    // minimal syntax check:
    if (undefined === doc || !Array.isArray(doc) || doc.length < 1)
        return false;
    for (var i = 0; i < doc.length; i++) {
        if (undefined === doc[i].map || !Array.isArray(doc[i].map) ||
                doc[i].map.length < 1)
            return false;
    }
    return true;
}
