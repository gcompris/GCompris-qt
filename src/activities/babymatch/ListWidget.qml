/* gcompris - ListWidget.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
import GCompris 1.0
import "../../core"
import "babymatch.js" as Activity

Item {
    id: listWidget
    anchors.fill: parent
    anchors.topMargin: 5 * ApplicationInfo.ratio
    anchors.leftMargin: 5 * ApplicationInfo.ratio
    z: 10

    property bool vert
    property alias model: mymodel
    property alias view: view
    property alias showOk: showOk
    property alias hideOk: hideOk
    property alias repeater: repeater

    ListModel {
        id: mymodel
    }

    PropertyAnimation {
        id: showOk
        target: ok
        properties: "height"
        from: 0
        to: view.iconSize * 0.9
        duration: 300
        onStopped: {
            view.okShowed = true
            instruction.show()
        }
    }
    PropertyAnimation {
        id: hideOk
        target: ok
        properties: "height"
        from: view.iconSize * 0.9
        to: 0
        duration: 200
        onStopped: view.checkDisplayedGroup()
    }

    Image {
        id: ok
        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
        sourceSize.width: view.iconSize
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: view.checkAnswer()
        }
    }

    Grid {
        id: view
        width: listWidget.vert ? leftWidget.width : 2 * bar.height
        height: listWidget.vert ? background.height - 2 * bar.height : bar.height
        spacing: 10
        z: 20
        columns: listWidget.vert ? 1 : nbItemsByGroup + 1

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup
        property int nbItemsByGroup:
            listWidget.vert ?
                parent.height / iconSize - 2 :
                parent.width / iconSize - 2

        property int nbDisplayedGroup: nbItemsByGroup > 0 ? Math.ceil(model.count / nbItemsByGroup) : 0
        property int iconSize: 80 * ApplicationInfo.ratio
        property int previousNavigation: 1
        property int nextNavigation: 1
        property bool okShowed: false
        property bool showGlow: false
        property var displayedGroup: []
        property alias ok: ok

        onNbDisplayedGroupChanged: correctDisplayedGroup()
        
        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        }

        // For correcting values of Displayed Groups when height or width is changed
        function correctDisplayedGroup() {
            if (nbDisplayedGroup > 0) {
                for(var i = 0 ; i < nbDisplayedGroup ; i++) {
                    var groupEmpty = true
                    for(var j = 0 ; j < nbItemsByGroup, i*nbItemsByGroup + j < model.count ; j++) {
                        if (repeater.itemAt(i*nbItemsByGroup + j).dropStatus < 0) {
                            groupEmpty = false
                            break
                        }
                    }
                    if (groupEmpty)
                        displayedGroup[i] = false
                    else
                        displayedGroup[i] = true
                }
                view.refreshLeftWidget()
                view.checkDisplayedGroup()
            }
        }

        //For setting navigation buttons
        function setNextNavigation() {
            nextNavigation = 0
            for(var i = currentDisplayedGroup + 1 ; i < nbDisplayedGroup ; i++) {
                if(displayedGroup[i]) {
                    nextNavigation = i - currentDisplayedGroup
                    break
                }
            }
        }
        
        function setPreviousNavigation() {
            previousNavigation = 0
            for(var i = currentDisplayedGroup - 1 ; i >= 0 ; i--) {
                if(displayedGroup[i]) {
                    previousNavigation = currentDisplayedGroup - i
                    break
                }
            }
        }
        
        function checkDisplayedGroup() {
            var i = currentDisplayedGroup * nbItemsByGroup 
            var groupEmpty = true
            while(i < model.count && i < (currentDisplayedGroup + 1) * nbItemsByGroup) {
                if (repeater.itemAt(i).dropStatus < 0) {
                    groupEmpty = false
                    break
                }
                i++
            }

            if (groupEmpty) {
                displayedGroup[currentDisplayedGroup] = false
                previousNavigation = 0
                nextNavigation = 0
                for(var i = 0 ; i < nbDisplayedGroup ; ++i) {
                    if(displayedGroup[i]) {
                        view.setCurrentDisplayedGroup = i
                        view.refreshLeftWidget()
                        break
                    }
                }
            }
        }

        function refreshLeftWidget() {
            availablePieces.view.currentDisplayedGroup = availablePieces.view.setCurrentDisplayedGroup
            availablePieces.view.setNextNavigation()
            availablePieces.view.setPreviousNavigation()
        }

        function areAllPlaced() {
            for(var i = 0 ; i < model.count ; ++i) {
                if(repeater.itemAt(i).dropStatus < 0) {
                    return false
                }
            }
            return true
        }

        function checkAnswer() {
            view.showGlow = true
            for(var i = 0 ; i < model.count ; ++i) {
                if(repeater.itemAt(i).dropStatus !== 1) {
                    return
                }
            }
            Activity.win()
        }

        Repeater {
            id: repeater
            property int currentIndex
            onCurrentIndexChanged: {
                for(var i = 0; i < mymodel.count; i++) {
                    if(currentIndex != i)
                        repeater.itemAt(i).selected = false
                    else
                        repeater.itemAt(i).selected = true
                }
                if(currentIndex == -1)
                    toolTip.opacity = 0
            }
            DragListItem {
                id: contactsDelegate
                z: 1
                heightInColumn: view.iconSize * 0.85
                widthInColumn: view.iconSize * 0.85
                tileWidth: view.iconSize
                tileHeight: view.iconSize
                visible: view.currentDisplayedGroup * view.nbItemsByGroup <= index &&
                         index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup-1

                onPressed: repeater.currentIndex = index
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1
        }

        Row {
            spacing: view.iconSize * 0.20

            Image {
                id: previous
                opacity: (model.count > view.nbItemsByGroup &&
                          view.previousNavigation != 0 && view.currentDisplayedGroup != 0) ? 1 : 0
                source:"qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.width: view.iconSize * 0.35
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1
                        if(previous.opacity == 1) {
                            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation
                            view.refreshLeftWidget()
                        }
                    }
                }
            }

            Image {
                id: next
                visible: model.count > view.nbItemsByGroup && view.nextNavigation != 0 && view.currentDisplayedGroup < 
						 view.nbDisplayedGroup - 1
                source:"qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.width: view.iconSize * 0.35
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1
                        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation
                        view.refreshLeftWidget()
                    }
                }
            }
        }
    }
}
