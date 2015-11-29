/* GCompris - playpiano.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import GCompris 1.0

import "../../core"

Item {
    id: staff
    property int verticalDistanceBetweenLines: 20 // todo width/nbLines * smth
    
    property string clef

    width: 400
    // Stave
    property int nbLines: 5

    property bool lastPartition: false

    Image {
        source: clef ? "qrc:/gcompris/src/activities/playpiano/resource/"+clef+".svg" : ""
        sourceSize.width: (nbLines-2)*verticalDistanceBetweenLines
    }
    Repeater {
        model: nbLines
        
        Rectangle {
            width: staff.width
            height: 5
            border.width: 5
            color: "black"
            x: 0
            y: index * verticalDistanceBetweenLines
        }
    }
    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines-1) * verticalDistanceBetweenLines+5
        color: "black"
        x: staff.width
        y: 0
    }
    // end of partition line
    Rectangle {
        width: 5
        border.width: 5
        height: (nbLines-1) * verticalDistanceBetweenLines+5
        visible: lastPartition
        color: "black"
        x: staff.width-10
        y: 0
    }
}
