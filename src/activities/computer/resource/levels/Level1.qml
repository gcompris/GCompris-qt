/* GCompris - level1.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick)
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
import "../../computer.js" as Activity
import "../../../../core"

Item {

    Image {
        id: table
        source: Activity.url + "images/table.svg"
        sourceSize.height: parent.height/2
        sourceSize.width: parent.width/2
        anchors {
            left: parent.left
            leftMargin: parent.width*0.1*ApplicationInfo.ratio
            bottom: parent.bottom
            bottomMargin: 0.2*parent.height*ApplicationInfo.ratio
        }

        Image {
            id: switchboard
            sourceSize.width: parent.width*0.15
            source: Activity.url + "images/switchoff.svg"
            anchors {
                bottom: table.top
                right: table.right
                rightMargin: parent.width*0.2
                bottomMargin: parent.height*0.3
            }
            MouseArea {
                anchors.fill: switchboard
                onClicked: switchboard.source = switchboard.source == Activity.url + "images/switchoff.svg" ? Activity.url + "images/switchon.svg" : Activity.url + "images/switchoff.svg"
            }
        }

        Image {
            id:monitor
            source: Activity.url + "images/monitor.svg"
            sourceSize.height: parent.height/2
            sourceSize.width :parent.width/2
            anchors {
                bottom: table.bottom
                left: table.left
                leftMargin: table.width *0.2
                bottomMargin: table.height*0.9

            }

            Flickable {
                id: flick
                width:monitor.width*0.65
                height:monitor.height*0.7
                contentWidth: edit.paintedWidth
                contentHeight: edit.paintedHeight
                clip: true
                anchors {
                    left:monitor.left
                    leftMargin:monitor.width*0.1
                    top:monitor.top
                    topMargin:monitor.height*0.1
                }

                function ensureVisible(r)
                {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX+width <= r.x+r.width)
                        contentX = r.x+r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY+height <= r.y+r.height)
                        contentY = r.y+r.height-height;
                }

                TextEdit {
                    id: edit
                    color:"red"
                    width: flick.width
                    height: flick.height
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                }
            }
            visible: true
        }

        Image {
            id:cpu
          source: Activity.url + "images/cpu.svg"
            sourceSize.height: parent.height*0.60
            sourceSize.width :parent.width/2

            anchors {
                bottom: table.bottom
                left: monitor.right
                leftMargin: table.width *0.1
                bottomMargin: table.height*0.8
            }
            visible: true
        }

        Image {
            id:keyboard
            source: Activity.url + "images/keyboard.svg"
            sourceSize.height: parent.height/4
            sourceSize.width : parent.width/3

            anchors {
                top: monitor.bottom
                left: table.left
                leftMargin: table.width *0.3
            }
            visible: true
        }

        Image {
            id:mouse
            source: Activity.url + "images/mouse.svg"
            sourceSize.height: parent.height/3
            sourceSize.width :parent.width/3

            anchors {
                bottom: table.bottom
                left: keyboard.right
                leftMargin: table.width *0.1
                bottomMargin :table.height*0.6
            }
            visible: true
        }
    }
}
