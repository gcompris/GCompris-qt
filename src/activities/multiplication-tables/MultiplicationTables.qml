/* GCompris - multiplication-tables.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
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

import "../../core"
import "multiplication-tables.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias repeater: repeater
            property alias gridTableRepeater: gridTableRepeater

            property int spacing: 5
            property int multiplier: 1
            property int multiplicand: 1
            property int rectHeight: main.height/15
            property int rectWidth: main.height/15 //main.width/20
            property bool answer: true
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /////////////////////////////////////////////////////
        
        Grid {
            id:grid_row
            anchors {
                top: parent.top
                topMargin: 20
                left: parent.left
                leftMargin: 20
            }
            spacing: items.spacing
            columns: 11
            rows: 1
            Repeater {
                id: repeater_grid_row
                model: 11
                Rectangle {
                   id: dots_grid_row
                   width: items.rectWidth
                   height: items.rectHeight
                   GCText{ text: index}
                }
            }

        }

        Grid {
            id:grid_col
            anchors {
                top: parent.top
                topMargin: 20
                left: parent.left
                leftMargin: 20
            }
            spacing: items.spacing
            columns: 1
            rows: 11
            Repeater {
                id: repeater_grid_col
                model: 11
                Rectangle {
                   id: dots_grid_col
                   width: items.rectWidth
                   height: items.rectHeight
                   GCText{ text: index}
                }
            }

        }

        Grid {
            id: grid
            anchors {
                top: grid_row.bottom
                topMargin: items.spacing
                left: grid_col.right
                leftMargin: items.spacing
            }

            spacing: items.spacing
            columns: 10
            rows: 10

            Repeater {
               id: repeater
               model: 100
               Rectangle {
                  id: dots
                  width: items.rectWidth
                  height: items.rectHeight
                  state: "default"
                  property bool clickedFlag: false
                  states:[
                      State {
                          name: "default"
                          PropertyChanges { target: dots; color: "green"}
                          PropertyChanges { target: dots; clickedFlag: false}
                      },
                      State {
                          name: "active"
                          PropertyChanges { target: dots; color: "red"}
                          PropertyChanges { target: dots; clickedFlag: true}
                      }
                  ]

                  MouseArea {
                      anchors.fill: parent
                      onClicked: {
                          if (dots.state == "default")
                              dots.state = "active"
                          else
                              dots.state = "default"
                      }
                  }
               }
            }
        }

        GCText{
            id: numberForTable
            anchors {
                top: parent.top
                topMargin: main.height/5 - 2*numberForTable.height/3
                right: parent.right
                rightMargin: (main.width - grid.width - grid_col.width - numberForTable.width) / 2
            }
            fontSize: 80
            text: items.multiplicand
        }

        Grid {
            id: gridTable
            anchors {
                top: numberForTable.bottom
                topMargin: -10
                horizontalCenter: numberForTable.horizontalCenter
            }
            spacing: 2
            columns: 1
            rows: 10
            Repeater {
                id: gridTableRepeater
                model: 10
                GCText{
                    text: items.multiplicand + " x " + (index+1) + " = " + items.multiplicand*(index+1)
                    opacity: 0.0
                }
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                bottomMargin: items.spacing
                left: bar.right
                leftMargin: 500
            }
            width: 300
            height: 100
            color:"yellow"
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Check your answer"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    for(var i=0; i<repeater.count; i++) {
                        if(repeater.itemAt(i).clickedFlag) {
                            if( i%10 >= items.multiplier ) {
                                items.answer = false
                            }
                            if( i >= items.multiplicand *10 ) {
                                items.answer = false
                            } // To check if red then not outside red area
                            //console.log((i+1), "asdfgh", items.multiplicand, "asd", items.multiplier,"asdf",( i%10 >= items.multiplier ), "asdf", ( i >= items.multiplicand *10 ))
                        }
                        if(!(repeater.itemAt(i).clickedFlag)) {
                            if( i%10 < items.multiplier && i < items.multiplicand *10 ) {
                                items.answer = false
                            }  // To check if green then not in red area
                            //console.log((i+1), "asdfgh", items.multiplicand, "asd", ( i%10 < items.multiplier && i < items.multiplicand *10 ), "answere", items.answer)
                        }
                    }
                    Activity.checkit()
                }
            }
        }

        /////////////////////////////////////////

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
