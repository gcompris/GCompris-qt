/* GCompris - multiplication-chart.qml
 *
 * Copyright (C) 2016 Varun Kumar <varun13169@iiitd.ac.in>
 *
 * Authors:
 *
 *   Varun Kumar <varun13169@iiitd.ac.in>
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
import "multiplication-chart.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/multiplication-chart/resource/numbers.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height

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
            /*variables*/
            property int spacing: 5
            /*
            property int rectHeight: wrap.height/25
            property int rectWidth: wrap.height/25
            */
            property int rowSelected: 0
            property int colSelected: 0
            property int rowQues: 0
            property int colQues: 0
        }

        onStart: Activity.start(items, additionalItem)
        onStop:  Activity.stop()



        /////////////////////////////////////////////////////
        Rectangle {
            id: wrap
            color: "transparent"
            opacity: 1
            height: Math.min(background.height , background.width)
            width:  height
            anchors.centerIn: background
            property int rectHeight: wrap.height/25
            property int rectWidth: wrap.height/25

        Grid {
            id:gridRow
            anchors {
                top: parent.top
                topMargin: 20*(ApplicationInfo.ratio/1.476923076923077) //(wrap.height*5)/192     // 768*5/192 = 20
                left: parent.left
                leftMargin: 20*(ApplicationInfo.ratio/1.476923076923077) //(wrap.width*15)/683  // 1366*15/683 = 150
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
                   width: wrap.rectWidth
                   height: wrap.rectHeight
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

                   GCText{
                       text: index
                       anchors.centerIn: parent
                       fontSize: 12*(ApplicationInfo.fontRatio/1.6) //(wrap.height*6)/384  //768*6/384 = 12
                       //fontSizeMode: Text.Fit//; minimumPixelSize: 1
                   }

                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           if (dotsGridRow.state == "default") {
                               dotsGridRow.state = "active"
                               items.rowSelected = index
                           }
                           else {
                               dotsGridRow.state = "default"
                               items.rowSelected = 0
                           }
                           Activity.makeOtherColInRowWhite()
                           Activity.changesInMainBoard()
                           Activity.checkit()
                       }
                   }
                }

            }
        }

        Grid {
            id:gridCol
            anchors {
                top: parent.top
                topMargin:  20*(ApplicationInfo.ratio/1.476923076923077) //(wrap.height*5)/192    // 768*5/192 = 20
                left: parent.left
                leftMargin: 20*(ApplicationInfo.ratio/1.476923076923077) //(wrap.width*15)/683  // 1366*15/683 = 150
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
                   width: wrap.rectWidth
                   height: wrap.rectHeight
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

                   GCText {
                       text: index
                       anchors.centerIn: parent
                       fontSize: 12*(ApplicationInfo.fontRatio/1.6) //(wrap.height*6)/384  //768*6/384 = 12
                   }

                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           if (dotsGridCol.state == "default") {
                               dotsGridCol.state = "active"
                               items.colSelected = index
                           }
                           else {
                               dotsGridCol.state = "default"
                               items.colSelected = 0
                           }
                           Activity.makeOtherRowInColWhite()
                           Activity.changesInMainBoard()
                           Activity.checkit()
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
                    width: wrap.rectWidth
                    height: wrap.rectHeight
                    color: "green"

                    GCText {
                        text: (Math.floor(index/10) + 1) * (index%10 + 1)
                        anchors.centerIn: parent
                        fontSize: 12*(ApplicationInfo.fontRatio/1.6) //(wrap.height*6)/384  //768*6/384 = 12
                    }

                }
            }
        }

        GCText{
            id: instruction
            anchors {
                top: parent.top
                topMargin: (wrap.height/4 - instruction.height/3)
                left: grid.right
                leftMargin: 20*(ApplicationInfo.ratio/1.476923076923077) //(wrap.width*17)/683 // 1366*17/683 = 34
            }
            fontSize: 14*(ApplicationInfo.fontRatio/1.6) //(wrap.height*7)/384  //768*7/384 = 14
            text: qsTr("Instruction:\n")+
                    qsTr("   Multiplicand x Multiplier\n")+
                    qsTr("                      = Answer\n")+
                    qsTr("       1) Select the Column\n")+
                    qsTr("       2) Select the Row\n")+
                    qsTr("       3) State the answer\n")
        }

        GCText {
            id: question
            anchors {
                left: wrap.left
                leftMargin: 230*(ApplicationInfo.ratio/1.476923076923077) //(wrap.height*115)/384  //768*10/384 = 20
                top: grid.bottom
                topMargin: 50*(ApplicationInfo.ratio/1.476923076923077) //(wrap.height*30)/384  //768*10/384 = 20
            }
            fontSize: 32*(ApplicationInfo.fontRatio/1.6) //(wrap.height*16)/384  //768*16/384 = 32
            text: items.rowQues + " X " + items.colQues + " = " + numpad.answer
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


    Item {
        id: additionalItem
        property alias numpad: numpad
    }

    NumPad {
        id: numpad
        maxDigit: 3
        onAnswerChanged: {
            Activity.checkit()
            //console.log(ApplicationInfo.ratio, "asdf")
        }
    }

    Keys.onPressed: {
        numpad.updateAnswer(event.key, true);
    }

    Keys.onReleased: {
        numpad.updateAnswer(event.key, false);
    }

}
