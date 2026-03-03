/* GCompris - Superbrain.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Layout refactoring and code clean-up)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"
import "superbrain.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core
import core 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

     onActivityNextLevel: {
         Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        focus: true

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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 0
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property alias bonus: bonus
            property alias score: score
            property alias colorsRepeater: colorsRepeater
            property alias chooserGrid: chooserGrid
            property alias guessModel: guessModel
            property alias guessColumn: guessColumn
            property alias currentRepeater: currentRepeater
            property string mode: "color"
            property alias goodAnswerSound: goodAnswerSound
            property bool buttonsBlocked: false
            property alias tooltipTimer: tooltipTimer
            property alias chooserTimer: chooserTimer
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        Column {
            id: colorsColumn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.margins: GCStyle.halfMargins
            spacing: GCStyle.halfMargins
            width: Math.min(40 * ApplicationInfo.ratio, height / colorsRepeater.model.count - colorsColumn.spacing)

            add: Transition {
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutBounce }
            }

            Repeater {
                id: colorsRepeater

                model: ListModel {}

                delegate: SearchItem {
                    width: colorsColumn.width
                    height: width
                    border.width: GCStyle.thinnestBorder
                    border.color: GCStyle.darkBorder
                    searchItemIndex: itemIndex
                }
            }
        }

        Rectangle {
            id: tooltipRect
            width: tooltipText.contentWidth + GCStyle.baseMargins
            height: tooltipText.contentHeight + GCStyle.halfMargins
            radius: GCStyle.tinyMargins
            x: 0
            y: 0
            color: "#e4ffffff"
            opacity: 0
            z: 100
            property alias text: tooltipText.text

            GCText {
                id: tooltipText
                width: 200 * ApplicationInfo.ratio
                height: 30 * ApplicationInfo.ratio
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                text: ""
                color: GCStyle.darkText
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }


        Timer {
            id: tooltipTimer
            repeat: false
            interval: 500
            signal stopTimer
            property MouseArea mouseAreaRect: null

            onTriggered: {
                if(mouseAreaRect) {
                    showTooltip(true, mouseAreaRect.guessStatus, mouseAreaRect);
                }
            }

            function resetTimer() {
                mouseAreaRect = null;
                tooltipTimer.stop();
                showTooltip(false);
            }
        }

        function showTooltip(visible, status, mouseArea) {
            if (!visible || status === Activity.STATUS_UNKNOWN) {
                tooltipRect.opacity = 0;
                return;
            }
            chooserTimer.resetTimer();

            var obj = activityBackground.mapFromItem(mouseArea, mouseArea.mouseX, mouseArea.mouseY);

            if (status === Activity.STATUS_CORRECT)
                tooltipRect.text = qsTr("This item is well placed.");
            if (status === Activity.STATUS_MISPLACED)
                tooltipRect.text = qsTr("This item is misplaced.");
            tooltipRect.x = Core.clamp(obj.x - tooltipRect.width * 0.5, 0, activityBackground.width - tooltipRect.width);
            tooltipRect.y = Core.clamp(obj.y - tooltipRect.height, 0, activityBackground.height - tooltipRect.height);
            tooltipRect.opacity = 1;
        }

        Timer {
            id: chooserTimer
            interval: 5000
            onTriggered: showChooser(false);

            function resetTimer() {
                chooserTimer.stop();
                showChooser(false);
            }
        }

        function showChooser(visible, guessIndex, item) {
            if (!visible) {
                chooser.visible = false;
                return;
            }
            var modelObj = guessModel.get(0).guess.get(guessIndex);
            var absolutePosition = activityBackground.mapFromItem(currentRow, item.x, item.y)
            chooserGrid.colIndex = modelObj.colIndex;
            chooserGrid.guessIndex = guessIndex;
            chooserArrow.x = absolutePosition.x + item.width * 0.5 - chooserArrow.width * 0.5
            chooserArrow.y = absolutePosition.y - chooserArrow.height
            chooser.x = Core.clamp(chooserArrow.x + chooserArrow.width * 0.5 - chooser.width * 0.5, 0, activityBackground.width - chooser.width)
            chooser.y = chooserArrow.y + chooserArrow.height * 0.5 - chooser.height
            chooser.visible = true;
            chooserTimer.restart();
        }

        Rectangle {
            id: currentWrapper
            z: 10
            color: "#80FFFFFF"
            height: currentRow.height
            anchors.left: colorsColumn.right
            anchors.right: parent.right
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: bar.height

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

            Row {
                id: currentRow
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: GCStyle.halfMargins
                height: Math.min(60 * ApplicationInfo.ratio, currentWrapper.width / (currentRepeater.count + 1) - spacing)
                width: (height + GCStyle.halfMargins) * (currentRepeater.count + 1)

                Repeater {
                    id: currentRepeater
                    delegate: SearchItem {
                        id: currentGuess
                        width: currentRow.height
                        height: width
                        border.width: GCStyle.thinBorder
                        border.color: GCStyle.darkBorder
                        searchItemIndex: colIndex
                        opacity: 1.0

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            enabled: !items.buttonsBlocked
                            hoverEnabled: ApplicationInfo.isMobile ? false : true

                            onPressAndHold: {
                                if (guessColumn.count > 1)
                                    guessModel.get(0).guess.get(index).colIndex = guessModel.get(1).guess.get(index).colIndex;
                            }

                            onClicked: (mouse) => {
                                if(!chooser.visible || chooserGrid.guessIndex != index) {
                                    showChooser(true, index, parent);
                                } else {
                                    chooserTimer.restart();
                                    var obj = items.guessModel.get(0).guess.get(index);
                                    if(chooserGrid.guessIndex === index) {
                                        if (mouse.button == Qt.LeftButton)
                                            obj.colIndex = (obj.colIndex ==
                                                            Activity.currentIndeces.length - 1) ? 0 : obj.colIndex + 1;
                                        else
                                            obj.colIndex = (obj.colIndex == 0) ?
                                                        Activity.currentIndeces.length - 1 : obj.colIndex - 1;
                                        chooserGrid.colIndex = obj.colIndex;
                                    }
                                }
                            }
                        }
                        states: State {
                            name: "scaled"; when: mouseArea.containsMouse
                            PropertyChanges {
                                currentGuess {
                                    scale: 1.1
                                }
                            }
                        }
                        transitions: Transition {
                            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
                        }
                    }
                }

                BarButton {
                    id: okButton
                    enabled: !items.buttonsBlocked
                    source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                    width: currentRow.height
                    visible: true
                    onClicked: {
                        tooltipTimer.resetTimer();
                        chooserTimer.resetTimer();
                        Activity.checkGuess();
                    }
                }
            }
        }

        Rectangle {
            id: chooserArrow
            z: 100
            width: GCStyle.halfMargins
            height: GCStyle.halfMargins
            visible: chooser.visible
            color: chooser.color
            rotation: 45
        }

        Rectangle {
            id: chooser
            z: 100
            width: chooserGrid.width + GCStyle.halfMargins
            height: chooserGrid.height + GCStyle.halfMargins
            color: "darkgray"
            border.width: 0
            visible: false

            GridView {
                id: chooserGrid
                cellWidth: Math.min(60 * ApplicationInfo.ratio, guessColumn.guessSize * 2)
                cellHeight: cellWidth
                width: Math.ceil(count / 2) * cellWidth
                height: 2 * cellHeight
                anchors.centerIn: parent
                clip: false
                interactive: false
                verticalLayoutDirection: GridView.TopToBottom
                layoutDirection: Qt.LeftToRight
                flow: GridView.FlowLeftToRight

                property int colIndex: 0 // index of selected color
                property int guessIndex: 0 // index of target item in the row

                model: new Array()

                delegate: Item {
                    width: chooserGrid.cellWidth
                    height: chooserGrid.cellWidth

                    SearchItem {
                        id: chooserItem
                        width: parent.width * 0.9
                        height: width
                        anchors.centerIn: parent
                        border.width: index == chooserGrid.colIndex ? GCStyle.midBorder : 1
                        border.color: GCStyle.darkBorder
                        highlightSymbol: index == chooserGrid.colIndex
                        searchItemIndex: modelData
                    }

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        enabled: chooser.visible && !items.buttonsBlocked
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserGrid.colIndex = chooserItem.searchItemIndex;
                            var obj = items.guessModel.get(0);
                            obj.guess.setProperty(chooserGrid.guessIndex, "colIndex", chooserGrid.colIndex);
                            chooserTimer.resetTimer();
                        }
                    }
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        ListModel {
            id: guessModel
            dynamicRoles: true
        }

        ListView {
            id: guessColumn
            anchors.left: currentWrapper.left
            anchors.right: currentWrapper.right
            anchors.top: parent.top
            anchors.bottom: currentWrapper.top
            anchors.bottomMargin: GCStyle.halfMargins
            boundsBehavior: Flickable.DragOverBounds
            verticalLayoutDirection: ListView.BottomToTop

            readonly property int guessSize: Math.min(45 * ApplicationInfo.ratio, width * 0.6 / currentRepeater.model.count - GCStyle.halfMargins)

            spacing: GCStyle.halfMargins

            displaced: Transition {
                NumberAnimation { easing.type: Easing.OutCubic; properties: "y"; duration: 300 }
            }

            model: guessModel

            delegate: Row {
                id: guessRow
                width: guessColumn.width
                height: guessColumn.guessSize
                spacing: GCStyle.halfMargins
                property int rowIndex: index
                visible: index != 0

                Item {
                    id: guessRowSpacer
                    width: (guessColumn.width - guessRepeater.width) * 0.4
                    height: parent.height
                }

                Repeater {
                    id: guessRepeater
                    width: (guessColumn.guessSize + GCStyle.halfMargins) * model.count
                    model: guess

                    delegate: Item { // wrapper needed for singleGuessStatusRect's opacity
                        id: singleGuessWrapper

                        width: guessColumn.guessSize
                        height: guessColumn.guessSize

                        Rectangle {
                            id: singleGuessStatusRect
                            border.width: GCStyle.thinnestBorder
                            border.color: (status == Activity.STATUS_CORRECT) ? "white" : "black";
                            anchors.fill: parent
                            color: (status == Activity.STATUS_CORRECT) ? "black" : "white";
                            opacity: (status == Activity.STATUS_UNKNOWN) ? 0 : 1

                            MouseArea {
                                id: mouseAreaRect
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                enabled: guessRow.rowIndex > 0 && !items.buttonsBlocked
                                hoverEnabled: ApplicationInfo.isMobile ? false : true

                                property int guessStatus: status

                                onEntered: {
                                    tooltipTimer.mouseAreaRect = mouseAreaRect;
                                    tooltipTimer.restart();
                                }

                                onExited: {
                                    tooltipTimer.resetTimer();
                                }

                                onClicked: showTooltip(true, status, mouseAreaRect);
                                onDoubleClicked: Activity.ackColor(index, colIndex);

                            }
                        }

                        SearchItem {
                            id: singleGuess
                            width: guessColumn.guessSize * 0.9
                            height: width
                            anchors.centerIn: parent
                            border.width: GCStyle.thinnestBorder
                            border.color: GCStyle.darkBorder
                            searchItemIndex: colIndex
                            opacity: 1.0

                            Image {
                                id: okImage
                                visible: isAcked
                                width: parent.width * 0.5
                                height: width
                                anchors.centerIn: parent
                                source: "qrc:/gcompris/src/core/resource/apply.svg"
                            }

                            MouseArea {
                                id: ackMouseArea
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                enabled: status == Activity.STATUS_UNKNOWN && !bonus.isPlaying
                                visible: status == Activity.STATUS_UNKNOWN
                                hoverEnabled: ApplicationInfo.isMobile ? false : true
                                onDoubleClicked: Activity.ackColor(index, colIndex);
                            }
                        }
                    }
                }

                Item {
                    id: guessRowSpacer2
                    width: GCStyle.halfMargins
                    height: guessColumn.guessSize
                }

                Column {
                    id: guessResultColumn

                    width: guessColumn.width - guessRowSpacer.width - guessRepeater.width - GCStyle.halfMargins
                    height: guessColumn.guessSize
                    spacing: GCStyle.tinyMargins

                    readonly property int resultSize: Math.min(GCStyle.baseMargins,
                                                            guessResultColumn.width / currentRepeater.count - guessResultColumn.spacing)

                    Item {
                        id: guessResultColSpacer
                        width: guessResultColumn.width
                        height: (guessResultColumn.height - 2 * (guessResultColumn.resultSize)) * 0.5
                    }

                    Row {
                        id: guessResultCorrectRow

                        width: guessResultColumn.width
                        height: guessResultColumn.resultSize
                        spacing: GCStyle.tinyMargins

                        Repeater {
                            id: guessResultCorrectRepeater

                            model: result.correct
                            delegate: Rectangle {
                                id: singleCorrectResult

                                width: guessResultColumn.resultSize
                                height: guessResultColumn.resultSize

                                radius: width * 0.5
                                border.width: GCStyle.thinnestBorder
                                border.color: "white"
                                color: "black"
                            }
                        }
                    }

                    Row {
                        id: guessResultMisplacedRow

                        width: guessResultColumn.width
                        height: guessResultColumn.resultSize
                        spacing: GCStyle.tinyMargins

                        Repeater {
                            id: guessResultMisplacedRepeater

                            model: result.misplaced
                            delegate: Rectangle {
                                id: singleMisplacedResult

                                width: guessResultColumn.resultSize
                                height: guessResultColumn.resultSize

                                radius: width * 0.5
                                border.width: GCStyle.thinnestBorder
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
            Component.onCompleted: win.connect(activity.nextLevel)
        }

        Score {
            id: score
            anchors.bottom: undefined
            anchors.left: undefined
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            onStop: Activity.nextSubLevel()
        }
    }
}
