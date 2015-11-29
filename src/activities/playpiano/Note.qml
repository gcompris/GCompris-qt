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
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"

Item {
    id: note
    property string value
    property bool noteIsColored: true
    property int type: wholeNote
    property string noteType: type == wholeNote ? "whole" :
                              type == halfNote ? "half" :
                              type == quarterNote ? "quarter" : 
                              type == eighthNote ? "eighth" : ""
    width: noteImage.width
    height: noteImage.height

    readonly property int wholeNote: 1
    readonly property int halfNote: 2
    readonly property int quarterNote: 4
    readonly property int eighthNote: 8

    property var noteColorMap: { "1": "#FF0000", "2": "#FF7F00", "3": "#FFFF00",
        "4": "#32CD32", "5": "#6495ED", "6": "#D02090", "7": "#FF1493", "8": "#FF0000",
        "-1": "#FF6347", "-2": "#FFD700", "-3": "#20B2AA", "-4": "#8A2BE2",
        "-5": "#FF00FF" }

    Image {
        id: noteImage
        source: "qrc:/gcompris/src/activities/playpiano/resource/"+noteType+"-note.svg"
        sourceSize.width: 60
    }
    // If the result is not good enought maybe have a rectangle and use opacity mask with a note
    ColorOverlay {
        anchors.fill: noteImage
        source: noteImage
        color: noteColorMap[value]  // make image like it lays under red glass 
        visible: noteIsColored
    }
}
