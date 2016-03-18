/* GCompris - multiplication-chart.qml
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
import "multiplication-chart.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        source: "./resource/numbers.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height

        //anchors.fill: parent
        //color: "#ABCDEF"
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
            property alias repeaterGridRow: repeaterGridRow
            property alias repeaterGridCol: repeaterGridCol
            property alias repeater: repeater
            //property alias gridTableRepeater: gridTableRepeater

            property int spacing: 5
            property int multiplier: 1
            property int multiplicand: 1
            property int rectHeight: main.height/15
            property int rectWidth: main.height/15 //main.width/20
            property bool answer: true
            property int rowSelected: 0
            property int colSelected: 0
            property int rowQues: 0
            property int colQues: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /////////////////////////////////////////////////////

        Grid {
            id:gridRow
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
                id: repeaterGridRow
                model: 11
                Rectangle {
                   id: dotsGridRow
                   color: "white"
                   width: items.rectWidth
                   height: items.rectHeight
                   property bool clickedFlagRow: false
                   state: "default"
                   states:[
                       State {
                           name: "default"
                           PropertyChanges { target: dotsGridRow; color: "white"}
                           PropertyChanges { target: dotsGridRow; clickedFlagRow: false}
                       },
                       State {
                           name: "active"
                           PropertyChanges { target: dotsGridRow; color: "red"}
                           PropertyChanges { target: dotsGridRow; clickedFlagRow: false}
                       }
                   ]

                   GCText{ text: index}

                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           if (dotsGridRow.state == "default")
                               dotsGridRow.state = "active"
                           else
                               dotsGridRow.state = "default"
                           items.rowSelected = index
                           Activity.makeOtherColInRowWhite()
                       }
                   }
                }

            }
        }

        Grid {
            id:gridCol
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
                id: repeaterGridCol
                model: 11
                Rectangle {
                   id: dotsGridCol
                   color: "white"
                   width: items.rectWidth
                   height: items.rectHeight
                   property bool clickedFlagCol: false
                   state: "default"
                   states:[
                       State {
                           name: "default"
                           PropertyChanges { target: dotsGridCol; color: "white"}
                           PropertyChanges { target: dotsGridCol; clickedFlagCol: false}
                       },
                       State {
                           name: "active"
                           PropertyChanges { target: dotsGridCol; color: "red"}
                           PropertyChanges { target: dotsGridCol; clickedFlagCol: false}
                       }
                   ]

                   GCText{ text: index}

                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           if (dotsGridCol.state == "default")
                               dotsGridCol.state = "active"
                           else
                               dotsGridCol.state = "default"
                           items.colSelected = index
                           Activity.makeOtherRowInColWhite()
                           //Activity.changesInMainBoard()
                       }
                   }
                }
            }

        }

        Grid {
            id: grid
            anchors {
                top: gridRow.bottom
                topMargin: items.spacing
                left: gridCol.right
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
                    //state: "default"
                    property bool clickedFlag: false ///
                    color: "green"

                    GCText {
                        text: (Math.floor(index/10) + 1) * (index%10 + 1)
                    }

                }
            }
        }

        GCText{
            id: instruction
            anchors {
                top: parent.top
                topMargin: main.height/3 - 2*instruction.height/3
                right: parent.right
                rightMargin: (main.width/5)// - grid.width - gridCol.width - instruction.width) / 2
            }
            fontSize: regularSize
            text: "Instruction: \n Column x Row = Answer\n
1) Select the Column\n2) Select the Row\n3) State the answer"
        }

        GCText {
            id: question
            anchors {
                horizontalCenter: instruction.horizontalCenter
                top: instruction.bottom
                topMargin: 40
                }
            fontSize: hugeSize
            text: items.rowQues + " X " + items.colQues + " = "
        }

        /*Grid {
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
        }*/

        Image {
            anchors {
                bottom: parent.bottom
                bottomMargin: items.spacing
                left: bar.right
                leftMargin: 500
            }

            fillMode: Image.Stretch
            source: "./resource/redButton.svg"

            width: 250
            height: 100
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Click to Verify\n  Your Answer")
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Activity.checkPlaceChangedSquares()
                    Activity.checkit()
                }
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////////////

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
