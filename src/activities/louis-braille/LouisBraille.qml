/* GCompris - louis-braille.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   <Srishti Sethi> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
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
            property var dataset: Dataset.dataset
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

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

                    // workaround for https://bugreports.qt.io/browse/QTBUG-72643 (qml binding with global variable in Repeater do not work)
                    property alias rowSpacing: row.spacing
                    Item {
                        id: inner
                        height: charList.height * 0.95
                        width: (charList.width - 13 * cardRepeater.rowSpacing)/ 13

                        Rectangle {
                            id: rect1
                            width: charList.width / 13
                            height: ins.height
                            border.width: 3
                            opacity: index == 5 ? 0 :1
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
            height: background.height/5
            anchors.top: charList.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5 * ApplicationInfo.ratio

            GCText {
                id: info
                color: "black"
                anchors.centerIn: parent
                horizontalAlignment:  Text.AlignHCenter
                width: parent.width * 0.94
                height: info_rect.height
                wrapMode: Text.WordWrap
                fontSize: regularSize
                text: items.dataset[items.count].text
                fontSizeMode: Text.Fit
            }
        }

        // Image and date
        Image {
            id: img
            anchors.top: info_rect.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: parent.height - (charList.height + info_rect.height + bar.height)
            height: (parent.height - (charList.height + info_rect.height + bar.height)) * 0.8
            width: parent.width * 0.7
            source: items.dataset[items.count].img
            fillMode: Image.PreserveAspectFit

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
                var dataitems = Object.create(items.dataset)
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
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                items.count = 0
                list.visible = false
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(list.shuffle)
        }
    }

}
