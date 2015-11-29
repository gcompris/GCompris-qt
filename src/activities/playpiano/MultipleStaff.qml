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

    property int nbStaves
    property string clef
    property int verticalDistanceBetweenLines: 30
    property int distanceBetweenStaff: 20
    property int nbLines: 5

    Column {
        Repeater {
            model: nbStaves
            Staff {
                clef: staff.clef
                height: (staff.height-distanceBetweenStaff*(nbStaves-1))/nbStaves
                width: staff.width
                y: index * (height+distanceBetweenStaff)
                lastPartition: index == nbStaves-1
            }
        }
    }

    Row {
        Repeater {
            model: notes
            Note {
                value: mValue
                type:mType
                //(nbLines-3)*verticalDistanceBetweenLines == bottom line
                y: (nbLines-2)*verticalDistanceBetweenLines - (mValue-1)*verticalDistanceBetweenLines/2
            }
        }
    }
    ListModel {
        id: notes
    }
    function addNote(newValue_, newType_) {
        notes.append({"mValue": newValue_, "mType": newType_});
    }
}
