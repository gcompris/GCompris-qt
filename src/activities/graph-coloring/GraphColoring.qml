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
import QtQuick 2.12

import "../../core"
import "graph-coloring.js" as Activity
import GCompris 1.0

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
        id: background
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
            onClicked: showChooser(false);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias colorsRepeater: colorsRepeater
            property alias nodesRepeater: nodesRepeater
            property alias edgesRepeater: edgesRepeater
            property alias chooserGrid: chooserGrid
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

        Item {
            id: eventHandler
            focus: true
            Keys.enabled: !bonus.isPlaying && !dialogActivityConfig.visible
            Keys.onPressed: {
                items.keyNavigationMode = true;
                items.currentKeyZone.handleKeys(event);
            }
        }

        Column {
            id: colorsColumn

            anchors.left: parent.left
            anchors.leftMargin: 5 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            spacing: 3  * ApplicationInfo.ratio

            add: Transition {
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutBounce }
            }

            Repeater {
                id: colorsRepeater

                model: ListModel {}

                delegate:
                    Node {
                    width: 40 * ApplicationInfo.ratio
                    height: 40 * ApplicationInfo.ratio
                    border.width: 2
                    border.color: "white"
                    searchItemIndex: itemIndex
                }
            }
        }

        Item {
            id: graphRect
            anchors.left: parent.left
            anchors.leftMargin: 100 * ApplicationInfo.ratio
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 50 * ApplicationInfo.ratio
            height: background.height - 100 * ApplicationInfo.ratio
            width: background.width - 150 * ApplicationInfo.ratio
            property int diameter: graphRect.width/11
            property int minDiameter: 40 * ApplicationInfo.ratio
            property int maxDiameter: 80 * ApplicationInfo.ratio
            property int optDiameter: diameter < minDiameter ? minDiameter : ( diameter > maxDiameter ? maxDiameter : diameter)
            Repeater {
                id: edgesRepeater
                model: ListModel {}
                delegate: Rectangle {
                    id: line
                    opacity: 1
                    antialiasing: true
                    color: highlight == true ? "red" : "#373737"

                    transformOrigin: Item.TopLeft
                    x: xp * graphRect.width
                    y: yp * graphRect.height
                    property var x2: xpp * graphRect.width
                    property var y2: ypp * graphRect.height
                    width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                    height: highlight == true ? 7 * ApplicationInfo.ratio : 3 * ApplicationInfo.ratio
                    rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)
                    Behavior on color {
                        ColorAnimation {
                            duration: 2000
                            easing.type: Easing.OutExpo
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 2000
                            easing.type: Easing.OutExpo
                        }
                    }
                }


            }
            Repeater{
                id: nodesRepeater

                model: ListModel {}

                delegate:
                    Node{
                    id: currentNode

                    x: posX * graphRect.width - width/2
                    y: posY * graphRect.height - height/2
                    width: graphRect.optDiameter
                    height: width
                    radius: width/2
                    border.color: highlight ? "red" : "black"
                    border.width: highlight ? 7 : 4
                    symbolRotation: highlight
                    searchItemIndex: colIndex
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 2000
                            easing.type: Easing.OutExpo
                        }
                    }

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 2000
                            easing.type: Easing.OutExpo
                        }
                    }


                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        enabled: !bonus.isPlaying
                        z: 3
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked:{
                            activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                            items.currentKeyZone = chooser;
                            items.nodeHighlight.setHighlight(index);
                            showChooser(true, index, parent);
                        }
                    }
                    states: State {
                        name: "scaled"; when: mouseArea.containsMouse
                        PropertyChanges {
                            target: currentNode
                            scale: 1.1
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
                color: "#80ffffff"
                visible: items.currentKeyZone === graphRect && items.keyNavigationMode
                anchors.centerIn: nodesRepeater.itemAt(0)
                property int index: -1
                function setHighlight(toIndex) {
                    index = toIndex;
                    anchors.centerIn = nodesRepeater.itemAt(index);
                }
            }

            function handleKeys(event) {
                if(event.key === Qt.Key_Right) {
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                    nodeHighlight.index += 1;
                    if(nodeHighlight.index > nodesRepeater.count - 1) {
                        nodeHighlight.index = 0;
                    }
                }
                if(event.key === Qt.Key_Left) {
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
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
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                    showChooser(true, nodeHighlight.index, nodesRepeater.itemAt(nodeHighlight.index));
                    items.currentKeyZone = chooser;
                    items.chooserGrid.currentIndex = 0;
                }
            }
        }
        function showChooser(visible, guessIndex, item)
        {
            if (!visible) {
                chooser.visible = false;
                return;
            }
            var modelObj = items.nodesRepeater.model.get(guessIndex);
            var absolute = graphRect.mapToItem(background, item.x, item.y);
            chooserGrid.colIndex = modelObj.colIndex;
            chooserGrid.guessIndex = guessIndex;
            var targetX = absolute.x + item.width;
            var targetY = absolute.y - item.height/2;
            if (targetX < 0) {
                targetX = 0;
            }
            if (targetX + chooser.width > background.width) {
                targetX = background.width - chooser.width - 10;
            }
            if (targetY < 0) {
                targetY = 0;
            }
            if (targetY + chooser.height > background.height) {
                targetY = background.height - chooser.height - 10;
            }
            chooser.x = targetX;
            chooser.y = targetY;
            chooser.visible = true;
            //console.log(" item.x = " + item.x + " item.y" + item.y+" absolute.x" + absolute.x +" absolute.y" + absolute.y)
        }

        Rectangle {
            id: chooser

            width: chooserGrid.width + 5
            height: chooserGrid.height + 5

            color: "darkgray"
            border.width: 0
            border.color: "white"

            opacity: 1
            visible: false
            z: 10

            GridView {
                id: chooserGrid

                cellWidth: graphRect.optDiameter - 2
                cellHeight: cellWidth
                width: Math.ceil(count / 2) * cellWidth
                height: 2 * cellHeight
                anchors.centerIn: parent
                z: 11

                clip: false
                interactive: false
                verticalLayoutDirection: GridView.TopToBottom
                layoutDirection: Qt.LeftToRight
                flow: GridView.FlowLeftToRight
                highlight: Rectangle {
                    color: "#80ffffff"
                    visible: items.currentKeyZone === chooser && items.keyNavigationMode
                }

                property int gridCount : count
                property int colIndex: 0
                property int guessIndex: 0

                model: new Array()

                delegate: Node {
                    id: chooserItem
                    width: graphRect.optDiameter - 5
                    height: width
                    border.width: index == chooserGrid.colIndex ? 3 : 1
                    border.color: index == chooserGrid.colIndex ? "white" : "darkgray"
                    searchItemIndex: modelData
                    highlightSymbol: index == chooserGrid.colIndex
                    radius: width * 0.5

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        enabled: !bonus.isPlaying
                        z: 11
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserGrid.colIndex = chooserItem.searchItemIndex;
                            chooser.selectItem();
                        }
                    }
                }
            }

            function handleKeys(event) {
                if(event.key === Qt.Key_Right) {
                    activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                    chooserGrid.currentIndex += 1;
                    if(chooserGrid.currentIndex > chooserGrid.count - 1) {
                        chooserGrid.currentIndex = 0;
                    }
                }
                if(event.key === Qt.Key_Left) {
                    activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                    chooserGrid.currentIndex -= 1;
                    if(chooserGrid.currentIndex < 0) {
                        chooserGrid.currentIndex = chooserGrid.count - 1;
                    }
                }
                if(event.key === Qt.Key_Space) {
                    chooserGrid.colIndex = chooserGrid.currentItem.searchItemIndex;
                    selectItem();
                }
            }

            function selectItem() {
                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
                var obj = items.nodesRepeater.model;
                obj.setProperty(chooserGrid.guessIndex, "colIndex", chooserGrid.colIndex);
                showChooser(false);
                Activity.checkAdjacent();
                Activity.checkGuess();
                items.currentKeyZone = graphRect;
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home();
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
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
