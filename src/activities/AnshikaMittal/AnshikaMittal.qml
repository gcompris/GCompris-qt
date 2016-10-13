/* GCompris - AnshikaMittal.qml
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
import "AnshikaMittal.js" as Activity

ActivityBase {
    id: activity
    property color buttonColor: "lightblue"
    property color onHoverColor: "gold"
    property color borderColor: "white"



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
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            //  anchors.centerIn: parent
            text: "Anshika Mittal's activity"
            x:870; y:670;
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

        Image{
            id: img1

               width : 200;
               height: 250;
                x: 950
                y:350
                   source: "qrc:/gcompris/src/activities/AnshikaMittal/resource/blocks.svg"
                   anchors.fill: parent.BottomLeft
        }


        Rectangle {  id: text_title ; color: "orange"; radius: 40.0
            width: 400; height: 60
            x: 500
            y:20
            Text { anchors.centerIn: parent
                font.pointSize: 25; text: "-- Let's make a tower --" }

        }

        TextEdit {
            id: text_map
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
                text_map.insert(parent.BottomLeft, text)
            }
        }


        Text
        {
            id: text1
            width: 250; height: 300
            x: 30
            y:70
            text: "Input Rectangles"
            font.pointSize: 20;
            color: "blue"
        }




        Item{

            Rectangle {  id: rect_map ; color: "white"; radius: 10.0
                width: 70; height: 80
                x:560;
                y: 310;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "70" }
                function check(){
                    return rect_map.x;
                }

            }


            Rectangle { id: rect_map1 ; color: "white"; radius: 10.0
                width: 60; height: 80
                x:520;
                y: 392;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "60" }
                function checkX(){
                    return rect_map1.x;
                }

                function checkY(){
                    return rect_map1.y;
                }
                // x: 50; y : 100;
            }
            Rectangle { id: rect_map2; color: "white"; radius: 10.0
                width: 100; height: 80
                x: 584;
                y: 392;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "100" }
                function checkX(){
                    return rect_map2.x;
                }

                function checkY(){
                    return rect_map2.y;
                }
            }

            Rectangle { id: rect_map3; color: "white"; radius: 10.0
                width: 120; height: 80
                x:440;
                y:476;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "120" }
                function checkX(){
                    return rect_map3.x;
                }

                function checkY(){
                    return rect_map3.y;
                }
            }

            Rectangle { id: rect_map4; color: "white"; radius: 10.0
                width: 150; height: 80
                x:738;
                y:560;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "150" }
                function checkX(){
                    return rect_map4.x;
                }

                function checkY(){
                    return rect_map4.y;
                }

            }
            Rectangle {  id: rect_map5; color: "white"; radius: 10.0
                width: 180; height: 80
                x:350;
                y:560;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "180" }
                function checkX(){
                    return rect_map5.x;
                }

                function checkY(){
                    return rect_map5.y;
                }

            }
            Rectangle {  id: rect_map6 ; color: "white"; radius: 10.0
                width: 200; height: 80
                x:534;
                y:560;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "200" }
                function checkX(){
                    return rect_map6.x;
                }

                function checkY(){
                    return rect_map6.y;
                }

            }
            Rectangle {  id: rect_map7 ; color: "white"; radius: 10.0
                width: 220; height: 80
                x: 564;
                y:476;
                Text { anchors.centerIn: parent
                    font.pointSize: 18; text: "220" }
                function checkX(){
                    return rect_map7.x;
                }

                function checkY(){
                    return rect_map7.y;
                }
            }
        }

        Item {
            width: background.width; height: 320

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                spacing: 5

                Rectangle {  id: rect ; color: "blue"; radius: 10.0
                    width: 70; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "70" }
                    function checkX(){
                        return rect.x;
                    }

                    function checkY(){
                        return rect.y;
                    }

                    MouseArea {

                        anchors.fill: parent
                        drag.target: rect
                        drag.axis: Drag.XAndYAxis
                        onClicked: {text_map.undo()
                            text_map.insert(parent.BottomLeft,"Blue colour done")}


                    }
                }
                Rectangle { id: rect1 ; color: "gold"; radius: 10.0
                    width: 60; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "60" }
                    // x: 50; y : 100;
                    function checkX(){
                        return rect1.x;
                    }

                    function checkY(){
                        return rect1.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect1
                        drag.axis: Drag.XAndYAxis
                        onClicked: {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"Gold colour done")
                        }
                    }
                }
                Rectangle { id: rect2; color: "lightgreen"; radius: 10.0
                    width: 100; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "100" }
                    function checkX(){
                        return rect2.x;
                    }

                    function checkY(){
                        return rect2.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect2
                        drag.axis: Drag.XAndYAxis
                        onClicked: {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"Light green done")}

                    }}

                Rectangle { id: rect3; color: "green"; radius: 10.0
                    width: 120; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "120" }
                    function checkX(){
                        return rect3.x;
                    }

                    function checkY(){
                        return rect3.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect3
                        drag.axis: Drag.XAndYAxis
                        onClicked: {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"green colour done")}

                    }}

                Rectangle { id: rect4; color: "yellow"; radius: 10.0
                    width: 150; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "150" }
                    function checkX(){
                        return rect4.x;
                    }

                    function checkY(){
                        return rect4.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect4
                        drag.axis: Drag.XAndYAxis
                        onClicked: {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"yellow colour done")}
                    }
                }
                Rectangle {  id: rect5 ; color: "red"; radius: 10.0
                    width: 180; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "180" }
                    function checkX(){
                        return rect5.x;
                    }

                    function checkY(){
                        return rect5.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect5
                        drag.axis: Drag.XAndYAxis
                        onClicked: {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"red colour done")}
                    }
                }
                Rectangle {  id: rect6 ; color: "pink"; radius: 10.0
                    width: 200; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "200" }
                    function checkX(){
                        return rect6.x;
                    }

                    function checkY(){
                        return rect6.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect6
                        drag.axis: Drag.XAndYAxis
                        onClicked:
                        {
                            text_map.undo();
                            text_map.insert(parent.BottomLeft,"pink colour done")
                        }

                    }
                }


                Rectangle {  id: rect7 ; color: "grey"; radius: 10.0
                    width: 220; height: 80
                    Text { anchors.centerIn: parent
                        font.pointSize: 18; text: "220" }
                    function checkX(){
                        return rect7.x;
                    }

                    function checkY(){
                        return rect7.y;
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: rect7
                        drag.axis: Drag.XAndYAxis
                        onClicked: {text_map.undo();
                            text_map.insert(parent.BottomLeft,"grey colour done")}
                    }
                }
            }
        }

        /* Rectangle {
            id: simpleButton
            x: 900
            y: 600
            width: 300; height: 75
            Text
            {
                id: buttonLabel
                anchors.centerIn: parent
                text: "Correct ? "
                font.pointSize: 40
            }

            MouseArea
            {
                id: buttonMouseArea
                anchors.fill: parent

                hoverEnabled: true
                onEntered: parent.border.color = onHoverColor
                onExited:  parent.border.color = borderColor

                onClicked: if(rect.x == rect_map.x && rect.y == rect_map.y  &&
                                   rect1.x == rect1_map1.x && rect1.y == rect1_map.y  &&
                                   rect2.x == rect_map2.x && rect2.y == rect_map2.y &&
                                   rect3.x == rect_map3.x && rect3.y == rect_map3.y &&
                                   rect4.x == rect_map4.x && rect4.y == rect_map4.y  &&
                                   rect5.x == rect_map5.x && rect5.y == rect_map5.y  &&
                                   rect6.x == rect_map6.x && rect6.y == rect_map6.y &&
                                   rect7.x == rect_map7.x && rect7.y == rect_map7.y
                                   )
                           {
                               text_map.insert(parent.bottom, "Done");
                           }

                           else
                           {
                               console.log("Error");
                           }
            }
        }*/


    }


}
