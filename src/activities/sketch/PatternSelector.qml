/* GCompris - PatternSelector.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Item {
    id: patternSelector
    // NOTE: don't forget to set width when using it...
    // There's a bug in Qt 6.7.3 where only setting a relative value for the height makes this Item block the activity loading...
    // Using a Math.max binding (and calling requestPaint on buttonCanvas onHeightChanged) seems to workaround the problem.
    height: Math.max(10, toolsPanel.settingsDoubleLineHeight)
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

    Row {
        width: parent.width
        height: parent.height
        spacing: items.baseMargins

        Item {
            id: leftButton
            height: parent.height
            width: height * 0.5
            Image {
                id: leftButtonIcon
                anchors.fill: parent
                source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
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
            width: patternSelector.width - patternSelector.height - items.baseMargins * 2
            height: parent.height
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            highlight: Rectangle {
                height: leftButton.height
                width: height
                color: "transparent"
                border.color: items.contentColor
                border.width: 2 * ApplicationInfo.ratio
                x: patternListView.currentItem.x
                y: patternListView.currentItem.y
            }
            highlightFollowsCurrentItem: false
            clip: true
            model: items.patternList
            delegate: Item {
                height: patternListView.height
                width: height
                Canvas {
                    id: buttonCanvas
                    anchors.fill: parent
                    anchors.margins: items.baseMargins
                    onPaint: {
                        var ctx = getContext("2d");
                        var pattern = ctx.createPattern(Qt.rgba(1,1,1,0.5), items.patternList[index]);
                        ctx.fillStyle = pattern;
                        ctx.fillRect(0, 0, width, height);
                    }
                    onHeightChanged: requestPaint();
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        patternSelector.selectPattern(index);
                    }
                }
            }
            onCurrentIndexChanged: {
                positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }

        Item {
            id: rightButton
            height: parent.height
            width: height * 0.5
            Image {
                id: rightButtonIcon
                anchors.fill: parent
                source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
                mirror: true
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
