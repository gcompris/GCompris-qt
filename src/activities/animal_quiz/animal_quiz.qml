/* GCompris - sanjay.qml
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.2

import "../../core"
import "animal_quiz.js" as Activity

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
            property alias backgroundImg: backgroundImg
            property alias option1: bt1
            property alias option2: bt2
            property alias option3: bt3
            property alias respond: respond
            property alias anim: anim
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors.topMargin: parent
            text: "Animals"
            fontSize: largeSize
        }

        Image {
            id: backgroundImg
            source: Activity.url + Activity.animals[0]
            sourceSize.height: parent.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

        }
        SequentialAnimation{
            id:anim
            NumberAnimation { target:backgroundImg; property:"x"; from : 0; to : 200;duration:500 }
        }

        Column {
            id: answers
            spacing: 2
            anchors.left: backgroundImg.right
            anchors.verticalCenter: parent.verticalCenter
            Button {
                id: bt1
                text: "option1"
                onClicked: Activity.validate(bt1.text)
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 150
                            implicitHeight: 50
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                 }
            }
            Button {
                id:bt2
                text: "options2"
                onClicked: Activity.validate(bt2.text)
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 150
                            implicitHeight: 50
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                 }
            }
            Button {
                id: bt3
                text: "option3"
                onClicked: Activity.validate(bt3.text)
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 150
                            implicitHeight: 50
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                 }
            }
        }

        GCText {
            id:respond
            anchors.left:backgroundImg.left
            text: ""
            fontSize: largeSize
            visible: false
            color: "green"
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
