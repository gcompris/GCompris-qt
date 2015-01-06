/* GCompris - BrailleChar.qml
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
import QtMultimedia 5.0
import "braille_alphabets.js" as Activity
import "../../core"
import "questions.js" as Data
import GCompris 1.0

Item {
    id: brailleCharItem
    height: dotWidth * 3 + grid.spacing * 4

    property string brailleChar: ""
    property real dotWidth: width * 0.4
    property real dotHeight: dotWidth
    property alias circles: circles
    property bool clickable
    property bool isLetter: brailleChar >= 'A' && brailleChar <= 'Z'
    property variant brailleCodesLetter: {
        // For ASCII each letter, this represent the active dots in Braille.
        "A": [1], "B": [1, 2], "C": [1, 4], "D": [1, 4, 5], "E": [1, 5],
        "F": [1, 2, 4], "G": [1, 2, 4, 5], "H": [1, 2, 5], "I": [2, 4],
        "J": [2, 4, 5], "K": [1, 3], "L": [1, 2, 3], "M": [1, 3, 4],
        "N": [1, 3, 4, 5], "O": [1, 3, 5], "P": [1, 2, 3, 4], "Q": [1, 2, 3, 4, 5],
        "R": [1, 2, 3, 5], "S": [2, 3, 4], "T": [2, 3, 4, 5], "U": [1, 3, 6],
        "V": [1, 2, 3, 6], "W": [2, 4, 5, 6], "X": [1, 3, 4, 6], "Y": [1, 3, 4, 5, 6],
        "Z": [1, 3, 5, 6]
    }
    property variant brailleCodesNumber: {
        // For ASCII each letter, this represent the active dots in Braille.
        "+" : [3,4,6], "-": [3,6], "*" : [1,6], "/" : [3,4],
        "#" : [3,4,5,6],1: [1],2 :[1, 2], "3" : [1, 4], "4": [1, 4, 5], "5" : [1, 5],
        "6" : [1, 2, 4], "7" : [1, 2, 4, 5], "8" : [1, 2, 5], "9" : [2, 4], "0" :[3, 5, 6]
    }
    property variant brailleCodes: isLetter ? brailleCodesLetter : brailleCodesNumber

    function updateDotsFromBrailleChar() {
        var dots = []
        for(var car in brailleCodes) {
            if(car === brailleChar) {
                dots = brailleCodes[car]
            }
        }

        // Clear all the dots
        for( var i = 0; i < 6; i++) {
            circles.itemAt(i).state = "off"
        }

        for( var i in dots) {
            circles.itemAt(i).state = "on"
        }
    }

    function updateBrailleCharFromDots() {
        var dots = []
        for( var i = 0; i < 6; i++) {
            if(circles.itemAt(i).state === "on")
                dots.push(i + 1)
        }

        for(var car in brailleCodes) {
            if(JSON.stringify(brailleCodes[car]) === JSON.stringify(dots)) {
                brailleChar = car
                return
            }
        }
        brailleChar = ""
    }

    Grid {
        id: grid
        anchors.centerIn: brailleCharItem
        spacing: (brailleCharItem.width - brailleCharItem.dotWidth * 2) / 2
        columns: 2
        rows: 3
        flow: Grid.TopToBottom

        Repeater {

            id: circles
            model: ["1", "2", "3", "4", "5", "6"]

            Rectangle {
                id: incircle1
                border.width: 2 * ApplicationInfo.ratio
                color: on ? "red" : "white"
                border.color: "black"
                width: dotWidth
                height: dotHeight
                radius: width * 0.5

                property bool on: clickable ? false : click_on_off()

                function click_on_off() {
                    if(!brailleCodes[brailleChar])
                        return false
                    for( var i  = 0; i < brailleCodes[brailleChar].length; i++) {
                        if(brailleCodes[brailleChar][i] === index + 1) {
                            return true
                        }
                    }
                    return false
                }

                Text {
                    id: numtext
                    text: (clickable) ? modelData : ""
                    anchors.left: alignment()
                    font.weight: Font.DemiBold
                    font.pixelSize: Math.min(30 * ApplicationInfo.ratio,
                                             Math.max(parent.height, 20))
                    anchors.margins: 10

                    function alignment() {
                        if(index < 3) {
                            anchors.right = incircle1.left
                        } else {
                            anchors.left = incircle1.right
                        }
                    }
                }

                MouseArea {
                    id : mouse1
                    enabled:  clickable ? true : false
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: incircle1.border.width = 4 * ApplicationInfo.ratio
                    onExited : incircle1.border.width = 2 * ApplicationInfo.ratio
                    onClicked: {
                        if (incircle1.state == "on") {
                            incircle1.state = "off"
                        } else {
                            incircle1.state = "on"
                        }
                        // On touch screens we don't get the exit event.
                        incircle1.border.width = 2 * ApplicationInfo.ratio
                        brailleCharItem.updateBrailleCharFromDots()
                    }
                }

                states: [
                    State {
                        name: "on"

                        PropertyChanges {
                            target: incircle1
                            on: true
                        }

                    },
                    State {
                        name: "off"

                        PropertyChanges {
                            target: incircle1
                            on: false
                        }
                    }
                ]
            }
        }
    }
}
