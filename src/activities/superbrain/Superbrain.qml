/* GCompris - Superbrain.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"
import "superbrain.js" as Activity
import GCompris 1.0

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.baseUrl + "background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        focus: true

        readonly property double scaleFactor: Math.max(1,
                                                       Math.min(background.width / 800,
                                                                background.height / 520))
        readonly property bool isPortrait: (height > width)

        signal start
        signal stop

        MouseArea {
            anchors.fill: parent
            onClicked: showChooser(false);
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias colorsRepeater: colorsRepeater
            property alias chooserRepeater: chooserRepeater
            property alias guessModel: guessModel
            property alias guessColumn: guessColumn
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Column {
            id: colorsColumn

            anchors.left: parent.left
            anchors.leftMargin: 65 * background.scaleFactor * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 20 * background.scaleFactor * ApplicationInfo.ratio

            spacing: 5 * background.scaleFactor * ApplicationInfo.ratio

            width: 100 * ApplicationInfo.ratio
            height: 100 * ApplicationInfo.ratio

            Repeater {
                id: colorsRepeater

                model: new Array()

                delegate: Rectangle {
                    width: 40 * background.scaleFactor * ApplicationInfo.ratio
                    height: 40 * background.scaleFactor * ApplicationInfo.ratio
                    radius: width * 0.5
                    border.width: 2
                    border.color: "white"
                    color: modelData
                }
            }
        }

        Rectangle {
            id: tooltipRect
            width: 100
            height: tooltipText.font.pixelSize + 10
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
                fontSize: NaN
                font.pixelSize: 11 * ApplicationInfo.ratio
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
            showChooser(false);
            if (!visible || status === Activity.STATUS_UNKNOWN) {
                tooltipRect.opacity = 0;
                return;
            }

            var obj = background.mapFromItem(mouseArea, mouseArea.mouseX, mouseArea.mouseY);

            if (status === Activity.STATUS_CORRECT)
                tooltipRect.text = qsTr("This item is well placed");
            if (status === Activity.STATUS_MISPLACED)
                tooltipRect.text = qsTr("This item is misplaced");
            tooltipRect.x = obj.x - 5 - tooltipRect.width;
            tooltipRect.y = obj.y - 5 - tooltipRect.height;
            tooltipRect.opacity = 0.9;
        }

        Column {
            id: chooserColumn

            property int colIndex: 0
            property int guessIndex: 0
            spacing: 0
            opacity: 0
            visible: false

            Timer {
                id: chooserTimer
                interval: 2000
                onTriggered: showChooser(false);
            }

            Repeater {
                id: chooserRepeater

                model: new Array()

                delegate: Rectangle {
                    width: guessColumn.guessSize * 1.6
                    height: guessColumn.guessSize / 2
                    radius: 4 //width * 0.5
                    border.width: index == chooserColumn.colIndex ? 3 : 0
                    border.color: "white"
                    color: modelData

                    MouseArea {
                        id: chooserMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        z: 3
                        hoverEnabled: ApplicationInfo.isMobile ? false : true

                        onClicked: {
                            chooserColumn.colIndex = index;
                            var obj = items.guessModel.get(0);
                            obj.guess.setProperty(chooserColumn.guessIndex, "colIndex", chooserColumn.colIndex);
                            showChooser(false);
                        }
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        function showChooser(visible, guessIndex, item)
        {
            if (!visible) {
                chooserTimer.stop();
                chooserColumn.opacity = 0;
                return;
            }

            var modelObj = guessModel.get(0).guess.get(guessIndex);
            var obj = background.mapFromItem(item, item.x, item.y);
            chooserColumn.colIndex = modelObj.colIndex;
            chooserColumn.guessIndex = guessIndex;
            chooserColumn.x = obj.x - 0.4 * guessColumn.guessSize;
            chooserColumn.y = obj.y - chooserRepeater.count * guessColumn.guessSize / 2 - guessColumn.guessSize * 0.15;
            chooserColumn.opacity = 0.9;
            chooserColumn.visible = true;
            chooserTimer.restart();
        }

        ListModel {
            id: guessModel
            dynamicRoles: true
        }

        Column {
            id: guessColumn

            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: background.isPortrait ? bar.top : parent.bottom
            anchors.bottomMargin: Math.min(5, background.height - height - (background.isPortrait ? bar.height : 0))

            readonly property int guessSize: 30 * background.scaleFactor * ApplicationInfo.ratio
            readonly property int vertSpacing: 15 * background.scaleFactor * ApplicationInfo.ratio
            readonly property int horizSpacing: 15 * background.scaleFactor * ApplicationInfo.ratio
            readonly property int statusMargin: 5 * background.scaleFactor * ApplicationInfo.ratio
            readonly property int resultSize: 10 * background.scaleFactor * ApplicationInfo.ratio
            readonly property int guessColWidth: Activity.maxPieces * (guessSize + (2 * guessColumn.statusMargin))
                                                 + (Activity.maxPieces-1) * horizSpacing;
            readonly property int resultColWidth: Activity.maxPieces * resultSize
                                                  + (Activity.maxPieces-1) * 2;

            spacing: vertSpacing

            width: guessColWidth + 10 + (2 * horizSpacing) + resultColWidth
            height: guessColRepeater.count * (guessSize + vertSpacing)

            Repeater {
                id: guessColRepeater

                model: guessModel

                delegate: Row {
                    id: guessRow
                    width: guessColumn.width
                    height: guessColumn.guessSize
                    spacing: guessColumn.horizSpacing
                    property int rowIndex: index

                    Item {
                        id: guessRowSpacer
                        width: guessColumn.guessColWidth - (guessRepeater.count * (guessColumn.guessSize + (2 * guessColumn.statusMargin) + guessColumn.horizSpacing))
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
                                    enabled: guessRow.rowIndex > 0
                                    z: 4
                                    hoverEnabled: ApplicationInfo.isMobile ? false : true

                                    Timer {
                                        id: tooltipTimer
                                        repeat: false
                                        interval: 300

                                        onTriggered: showTooltip(true, status, mouseAreaRect)
                                    }

                                    onEntered: tooltipTimer.restart()

                                    onExited: {
                                        tooltipTimer.stop()
                                        showTooltip(false)
                                    }

                                    onClicked: showTooltip(true, status, mouseAreaRect)  // for mobile
                                }
                            }

                            Rectangle {
                                id: singleGuess

                                width: guessColumn.guessSize
                                height: guessColumn.guessSize
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.leftMargin: guessColumn.statusMargin
                                anchors.topMargin: guessColumn.statusMargin

                                radius: width * 0.5
                                border.width: 2
                                border.color: "lightgray"
                                color: Activity.colors[colIndex]
                                opacity: 1.0
                                z: 2

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    enabled: guessRow.rowIndex == 0
                                    visible: guessRow.rowIndex == 0  // note, need to set invisible or it will cover the tooltip MouseArea
                                    z: 3
                                    hoverEnabled: ApplicationInfo.isMobile ? false : true

                                    onPressAndHold: {
                                        if (guessColRepeater.count > 1)
                                            guessRepeater.model.get(index).colIndex = guessModel.get(1).guess.get(index).colIndex;
                                    }

                                    onClicked: {
                                        var obj = guessRepeater.model.get(index);
                                        if (mouse.button == Qt.LeftButton)
                                            obj.colIndex = (obj.colIndex == Activity.currentColors.length - 1) ? 0 : obj.colIndex + 1;
                                        else
                                            obj.colIndex = (obj.colIndex == 0) ? Activity.currentColors.length - 1 : obj.colIndex - 1;
                                        showChooser(true, index, parent);
                                    }
                                }
                            }

                            states: State {
                                name: "scaled"; when: mouseArea.containsMouse
                                PropertyChanges {
                                    target: singleGuessWrapper
                                    scale: 1.3
                                }
                            }

                            transitions: Transition {
                                NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
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
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 66 * bar.barZoom
            visible: true
            anchors {
                bottom: parent.bottom
                bottomMargin: 0.3 * parent.height
                right: guessColumn.left
                rightMargin: 10
            }
            onClicked: {
                showChooser(false);
                Activity.checkGuess();
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score

            anchors.bottom: bar.top
            anchors.bottomMargin: 30 * ApplicationInfo.ratio
            anchors.left: background.left
            anchors.leftMargin: 10
            anchors.top: undefined
            anchors.right: undefined
        }
    }

}
