/* GCompris - louis-braille.qml
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   <Srishti Sethi> (GTK+ version)
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
import QtQuick.Layouts 1.1
import GCompris 1.0
import "../../core"
import "../braille_alphabets"
import "louis-braille.js" as Activity
import "louis_braille_data.js" as Dataset
import "qrc:/gcompris/src/core/core.js" as Core

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
            property int count: 0
            property alias containerModel: containerModel
            property var dataset: Dataset.dataset
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        ListModel {
            id: containerModel
        }

        Image {
            id: charList
            y: 20 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            source: Activity.url + "top_back.svg"
            sourceSize.width: parent.width * 0.90


            Row {
                id: row
                spacing: 10 * ApplicationInfo.ratio
                anchors.centerIn: charList
                anchors.horizontalCenterOffset: 5
                width: parent.width

                Repeater {
                    id: cardRepeater
                    model: ["L","O","U","I","S"," ","B","R","A","I","L","L","E"]

                    Item {
                        id: inner
                        height: charList.height * 0.95
                        width:(charList.width - 13 * row.spacing)/ 13

                        Rectangle {
                            id: rect1
                            width:  charList.width / 13
                            height: ins.height
                            border.width: 3
                            opacity: index==5 ? 0 :1
                            border.color: "black"
                            color: "white"

                            BrailleChar {
                                id: ins
                                width: parent.width * 0.9
                                anchors.centerIn: parent
                                clickable: false
                                brailleChar: modelData
                            }
                        }

                        GCText {
                            text: modelData
                            font.weight: Font.DemiBold
                            style: Text.Outline
                            styleColor: "white"
                            color: "black"
                            fontSize: regularSize
                            anchors {
                                top: rect1.bottom
                                topMargin: 4 * ApplicationInfo.ratio
                                horizontalCenter: rect1.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        Keys.onRightPressed: background.next()
        Keys.onLeftPressed: background.previous()

        function previous() {
            if(items.count == 0)
                items.count = items.dataset.length - 1
            else
                items.count--
        }

        function next() {
            if(items.count == items.dataset.length - 1) {
                list.shuffle()
                items.count = 0
                list.visible = true
            } else {
                items.count++
            }
        }

        Image {
            id: previous
            anchors.right: img.left
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            Behavior on scale { PropertyAnimation { duration: 100} }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: previous.scale = 1.1
                onExited: previous.scale = 1
                onClicked: background.previous()
            }
        }

        // The image description
        Rectangle {
            id: info_rect
            border.color: "black"
            border.width: 1 * ApplicationInfo.ratio
            color: "white"
            width: parent.width * 0.9
            height:info.height * 1.3
            anchors.top: charList.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5 * ApplicationInfo.ratio

            GCText {
                id:info
                color: "black"
                font.pixelSize: Math.max(parent.width * 0.01, 20)
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                fontSize: regularSize
                text: items.dataset[items.count].text
            }
        }

        // Image and date
        Image {
            id: img
            anchors.top: info_rect.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: parent.height - (charList.height + info_rect.height + bar.height)
            source: items.dataset[items.count].img

            Rectangle {
                id: year_rect
                border.color: "black"
                border.width: 1
                color: "white"
                width: year.width * 1.1
                height: year.height * 1.1
                anchors {
                    bottom: img.bottom
                    horizontalCenter: img.horizontalCenter
                    bottomMargin: 5 * ApplicationInfo.ratio
                }
                GCText {
                    id: year
                    color: "black"
                    fontSize: regularSize
                    anchors.centerIn: year_rect
                    text: items.dataset[items.count].year
                }
            }

        }

        Image {
            id: next
            anchors.left: img.right
            anchors.leftMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            Behavior on scale { PropertyAnimation { duration: 100} }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: next.scale = 1.1
                onExited: next.scale = 1
                onClicked: background.next()
            }
        }

        Keys.onUpPressed: list.up()
        Keys.onDownPressed: list.down()
        Keys.onEnterPressed: list.space()
        Keys.onReturnPressed: list.space()
        Keys.onSpacePressed: list.space()

        ReorderList {
            id: list
            visible: false
            bonus: bonus

            signal shuffle

            onShuffle: {
                containerModel.clear()
                var dataitems = items.dataset
                dataitems = Core.shuffle(dataitems)
                for(var i = 0 ; i < dataitems.length ; i++) {
                    containerModel.append(dataitems[i]);
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(list.shuffle)
        }
    }

}
