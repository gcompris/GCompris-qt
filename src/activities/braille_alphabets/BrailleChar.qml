/* GCompris - ColorItem.qml
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
    id:newit

    property var wid
    property var hei
    property alias circles: circles
    property bool clickable

    height: parent.height / 1.1
    width: parent.width / 1.1


    Grid {

        anchors.centerIn: newit
        id: gridthree
        spacing: parent.height / 50
        columns: 2
        rows: 3
        flow: Grid.TopToBottom

        Repeater {

            id: circles
            model: ["1","2","3","4","5","6"]



            Rectangle {
                property bool on: (clickable) ? false : true
                id: incircle1
                border.width: parent.height / 30
                color: click_on_off()
                function click_on_off() {
                    if(clickable) {
                        incircle1.color  = "white"
                    }
                    else {
                        var t  = 0;
                        var arr  = [];
                        for( t  = 0; t < braille_letter.count; t++) {
                            if(braille_letter.get(t).pos != 0) {
                                arr.push(braille_letter.get(t).pos)
                            }
                        }
                        if(arr.indexOf((index + 1)) > -1)
                            incircle1.color  = "red"
                        else
                            incircle1.color  = "white"

                    }
                }


                Text {
                    id: numtext
                    text: (clickable) ? modelData : ""
                    scale: 3

                    function alignment() {
                        if(index < 3) {
                            anchors.right = incircle1.left
                        }
                        else
                            anchors.left = incircle1.right
                    }

                    anchors.left: alignment()
                    font.weight: Font.DemiBold
                    anchors.margins: 10
                }

                MouseArea {

                    function abcd() {
                        if (incircle1.state == "on") {
                            incircle1.state = "off"
                        }
                        else {
                            incircle1.state = "on"
                        }
                        incircle1.opacity = 1


//                        Call the below function to print the current alphabet to the console
//                        Activity.current_alphabet();


                    }

                    id : mouse1
                    enabled: (clickable) ? true : false
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if(incircle1.state == "off") {
                                   incircle1.color = "#E41B2D"
                                   incircle1.opacity = 0.3
                               }
                    onExited :if(incircle1.opacity == 0.3) {
                                  incircle1.color = "white"
                                  incircle1.opacity = 1
                              }
                    onClicked: abcd()
                }


                state: {
                    if(clickable) {
                        state  = "off"
                    }
                }

                states: [
                    State {
                        name: "on"

                        PropertyChanges { target: incircle1; color:"red" }
                        PropertyChanges { target: incircle1; on: true }

                    },
                    State {
                        name: "off"

                        PropertyChanges { target: incircle1; color:"white" }
                        PropertyChanges { target: incircle1; on: false }
                    }
                ]

                border.color: "black"
                width: wid; height:hei
                radius: width*0.5

            }
        }
    }
}



