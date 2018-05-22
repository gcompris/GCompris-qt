/* GCompris - Note.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"

Item {
    id: note
    property string noteName
    property bool noteIsColored: true
    property string noteType
    property string blackType: noteName[1] === "#" ? "sharp"
                               : noteName[1] === "b" ? "flat" : ""// empty, "flat" or "sharp"

    readonly property string length: noteType == "Whole" ? 1 :
                                     noteType == "Half"  ? 2 :
                                     noteType == "Quarter" ? 4 :
                                     noteType == 8

    readonly property int noteDuration: 2000 / length

    readonly property var noteColorMap: { "1": "#FF0000", "2": "#FF7F00", "3": "#FFFF00",
        "4": "#32CD32", "5": "#6495ED", "6": "#D02090", "7": "#FF1493", "8": "#FF0000",
        "-1": "#FF6347", "-2": "#FFD700", "-3": "#20B2AA", "-4": "#8A2BE2",
        "-5": "#FF00FF" }

    readonly property var whiteNoteName: { "C": "1", "D": "2", "E": "3", "F": "4", "G": "5", "A": "6", "B": "7", "C": "8" }

    readonly property var sharpNoteName: { "C#": "-1", "D#": "-2", "F#": "-3", "G#": "-4", "A#": "-5" }
    readonly property var flatNoteName: { "Db": "-1", "Eb": "-2", "Gb": "-3", "Ab": "-4", "Bb": "-5" }
    readonly property var blackNoteName: blackType == "" ? blackType :
                                blackType == "flat" ? flatNoteName : sharpNoteName

    property bool highlightWhenPlayed: false
    property alias highlightTimer: highlightTimer

    property var noteDetails

    Image {
        id: blackTypeImage
        source: blackType !== "" ? "qrc:/gcompris/src/activities/piano_composition/resource/black" + blackType + ".svg" : ""
        sourceSize.width: noteImage.width / 2.5
        anchors.right: parent.rotation === 180 ? undefined : noteImage.left
        anchors.left: parent.rotation === 180 ? noteImage.right : undefined
        rotation: parent.rotation === 180 ? 180 : 0
        anchors.rightMargin: -width / 2
        anchors.leftMargin: -width
        anchors.bottom: noteImage.bottom
        anchors.bottomMargin: height / 2
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: highlightImage
        source: "qrc:/gcompris/src/activities/piano_composition/resource/note_highlight.png"
        visible: false
        sourceSize.width: noteImage.width
        height: noteImage.height / 2
        anchors.bottom: noteImage.bottom
    }

    Rectangle {
        id: highlightRectangle
        width: noteImage.width * 0.9
        height: noteImage.height * 0.9
        color: "red"
        opacity: 0.6
        border.color: "white"
        radius: width / 6
        visible: noteMouseArea.containsMouse || highlightTimer.running
    }

    Image {
        id: noteImage
        source: "qrc:/gcompris/src/activities/piano_composition/resource/" + noteDetails.imageName + noteType + ".svg"
        sourceSize.width: 200
        width: note.width
        height: note.height
    }

    // If the result is not good enough maybe have a rectangle and use opacity mask with a note
    ColorOverlay {
        anchors.fill: noteImage
        source: noteImage

        readonly property int noteColorNumber: blackType == "" ? whiteNoteName[noteName[0]] : blackNoteName[noteName.substring(0,2)]

        color: noteColorMap[noteColorNumber]  // make image like it lays under red glass
        visible: noteIsColored
    }

    Timer {
        id: highlightTimer
        interval: noteDuration
        onRunningChanged: {
            highlightRectangle.visible = running
//             highlightImage.visible = running
        }
    }
}
