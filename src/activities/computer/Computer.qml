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
            property alias info: info
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
            fontSize: regularSize
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
                    background.opacity = 0.5
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
                background.opacity = 0.7
                show.stop()
                previous.visible =  true
                next.visible = true
                info_rect.visible = true
                Activity.next()
            }
        }

        //main frame for showing images

        Rectangle
        {
            id: holder
            visible: false
            width: Math.max(img.width * 1.1, img.height * 1.1)
            height: name_rect.y + name_rect.height
            x: (background.width - width* ApplicationInfo.ratio) / 2
            y: 100
            color: "black"
            radius: 10
            border.width: 2
            border.color: "black"
            anchors.top: info_rect.bottom
            anchors.topMargin: parent.height * 0.05
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
                fillMode: Image.PreserveAspectFit
            }

            Rectangle {
                id: name_rect
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
                    horizontalCenter: name_rect.horizontalCenter
                    verticalCenter: name_rect.verticalCenter
                }
                style: Text.Outline; styleColor: "black"
                color: "white"
                fontSize: largeSize

                NumberAnimation on scale{
                    running: true
                    loops: Animation.Infinite
                    from: 0.7
                    to: 1
                    duration: 1000
                }
            }
        }

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

        Rectangle {
            visible: false
            id: info_rect
            border.color: "black"
            border.width: 1 * ApplicationInfo.ratio
            color: "white"
            width: parent.width * 0.9
            height:info.height * 1.3
            anchors.top: intro_textbg.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5 * ApplicationInfo.ratio

            GCText {
                id:info
                color: "blue"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                fontSize: smallSize
            }
        }


        // Load the next part

        Rectangle
        {
            width: 130 * 0.7 * ApplicationInfo.ratio
            height: 70 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }
            radius: 10
            border.width: 3
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fdf1aa" }
                GradientStop { position: 0.1; color: "#fcec89" }
                GradientStop { position: 0.4; color: "#f8d600" }
                GradientStop { position: 1.0; color: "#f8d600" }
            }

            GCText {
                text: qsTr("Click")
                anchors.centerIn: parent
                fontSize: smallSize
                style: Text.Outline; styleColor: "white"
                color: "black"
                NumberAnimation on scale{
                    running: true
                    loops: Animation.Infinite
                    from: 0.7
                    to: 1
                    duration: 1000
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:  {
                        holder.visible = false
                        next.visible = false
                        previous.visible = false
                        info_rect.visible = false
                        background.source = "qrc:/gcompris/src/activities/imageid/resource/imageid-bg.svg"
                        load.source = "Quiz.qml"
                    }
                }
            }

        }

        Loader {
            id: load
            anchors.fill: parent
            source: ""
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
