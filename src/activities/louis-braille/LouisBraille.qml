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
        color: "#85D8F6"
        signal start
        signal stop

        property double baseMargins: 10 * ApplicationInfo.ratio

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
            anchors.topMargin: activityBackground.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            height: childrenRect.height
            width: Math.min(parent.width - 2 * activityBackground.baseMargins, 520 * ApplicationInfo.ratio)

            Row {
                id: row
                spacing: activityBackground.baseMargins
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width

                Repeater {
                    id: cardRepeater
                    model: ["L","O","U","I","S"," ","B","R","A","I","L","L","E"]

                    // workaround for https://bugreports.qt.io/browse/QTBUG-72643 (qml binding with global variable in Repeater do not work)
                    property alias rowSpacing: row.spacing
                    property alias rowWidth: row.width
                    Item {
                        id: inner
                        height: childrenRect.height
                        width: (cardRepeater.rowWidth - 12 * cardRepeater.rowSpacing)/ 13

                        Rectangle {
                            id: rect1
                            width: inner.width
                            height: ins.height
                            border.width: ApplicationInfo.ratio
                            opacity: index == 5 ? 0 :1
                            border.color: "#373737"
                            color: "#F0F0F0"

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
                            color: "#373737"
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
            anchors.margins: activityBackground.baseMargins
            height: activityBackground.height - charList.height - bar.height * 1.2 - 3 * activityBackground.baseMargins
        }

        // The image description
        Rectangle {
            id: info_rect
            border.color: "#373737"
            border.width: ApplicationInfo.ratio
            color: "#F0F0F0"
            width: layoutArea.width
            height: layoutArea.height * 0.3
            radius: 5 * ApplicationInfo.ratio
            anchors.top: layoutArea.top
            anchors.horizontalCenter: layoutArea.horizontalCenter

            GCText {
                id: info
                color: "#373737"
                anchors.centerIn: parent
                horizontalAlignment:  Text.AlignHCenter
                width: parent.width - 2 * activityBackground.baseMargins
                height: parent.height - 2 * activityBackground.baseMargins
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
            anchors.topMargin: activityBackground.baseMargins
            anchors.horizontalCenter: layoutArea.horizontalCenter
            sourceSize.height: width
            sourceSize.width: width
            height: width
            width: Math.min(layoutArea.width - previous.width * 2 - 60 * ApplicationInfo.ratio,
                            layoutArea.height - (info_rect.height + year_rect.height + 2 * activityBackground.baseMargins))
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
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            height: 80 * ApplicationInfo.ratio
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
            anchors.leftMargin: 20 * ApplicationInfo.ratio
            anchors.verticalCenter: img.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            height: 80 * ApplicationInfo.ratio
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
            border.color: "#373737"
            border.width: ApplicationInfo.ratio
            radius: 5 * ApplicationInfo.ratio
            color: "#F0F0F0"
            width: year.width + 2 * activityBackground.baseMargins
            height: year.height + activityBackground.baseMargins
            anchors {
                top: img.bottom
                horizontalCenter: img.horizontalCenter
                topMargin: activityBackground.baseMargins
            }
            GCText {
                id: year
                color: "#373737"
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
