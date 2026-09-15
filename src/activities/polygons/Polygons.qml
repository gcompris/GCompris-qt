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

import "../../core"
import "polygons.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
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
            property alias background: background
            property int currentLevel: activity.currentLevel
            property string mode: "tutorial"
            property bool isTutorialMode: mode === "tutorial" ? true : false
            property alias bonus: bonus

            // Pen and color properties
            readonly property color gridColor: "#b3b3b3"
            readonly property color polygonColor: "#10721d"
            readonly property color dotColor: "#5020a8dd"
            // View properties
            readonly property int mainSize: Math.min(layoutArea.width, layoutArea.height)
            readonly property int gridStep: mainSize / 10
            readonly property int gridSize: gridStep * 10
            readonly property real dotOffset: 0.5 * gridStep
            readonly property real minDrag: -dotOffset
            readonly property real maxDrag: gridSize - dotOffset
            property alias points: points
            property alias sceneGrid: sceneGrid
            property bool isClosed: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.5
        }

        Rectangle {
            id: canvasContainer
            anchors.centerIn: layoutArea
            width: items.gridSize
            height: items.gridSize
            color: "#FFFFFF"

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
                    enabled: !items.isClosed

                    onClicked: (mouse) => {
                        var point = {
                            "x": Math.round(mouse.x / items.gridStep),
                            "y": Math.round(mouse.y / items.gridStep)
                        }
                        points.append(point)
                        sceneGrid.requestPaint()
                    }
                }
            }

            // DO NOT put points inside the Canvas, else their MouseArea are clipped by its boundaries
            Repeater {
                model: points
                delegate: Rectangle {
                    id: pointItem
                    color: items.dotColor
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

                        onClicked: {
                            // simple click on first point closes the shape if at least 3 points already placed
                            if(index === 0 && points.count > 2) {
                                var point = {
                                    "x": model.x,
                                    "y": model.y
                                }
                                points.append(point);
                                sceneGrid.requestPaint();
                                items.isClosed = true;
                            }
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
        }
    }

}

/*
Draw the following form, a line will be drawn with the previous point.
When you reach again the first point, the figure will be finished.

Examples:
- draw a triangle
- draw a right triangle
- draw an isoceles triangle which is not a rectangle triangle
- draw a square
- draw a rectangle that is not a square
- draw a losange which is not a square
- draw a parallelogram which is not a square
- draw a pentagram
- draw an hexagon


*/
