/* GCompris - balancebox_common.js
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/**
 * Level description format:
 *
 * Example:
 * [ { "level": 1,
 *     "map": [ [ 0x0000,  0x0308, ... ],
 *              [ 0x0010,  0x0008, ... ],
 *              ...
 *            ],
 *     "targets": [ 1, 2, 3, 5, 10, ... ]
 *   },
 *   { "level": 2, ... }
 *   ...
 * ]
 *
 * "level": Number of the level.
 * "map":   Definition of the map inside the balancebox.
 *          The map is a 2-dimensional array of map cells. A cell is
 *          described by a bitmask of 16 bit with the lower 8bit defining walls,
 *          objects, etc. (cf. below) and the higher 8 bit defining the order of
 *          buttons present on the map. The values of the buttons are described
 *          in the "targets" property.
 * "targets": Values of the buttons present on the map. Most likely these will
 *            be numbers, but letters are also possible. The order in which they
 *            need to be pressed by the ball is defined in the higher 8 bits of
 *            the map fields.
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
var builtinFile = baseUrl + "/levels-default.json";

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
