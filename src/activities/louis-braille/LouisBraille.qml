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
import QtQuick 2.12
import core 1.0
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
        id: activityBackground
        anchors.fill: parent
        color: GCStyle.lightBlueBg
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
            property alias activityBackground: activityBackground
            property alias bonus: bonus
            property int count: 0
            property var dataset: Dataset.dataset
        }

        onStart: { Activity.start(items) }
        onStop: {
            listScreen.stopTimer()
            Activity.stop()
        }

        Item {
            id: charList
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            height: childrenRect.height
            width: Math.min(parent.width - 2 * GCStyle.baseMargins, 520 * ApplicationInfo.ratio)

            Row {
                id: topCardRow
                spacing: GCStyle.baseMargins
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width

                Repeater {
                    id: cardRepeater
                    model: ["L","O","U","I","S"," ","B","R","A","I","L","L","E"]

                    Item {
                        id: inner
                        height: childrenRect.height
                        width: (topCardRow.width - 12 * topCardRow.spacing)/ 13

                        Rectangle {
                            id: rect1
                            width: inner.width
                            height: ins.height
                            border.width: GCStyle.thinnestBorder
                            opacity: index == 5 ? 0 :1
                            border.color: GCStyle.darkBorder
                            color: GCStyle.lightBg

                            BrailleChar {
                                id: ins
                                width: parent.width * 0.9
                                anchors.centerIn: parent
                                clickable: false
                                brailleChar: modelData
                                thinnestBorder: true
                            }
                        }

                        GCText {
                            text: modelData
                            font.weight: Font.DemiBold
                            color: GCStyle.darkText
                            fontSize: regularSize
                            anchors {
                                top: rect1.bottom
                                topMargin: GCStyle.halfMargins
                                horizontalCenter: rect1.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        Keys.onRightPressed: activityBackground.next()
        Keys.onLeftPressed: activityBackground.previous()

        function previous() {
            if(items.count == 0)
                items.count = items.dataset.length - 1
            else
                items.count--
        }

        function next() {
            if(items.count == items.dataset.length - 1) {
                listScreen.shuffle()
                items.count = 0
                listScreen.visible = true
            } else {
                items.count++
            }
        }

        Item {
            id: layoutArea
            anchors.top: charList.bottom
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: GCStyle.baseMargins
            height: activityBackground.height - charList.height - bar.height * 1.2 - 3 * GCStyle.baseMargins
        }

        // The image description
        Rectangle {
            id: info_rect
            border.color: GCStyle.darkBorder
            border.width: ApplicationInfo.ratio
            color: GCStyle.lightBg
            width: layoutArea.width
            height: layoutArea.height * 0.3
            radius: GCStyle.halfMargins
            anchors.top: layoutArea.top
            anchors.horizontalCenter: layoutArea.horizontalCenter

            GCText {
                id: info
                color: GCStyle.darkText
                anchors.centerIn: parent
                horizontalAlignment:  Text.AlignHCenter
                width: parent.width - 2 * GCStyle.baseMargins
                height: parent.height - 2 * GCStyle.baseMargins
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
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: layoutArea.horizontalCenter
            sourceSize.height: width
            sourceSize.width: width
            height: width
            width: Math.min(layoutArea.width - previous.width * 2 - 60 * ApplicationInfo.ratio,
                            layoutArea.height - (info_rect.height + year_rect.height + 2 * GCStyle.baseMargins))
            source: items.dataset[items.count].img
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: activityBackground.next()
            }
        }

        Image {
            id: previous
            anchors.right: img.left
            anchors.rightMargin: 2 * GCStyle.baseMargins
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            height: GCStyle.bigButtonHeight
            width: height * 0.5
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            Behavior on scale { PropertyAnimation { duration: 100} }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: previous.scale = 1.1
                onExited: previous.scale = 1
                onClicked: activityBackground.previous()
            }
        }

        Image {
            id: next
            anchors.left: img.right
            anchors.leftMargin: 2 * GCStyle.baseMargins
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            height: GCStyle.bigButtonHeight
            width: height * 0.5
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            Behavior on scale { PropertyAnimation { duration: 100} }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: next.scale = 1.1
                onExited: next.scale = 1
                onClicked: activityBackground.next()
            }
        }

        Rectangle {
            id: year_rect
            border.color: GCStyle.darkBorder
            border.width: ApplicationInfo.ratio
            radius: GCStyle.halfMargins
            color: GCStyle.lightBg
            width: year.width + 2 * GCStyle.baseMargins
            height: year.height + GCStyle.baseMargins
            anchors {
                top: img.bottom
                horizontalCenter: img.horizontalCenter
                topMargin: GCStyle.baseMargins
            }
            GCText {
                id: year
                color: GCStyle.darkText
                fontSize: regularSize
                anchors.centerIn: year_rect
                text: items.dataset[items.count].year
            }
        }

        Keys.onUpPressed: listScreen.up()
        Keys.onDownPressed: listScreen.down()
        Keys.onEnterPressed: listScreen.space()
        Keys.onReturnPressed: listScreen.space()
        Keys.onSpacePressed: listScreen.space()

        ReorderList {
            id: listScreen
            visible: false

            signal shuffle

            onShuffle: {
                bonusRunning = false
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
                listScreen.visible = false
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(listScreen.shuffle)
        }
    }

}
