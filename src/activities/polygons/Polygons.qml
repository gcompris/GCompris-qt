/* GCompris - Polygons.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import core 1.0
import "../../core"
import "polygons.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property string mode: "tutorial"
            property bool isTutorialMode: mode === "tutorial" ? true : false
            property alias tutorialDataset: tutorialDataset
            property alias tutorialInstruction: tutorialInstruction
            property alias tutorialImage: tutorialImage
            property alias instruction: instructionPanel.textItem
            property bool buttonsBlocked: true
            property alias bonus: bonus

            // Properties to check answer
            property list<real> polygonAngles: []
            property list<real> polygonSides: []

            // Pen and color properties
            readonly property color gridColor: "#b3b3b3"
            readonly property color polygonColor: "#10721d"
            readonly property color dotColor: "#5020a8dd"
            readonly property color lastDotColor: "#50dda820"
            // View properties
            readonly property int mainSize: Math.min(layoutArea.width, layoutArea.height)
            readonly property int gridStep: mainSize / 10
            readonly property int gridSize: gridStep * 10
            readonly property real dotOffset: 0.5 * gridStep
            readonly property real minDrag: -dotOffset
            readonly property real maxDrag: gridSize - dotOffset
            property alias points: points
            property alias sceneGrid: sceneGrid
            property alias canvasContainer: canvasContainer
            property bool isClosed: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [tutorialInstruction]

        Keys.onPressed: (event) => {
            if((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && okButton.enabled) {
                Activity.checkAnswer()
            }
        }

        TutorialDataset {
            id: tutorialDataset
        }

        IntroMessage {
            id: tutorialInstruction
            intro: ListModel {}
            customIntroArea: introArea
            useGrayedBg: false
            z: 100
        }

        Image {
            id: tutorialImage
            anchors {
                top: introArea.bottom
                bottom: layoutArea.bottom
                left: layoutArea.left
                right: layoutArea.right
                margins: GCStyle.baseMargins
            }
            sourceSize.width: Math.min(width, height)
            fillMode: Image.PreserveAspectFit
            visible: tutorialInstruction.visible
            z: 100
        }

        Item {
            id: introArea
            anchors.top: parent.top
            anchors.right: layoutArea.right
            anchors.left: layoutArea.left
            anchors.bottom: layoutArea.verticalCenter
            anchors.topMargin: GCStyle.baseMargins
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.3
            anchors.topMargin: items.isTutorialMode ? instructionPanel.height + GCStyle.baseMargins : GCStyle.baseMargins
        }

        Rectangle {
            id: canvasContainer
            anchors.centerIn: layoutArea
            width: items.gridSize
            height: items.gridSize
            color: "#FFFFFF"
            visible: !tutorialInstruction.visible

            ListModel {
                id: points
            }

            Canvas {
                id: sceneGrid
                anchors.fill: parent
                clip: false

                onPaint: {
                    var ctx = getContext("2d")
                    if (ctx === null) {
                        return
                    }
                    // Draw the grid
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = items.gridColor
                    ctx.lineWidth = GCStyle.thinnestBorder
                    ctx.beginPath()
                    var nrows = 10
                    for(var i = 1; i < nrows; i++){   // Draw grid rows, skipping first and last ones
                        ctx.moveTo(0, (items.gridStep * i))
                        ctx.lineTo(width, (items.gridStep * i))
                    }

                    var ncols = 10 // Draw grid columns, skipping first and last ones
                    for(var j = 1; j < ncols; j++) {
                        ctx.moveTo((items.gridStep * j), 0)
                        ctx.lineTo((items.gridStep * j), height)
                    }
                    ctx.closePath()
                    ctx.stroke()

                    // Draw the existing shapes
                    if(points.count < 1) {
                        return
                    }
                    ctx.beginPath()
                    var lastPoint = points.get(0)
                    ctx.moveTo(lastPoint.x * items.gridStep, lastPoint.y * items.gridStep)
                    for(var i = 1; i < points.count; ++ i) {
                        var point = points.get(i);
                        ctx.lineTo(point.x * items.gridStep, point.y * items.gridStep)
                        lastPoint = point
                    }
                    ctx.strokeStyle = items.polygonColor
                    ctx.lineWidth = GCStyle.midBorder
                    ctx.stroke()
                }
                onWidthChanged: sceneGrid.requestPaint()
                onHeightChanged: sceneGrid.requestPaint()

                MouseArea {
                    id: mouseArea
                    width: parent.width
                    height: parent.height
                    hoverEnabled: true
                    enabled: !items.isClosed && !items.buttonsBlocked

                    onClicked: (mouse) => {
                        mouse.accpeted = true;
                        var point = {
                            "x": Math.round(mouse.x / items.gridStep),
                            "y": Math.round(mouse.y / items.gridStep)
                        }
                        points.append(point);
                        sceneGrid.requestPaint();
                    }
                }
            }

            // DO NOT put points inside the Canvas, else their MouseArea are clipped by its boundaries
            Repeater {
                model: points
                delegate: Rectangle {
                    id: pointItem
                    color: (index === points.count - 1 && !items.isClosed) ?
                        items.lastDotColor : items.dotColor
                    width: items.gridStep
                    height: items.gridStep
                    radius: width
                    x: (model.x - 0.5) * items.gridStep
                    y: (model.y - 0.5) * items.gridStep
                    visible: (index === 0 && items.isClosed) ? false : true

                    readonly property real centerX: x + items.dotOffset
                    readonly property real centerY: y + items.dotOffset

                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent
                        drag.minimumX: items.minDrag
                        drag.minimumY: items.minDrag
                        drag.maximumX: items.maxDrag
                        drag.maximumY: items.maxDrag
                        enabled: !items.buttonsBlocked

                        onClicked: (mouse)=> {
                            mouse.accepted = true;
                            // simple click on first or last point closes the shape if at least 3 points already placed
                            if(!items.isClosed && points.count > 2 &&
                                (index === 0 || index === points.count - 1)) {
                                var point = {
                                    "x": points.get(0).x,
                                    "y": points.get(0).y
                                };
                                points.append(point);
                                sceneGrid.requestPaint();
                                items.isClosed = true;
                            }
                        }

                        onDoubleClicked: (mouse)=> {
                            mouse.accepted = true;
                            // logic must be done outside the item, else it breaks as soon as the point is deleted.
                            Activity.deletePoint(index);
                        }

                        onPositionChanged: (movedPosition)=> {
                            const newPointX = Math.round(pointItem.centerX / items.gridStep);
                            const newPointY = Math.round(pointItem.centerY / items.gridStep);

                            var hasChanged = false;
                            if(newPointX != model.x) {
                                points.setProperty(index, "x", newPointX);
                                hasChanged = true;
                            }
                            if(newPointY != model.y) {
                                points.setProperty(index, "y", newPointY);
                                hasChanged = true;
                            }
                            if(hasChanged) {
                                // move first point too if needed
                                if(items.isClosed && index === points.count - 1) {
                                    points.setProperty(0, "x", newPointX);
                                    points.setProperty(0, "y", newPointY);
                                }
                                sceneGrid.requestPaint();
                            }
                        }

                        onPressed: {
                            // break the binding while dragging
                            pointItem.x = pointItem.x;
                            pointItem.y = pointItem.y;
                        }

                        onReleased: {
                            // restore the binding after dragging
                            pointItem.x = Qt.binding(function() { return (model.x - 0.5) * items.gridStep });
                            pointItem.y = Qt.binding(function() { return (model.y - 0.5) * items.gridStep });
                        }
                    }
                }
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.halfMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
            visible: items.isTutorialMode && !tutorialInstruction.visible && items.instruction != ""
        }

        BarButton {
            id: okButton
            visible: items.isTutorialMode && items.isClosed
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: GCStyle.baseMargins
                bottomMargin: height * 0.5
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            enabled: visible && !items.buttonsBlocked
            onClicked: Activity.checkAnswer();
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | (items.isTutorialMode ? level : 0) | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.resetShape()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
            onLoose: items.buttonsBlocked = false
        }
    }

}
