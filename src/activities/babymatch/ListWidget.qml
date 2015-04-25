/* gcompris - ListWidget.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2015: Pulkit Gupta: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.1
import GCompris 1.0
import "../../core"
import "babymatch.js" as Activity

Item {
    width: view.width
    height: view.height
    z: 10

    anchors {
        left: parent.left
        leftMargin: 5 * ApplicationInfo.ratio
        top: parent.top
        topMargin: 10 * ApplicationInfo.ratio
    }

    property alias model: mymodel;
    property alias view: view;
    property alias showOk : showOk
    property alias hideOk : hideOk
    property alias repeater : repeater
    property int widgetWidth: view.iconSize

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
    }
    PropertyAnimation {
        id: hideOk
        target: ok
        properties: "height"
        from: view.iconSize * 0.9
        to: 0
        duration: 200
        onStopped: {view.checkDisplayedGroup()}
    }

    Column {
        id: view
        width: leftWidget.width
        height: background.height- 2*bar.height
        spacing: 10
        z: 20
        
        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup
        property int nbItemsByGroup: 4
        property int itemsDropped: 0
        property int nbDisplayedGroup: 1 + model.count/nbItemsByGroup
        property int iconSize: width - 10 * ApplicationInfo.ratio
        property int previousNavigation: 1
        property int nextNavigation: 1
        property bool okShowed: false
        property bool showGlow: false
        property var displayedGroup: []
        property alias ok: ok
        
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
            while(i < model.count && i <  (currentDisplayedGroup + 1) * nbItemsByGroup) {
                if (repeater.itemAt(i).isInList) {
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
                        hideLeftWidget.start()
                        break
                    }
                }
            }
        }
        
        function checkAnswer() {
            var win = true
            view.showGlow = true
            for(var i = 0 ; i < model.count ; ++i) {
                if(repeater.itemAt(i).imageName != repeater.itemAt(i).answer.imgName) {
                    win = false
                    repeater.itemAt(i).tileImageGlow.setColor = "red"
                }
                else
                    repeater.itemAt(i).tileImageGlow.setColor = "green"
            }
            if(win)
                Activity.win()//print("You won")
            else
                Activity.wrong()//print("Wrong Answer")
        }
        
        Image {
            id: ok
            source:"qrc:/gcompris/src/core/resource/bar_ok.svgz"
            width: view.iconSize * 0.9
            height: 0
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {backgroundImage.displayTextZ = 3}
                onClicked: {view.checkAnswer()}
                onExited: {backgroundImage.displayTextZ = 1}
            }
        }
                                     
        Repeater {
            id: repeater
            Component {
                id: contactsDelegate

                DragListItem {
                        id: item
                        z: 1
                        heightInColumn: view.iconSize * 0.85
                        widthInColumn: view.iconSize * 0.85
                        tileWidth: view.iconSize
                        tileHeight: view.iconSize
                        
                        visible: view.currentDisplayedGroup*view.nbItemsByGroup <= index &&
                                 index <= (view.currentDisplayedGroup+1)*view.nbItemsByGroup-1
                    }
                    
                }
            
            clip: true
            model: mymodel
            delegate: contactsDelegate
        }

        Row {
            spacing: view.iconSize * 0.20
            
            Image {
                id: previous
                opacity: (model.count > view.nbItemsByGroup && view.previousNavigation != 0 && view.currentDisplayedGroup != 0) ? 1 : 0
                source:"qrc:/gcompris/src/core/resource/bar_previous.svgz"
                width: view.iconSize * 0.35
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onClicked: {
                        if(previous.opacity == 1) {
                            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation
                            hideLeftWidget.start()
                        }
                    }
                }
            }
            
            Image {
                id: next
                visible: model.count > view.nbItemsByGroup && view.nextNavigation != 0 && view.currentDisplayedGroup < 
						 view.nbDisplayedGroup - 1
                source:"qrc:/gcompris/src/core/resource/bar_next.svgz"
                width: view.iconSize * 0.35
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation
                        hideLeftWidget.start()
                    }
                }
            }
        }
    }
}
