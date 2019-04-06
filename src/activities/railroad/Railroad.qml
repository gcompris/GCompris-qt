/* GCompris - railroad.qml
 *
 * Copyright (C) 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Pascal Georges (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
 *   Amit Sagtani <asagtani06@gmail.com> (Qt Quick port)
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
import "railroad.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    property bool isHorizontal: background.width >= background.height

    pageComponent: Image {
        id: background
        source: Activity.resourceURL + "railroad-bg.svg"
        sourceSize.height: background.height
        fillMode: Image.PreserveAspectCrop
        anchors.horizontalCenter: parent.horizontalCenter

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
            property alias score: score
            property alias trainAnimationTimer: trainAnimationTimer
            property alias sampleList: sampleList
            property alias listModel: listModel
            property alias answerZone: answerZone
            property alias animateFlow: animateFlow
            property alias introMessage: introMessage
            property bool memoryMode: false
            property bool mouseEnabled: true
            property var currentKeyZone: sampleList
            property bool keyNavigationMode: false
            // stores height of sampleGrid images to set rail bar support position
            property int sampleImageHeight: 0
            property int sampleModel: Activity.dataset["noOfLocos"][bar.level - 1] + Activity.dataset["noOfWagons"][bar.level - 1]
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        Keys.enabled: !trainAnimationTimer.running && !animateFlow.running && !introMessage.visible
        Keys.onPressed: {
            items.keyNavigationMode = true;
            items.currentKeyZone.handleKeys(event);
            activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
        }

        // Countdown timer
        Timer {
            id: trainAnimationTimer
            repeat: false
            interval: 4000
            onTriggered: {
                items.animateFlow.start()
                activity.audioEffects.play(Activity.resourceURL + 'sounds/train.wav')
            }
        }

        // Intro message
        IntroMessage {
            id: introMessage
            y: background.height / 4.7
            anchors {
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: score.z + 1
            onIntroDone: {
                trainAnimationTimer.start()
            }
            intro: [
                qsTr("Observe and remember the train before the timer ends and then drag the items to set up a similar train."),
                qsTr("If you forget the positions, you can click on the Hint button to view them again.")
            ]
        }

        // Top Display Area
        Rectangle {
            id: topDisplayArea
            width: background.width
            height: background.height * 0.2
            anchors.bottom: sampleList.top
            color: 'transparent'
            z: 1

            GridView {
                id: answerZone
                readonly property int levelCellWidth: isHorizontal ? background.width / (listModel.count > 5 ? 7.2 : 5.66) :
                                                                                               background.width / ((listModel.count > 5) ? 7.1 : 5)
                readonly property int levelCellHeight: levelCellWidth * 0.42
                width: parent.width
                height: levelCellHeight
                cellWidth: levelCellWidth
                cellHeight: levelCellHeight
                anchors.bottom: parent.bottom
                interactive: false
                model: listModel
                delegate: Image {
                    id: wagon
                    source: Activity.resourceURL + modelData + ".svg"
                    fillMode: Image.PreserveAspectFit
                    width: answerZone.cellWidth
                    sourceSize.width: wagon.width
                    function checkDrop(dragItem) {
                        // Checks the drop location of this wagon
                        var globalCoordinates = dragItem.mapToItem(answerZone, 0, 0)
                        if(globalCoordinates.y <= ((background.height / 12.5) + (background.height / 8))) {
                            var dropIndex = Activity.getDropIndex(globalCoordinates.x)

                            if(dropIndex > (listModel.count - 1)) {
                                // Handles index overflow
                                dropIndex = listModel.count - 1
                            }
                            listModel.move(listModel.count - 1, dropIndex, 1)
                            opacity = 1
                        }
                        if(globalCoordinates.y > (background.height / 8)) {
                            // Remove it if dropped in the lower section
                            activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                            listModel.remove(listModel.count - 1)
                        }
                    }

                    function createNewItem() {
                        var component = Qt.createComponent("Loco.qml");
                        if(component.status === Component.Ready) {
                            var newItem = component.createObject(parent, {"x": x, "y": y, "z": 10, "imageURL": source});
                        }
                        return newItem
                    }

                    MouseArea {
                        id: displayWagonMouseArea
                        hoverEnabled: true
                        enabled: !introMessage.visible && items.mouseEnabled
                        anchors.fill: parent

                        onPressed: {
                            if(items.memoryMode) {
                                drag.target = parent.createNewItem();
                                parent.opacity = 0
                                listModel.move(index, listModel.count - 1, 1)
                            }
                            answerZone.selectedSwapIndex = -1;
                        }
                        onReleased: {
                            if(items.memoryMode) {
                                var dragItem = drag.target
                                parent.checkDrop(dragItem)
                                dragItem.destroy();
                                parent.Drag.cancel()
                            }
                        }

                        onClicked: {
                            // skips memorization time
                            if(!items.memoryMode) {
                                bar.hintClicked()
                            }
                            else {
                                items.currentKeyZone = answerZone
                                if(items.keyNavigationMode) {
                                    answerZone.currentIndex = index
                                }
                            }
                            answerZone.selectedSwapIndex = -1;
                        }
                    }
                    states: State {
                        name: "wagonHover"
                        when: displayWagonMouseArea.containsMouse && (items.memoryMode === true)
                        PropertyChanges {
                            target: wagon
                            scale: 1.1
                        }
                    }
                }

                onXChanged: {
                    if(answerZone.x >= background.width) {
                        trainAnimationTimer.stop()
                        animateFlow.stop();
                        listModel.clear();
                        items.memoryMode = true;
                    }
                }

                PropertyAnimation {
                    id: animateFlow
                    target: answerZone
                    properties: "x"
                    from: answerZone.x
                    to: background.width
                    duration: 4000
                    easing.type: Easing.InExpo
                    loops: 1
                    onStopped: answerZone.x = 2;
                }

                function handleKeys(event) {
                    // Switch zones via tab key.
                    if(event.key === Qt.Key_Tab) {
                        items.currentKeyZone = sampleList
                        sampleList.currentIndex = 0
                        answerZone.currentIndex = -1
                    }
                    if(event.key === Qt.Key_Down) {
                        items.currentKeyZone = sampleList
                        answerZone.currentIndex = -1
                        sampleList.currentIndex = 0
                    }
                    if(event.key === Qt.Key_Up) {
                        items.currentKeyZone = sampleList
                        answerZone.currentIndex = -1
                        sampleList.currentIndex = 0
                    }
                    if(event.key === Qt.Key_Left) {
                        items.currentKeyZone = answerZone
                        answerZone.moveCurrentIndexLeft()
                    }
                    if(event.key === Qt.Key_Right) {
                        items.currentKeyZone = answerZone
                        answerZone.moveCurrentIndexRight()
                    }
                    // Remove a wagon via Delete/Return key.
                    if(event.key === Qt.Key_Delete && listModel.count > 0) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                        listModel.remove(answerZone.currentIndex)
                        if(listModel.count < 2) {
                            answerZone.selectedSwapIndex = -1;
                        }
                    }
                    // Checks answer.
                    if((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && items.mouseEnabled) {
                        items.currentKeyZone = answerZone
                        Activity.checkAnswer();
                    }
                    // Swaps two wagons with help of Space/Enter keys.
                    if(event.key === Qt.Key_Space) {
                        if(selectedSwapIndex === -1 && listModel.count > 1) {
                            answerZone.selectedSwapIndex = answerZone.currentIndex;
                            swapHighlight.x = answerZone.currentItem.x;
                            swapHighlight.anchors.top = answerZone.top;
                        }
                        else if(answerZone.currentIndex != selectedSwapIndex && listModel.count > 1){
                            var min = Math.min(selectedSwapIndex, answerZone.currentIndex);
                            var max = Math.max(selectedSwapIndex, answerZone.currentIndex);
                            listModel.move(min, max, 1);
                            listModel.move(max-1, min, 1);
                            answerZone.selectedSwapIndex = -1;
                        }
                    }
                }
                // variable for storing the index of wagons to be swapped via key navigations.
                property int selectedSwapIndex: -1

                Keys.enabled: true
                focus: true
                keyNavigationWraps: true
                highlightRangeMode: GridView.ApplyRange
                highlight: Rectangle {
                    width: answerZone.cellWidth
                    height: answerZone.cellHeight
                    color: "blue"
                    opacity: 0.3
                    radius: 5
                    visible: (items.currentKeyZone === answerZone) && (!trainAnimationTimer.running && !animateFlow.running) && items.keyNavigationMode
                    x: (visible && answerZone.currentItem) ? answerZone.currentItem.x : 0
                    y: (visible && answerZone.currentItem) ? answerZone.currentItem.y : 0
                    Behavior on x {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
                highlightFollowsCurrentItem: false
            }

            // Used to highlight a wagon selected for swaping via key navigations
            Rectangle {
                id: swapHighlight
                width: answerZone.cellWidth
                height: answerZone.cellHeight
                visible: answerZone.selectedSwapIndex != -1 ? true : false
                color: "#AA41AAC4"
                opacity: 0.8
                radius: 5
            }

            ListModel {
                id: listModel
            }
        }

        // Lower Sample Wagon Display Area
        GridView {
            id: sampleList
            visible: items.memoryMode
            y: background.height * 0.2
            z: 5
            width: background.width
            height: background.height * 0.8
            anchors.margins: 20
            cellWidth: width / columnCount
            cellHeight: isHorizontal ? background.height / 7 : background.height / 7.5
            model: Math.max(0, items.sampleModel)
            interactive: false

            // No. of wagons in a row
            readonly property int columnCount: isHorizontal ? Activity.dataset["columnsInHorizontalMode"][bar.level - 1] :
        Activity.dataset["columsInVerticalMode"][bar.level - 1]

            readonly property int rowCount: columnCount > 0 ? model / columnCount : 0

            delegate: Image {
                id: loco
                readonly property string uniqueID: Activity.uniqueId[index]
                property real originX
                property real originY
                source: Activity.resourceURL + uniqueID + ".svg"
                width: isHorizontal ? background.width / 5.66 : background.width / 4.2
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
                visible: true
                onHeightChanged: items.sampleImageHeight = height
                onVisibleChanged: items.sampleImageHeight = height
                function initDrag() {
                    originX = x
                    originY = y
                }

                function replace() {
                    x = originX
                    y = originY
                }

                function checkDrop() {
                    // Checks the drop location of this wagon
                    var globalCoordinates = loco.mapToItem(answerZone, 0, 0)
                    // checks if the wagon is dropped in correct zone and no. of wagons in answer row are less than
                    // total no. of wagons in correct answer + 2, before dropping the wagon
                    if(globalCoordinates.y <= (background.height / 12.5) &&
                            listModel.count < Activity.dataset["WagonsInCorrectAnswers"][bar.level - 1] + 2) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                        var dropIndex = Activity.getDropIndex(globalCoordinates.x)
                        Activity.addWagon(uniqueID, dropIndex);
                    }
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    drag.target: parent
                    enabled: items.mouseEnabled
                    onClicked: {
                        items.currentKeyZone = sampleList
                        if(items.keyNavigationMode) {
                            sampleList.currentIndex = index
                        }
                    }
                    onPressed: {
                        parent.initDrag()
                    }
                    onReleased: {
                        parent.Drag.cancel()
                        parent.checkDrop()
                        parent.replace()
                    }
                }

                Component.onCompleted: initDrag();

                states: State {
                    name: "carHover"
                    when: mouseArea.containsMouse
                    PropertyChanges {
                        target: loco
                        scale: 1.1
                    }
                }
            }

            function handleKeys(event) {
                if(event.key === Qt.Key_Tab) {
                    if(listModel.count > 0) {
                        items.currentKeyZone = answerZone
                        sampleList.currentIndex = -1
                        answerZone.currentIndex = 0
                    }
                }
                if(event.key === Qt.Key_Up) {
                    items.currentKeyZone = sampleList
                    // Checks if current highlighted element is in first row of the grid.
                    if(sampleList.currentIndex < columnCount && listModel.count > 0) {
                        items.currentKeyZone = answerZone
                        answerZone.currentIndex = 0
                        sampleList.currentIndex = -1
                    }
                    else {
                        sampleList.moveCurrentIndexUp()
                    }
                }
                if(event.key === Qt.Key_Down) {
                    items.currentKeyZone = sampleList
                    sampleList.moveCurrentIndexDown()
                }
                if(event.key === Qt.Key_Left) {
                    items.currentKeyZone = sampleList
                    sampleList.moveCurrentIndexLeft()
                }
                if(event.key === Qt.Key_Right) {
                    items.currentKeyZone = sampleList
                    sampleList.moveCurrentIndexRight()
                }
                if(event.key === Qt.Key_Space) {
                    var imageId = Activity.uniqueId[sampleList.currentIndex]
                    // At most (current level + 2) wagons are allowed in answer row at a time.
                    if(listModel.count < Activity.dataset["WagonsInCorrectAnswers"][bar.level - 1] + 2) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                        Activity.addWagon(imageId, listModel.count);
                    }
                }
                if((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) && listModel.count > 0 && items.mouseEnabled) {
                    items.currentKeyZone = sampleList
                    Activity.checkAnswer()
                }
            }

            Keys.enabled: true
            focus: true
            keyNavigationWraps: true
            highlightRangeMode: GridView.ApplyRange
            highlight: Rectangle {
                width: isHorizontal ? background.width / 5.66 : background.width / 4.2
                height: isHorizontal ? sampleList.cellHeight : sampleList.cellHeight / 1.65
                color: "#AA41AAC4"
                opacity: 0.8
                radius: 5
                visible: items.currentKeyZone === sampleList && items.keyNavigationMode
                x: (sampleList.currentIndex >= 0 && sampleList.currentItem) ? sampleList.currentItem.x : 0
                y: (sampleList.currentIndex >= 0 && sampleList.currentItem) ? sampleList.currentItem.y : 0
                Behavior on x {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }
            highlightFollowsCurrentItem: false
        }

        // Lower level wagons shelves
        Repeater {
            id: railSupporter
            model: sampleList.rowCount
            Rectangle {
                x: 0
                y: sampleList.y + (sampleList.cellHeight * (index + 1)) - (sampleList.cellHeight - items.sampleImageHeight)
                z: 1
                width: background.width
                height: isHorizontal ? 6 : 3
                border.color: "#808180"
                color: "transparent"
                border.width: 4
            }
        }

        // Answer Submission button
        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            height: score.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            anchors.top: score.top
            z: score.z
            anchors {
                right: score.left
                rightMargin: 10
            }
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            MouseArea {
                id: okButtonMouseArea
                anchors.fill: parent
                enabled: !trainAnimationTimer.running && !animateFlow.running && listModel.count > 0 && items.mouseEnabled
                onClicked: Activity.checkAnswer()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Score {
            id: score
            height: bar.height * 0.8
            width: height
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.left: undefined
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            z: introMessage.z
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: {
                if(!introMessage.visible && items.mouseEnabled) {
                    if(items.memoryMode == false) {
                        trainAnimationTimer.stop()
                        animateFlow.stop();
                        listModel.clear();
                        for(var index = 0; index < Activity.backupListModel.length; index++) {
                            Activity.addWagon(Activity.backupListModel[index], index);
                        }
                        items.memoryMode = true;
                        okButton.visible = true;
                    } else {
                        Activity.restoreLevel();
                        okButton.visible = false;
                    }
                }
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
