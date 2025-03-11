/* GCompris - graph-coloring.qml
 *
 * SPDX-FileCopyrightText: 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12

import "../../core"
import "graph-coloring.js" as Activity
import core 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the eventHandler item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusEventInput()
        }
    }

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: activityBackground.showChooser(false);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int numberOfColors: 0
            property alias nodesRepeater: nodesRepeater
            property alias edgesRepeater: edgesRepeater
            property alias nodeHighlight: nodeHighlight
            property string mode: "color"
            property var currentKeyZone: graphRect
            property bool keyNavigationMode: false
            property alias eventHandler: eventHandler
        }

        onStart: {
            Activity.start(items);
            eventHandler.forceActiveFocus();
        }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: eventHandler
            focus: true
            Keys.enabled: !bonus.isPlaying && !dialogActivityConfig.visible
            Keys.onPressed: (event) => {
                items.keyNavigationMode = true;
                items.currentKeyZone.handleKeys(event);
            }
        }

        Column {
            id: colorsColumn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: bar.height * 1.3
            width: Math.min(40 * ApplicationInfo.ratio,
                            colorsColumn.height / items.numberOfColors - spacing)
            spacing: GCStyle.halfMargins
            add: Transition {
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutBounce }
            }
            Repeater {
                id: colorsRepeater
                model: items.numberOfColors
                delegate:
                    Node {
                        required property int index
                        width: colorsColumn.width
                        border.width: GCStyle.thinBorder
                        border.color: GCStyle.darkBorder
                        colorIndex: index
                        isError: false
                        mode: items.mode
                        posX: 0
                        posY: 0
                }
            }
        }

        Item {
            id: layoutArea
            anchors.left: colorsColumn.right
            anchors.bottom: colorsColumn.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
        }

        Item {
            id: graphRect
            anchors.left: colorsColumn.right
            anchors.bottom: colorsColumn.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: optDiameter * 0.75 + GCStyle.baseMargins
            property int diameter: Math.min(layoutArea.width, layoutArea.height) / 11
            property int minDiameter: 40 * ApplicationInfo.ratio
            property int maxDiameter: GCStyle.bigButtonHeight
            property int optDiameter: diameter < minDiameter ? minDiameter : ( diameter > maxDiameter ? maxDiameter : diameter)

            Repeater {
                id: edgesRepeater
                model: ListModel {}
                delegate: Rectangle {
                    id: line
                    antialiasing: true
                    required property bool isError
                    required property double xp
                    required property double yp
                    required property double xpp
                    required property double ypp
                    color: isError ? GCStyle.badAnswerBorder : GCStyle.darkBorder
                    transformOrigin: Item.Left
                    x: xp * graphRect.width
                    y: yp * graphRect.height
                    property var x2: xpp * graphRect.width
                    property var y2: ypp * graphRect.height
                    width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                    height: isError ? GCStyle.thickerBorder : GCStyle.midBorder
                    rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.OutExpo
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.OutExpo
                        }
                    }
                }
            }

            Repeater{
                id: nodesRepeater
                model: ListModel {}
                delegate:
                    Node {
                    id: currentNode
                    required property int index
                    x: posX * graphRect.width - width * 0.5
                    y: posY * graphRect.height - height * 0.5
                    width: graphRect.optDiameter
                    height: width
                    border.color: isError ? GCStyle.badAnswerBorder : GCStyle.darkBorder
                    border.width: isError ? GCStyle.thickBorder : GCStyle.thinBorder
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.OutExpo
                        }
                    }

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.OutExpo
                        }
                    }

                    mode: items.mode

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        enabled: !bonus.isPlaying
                        z: 3
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked:{
                            smudgeSound.play();
                            items.currentKeyZone = chooser;
                            items.nodeHighlight.setHighlight(currentNode.index);
                            activityBackground.showChooser(true, currentNode.index, parent);
                        }
                    }
                    states: State {
                        name: "scaled"; when: mouseArea.containsMouse
                        PropertyChanges {
                            currentNode {
                                scale: 1.1
                            }
                        }
                    }
                    transitions: Transition {
                        NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
                    }

                }
            }

            Rectangle {
                id: nodeHighlight
                z: -1
                width: graphRect.optDiameter * 1.5
                height: width
                radius: width * 0.5
                color: GCStyle.whiteBg
                opacity: 0.5
                visible: items.keyNavigationMode
                anchors.centerIn: nodesRepeater.itemAt(0)
                property int index: -1
                function setHighlight(toIndex: int) {
                    index = toIndex;
                    anchors.centerIn = nodesRepeater.itemAt(index);
                }
            }

            function handleKeys(event: var) {
                if(event.key === Qt.Key_Right) {
                    smudgeSound.play();
                    nodeHighlight.index += 1;
                    if(nodeHighlight.index > nodesRepeater.count - 1) {
                        nodeHighlight.index = 0;
                    }
                }
                if(event.key === Qt.Key_Left) {
                    smudgeSound.play();
                    nodeHighlight.index -= 1;
                    if(nodeHighlight.index < 0) {
                        nodeHighlight.index = nodesRepeater.count - 1;
                    }
                }
                //if space is used before direction keys, init index at 0
                if(nodeHighlight.index === -1) {
                    nodeHighlight.index = 0;
                }
                nodeHighlight.anchors.centerIn = nodesRepeater.itemAt(nodeHighlight.index);
                if(event.key === Qt.Key_Space) {
                    smudgeSound.play();
                    activityBackground.showChooser(true, nodeHighlight.index, nodesRepeater.itemAt(nodeHighlight.index));
                    items.currentKeyZone = chooser;
                }
            }
        }

        function showChooser(showIt: bool, guessIndex: int, item: Item) {
            if (!showIt) {
                chooser.visible = false;
                chooserGrid.currentIndex = 0;
                return;
            }
            var modelObj = items.nodesRepeater.model.get(guessIndex);
            var absolute = graphRect.mapToItem(activityBackground, item.x, item.y);
            chooserGrid.currentIndex = 0;
            chooserGrid.colorIndex = modelObj.colorIndex;
            chooserGrid.guessIndex = guessIndex;
            var targetX = absolute.x + item.width;
            var targetY = absolute.y - item.height * 0.5;
            if (targetX < GCStyle.halfMargins) {
                targetX = GCStyle.halfMargins;
            }
            if (targetX + chooser.width > activityBackground.width - GCStyle.halfMargins) {
                targetX = activityBackground.width - chooser.width - GCStyle.halfMargins;
            }
            if (targetY < GCStyle.halfMargins) {
                targetY = GCStyle.halfMargins;
            }
            if (targetY + chooser.height > activityBackground.height - GCStyle.halfMargins) {
                targetY = activityBackground.height - chooser.height - GCStyle.halfMargins;
            }
            chooser.x = targetX;
            chooser.y = targetY;
            chooser.visible = true;
        }

        Rectangle {
            id: chooser
            width: chooserGrid.width + GCStyle.halfMargins
            height: chooserGrid.height + GCStyle.halfMargins
            color: GCStyle.lightBg
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.darkBg
            visible: false
            z: 10

            GridView {
                id: chooserGrid
                cellWidth: graphRect.optDiameter
                cellHeight: cellWidth
                width: Math.ceil(count / 2) * cellWidth
                height: 2 * cellHeight
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: GCStyle.halfMargins
                z: 11
                clip: false
                interactive: false
                verticalLayoutDirection: GridView.TopToBottom
                layoutDirection: Qt.LeftToRight
                flow: GridView.FlowLeftToRight
                highlight: Rectangle {
                    color: GCStyle.highlightColor
                    opacity: 0.5
                    visible: items.currentKeyZone === chooser && items.keyNavigationMode
                }
                property int colorIndex: 0
                property int guessIndex: 0
                model: items.numberOfColors
                delegate: Node {
                    id: chooserItem
                    required property int index
                    width: graphRect.optDiameter - GCStyle.halfMargins
                    border.width: index == chooserGrid.colorIndex ? GCStyle.thinBorder : GCStyle.thinnestBorder
                    border.color: index == chooserGrid.colorIndex ? GCStyle.darkBorder : GCStyle.grayBorder
                    colorIndex: index
                    posX: 0
                    posY: 0
                    isError: false
                    mode: items.mode
                    highlightSymbol: index == chooserGrid.colorIndex

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        enabled: !bonus.isPlaying
                        z: 11
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserGrid.colorIndex = chooserItem.colorIndex;
                            chooser.selectItem();
                        }
                    }
                }
            }

            function handleKeys(event: var) {
                if(event.key === Qt.Key_Right) {
                    smudgeSound.play();
                    chooserGrid.currentIndex += 1;
                    if(chooserGrid.currentIndex > chooserGrid.count - 1) {
                        chooserGrid.currentIndex = 0;
                    }
                }
                if(event.key === Qt.Key_Left) {
                    smudgeSound.play();
                    chooserGrid.currentIndex -= 1;
                    if(chooserGrid.currentIndex < 0) {
                        chooserGrid.currentIndex = chooserGrid.count - 1;
                    }
                }
                if(event.key === Qt.Key_Space) {
                    chooserGrid.colorIndex = chooserGrid.currentItem.colorIndex;
                    chooser.selectItem();
                }
            }

            function selectItem() {
                smudgeSound.play();
                var obj = items.nodesRepeater.model;
                obj.setProperty(chooserGrid.guessIndex, "colorIndex", chooserGrid.colorIndex);
                activityBackground.showChooser(false);
                Activity.checkAdjacent();
                Activity.checkGuess();
                items.currentKeyZone = graphRect;
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                activity.home();
                eventHandler.forceActiveFocus();
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onStartActivity: {
                eventHandler.forceActiveFocus();
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: activityConfig | help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
