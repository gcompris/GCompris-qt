/* GCompris - musicElement.qml
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"

Item {
    id: musicElement
    width: noteImageWidth
    height: multipleStaff.height / 5

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        highlightTimer.stop();
    }

    property string noteName
    property string noteType
    property string soundPitch
    property string clefType
    property string elementType
    property bool noteIsColored: true
    property bool isDefaultClef: false
    property string blackType: noteName === "" ? ""
                                               : noteName[1] === "#" ? "sharp"
                                               : noteName[1] === "b" ? "flat" : ""// empty, "flat" or "sharp"

    /**
     * Calculates and assign the timer interval for a note.
     */
    function calculateTimerDuration(noteType) {
        noteType = noteType.toLowerCase()
        if(noteType === "whole")
            return 240000 / multipleStaff.bpmValue
        else if(noteType === "half")
            return 120000 / multipleStaff.bpmValue
        else if(noteType === "quarter")
            return 60000 / multipleStaff.bpmValue
        else
            return 30000 / multipleStaff.bpmValue
    }

    readonly property int duration: {
        if(elementType != "clef") {
            if(noteType === "Rest")
                return calculateTimerDuration(noteName)
            else
                return calculateTimerDuration(noteType)
        }
        return 0
    }

    readonly property real noteImageWidth: (multipleStaff.width - 15 - clefImageWidth) / 10

    readonly property var noteColorMap: { "1": "#FF0000", "2": "#FF7F00", "3": "#FFFF00",
        "4": "#32CD32", "5": "#6495ED", "6": "#D02090", "7": "#FF1493", "8": "#FF0000",
        "-1": "#FF6347", "-2": "#FFD700", "-3": "#20B2AA", "-4": "#8A2BE2",
        "-5": "#FF00FF" }

    readonly property var whiteNoteName: { "C": "1", "D": "2", "E": "3", "F": "4", "G": "5", "A": "6", "B": "7", "C": "8" }

    readonly property var sharpNoteName: { "C#": "-1", "D#": "-2", "F#": "-3", "G#": "-4", "A#": "-5" }
    readonly property var flatNoteName: { "Db": "-1", "Eb": "-2", "Gb": "-3", "Ab": "-4", "Bb": "-5" }
    readonly property var blackNoteName: blackType == "" ? blackType
                                                         : blackType == "flat" ? flatNoteName : sharpNoteName

    property bool highlightWhenPlayed: false
    property alias highlightTimer: highlightTimer

    property var noteDetails

    property bool noteAnswered: false
    property bool isCorrectlyAnswered: false

    rotation: {
        if((noteDetails === undefined) || elementType === "clef")
            return 0
        else if((noteDetails.positionOnStaff < 0) && (noteType === "Whole"))
            return 180
        else
            return noteDetails.rotation
    }
    
    Image {
        id: blackTypeImage
        source: blackType !== "" ? "qrc:/gcompris/src/activities/piano_composition/resource/black" + blackType + ".svg" : ""
        sourceSize.width: noteImage.width / 2
        anchors.right: parent.rotation === 180 ? undefined : noteImage.left
        anchors.left: parent.rotation === 180 ? noteImage.right : undefined
        rotation: parent.rotation === 180 ? 180 : 0
        anchors.rightMargin: -noteImage.width / 4
        anchors.leftMargin: -noteImage.width / 2.5
        anchors.bottom: noteImage.bottom
        anchors.bottomMargin: parent.height / 6
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: highlightRectangle
        width: musicElement.width
        height: musicElement.height * 0.9
        color: "transparent"
        opacity: 1
        border.color: "#373737"
        border.width: radius * 0.5
        radius: width * 0.1
        visible: (multipleStaff.noteHoverEnabled && noteMouseArea.containsMouse) || highlightTimer.running
    }

    Rectangle {
        id: selectedNoteIndicator
        width: musicElement.width
        height: musicElement.height * 0.9
        color: "blue"
        opacity: 0.6
        border.color: "white"
        radius: width / 5
        visible: selectedIndex == index
    }
    
    Image {
        id: noteImage
        source: (noteDetails === undefined) ? ""
                : noteType != "Rest" ? "qrc:/gcompris/src/activities/piano_composition/resource/" + noteDetails.imageName + noteType + ".svg"
                : "qrc:/gcompris/src/activities/piano_composition/resource/" + noteDetails.imageName + ".svg"
        sourceSize.width: 200
        width: musicElement.width
        height: musicElement.height
        mirror: parent.rotation == 180 && parent.noteType == "Eighth" ? true : false
    }

    Image {
        id: clefImage
        source: (elementType === "clef") ? "qrc:/gcompris/src/activities/piano_composition/resource/" + clefType.toLowerCase() + "Clef.svg" : ""
        sourceSize.width: multipleStaff.clefImageWidth
    }

    Image {
        id: correctOrWrongAnswerIndicator
        visible: noteAnswered
        source: isCorrectlyAnswered ? "qrc:/gcompris/src/activities/piano_composition/resource/passed.svg"
                                    : "qrc:/gcompris/src/activities/piano_composition/resource/failed.svg"
        sourceSize.width: noteImage.width / 2.5
        anchors.right: parent.rotation === 180 ? undefined : noteImage.right
        anchors.left: parent.rotation === 180 ? noteImage.left : undefined
        rotation: parent.rotation === 180 ? 180 : 0
        anchors.rightMargin: 12
        anchors.bottom: noteImage.bottom
        anchors.bottomMargin: parent.height / 6
        fillMode: Image.PreserveAspectFit
        z: 3
    }
    
    Rectangle {
        id:softColor
        readonly property int invalidConditionNumber: -6
        readonly property int noteColorNumber: {
            if(noteDetails === undefined || noteType === "" || noteType === "Rest" || noteName === "")
                return invalidConditionNumber
            else if((blackType === "") && (whiteNoteName[noteName[0]] != undefined))
                return whiteNoteName[noteName[0]]
            else if((noteName.length > 2) && (blackNoteName[noteName.substring(0,2)] != undefined))
                return blackNoteName[noteName.substring(0,2)]
            else
                return invalidConditionNumber
        }
        color: {
            if(multipleStaff.notesColor === "inbuilt")
                return (noteColorNumber > invalidConditionNumber) ? noteColorMap[noteColorNumber] : "white"
            else
                return multipleStaff.notesColor
        }
        z: -1
        width: noteImage.width * 0.8
        height: width
        radius: width * 0.5
        anchors.centerIn: noteImage
        opacity: softColorOpacity
        visible: noteIsColored && (elementType != "clef")
    }

    Timer {
        id: highlightTimer
        interval: duration
    }
}
