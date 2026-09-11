/* GCompris - Polygons.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "polygons.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias bonus: bonus

            // Pen and color properties
            readonly property string transparentColor: "#00000000"
            readonly property color contentColor: "#d2d2d2"
            property string backgroundColor: "#ffffff"
            // View properties
            property real mainSize: Math.min(canvasZone.width, canvasZone.height)
            property real viewSize: 100
            readonly property real devicePixelRatio: Math.max(1, Screen.devicePixelRatio)
            property int gridStep: 10
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
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Item {  // useful to compute view size. canvasContainer is scaled
            id: canvasZone
            anchors.fill: canvasContainer
        }

        Item {
            id: canvasContainer
            anchors.fill: layoutArea
            scale: items.mainSize / items.viewSize

            ListModel {
                id: points
            }

            Canvas {
                id: sceneGrid
                anchors.centerIn: canvasContainer
                width: items.viewSize * canvasContainer.scale
                height: width
                clip: false
                scale: items.viewSize / items.mainSize
                readonly property real scaledGridStep: items.gridStep / scale
                readonly property real dotOffset: 0.5 * scaledGridStep

                property color gridColor: "black"
                property color lineColor: "green"

                onPaint: {
                    var ctx = getContext("2d")
                    if (ctx === null) {
                        return
                    }
                    // Draw the grid
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = gridColor
                    ctx.lineWidth = canvasContainer.scale / 3
                    ctx.beginPath()
                    var nrows = height / sceneGrid.scaledGridStep
                    var offsetY = (height / 2) % sceneGrid.scaledGridStep
                    // fixed values used in for loops
                    var xInit = 0
                    var yInit = 0
                    for(var i = 0; i < nrows+1; i++){   // Draw dotted rows
                        ctx.moveTo(xInit, (sceneGrid.scaledGridStep * i) + yInit)
                        ctx.lineTo(width, (sceneGrid.scaledGridStep * i) + yInit)
                    }

                    var ncols = width / sceneGrid.scaledGridStep  // Draw dotted columns
                    var offsetX = (width / 2) % sceneGrid.scaledGridStep
                    xInit = 0
                    yInit = 0
                    for(var j = 0; j < ncols+1; j++) {
                        ctx.moveTo((sceneGrid.scaledGridStep * j) + xInit, yInit)
                        ctx.lineTo((sceneGrid.scaledGridStep * j) + xInit, height)
                    }

                    ctx.closePath()
                    ctx.stroke()

                    // Draw the existing shapes
                    if(points.count < 1) {
                        return
                    }
                    ctx.beginPath()
                    var lastPoint = points.get(0)
                    ctx.moveTo(lastPoint.x * sceneGrid.scaledGridStep, lastPoint.y * sceneGrid.scaledGridStep)
                    for(var i = 1; i < points.count; ++ i) {
                        var point = points.get(i);
                        ctx.lineTo(point.x * sceneGrid.scaledGridStep, point.y * sceneGrid.scaledGridStep)
                        lastPoint = point
                    }
                    ctx.strokeStyle = lineColor
                    ctx.lineWidth = canvasContainer.scale * 1.5
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
                            "x": Math.round((items.viewSize*mouse.x) / (items.gridStep*items.mainSize)),
                            "y": Math.round((items.viewSize*mouse.y) / (items.gridStep*items.mainSize))
                        }
                        points.append(point)
                        sceneGrid.requestPaint()
                    }
                }

                Repeater {
                    model: points
                    delegate: Rectangle {
                        id: pointItem
                        color: "blue"
                        opacity: 0.5
                        width: sceneGrid.scaledGridStep
                        height: sceneGrid.scaledGridStep
                        radius: width
                        x: (model.x - 0.5) * sceneGrid.scaledGridStep
                        y: (model.y - 0.5) * sceneGrid.scaledGridStep
                        visible: (index === 0 && items.isClosed) ? false : true

                        MouseArea {
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: 0 - sceneGrid.dotOffset
                            drag.minimumY: 0 - sceneGrid.dotOffset
                            drag.maximumX: sceneGrid.width - sceneGrid.dotOffset
                            drag.maximumY: sceneGrid.height - sceneGrid.dotOffset

                            onClicked: {
                                // simple click on first point closes the shape
                                if(index === 0) {
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
                                const centerX = pointItem.x + sceneGrid.dotOffset
                                const centerY = pointItem.y + sceneGrid.dotOffset
                                const newPointX = Math.round((items.viewSize*centerX) / (items.gridStep*items.mainSize));
                                const newPointY = Math.round((items.viewSize*centerY) / (items.gridStep*items.mainSize));
                                var hasChanged = false;
                                if(newPointX != pointItem.x) {
                                    points.setProperty(index, "x", newPointX);
                                    hasChanged = true;
                                }
                                if(newPointY != pointItem.y) {
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
                                pointItem.x = Qt.binding(function() { return (model.x - 0.5) * sceneGrid.scaledGridStep });
                                pointItem.y = Qt.binding(function() { return (model.y - 0.5) * sceneGrid.scaledGridStep });
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

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.resetShape()
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
