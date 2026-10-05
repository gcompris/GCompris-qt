/* gcompris - ListWidget.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0
import "../../core"
import "babymatch.js" as Activity

Item {
    id: listWidget
    anchors.fill: parent
    anchors.topMargin: GCStyle.baseMargins
    anchors.leftMargin: GCStyle.baseMargins
    z: 10

    property alias model: mymodel
    property alias view: view
    property alias showOk: showOk
    property alias hideOk: hideOk
    property alias repeater: repeater
    readonly property bool okEnabled: !items.inputLocked && ok.height === view.iconSize
    readonly property bool previousButtonVisible: (model.count > view.nbItemsByGroup &&
        view.previousNavigation != 0 && view.currentDisplayedGroup != 0)
    readonly property bool nextButtonVisible: (model.count > view.nbItemsByGroup &&
        view.nextNavigation != 0 && view.currentDisplayedGroup < view.nbDisplayedGroup - 1)

    function selectFirstItem() {
        // Select first item not already dropped in the list, else -1 if all dropped already.
        while(previous.opacity === 1) {
            showPreviousGroup();
        }
        repeater.currentIndex = -1;
        selectNextItem();
    }

    function selectNextItem() {
        if(repeater.currentIndex === repeater.count - 1) {
            return;
        }
        var indexToSelect = -1;
        var relativeNextIndex = 0;
        if(repeater.currentIndex === -1) {
            relativeNextIndex = view.nbItemsByGroup * view.currentDisplayedGroup;
        } else {
            relativeNextIndex = repeater.currentIndex + 1;
        }
        var lastDisplayedIndex = view.nbItemsByGroup * (view.currentDisplayedGroup + 1) - 1;

        for(var i = relativeNextIndex; i <= lastDisplayedIndex; i++) {
            if(repeater.itemAt(i) && !repeater.itemAt(i).isDropped) {
                indexToSelect = i;
                break;
            }
        }

        for(var groupId = 0; groupId < view.nbDisplayedGroup; groupId++) {
            var keepLooking = true;
            if(indexToSelect === -1 && listWidget.nextButtonVisible) {
                showNextGroup();
                relativeNextIndex = view.nbItemsByGroup * view.currentDisplayedGroup;
                lastDisplayedIndex = view.nbItemsByGroup * (view.currentDisplayedGroup + 1) - 1;
                for(var i = relativeNextIndex; i <= lastDisplayedIndex; i++) {
                    if(repeater.itemAt(i) && !repeater.itemAt(i).isDropped) {
                        indexToSelect = i;
                        break;
                    }
                }
            }
            if(!keepLooking) {
                break;
            }
        }

        if(indexToSelect != -1) {
            repeater.itemAt(indexToSelect).mousePressed(0,0);
        }
    }

    function selectPreviousItem() {
        if(repeater.currentIndex === 0) {
            return;
        }
        var indexToSelect = -1;
        var relativePreviousIndex = 0;
        if(repeater.currentIndex === -1) {
            relativePreviousIndex = view.nbItemsByGroup * view.currentDisplayedGroup;
        } else {
            relativePreviousIndex = repeater.currentIndex - 1;
        }
        var firstDisplayedIndex = view.nbItemsByGroup * view.currentDisplayedGroup;

        for(var i = relativePreviousIndex; i >= firstDisplayedIndex; i--) {
            if(!repeater.itemAt(i).isDropped) {
                indexToSelect = i;
                break;
            }
        }

        if(indexToSelect === -1 && listWidget.previousButtonVisible) {
            showPreviousGroup();
            relativePreviousIndex = view.nbItemsByGroup * (view.currentDisplayedGroup + 1) - 1;
            firstDisplayedIndex = view.nbItemsByGroup * view.currentDisplayedGroup;
            for(var i = relativePreviousIndex; i >= firstDisplayedIndex; i--) {
                if(!repeater.itemAt(i).isDropped) {
                    indexToSelect = i;
                    break;
                }
            }
        }

        if(indexToSelect != -1) {
            repeater.itemAt(indexToSelect).mousePressed(0,0);
        }
    }

    function showNextGroup() {
        repeater.currentIndex = -1;
        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation;
        view.refreshLeftWidget();
    }

    function showPreviousGroup() {
        repeater.currentIndex = -1;
        if(previous.opacity == 1) {
            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation;
            view.refreshLeftWidget();
        }
    }

    ListModel {
        id: mymodel
    }

    PropertyAnimation {
        id: showOk
        target: ok
        properties: "height"
        from: 0
        to: view.iconSize
        duration: 300
    }
    PropertyAnimation {
        id: hideOk
        target: ok
        properties: "height"
        from: view.iconSize
        to: 0
        duration: 200
        onFinished: view.checkDisplayedGroup();
    }

    Image {
        id: ok
        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
        sourceSize.width: view.iconSize
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            enabled: listWidget.okEnabled
            onClicked: {
                Activity.resetKeyboardControls();
                view.checkAnswer();
            }
        }
    }

    Grid {
        id: view
        width: leftWidget.width
        height: activityBackground.verticalBar ? activityBackground.height - bar.height : leftWidget.height
        spacing: GCStyle.halfMargins
        z: 20
        columns: activityBackground.verticalBar ? 1 : nbItemsByGroup + 1

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup
        property int nbItemsByGroup: activityBackground.verticalBar ?
            Math.floor(view.height / (view.iconSize + view.spacing) - 1) :
            Math.floor(view.width / (view.iconSize + view.spacing) - 1)
        property int nbDisplayedGroup: nbItemsByGroup > 0 ? Math.ceil(model.count / nbItemsByGroup) : 0
        property int iconSize: GCStyle.bigButtonHeight
        property int previousNavigation: 1
        property int nextNavigation: 1
        property bool okShowed: false
        property bool showGlow: false
        property var displayedGroup: []
        property alias ok: ok

        onNbDisplayedGroupChanged: correctDisplayedGroup();

        // For correcting values of Displayed Groups when height or width is changed
        function correctDisplayedGroup() {
            if(nbDisplayedGroup > 0) {
                for(var i = 0 ; i < nbDisplayedGroup ; i++) {
                    var groupEmpty = true;
                    for(var j = 0 ; j < nbItemsByGroup && i*nbItemsByGroup + j < model.count ; j++) {
                        if(repeater.itemAt(i*nbItemsByGroup + j).dropStatus < 0) {
                            groupEmpty = false;
                            break;
                        }
                    }
                    if(groupEmpty)
                        displayedGroup[i] = false;
                    else
                        displayedGroup[i] = true;
                }
                view.refreshLeftWidget();
                view.checkDisplayedGroup();
            }
        }

        //For setting navigation buttons
        function setNextNavigation() {
            nextNavigation = 0;
            for(var i = currentDisplayedGroup + 1 ; i < nbDisplayedGroup ; i++) {
                if(displayedGroup[i]) {
                    nextNavigation = i - currentDisplayedGroup;
                    break;
                }
            }
        }

        function setPreviousNavigation() {
            previousNavigation = 0;
            for(var i = currentDisplayedGroup - 1 ; i >= 0 ; i--) {
                if(displayedGroup[i]) {
                    previousNavigation = currentDisplayedGroup - i;
                    break;
                }
            }
        }

        function checkDisplayedGroup() {
            var i = currentDisplayedGroup * nbItemsByGroup;
            var groupEmpty = true;
            while(i < model.count && i < (currentDisplayedGroup + 1) * nbItemsByGroup) {
                if(repeater.itemAt(i).dropStatus < 0) {
                    groupEmpty = false;
                    break;
                }
                i++;
            }

            if(groupEmpty) {
                displayedGroup[currentDisplayedGroup] = false;
                previousNavigation = 0;
                nextNavigation = 0;
                for(var i = 0 ; i < nbDisplayedGroup ; ++i) {
                    if(displayedGroup[i]) {
                        view.setCurrentDisplayedGroup = i;
                        view.refreshLeftWidget();
                        break;
                    }
                }
            }
        }

        function refreshLeftWidget() {
            availablePieces.view.currentDisplayedGroup = availablePieces.view.setCurrentDisplayedGroup;
            availablePieces.view.setNextNavigation();
            availablePieces.view.setPreviousNavigation();
        }

        function areAllPlaced(): bool {
            for(var i = 0 ; i < model.count ; ++i) {
                if(repeater.itemAt(i).dropStatus < 0) {
                    return false;
                }
            }
            return true;
        }

        function checkAnswer() {
            view.showGlow = true;
            for(var i = 0 ; i < model.count ; ++i) {
                if(repeater.itemAt(i).dropStatus !== 1) {
                    items.badAnswerSound.play();
                    return;
                }
            }
            items.inputLocked = true;
            Activity.win();
        }

        Repeater {
            id: repeater
            property int currentIndex
            onCurrentIndexChanged: {
                for(var i = 0; i < mymodel.count; i++) {
                    if(currentIndex != i)
                        repeater.itemAt(i).selected = false;
                    else
                        repeater.itemAt(i).selected = true;
                }
                if(currentIndex == -1)
                    toolTip.opacity = 0;
            }
            DragListItem {
                id: contactsDelegate
                z: 1
                tileSize: view.iconSize
                visible: view.currentDisplayedGroup * view.nbItemsByGroup <= index &&
                         index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup-1

                onPressed: {
                    repeater.currentIndex = index;
                }
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1;
        }

        Item {
            width: view.iconSize
            height: view.iconSize

            Image {
                id: previous
                opacity: listWidget.previousButtonVisible ? 1 : 0
                source:"qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.height: view.iconSize * 0.85
                fillMode: Image.PreserveAspectFit
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    enabled: !items.inputLocked && parent.opacity > 0
                    onClicked: {
                        listWidget.showPreviousGroup();
                    }
                }
            }

            Image {
                id: next
                opacity: listWidget.nextButtonVisible ? 1 : 0
                source:"qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.height: view.iconSize * 0.85
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    enabled: !items.inputLocked && parent.opacity > 0
                    onClicked: {
                        listWidget.showNextGroup();
                    }
                }
            }
        }
    }
}
