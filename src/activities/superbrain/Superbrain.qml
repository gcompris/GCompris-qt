/* GCompris - Superbrain.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "superbrain.js" as Activity
import GCompris 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        focus: true

        readonly property double scaleFactor: 1
        readonly property bool isPortrait: (height >= width)

        signal start
        signal stop

        MouseArea {
            anchors.fill: parent
            onClicked: showChooser(false);
        }

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias colorsRepeater: colorsRepeater
            property alias chooserGrid: chooserGrid
            property alias guessModel: guessModel
            property alias guessColumn: guessColumn
            property alias currentRepeater: currentRepeater
            property string mode: "color"
        }

        onStart: { Activity.start(items) }
        onStop: {
            chooserTimer.stop()
            Activity.stop()
        }

        Column {
            id: colorsColumn

            anchors.left: parent.left
            anchors.leftMargin: 5 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            spacing: 3  * ApplicationInfo.ratio

            width: guessColumn.guessSize
            height: guessColumn.guessSize

            add: Transition {
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutBounce }
            }

            Repeater {
                id: colorsRepeater

                model: ListModel {}

                delegate: SearchItem {
                    width: 40 * ApplicationInfo.ratio
                    height: 40 * ApplicationInfo.ratio
                    border.width: 2
                    border.color: "#373737"
                    searchItemIndex: itemIndex
                }
            }
        }

        Rectangle {
            id: tooltipRect
            width: 100 * ApplicationInfo.ratio
            height: tooltipText.height + 10 * ApplicationInfo.ratio
            radius: 4
            x: 0
            y: 0
            color: "lightgray"
            opacity: 0
            z: 10
            property alias text: tooltipText.text

            GCText {
                id: tooltipText
                anchors.centerIn: parent
                fontSize: 13
                text: ""
                color: "black"

                onTextChanged: parent.width = width + 10
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        function showTooltip(visible, status, mouseArea)
        {
            if (!visible || status === Activity.STATUS_UNKNOWN) {
                tooltipRect.opacity = 0;
                return;
            }
            showChooser(false);

            var obj = background.mapFromItem(mouseArea, mouseArea.mouseX, mouseArea.mouseY);

            if (status === Activity.STATUS_CORRECT)
                tooltipRect.text = qsTr("This item is well placed.");
            if (status === Activity.STATUS_MISPLACED)
                tooltipRect.text = qsTr("This item is misplaced.");
            tooltipRect.x = obj.x - 5 - tooltipRect.width;
            tooltipRect.y = obj.y - 5 - tooltipRect.height;
            tooltipRect.opacity = 0.9;
        }

        function showChooser(visible, guessIndex, item)
        {
            if (!visible) {
                chooserTimer.stop();
                chooser.scale = 0;
                return;
            }
            var modelObj = guessModel.get(0).guess.get(guessIndex);
            var absolute = currentRow.mapToItem(background, item.x, item.y);
            chooserGrid.colIndex = modelObj.colIndex;
            chooserGrid.guessIndex = guessIndex;
            var chooserOffset = 0.5*chooser.width - item.width/2;
            var arrowOffset = 0;
            var targetX = item.x - chooserOffset;
            // beyond left screen border:
            if (absolute.x - chooserOffset < 0) {
                arrowOffset = absolute.x - chooserOffset;
                targetX -= arrowOffset;
            }
            // beyond right screen border:
            if (absolute.x + chooserOffset + item.width > background.width) {
                arrowOffset = absolute.x + chooserOffset + item.width - background.width;
                targetX -= arrowOffset;
            }

            chooser.x = targetX;
            chooser.arrowOffset = arrowOffset;
            var targetY = item.y - chooser.height - 15;
            var targetAbove = true;
            /* //only on top-level, at window border:
if (targetY < 0) {
                targetY = item.y + guessColumn.guessSize + 10;
                targetAbove = false;
            }*/
            chooser.y = targetY;
            chooser.above = targetAbove;
            chooser.scale = 1;
            chooser.visible = true;
            chooserTimer.restart();
            //console.log("XXX chooser at item.x=" + item.x + " absolute.x=" + absolute.x + " chooser.x/w=" + chooser.x + "/" + chooser.width + " background.width=" + background.width + " currentRow.x/y/w/h=" + currentRow.x + "/" + currentRow.y + "/" + currentRow.width + "/" + currentRow.height + " guessIdx=" + guessIndex + " arrowOff=" + arrowOffset);
        }

        Item {
            id: currentWrapper

            width: currentRow.width
            height: currentRow.height
            z: 8

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20 * ApplicationInfo.ratio

            state: ApplicationSettings.isBarHidden ? "hidden" : "shown"
            states: [
                State {
                    name: "hidden"
                    when: ApplicationSettings.isBarHidden
                    AnchorChanges {
                        target: currentWrapper;
                        anchors.bottom: parent.bottom
                    }
                },
                State {
                    name: "shown"
                    when: !ApplicationSettings.isBarHidden
                    AnchorChanges {
                        target: currentWrapper;
                        anchors.bottom: bar.top
                    }
                }
            ]

            transitions: Transition {
                AnchorAnimation { duration: 800; easing.type: Easing.OutBounce }
            }

            Rectangle {
                id: chooser

                width: chooserGrid.width + 15
                height: chooserGrid.height + 15

                color: "darkgray"
                border.width: 0
                border.color: "white"

                opacity: 1
                scale: 0
                visible: false
                z: 10

                property bool above: true
                property real arrowOffset: 0

                Rectangle {
                    id: chooserArrow
                    width: 10
                    height: 10

                    x: chooser.width / 2 - 5 + chooser.arrowOffset
                    y: chooser.above ? (chooser.height - 5) : (-5)
                    color: chooser.color
                    z: chooser.z
                    transform: Rotation { origin.x: 5; origin.y: 5; angle: 45}
                }

                GridView {
                    id: chooserGrid

                    cellWidth: guessColumn.guessSize * 2
                    cellHeight: guessColumn.guessSize * 2
                    width: Math.ceil(count / 2) * cellWidth
                    height: 2 * cellHeight
                    anchors.centerIn: parent
                    z: 11

                    clip: false
                    interactive: false
                    verticalLayoutDirection: GridView.TopToBottom
                    layoutDirection: Qt.LeftToRight
                    flow: GridView.FlowLeftToRight

                    property int colIndex: 0
                    property int guessIndex: 0

                    Timer {
                        id: chooserTimer
                        interval: 5000
                        onTriggered: showChooser(false);
                    }

                    model: new Array()

                    delegate: SearchItem {
                        id: chooserItem
                        width: chooserGrid.cellWidth
                        height: chooserGrid.cellWidth
                        border.width: index == chooserGrid.colIndex ? 3 : 1
                        border.color: index == chooserGrid.colIndex ? "#373737" : "darkgray"
                        highlightSymbol: index == chooserGrid.colIndex
                        searchItemIndex: modelData
                        radius: 5

                        MouseArea {
                            id: chooserMouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            enabled: chooser.scale !== 0 && !bonus.isPlaying
                            z: 11
                            hoverEnabled: ApplicationInfo.isMobile ? false : true

                            onClicked: {
                                chooserGrid.colIndex = chooserItem.searchItemIndex;
                                var obj = items.guessModel.get(0);
                                obj.guess.setProperty(chooserGrid.guessIndex, "colIndex", chooserGrid.colIndex);
                                showChooser(false);
                            }
                        }
                    }
                }
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }

            Row {
                id: currentRow
                visible: true

                property double factor: 1.9

                anchors.left: parent.left
                anchors.top: parent.top

                spacing: guessColumn.horizSpacing * factor
                height: guessColumn.guessSize * factor
                scale: 1
                z: 9

                Repeater {
                    id: currentRepeater

                    delegate: SearchItem {
                        id: currentGuess

                        width: guessColumn.guessSize * currentRow.factor
                        height: guessColumn.guessSize * currentRow.factor
                        border.width: 2 * currentRow.factor
                        border.color: "#373737"
                        searchItemIndex: colIndex
                        opacity: 1.0
                        z: 2

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            enabled: !bonus.isPlaying
                            z: 3
                            hoverEnabled: ApplicationInfo.isMobile ? false : true

                            onPressAndHold: {
                                if (guessColumn.count > 1)
                                    guessModel.get(0).guess.get(index).colIndex = guessModel.get(1).guess.get(index).colIndex;
                            }

                            onClicked: {
                                var obj = items.guessModel.get(0).guess.get(index);
                                if(chooserTimer.running && chooserGrid.guessIndex === index) {
                                    if (mouse.button == Qt.LeftButton)
                                        obj.colIndex = (obj.colIndex ==
                                                        Activity.currentIndeces.length - 1) ? 0 : obj.colIndex + 1;
                                    else
                                        obj.colIndex = (obj.colIndex == 0) ?
                                                    Activity.currentIndeces.length - 1 : obj.colIndex - 1;
                                }
                                showChooser(true, index, parent);
                            }
                        }
                        states: State {
                            name: "scaled"; when: mouseArea.containsMouse
                            PropertyChanges {
                                target: currentGuess
                                scale: 1.1
                            }
                        }
                        transitions: Transition {
                            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
                        }
                    }
                }

                BarButton {
                    id: okButton
                    enabled: !bonus.isPlaying
                    source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                    sourceSize.width: 66 * bar.barZoom
                    width: guessColumn.guessSize * currentRow.factor
                    height: guessColumn.guessSize * currentRow.factor
                    visible: true
                    z: 8
                    onClicked: {
                        showChooser(false);
                        Activity.checkGuess();
                    }
                }
            }
        }

        ListModel {
            id: guessModel
            dynamicRoles: true
        }

        ListView {
            id: guessColumn

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: currentWrapper.top
            anchors.bottomMargin: 10 * ApplicationInfo.ratio

            boundsBehavior: Flickable.DragOverBounds
            verticalLayoutDirection: ListView.BottomToTop

            readonly property int guessSize: 30 * ApplicationInfo.ratio
            readonly property int vertSpacing: 15 * ApplicationInfo.ratio
            readonly property int horizSpacing: 15 * ApplicationInfo.ratio
            readonly property int statusMargin: 5 * ApplicationInfo.ratio
            readonly property int resultSize: 10 * ApplicationInfo.ratio
            readonly property int guessColWidth: Activity.maxPieces * (guessSize + (2 * guessColumn.statusMargin))
                                                 + (Activity.maxPieces-1) * horizSpacing;
            readonly property int resultColWidth: Activity.maxPieces * resultSize
                                                  + (Activity.maxPieces-1) * 2;

            spacing: vertSpacing

            width: guessColWidth + 10 + (2 * horizSpacing) + resultColWidth
            height: count * (guessSize + vertSpacing)

            displaced: Transition {
                NumberAnimation { easing.type: Easing.OutCubic; properties: "y"; duration: 300 }
            }

            model: guessModel

            delegate: Row {
                id: guessRow
                width: guessColumn.width
                height: guessColumn.guessSize
                spacing: guessColumn.horizSpacing
                property int rowIndex: index
                visible: index != 0

                Item {
                    id: guessRowSpacer
                    width: guessColumn.guessColWidth -
                           (guessRepeater.count * (guessColumn.guessSize +
                                                   (2 * guessColumn.statusMargin) + guessColumn.horizSpacing))
                    height: parent.height
                }

                Repeater {
                    id: guessRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    model: guess

                    delegate: Item { // wrapper needed for singleGuessStatusRect's opacity
                        id: singleGuessWrapper

                        width: guessColumn.guessSize + (2 * guessColumn.statusMargin);
                        height: guessColumn.guessSize + (2 * guessColumn.statusMargin);

                        Rectangle {
                            id: singleGuessStatusRect
                            border.width: 2
                            border.color: (status == Activity.STATUS_CORRECT) ? "white" : "black";
                            anchors.fill: parent
                            radius: 3
                            color: (status == Activity.STATUS_CORRECT) ? "black" : "white";
                            opacity: (status == Activity.STATUS_UNKNOWN) ? 0 : 0.9
                            z: 1

                            MouseArea {
                                id: mouseAreaRect
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                enabled: guessRow.rowIndex > 0 && !bonus.isPlaying
                                z: 4
                                hoverEnabled: ApplicationInfo.isMobile ? false : true

                                Timer {
                                    id: tooltipTimer
                                    repeat: false
                                    interval: 500
                                    signal stopTimer

                                    Component.onCompleted: {
                                        activity.stop.connect(stopTimer);
                                    }

                                    onStopTimer: {
                                        stop();
                                    }

                                    onTriggered: showTooltip(true, status, mouseAreaRect)
                                }

                                onEntered: tooltipTimer.restart()

                                onExited: {
                                    tooltipTimer.stop()
                                    showTooltip(false)
                                }

                                onClicked: showTooltip(true, status, mouseAreaRect);
                                onDoubleClicked: Activity.ackColor(index, colIndex);

                            }
                        }

                        SearchItem {
                            id: singleGuess

                            width: guessColumn.guessSize
                            height: guessColumn.guessSize
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: guessColumn.statusMargin
                            anchors.topMargin: guessColumn.statusMargin

                            border.width: 2
                            border.color: "#373737"
                            searchItemIndex: colIndex
                            opacity: 1.0
                            z: 2

                            Image {
                                id: okImage
                                visible: isAcked

                                width: parent.width / 2
                                height: parent.height / 2

                                anchors.centerIn: parent

                                source: "qrc:/gcompris/src/core/resource/apply.svg"
                            }

                            MouseArea {
                                id: ackMouseArea
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                enabled: status == Activity.STATUS_UNKNOWN && !bonus.isPlaying
                                visible: status == Activity.STATUS_UNKNOWN
                                z: 3
                                hoverEnabled: ApplicationInfo.isMobile ? false : true

                                onDoubleClicked: Activity.ackColor(index, colIndex);
                            }
                        }
                    }
                }

                Item {
                    id: guessRowSpacer2
                    width: 10
                    height: guessColumn.guessSize
                }

                Column {
                    id: guessResultColumn

                    width: guessColumn.resultColWidth
                    height: guessColumn.guessSize
                    spacing: 2

                    Item {
                        id: guessResultColSpacer
                        width: guessResultColumn.width
                        height: (guessResultColumn.height - 2 * (guessColumn.resultSize))
                    }

                    Row {
                        id: guessResultCorrectRow

                        width: guessResultColumn.width
                        height: guessColumn.resultSize
                        spacing: 2

                        Repeater {
                            id: guessResultCorrectRepeater

                            model: result.correct
                            delegate: Rectangle {
                                id: singleCorrectResult

                                width: guessColumn.resultSize
                                height: guessColumn.resultSize

                                radius: width * 0.5
                                border.width: 1
                                border.color: "white"
                                color: "black"
                            }
                        }
                    }

                    Row {
                        id: guessResultMisplacedRow

                        width: guessResultColumn.width
                        height: guessColumn.resultSize
                        spacing: 2

                        Repeater {
                            id: guessResultMisplacedRepeater

                            model: result.misplaced
                            delegate: Rectangle {
                                id: singleMisplacedResult

                                width: guessColumn.resultSize
                                height: guessColumn.resultSize

                                radius: width * 0.5
                                border.width: 1
                                border.color: "black"
                                color: "white"
                            }
                        }
                    }
                }
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
                home()
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
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
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: undefined
            anchors.top: parent.top
            anchors.right: parent.right
        }
    }
}
