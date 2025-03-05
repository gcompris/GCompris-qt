/* GCompris - BrailleChar.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import core 1.0

// Requires items.clickSound in activity items

Item {
    id: brailleCharItem
    height: dotWidth * 3 + grid.spacing * 4

    signal brailleCharClicked

    property string brailleChar: ""
    property real dotWidth: width * 0.4
    property real dotHeight: dotWidth
    property alias circles: circles
    property bool clickable
    property bool isLetter: brailleChar >= 'A' && brailleChar <= 'Z'
    property bool thinnestBorder: false
    property var brailleCodesLetter: {
        // For ASCII each letter, this represent the active dots in Braille.
        "A": [1], "B": [1, 2], "C": [1, 4], "D": [1, 4, 5], "E": [1, 5],
        "F": [1, 2, 4], "G": [1, 2, 4, 5], "H": [1, 2, 5], "I": [2, 4],
        "J": [2, 4, 5], "K": [1, 3], "L": [1, 2, 3], "M": [1, 3, 4],
        "N": [1, 3, 4, 5], "O": [1, 3, 5], "P": [1, 2, 3, 4], "Q": [1, 2, 3, 4, 5],
        "R": [1, 2, 3, 5], "S": [2, 3, 4], "T": [2, 3, 4, 5], "U": [1, 3, 6],
        "V": [1, 2, 3, 6], "W": [2, 4, 5, 6], "X": [1, 3, 4, 6], "Y": [1, 3, 4, 5, 6],
        "Z": [1, 3, 5, 6]
    }
    property var brailleCodesNumber: {
        // For ASCII each letter, this represent the active dots in Braille.
        "+": [3, 4, 6], "-": [3, 6], "*": [1, 6], "/": [3, 4],
        "#": [3, 4, 5, 6], "1": [1], "2" :[1, 2], "3": [1, 4], "4": [1, 4, 5],
        "5": [1, 5], "6": [1, 2, 4], "7": [1, 2, 4, 5], "8": [1, 2, 5],
        "9": [2, 4], "0" :[2, 4, 5]
    }
    property var brailleCodes: isLetter ? brailleCodesLetter : brailleCodesNumber

    function updateDotsFromBrailleChar() {
        var dots = []
        for(var car in brailleCodes) {
            if(car === brailleChar) {
                dots = brailleCodes[car]
            }
        }

        // Clear all the dots
        for(var i = 0; i < 6; i++) {
            circles.itemAt(i).state = "off"
        }

        for(var i in dots) {
            circles.itemAt(i).state = "on"
        }
    }

    function updateBrailleCharFromDots() {
        var dots = []
        for( var i = 0; i < 6; i++) {
            if(circles.itemAt(i).state === "on")
                dots.push(i + 1)
        }

        var stringifiedDots = JSON.stringify(dots)
        for(var car in brailleCodes) {
            if(JSON.stringify(brailleCodes[car]) === stringifiedDots) {
                brailleChar = car
                return
            }
        }
        brailleChar = ""
    }

    function clearLetter() {
        brailleChar = ""
        updateDotsFromBrailleChar()
    }

    function switchState(value: int) {
        circles.itemAt(value-1).switchState()
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
            model: 6

            Rectangle {
                id: incircle1
                border.width: brailleCharItem.thinnestBorder ?
                    GCStyle.thinnestBorder : GCStyle.thinBorder
                color: on ? GCStyle.darkText : GCStyle.lightText
                border.color: GCStyle.darkText
                width: dotWidth
                height: dotHeight
                radius: width * 0.5

                property bool on: clickable ? false : click_on_off()

                function click_on_off(): bool {
                    var code = brailleCodes[brailleChar]
                    if(!code)
                        return false
                    for(var i = 0; i < code.length; i++) {
                        if(code[i] === index + 1) {
                            return true
                        }
                    }
                    return false
                }

                function switchState() {
                    if (state == "on") {
                        state = "off"
                    } else {
                        state = "on"
                    }
                    // On touch screens we don't get the exit event.
                    border.width = 2 * ApplicationInfo.ratio
                    brailleCharItem.updateBrailleCharFromDots()
                    brailleCharItem.brailleCharClicked()
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                GCText {
                    id: numtext
                    text: clickable ? modelData+1 : ""
                    color: GCStyle.darkerText
                    anchors.left: index >= 3 ? incircle1.right : undefined
                    anchors.right: index < 3 ? incircle1.left : undefined
                    anchors.verticalCenter: incircle1.verticalCenter
                    font.weight: Font.DemiBold
                    font.pointSize: NaN // need to clear font.pointSize explicitly
                    font.pixelSize: Math.min(30 * ApplicationInfo.ratio,
                                             Math.max(parent.height, 20))
                    anchors.margins: GCStyle.halfMargins
                }

                MouseArea {
                    id : mouse1
                    enabled: clickable && !items.buttonsBlocked ? true : false
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: incircle1.border.width = GCStyle.thickBorder
                    onExited: incircle1.border.width = GCStyle.thinBorder
                    onClicked: {
                        incircle1.switchState();
                    }
                }

                states: [
                    State {
                        name: "on"

                        PropertyChanges {
                            incircle1 {
                                on: true
                            }
                        }

                    },
                    State {
                        name: "off"

                        PropertyChanges {
                            incircle1 {
                                on: false
                            }
                        }
                    }
                ]
            }
        }
    }
}
