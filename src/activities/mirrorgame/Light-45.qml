/* GCompris - Light-45.qml
 *
 * Copyright (C) 2016 Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
 * Authors:
 *   Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
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
import QtQuick 2.1
import QtGraphicalEffects 1.0
import "../../core"
import "mirrorgame.js" as Activity

Rectangle{    
    id:rect
     property string uniquename
    transformOrigin: Item.Top
    rotation : -45
    width: 2
    color: "yellow"
    RectangularGlow {
           id: effect
           anchors.fill: rect
           glowRadius: 5
           spread: 0.2
           color: "yellow"

       }
}
