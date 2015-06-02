/* GCompris - computer-part.qml
 *
 * Copyright (C) 2015 <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   "Sagar Chand Agarwal" <atomsagar@gmail.com> (Qt Quick port)
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
import "computer-part.js" as Activity
import "computer-part-data.js" as Dataset
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "resource/background.svg"

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
            property var dataset: Dataset.dataset
        }

        onStart: { Activity.start(items,information) }
        onStop: { Activity.stop() }

        Information {
            id: information
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                left: parent.left
                leftMargin: 5
            }

        }


        Image {
            id: table
            source: "resource/table.svg"
            sourceSize.height: parent.height/2
            sourceSize.width: parent.width/2
            anchors {
                left: parent.left
                leftMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: parent.height*0.3*ApplicationInfo.ratio
            }
        }

        Image {
            id: boxclosed
            source: "resource/closebox.svg"
            visible: true
            sourceSize.height: parent.width/3
            sourceSize.width: parent.height/3
            anchors {
                right :parent.right
                rightMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: parent.height*0.1*ApplicationInfo.ratio
            }

            MouseArea {
                anchors.fill :boxclosed
                onClicked: {
                    boxclosed.visible=false,
                            boxopened.visible=true
                }
            }
        }

        Image {
            id: boxopened
            source: "resource/openbox.svg"
            sourceSize.height: boxclosed.height
            sourceSize.width: boxclosed.width
            anchors {
                right: parent.right
                rightMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: parent.height*0.1*ApplicationInfo.ratio

            }
            visible: false
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
                items.count = 0
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
            sourceSize.height: 80 * ApplicationInfo.ratio
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
            anchors.top: table.bottom
            anchors.left: parent.left
            anchors.leftMargin: 0.1*parent.width*ApplicationInfo.ratio
            anchors.topMargin: 5 * ApplicationInfo.ratio
            anchors.right: boxopened.left
            anchors.rightMargin: 20*ApplicationInfo.ratio

            GCText {
                id:info
                color: "red"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                fontSize: regularSize
                text: items.dataset[items.count].text
            }
        }

        // Image and name
        Image {
            id: img
            anchors.bottom: boxclosed.top
            anchors.bottomMargin: 40 * ApplicationInfo.ratio
            anchors.right : parent.right
            anchors.rightMargin: parent.width*0.1*ApplicationInfo.ratio
            sourceSize.height: boxopened*2*ApplicationInfo.ratio
            sourceSize.width: boxopened*2*ApplicationInfo.ratio
            source: items.dataset[items.count].img
            fillMode: Image.PreserveAspectFit

            Rectangle {
                id: name_rect
                border.color: "black"
                border.width: 1
                color: "white"
                width: name.width * 1.1
                height: name.height * 1.1
                anchors {
                    top: img.top
                    horizontalCenter: img.horizontalCenter
                    bottomMargin: 0.1*parent.height
                }
                GCText {
                    id: name
                    color: "blue"
                    fontSize: regularSize
                    anchors.centerIn: name_rect
                    text: items.dataset[items.count].name
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: background.next()
            }
        }

        Image {
            id: next
            anchors.left: img.right
            anchors.leftMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.height: 80 * ApplicationInfo.ratio
            Behavior on scale { PropertyAnimation { duration: 100} }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: next.scale = 1.1
                onExited: next.scale = 1
                onClicked: background.next()
            }
        }



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
