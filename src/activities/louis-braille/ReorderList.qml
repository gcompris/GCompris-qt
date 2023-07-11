/* GCompris - ReorderList.qml
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
import GCompris 1.0

import "../../core"
import "louis-braille.js" as Activity

Rectangle {
    id: wholeBody
    width: parent.width
    height: parent.height
    color: "#85D8F6"

    property int selectedIndex: -1
    property alias containerModel: list.model
    property bool bonusRunning: false

    signal up
    signal down
    signal space

    onUp: list.decrementCurrentIndex()
    onDown: list.incrementCurrentIndex()
    onSpace: selectItem()

    function selectItem() {
        if(list.currentIndex == selectedIndex) {
            selectedIndex = -1
        } else if(selectedIndex != -1) {
            containerModel.move(selectedIndex, list.currentIndex, 1)
            selectedIndex = -1
        } else {
            selectedIndex = list.currentIndex
        }
    }

    function checkWin() {
        var win = true
        // The shifted numbering comes from the header in the List
        for(var i = 0; i < list.count; i++) {
            if(list.contentItem.children[i].placed === false) {
                win = false
                return
            }
        }
        if(win) {
            bonusRunning = true
            bonus.good("tux")
            list.currentIndex = -1
        }
    }

    function stopTimer() {
        timer.stop();
    }

    Component {
        id: listElement

        Rectangle {
            id: listRect
            color: wholeBody.selectedIndex == index ? "#b5b9ff" : (placed ? "#c1ffb4" : "#F0F0F0")
            border.width: list.currentIndex == index ? 0 : ApplicationInfo.ratio
            border.color: "#373737"
            radius: 3
            width: list.width
            height: textinfo.height + background.baseMargins

            property bool placed: model.sequence === index
            property string text: model.text

            SequentialAnimation {
                id: borderAnim
                running: list.currentIndex == index
                loops: Animation.Infinite
                NumberAnimation {
                    target: listRect
                    property: "border.width"
                    to: 2 * ApplicationInfo.ratio; duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: listRect
                    property: "border.width"
                    to: 0; duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            GCText {
                id: textinfo
                text: listRect.text
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - background.baseMargins
                wrapMode: Text.WordWrap
                fontSize: smallSize
                color: "#373737"
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                onClicked: {
                    list.currentIndex = index
                    wholeBody.selectItem()
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

        }
    }

    ListModel {
        id: containerModel
    }

    ListView {
        id: list
        anchors {
            top: parent.top
            left: parent.left
            right: scrollItem.left
            bottom: parent.bottom
            topMargin: background.baseMargins
            leftMargin: background.baseMargins
            rightMargin: background.baseMargins
            bottomMargin: bar.height * 1.5
        }
        model: containerModel
        spacing: 5 * ApplicationInfo.ratio
        delegate: listElement
        interactive: true
        // setting huge cacheBuffer is needed to make sure hidden children are not discarded...
        cacheBuffer: 100000
        clip: true

        header: Item {
            width: parent.width
            height: heading.height + background.baseMargins * 2
            Rectangle {
                width: parent.width
                height: heading.height + background.baseMargins
                radius: background.baseMargins * 0.5
                anchors.top: parent.top
                color: "#80FFFFFF"
                GCText {
                    id: heading
                    text: qsTr("Arrange the events in the order in which they happened. " +
                    "Select the line to move, then select its target position.")
                    width: parent.width - background.baseMargins * 2
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                    color: "#373737"
                    fontSize: smallSize
                }
            }
        }
        onCurrentIndexChanged: {
            if(!wholeBody.bonusRunning) {
                timer.restart();
            }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        move: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        Component.onCompleted: currentIndex = -1
    }

    GCButtonScroll {
        id: scrollItem
        anchors.right: parent.right
        anchors.rightMargin: background.baseMargins
        anchors.top: parent.top
        anchors.topMargin: background.baseMargins
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bar.height * 1.5
        onUp: list.flick(0, 1000)
        onDown: list.flick(0, -1000)
        upVisible: list.atYBeginning ? false : true
        downVisible: list.atYEnd ? false : true
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: false
        onTriggered: wholeBody.checkWin()
    }
}
