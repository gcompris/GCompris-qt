/* GCompris - GianaBhateja.qml
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
import GCompris 1.0
import QtQuick.Controls 1.0

import "../../core"
import "GianaBhateja.js" as Activity

ActivityBase {
    id: activity

    property color buttonColor: "lightblue"
    property color onHoverColor: "gold"
    property color borderColor: "white"

    onStart: focus = true
    onStop: {}


   /* Image {
        id: icon
        //source: "GianaBhateja/arrow1.png"
        source: "qrc:/gcompris/src/activities/GianaBhateja/resource/img2.svg"
        anchors.horizontalCenter: parent.horizontalCenter
    }*/
    Text {
        id: textLabel
        anchors.centerIn: parent
        text: "Drag    and    Drop    Here    in    a    row......."
    }
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/GianaBhateja/resource/img2.svg"
        //anchors.horizontalCenter: parent.horizontalCenter
        // source: "qrc:/gcompris/src/GianaBhateja/resource/img2.svg";
        //sourceSize.height: visible ? 80 * ApplicationInfo.ratio : 1

        anchors.fill: parent
       // color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        GCText {
            id: text
            anchors {
                left: parent.left
                top: bar.top
                bottom: parent.bottom
                margins: 10
            }
            text: "More Games are coming soon. Stay tuned... :) "
            fontSize: smallSize
        }



        TextEdit {
            id: edit
            textFormat: TextEdit.RichText
            anchors {
                right: parent.right

                margins: 10
            }
            x: 500
            y: 500
            font {
                pointSize: (18 + ApplicationSettings.baseFontSize) * ApplicationInfo.fontRatio
                capitalization: ApplicationSettings.fontCapitalization
                weight: Font.DemiBold
                family: GCSingletonFontLoader.fontLoader.name
                letterSpacing: ApplicationSettings.fontLetterSpacing
                wordSpacing: 10
            }

            function insertText(text) {
                edit.insert(parent.BottomLeft, text)
            }
        }
        Column {
            id: control
            width: 400 * ApplicationInfo.ratio
            anchors {
                left: parent.left
                top: parent.top
                bottom: bar.bottom
                margins: 10
            }
            spacing: 10

            Rectangle {
                id: simpleButton
                color: "blue"
                width: 500; height: 75



                Text {
                    id: buttonLabel
                    anchors.centerIn: parent
                    text: "Drag and Drop rectangles in ascending sequence... :)"
                }

                MouseArea {
                    anchors.fill: parent
                    //drag.target: rect
                    //drag.axis: Drag.XAndYAxis
                    onClicked: console.log("Blue coloured rectangle taken")
                }
                // Determines the color of the button by using the conditional operator
                // color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor
            }
            Rectangle {
                id: id1
                color: "red"
                width: 75; height: 75
                Text {
                    id: text1
                    anchors.centerIn: parent
                    text: "1"
                }

                SequentialAnimation {
                    id: anim1
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id1
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id1
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin1
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id1
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id1
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("red coloured rectangle taken")
                }
                function left()
                {
                    return id1.x;
                }


            }

            Rectangle {
                id: id3
                color: "brown"
                width: 75; height: 75
                Text {
                    id: text3
                    anchors.centerIn: parent
                    text: "3"
                }

                SequentialAnimation {
                    id: anim3
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id3
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id3
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin3
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id3
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id3
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("brown coloured rectangle taken")
                }
                function left()
                {
                    return id3.x;
                }
            }

            Rectangle {
                id: id5
                color: "orange"
                width: 75; height: 75
                Text {
                    id: text5
                    anchors.centerIn: parent
                    text: "5"
                }

                SequentialAnimation {
                    id: anim5
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id5
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id5
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin5
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id5
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id5
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("orange coloured rectangle taken")
                }
                function left()
                {
                    return id5.x;
                }
            }

            Rectangle {
                id: id6
                color: "pink"
                width: 75; height: 75
                Text {
                    id: text6
                    anchors.centerIn: parent
                    text: "6"
                }

                SequentialAnimation {
                    id: anim6
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id6
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id6
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin6
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id6
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id6
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("pink coloured rectangle taken")
                }
                function left()
                {
                    return id6.x;
                }
            }

            Rectangle {
                id: id4
                color: "grey"
                width: 75; height: 75
                Text {
                    id: text4
                    anchors.centerIn: parent
                    text: "4"
                }

                SequentialAnimation {
                    id: anim4
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id4
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id4
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin4
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id4
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id4
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("grey coloured rectangle taken")
                }
                function left()
                {
                    return id4.x;
                }
            }

            Rectangle {
                id: id2
                color: "yellow"
                width: 75; height: 75
                Text {
                    id: text2
                    anchors.centerIn: parent
                    text: "2"
                }

                SequentialAnimation {
                    id: anim2
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: id1
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: id2
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }

                SequentialAnimation {
                    id: animWin2
                    running: false
                    loops: 1
                    NumberAnimation {
                        target: id2
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if (running == false) {
                            mouseArea.enabled = true
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: id2
                    drag.axis: Drag.XAndYAxis
                    onClicked: console.log("red coloured rectangle taken")
                }
                function left()
                {
                    return id2.x;
                }
            }

        }
        Column {
            id: controls
            width: 400 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                top: bar.top
                bottom: parent.bottom
                margins: 10
            }
            spacing: 10


            Button {
                style: GCButtonStyle {}
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Submit")
                width: parent.width

                onClicked:if(id1.left()<id2.left() && id2.left()<id3.left() && id3.left()<id4.left() && id4.left()<id5.left() && id5.left()<id6.left())
                          {
                              edit.undo();
                              edit.insertText("Yeah Smarty!! You did it :)")
                              console.log(id2.left())
                              console.log("done")
                          }
                          else {
                              edit.undo();
                              edit.insertText(("You missed it :(  Lets try again :)"))
                          }

            }
        }



        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors {
                right: parent.right
                top: parent.top
                bottom: bar.bottom
                margins: 10
            }
            text: "Diksha Bhateja's activity"
            fontSize: mediumSize
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
