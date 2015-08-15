/* GCompris - computer.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *
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

import "../../core"
import "computer.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "images/background.svg"
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
            property alias img: img
            property alias name: name
            property alias info: intro_text
            property alias answers: answers
        }

        // show of current part of topic

        Rectangle {
            id: intro_textbg
            x: intro_text.x - 4
            y: intro_text.y - 4
            width: intro_text.width + 4
            height: intro_text.height + 4
            color: "#d8ffffff"
            border.color: "#2a2a2a"
            border.width: 2
            radius: 8
        }

        GCText {
            id: intro_text
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: parent.top
                topMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 5 * ApplicationInfo.ratio
                left: parent.left
                leftMargin: 5 * ApplicationInfo.ratio
            }
            width: parent.width
            wrapMode: Text.WordWrap
            fontSize: smallSize * 0.5
            text: qsTr("Click on the box below.")
        }

        // starts with openBox

        Image {
            id: closebox
            source: Activity.url + "images/closebox.svg"
            sourceSize.width: parent.width*0.15
            anchors {
                centerIn: parent
            }
            visible: true
            NumberAnimation on scale{
                id: box_scale
                running: true
                loops: Animation.Infinite
                from: 1
                to: 1.5
                duration: 2000
            }
            MouseArea {
                anchors.fill: closebox
                id: closebox_area
                onClicked: {
                    openbox.visible = true
                    box_scale.running = false
                    closebox.visible= false
                    show.start()
                }
            }
        }

        Image {
            id: openbox
            source: Activity.url + "images/openbox.svg"
            sourceSize.width: parent.width*0.15
            anchors {
                centerIn: parent
            }
            visible: false
        }

        // timer activated on click on close box

        Timer {
            id: show
            interval: 500
            repeat: false
            running: false
            onTriggered: {
                intro_text.text = qsTr("Parts of the Computer")
                holder.visible = true
                openbox.visible = false
                show.stop()
                previous.visible =  true
                next.visible = true
                intro_text.visible = true
                Activity.next()
                holder.visible = true
            }
        }

        // Images are shown here

        Rectangle
        {
            id: holder
            visible: false
            width: Math.max(img.width * 1.1, img.height * 1.1)
            height: name_text.y + name_text.height
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: intro_text.bottom
            }
            color: "black"
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#80FFFFFF" }
                GradientStop { position: 0.9; color: "#80EEEEEE" }
                GradientStop { position: 1.0; color: "#80AAAAAA" }
            }

            Item
            {
                id: spacer
                height: 20
            }

            Image
            {
                id: img
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.top: spacer.bottom
                width: Math.min((background.width - 120 * ApplicationInfo.ratio) * 0.7,
                                (background.height - 100 * ApplicationInfo.ratio) * 0.7)
                height: width
            }

            Rectangle {
                id: name_text
                width: holder.width
                height: name.height * 1.5
                anchors.horizontalCenter: holder.horizontalCenter
                anchors.margins: 20
                anchors.top: img.bottom
                radius: 10
                border.width: 2
                border.color: "black"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
            }

            GCText {
                id: name
                anchors {
                    horizontalCenter: name_text.horizontalCenter
                    verticalCenter: name_text.verticalCenter
                }
                style: Text.Outline; styleColor: "black"
                color: "white"
                fontSize: smallSize
                visible: false
            }
        }


        // Load the previous part

        Image {
            visible: false
            id: previous
            anchors.right: holder.left
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: holder.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.height: 80 * ApplicationInfo.ratio
            Behavior on scale { PropertyAnimation { duration: 100} }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: previous.scale = 1.1
                onExited: previous.scale = 1
                onClicked: Activity.previous()
            }
        }

        // Load the next part

        Keys.onRightPressed: Activity.next()
        Keys.onLeftPressed: Activity.previous()

        Image {
            visible: false
            id: next
            anchors.left: holder.right
            anchors.leftMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: holder.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.height: 80 * ApplicationInfo.ratio
            Behavior on scale { PropertyAnimation { duration: 100} }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: next.scale = 1.1
                onExited: next.scale = 1
                onClicked: Activity.next()
            }
        }

        //Proceed to nextpart

        Rectangle {
            id: proceed
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: parent.height * 0.05
                rightMargin: parent.width * 0.05
            }
            border.color: "black"
            visible: true
            radius: 4
            smooth: true
            border.width: 0
            width: proceed_text.width * 1.1 * ApplicationInfo.ratio
            height: proceed_text.height * 1.1 * ApplicationInfo.ratio
            color: "#AAFFFFFF"

            GCText {
                id: proceed_text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                fontSize: smallSize
                text: qsTr("Visual <br> Demo")
                Behavior on scale { PropertyAnimation { duration: 100} }
            }

            MouseArea {
                anchors.fill: proceed
                hoverEnabled: true
                onEntered: proceed_text.scale = 1.1
                onExited: proceed_text.scale = 1
                onClicked: {
                    if(proceed_text.text == qsTr("Visual <br> Demo"))
                    {
                        reset()
                        proceed_text.text = qsTr("Quiz")
                        page.source = Activity.url + "levels/Level1.qml"
                    }
                    else if(proceed_text.text == qsTr("Quiz"))
                    {
                        reset()
                        Activity.nextQuestion()
                        holder.visible = true
                        proceed.visible = false
                    }
                }
            }
        }

        function reset () {
            openbox.visible = false
            closebox.visible = false
            holder.visible = false
            next.visible = false
            previous.visible = false
            intro_textbg.visible = false
            intro_text.visible = false
            page.source = ""
        }

        // loaders for sublevels

        Loader {
            id: page
            anchors.fill: parent
            source: ""
        }

        //quiz

        Column
        {
            id: buttonHolder
            property bool buttonHolderMouseArea : true
            spacing: 10 * ApplicationInfo.ratio
            x: holder.x - width - 10 * ApplicationInfo.ratio
            y: 30
            add: Transition {
                NumberAnimation { properties: "y"; from: 10; duration: 500 }
            }
            Repeater
            {
                id: answers
                AnswerButton {
                    width: 120 * ApplicationInfo.ratio
                    height: 80 * ApplicationInfo.ratio
                    textLabel: modelData
                    onPressed: {
                        if(modelData === Activity.getCorrectAnswer()) Activity.showAnswer()
                    }
                }
            }
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

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
        }
    }

}
