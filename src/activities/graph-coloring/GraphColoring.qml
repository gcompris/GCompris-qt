/* GCompris - graph-coloring.qml
 *
 * Copyright (C) 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
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

import "../../core"
import "graph-coloring.js" as Activity
import GCompris 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        focus: true

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
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
            property alias bar: bar
            property alias bonus: bonus
            property alias colorsRepeater: colorsRepeater
            property alias nodesRepeater: nodesRepeater
            property alias edgesRepeater: edgesRepeater
            property alias chooserGrid: chooserGrid
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

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
                    color: highlight == true ? "red" : "black"

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
                        enabled: true
                        z: 3
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked:{
                            var obj = items.nodesRepeater.model.get(index);
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
        }
        function showChooser(visible, guessIndex, item)
        {
            if (!visible) {
                chooserTimer.stop();
                chooser.scale = 0;
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
            chooser.scale = 1;
            chooser.visible = true;
            chooserTimer.restart();
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
            scale: 0
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

                property int gridCount : count
                property int colIndex: 0
                property int guessIndex: 0

                Timer {
                    id: chooserTimer
                    interval: 5000
                    onTriggered: showChooser(false);
                }

                model: new Array()

                delegate: Node {
                    id: chooserItem
                    width: graphRect.optDiameter - 5
                    height: width
                    border.width: index == chooserGrid.colIndex ? 3 : 1
                    border.color: index == chooserGrid.colIndex ? "white" : "darkgray"
                    searchItemIndex: modelData
                    highlightSymbol: index == chooserGrid.colIndex
                    radius: 5

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        z: 11
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserGrid.colIndex = chooserItem.searchItemIndex;
                            var obj = items.nodesRepeater.model;
                            obj.setProperty(chooserGrid.guessIndex, "colIndex", chooserGrid.colIndex);
                            showChooser(false);
                            Activity.checkAdjacent()
                            Activity.checkGuess()
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modeBox: modeBox

                    property var availableModes: [
                        { "text": qsTr("Colors"), "value": "color" },
                        { "text": qsTr("Shapes"), "value": "symbol" }
                    ]

                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modeBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your mode")
                        }
                    }
                }
            }
            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["mode"]) {
                    Activity.mode = dataToSave["mode"];
                }
            }

            onSaveData: {
                var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                if (newMode !== Activity.mode) {
                    chooserGrid.model = new Array();
                    Activity.mode = newMode;
                    dataToSave = {"mode": Activity.mode};
                    Activity.initLevel();
                }
            }

            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === Activity.mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: config | help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                // Set default values
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
