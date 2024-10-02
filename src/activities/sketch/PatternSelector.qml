/* GCompris - PatternSelector.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: patternSelector
    // NOTE: don't forget to set width and height when using it...
    property real controlsHeight: 10
    property alias value: patternListView.currentIndex

    signal patternClicked()

    function selectPreviousPattern() {
        if(patternListView.currentIndex == 0) {
            return;
        }
        selectPattern(patternListView.currentIndex - 1);
    }

    function selectNextPattern() {
        if(patternListView.currentIndex == patternListView.count - 1) {
            return;
        }
        selectPattern(patternListView.currentIndex + 1);
    }

    function selectPattern(index) {
        if(index == value) {
            return;
        }
        patternListView.currentIndex = index;
        patternClicked();
    }

    onWidthChanged: {
        patternListView.positionViewAtIndex(patternListView.currentIndex, ListView.Contain);
    }

    Component {
        id: patternItem
        Item {
            height: leftButton.height
            width: height

            Canvas {
                id: buttonCanvas
                height: leftButton.height - items.baseMargins * 2
                width: height
                anchors.centerIn: parent
                onPaint: {
                    var ctx = getContext("2d");
                    var pattern = ctx.createPattern(Qt.rgba(1,1,1,0.5), items.patternList[index]);
                    ctx.fillStyle = pattern;
                    ctx.fillRect(0, 0, width, height);
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    patternSelector.selectPattern(index);
                }
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            height: leftButton.height
            width: height
            color: "transparent"
            border.color: items.contentColor
            border.width: 2 * ApplicationInfo.ratio
            x: patternListView.currentItem.x
            y: patternListView.currentItem.y
        }
    }

    Column {
        GCText {
            id: patternLabel
            text: "Pattern"
            color: items.contentColor
            width: patternSelector.width
            height: patternSelector.controlsHeight
            fontSize: regularSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignBottom
        }

        Row {
            spacing: items.baseMargins

            Item {
                id: leftButton
                height: patternSelector.controlsHeight * 2
                width: height * 0.5

                Image {
                    id: leftButtonIcon
                    anchors.fill: parent
                    source: "qrc:/gcompris/src/activities/sketch/resource/empty.svg"
                    sourceSize.width: width
                    sourceSize.height: height
                    opacity: patternListView.currentIndex == 0 ? 0.5 : 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: leftButtonIcon.scale = 0.9
                    onReleased: leftButtonIcon.scale = 1
                    enabled: leftButtonIcon.opacity == 1
                    onClicked: {
                        patternSelector.selectPreviousPattern();
                    }
                }
            }

            ListView {
                id: patternListView
                width: patternSelector.width - leftButton.width - rightButton.width - items.baseMargins * 2
                height: leftButton.height
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                highlight: highlight
                highlightFollowsCurrentItem: false
                clip: true
                model: items.patternList
                delegate: patternItem
                onCurrentIndexChanged: {
                    positionViewAtIndex(currentIndex, ListView.Contain);
                }
            }

            Item {
                id: rightButton
                height: leftButton.height
                width: height * 0.5

                Image {
                    id: rightButtonIcon
                    anchors.fill: parent
                    source: "qrc:/gcompris/src/activities/sketch/resource/empty.svg"
                    sourceSize.width: width
                    sourceSize.height: height
                    opacity: patternListView.currentIndex == patternListView.count - 1 ? 0.5 : 1
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: rightButtonIcon.scale = 0.9
                    onReleased: rightButtonIcon.scale = 1
                    enabled: rightButtonIcon.opacity == 1
                    onClicked: {
                        patternSelector.selectNextPattern();
                    }
                }
            }
        }
    }
}
