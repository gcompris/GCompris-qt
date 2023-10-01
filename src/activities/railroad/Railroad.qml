/* GCompris - railroad.qml
 *
 * SPDX-FileCopyrightText: 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Pascal Georges (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
 *   Amit Sagtani <asagtani06@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (controls refactoring and bugfixes)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
            property int currentLevel: activity.currentLevel 
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
            property bool controlsEnabled: false
            property var currentKeyZone: sampleList
            property bool keyNavigationMode: false
            // stores height of sampleGrid images to set rail bar support position
            property int sampleImageHeight: 0
            property int sampleModel: Activity.dataset["noOfLocos"][currentLevel] + Activity.dataset["noOfWagons"][currentLevel]
            property var uniqueId: []
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: introMessage

        Keys.onPressed: {
            items.keyNavigationMode = true;
            items.currentKeyZone.handleKeys(event);
        }

        function playSoundFX() {
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
                qsTr("If you forgot the model, you can click on the Hint button to view it again.")
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
                        items.controlsEnabled = true;
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
                    // Checks answer.
                    if(event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        okButton.clicked();
                    }
                    if(trainAnimationTimer.running || animateFlow.running) {
                        return;
                    }
                    if(event.key === Qt.Key_Tab)
                        bar.hintClicked();
                    if(!items.controlsEnabled)
                        return;
                    if(event.key === Qt.Key_Down) {
                        playSoundFX();
                        items.currentKeyZone = sampleList;
                        answerZone.currentIndex = -1;
                        sampleList.currentIndex = 0;
                    }
                    if(event.key === Qt.Key_Up) {
                        playSoundFX();
                        items.currentKeyZone = sampleList;
                        answerZone.currentIndex = -1;
                        sampleList.currentIndex = 0;
                    }
                    if(event.key === Qt.Key_Left) {
                        playSoundFX();
                        answerZone.moveCurrentIndexLeft();
                    }
                    if(event.key === Qt.Key_Right) {
                        playSoundFX();
                        answerZone.moveCurrentIndexRight();
                    }
                    // Remove a wagon via Delete/Return key.
                    if((event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) && listModel.count > 0) {
                        playSoundFX();
                        listModel.remove(answerZone.currentIndex);
                        if(listModel.count < 2) {
                            answerZone.selectedSwapIndex = -1;
                        }
                    }
                    // Swaps two wagons with help of Space/Enter keys.
                    if(event.key === Qt.Key_Space) {
                        if(selectedSwapIndex === -1 && listModel.count > 1) {
                            playSoundFX();
                            answerZone.selectedSwapIndex = answerZone.currentIndex;
                            swapHighlight.x = answerZone.currentItem.x;
                            swapHighlight.anchors.top = answerZone.top;
                        }
                        else if(answerZone.currentIndex != selectedSwapIndex && listModel.count > 1){
                            playSoundFX();
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
                    visible: (items.currentKeyZone === answerZone) && (!trainAnimationTimer.running && !animateFlow.running)
                              && items.keyNavigationMode && items.controlsEnabled
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
            model: items.uniqueId
            interactive: false

            // No. of wagons in a row
            readonly property int columnCount: isHorizontal ? Activity.dataset["columnsInHorizontalMode"][items.currentLevel] :
            Activity.dataset["columsInVerticalMode"][items.currentLevel]

            readonly property int rowCount: columnCount > 0 ? model.length / columnCount : 0

            delegate: Image {
                id: loco
                readonly property string uniqueID: modelData
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
                            listModel.count < Activity.dataset["WagonsInCorrectAnswers"][items.currentLevel] + 2) {
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
                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    okButton.clicked();
                }
                if(trainAnimationTimer.running || animateFlow.running) {
                    return;
                }
                if(event.key === Qt.Key_Tab)
                    bar.hintClicked();
                if(!items.controlsEnabled)
                    return;

                if(event.key === Qt.Key_Up) {
                    playSoundFX();
                    // Checks if current highlighted element is in first row of the grid.
                    if(sampleList.currentIndex < columnCount && listModel.count > 0) {
                        items.currentKeyZone = answerZone;
                        answerZone.currentIndex = 0;
                        sampleList.currentIndex = -1;
                    }
                    else {
                        sampleList.moveCurrentIndexUp();
                    }
                }
                if(event.key === Qt.Key_Down) {
                    playSoundFX();
                    // Checks if current highlighted element is in last row of the grid.
                    if(sampleList.model - columnCount <= sampleList.currentIndex && listModel.count > 0) {
                        items.currentKeyZone = answerZone;
                        answerZone.currentIndex = 0;
                        sampleList.currentIndex = -1;
                    }
                    else {
                        sampleList.moveCurrentIndexDown();
                    }
                }
                if(event.key === Qt.Key_Left) {
                    playSoundFX();
                    sampleList.moveCurrentIndexLeft();
                }
                if(event.key === Qt.Key_Right) {
                    playSoundFX();
                    sampleList.moveCurrentIndexRight();
                }
                if(event.key === Qt.Key_Space) {
                    var imageId = items.uniqueId[sampleList.currentIndex];
                    // At most (current level + 2) wagons are allowed in answer row at a time.
                    if(listModel.count < Activity.dataset["WagonsInCorrectAnswers"][items.currentLevel] + 2) {
                        playSoundFX();
                        Activity.addWagon(imageId, listModel.count);
                    }
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
            onClicked: {
                if(trainAnimationTimer.running || animateFlow.running)
                    bar.hintClicked();
                else if(listModel.count > 0 && items.mouseEnabled && visible)
                    Activity.checkAnswer();
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
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            z: introMessage.z
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
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
                        items.controlsEnabled = true;
                    } else {
                        Activity.restoreLevel();
                        okButton.visible = false;
                        items.controlsEnabled = false;
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
