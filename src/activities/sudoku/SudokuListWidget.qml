/* gcompris - SudokuListWidget.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
import GCompris 1.0
import "sudoku.js" as Activity
import "../../core"

Item {
    id: listWidget
    width: view.width
    height: view.height
    anchors {
        left: parent.left
        leftMargin: 2 * ApplicationInfo.ratio
        top: parent.top
        topMargin: 2 * ApplicationInfo.ratio
    }

    property alias model: mymodel;
    property alias view: view;
    property GCSfx audioEffects

    ListModel {
        id: mymodel
    }

    ListView {
        id: view
        width: background.width / 5
        height: background.height - 2 * bar.height
        interactive: false
        spacing: 10
        model: mymodel
        delegate: contactsDelegate

        property int iconSize: Math.min((height - mymodel.count * spacing) /
                                        mymodel.count,
                                        view.width * 0.95)

        Component {
            id: contactsDelegate

            Item {
                width: view.iconSize
                height: view.iconSize

                Image {
                    id: icon
                    anchors.centerIn: parent
                    sourceSize.height: view.iconSize
                    source: model.imgName === undefined ? "" :
                                                          Activity.url + model.imgName + extension
                    z: iAmSelected ? 10 : 1

                    property bool iAmSelected: view.currentIndex == index

                    states: [
                        State {
                            name: "notclicked"
                            when: !icon.iAmSelected && !mouseArea.containsMouse
                            PropertyChanges {
                                target: icon
                                scale: 0.8
                            }
                        },
                        State {
                            name: "clicked"
                            when: mouseArea.pressed
                            PropertyChanges {
                                target: icon
                                scale: 0.7
                            }
                        },
                        State {
                            name: "hover"
                            when: mouseArea.containsMouse
                            PropertyChanges {
                                target: icon
                                scale: 1.1
                            }
                        },
                        State {
                            name: "selected"
                            when: icon.iAmSelected
                            PropertyChanges {
                                target: icon
                                scale: 1
                            }
                        }
                    ]

                    SequentialAnimation {
                        id: anim
                        running: icon.iAmSelected
                        loops: Animation.Infinite
                        alwaysRunToEnd: true
                        NumberAnimation {
                            target: icon
                            property: "rotation"
                            from: 0; to: 10
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: icon
                            property: "rotation"
                            from: 10; to: -10
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: icon
                            property: "rotation"
                            from: -10; to: 0
                            duration: 200
                            easing.type: Easing.InQuad
                        }
                    }

                    Behavior on scale { NumberAnimation { duration: 70 } }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: icon
                        hoverEnabled: true
                        onClicked: {
                            listWidget.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                            view.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}

