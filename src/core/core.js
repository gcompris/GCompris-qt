/* GCompris - core.js
 *
 * Copyright (C) 2014
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *   Holger Kaelberer <holger.k@elberer.de>
 *   Johnny Jazeix <jazeix@gmail.com>
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

/*
  This file contains all javascript methods that can be used by more than one
  activity.
  */

.pragma library

/*
  function shuffle()
  Shuffle the array passed in parameter and returns it.
*/
function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

// from soundutil.c
/** return a string representing of a letter or a number audio file
 *  get alphabet sound file name
 *
 * the returned sound has the suffix .ogg
 *
 * \return a newly allocated string of the form U0033.ogg
 */
function getSoundFilenamForChar(c)
{
    var result = "U";
    var codeHex = c.toLowerCase().charCodeAt(0).toString(16).toUpperCase();
    while (codeHex.length < 4) {
        codeHex = "0" + codeHex;
    }
    result += codeHex + ".ogg";
    return result;
}
