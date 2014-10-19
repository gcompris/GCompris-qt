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
    id: brailleChar

    property real dotWidth: width * 0.2
    property real dotHeight: dotWidth
    property alias circles: circles
    property bool clickable

    Grid {

        anchors.centerIn: brailleChar
        id: gridthree
        spacing: parent.height / 50
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
                    for( var i  = 0; i < braille_letter.count; i++) {
                        if(braille_letter.get(i).pos === index + 1) {
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
                    font.pointSize: Math.min(20 * ApplicationInfo.ratio,
                                             Math.max(parent.height, 10))
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
