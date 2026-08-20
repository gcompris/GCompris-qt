/* GCompris - shapes.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Shapes

import "../../core"
import "shapes.js" as Activity

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
                clip: true
                scale: items.viewSize / items.mainSize

                property color gridColor: "black"
                property color lineColor: "yellow"

                onPaint: {
                    var ctx = getContext("2d")
                    if (ctx === null) {
                        return
                    }
                    // Draw the grid
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = gridColor
                    ctx.lineWidth = canvasContainer.scale / 3
                    const scaledGridStep = items.gridStep / scale
                    ctx.beginPath()
                    var nrows = height / scaledGridStep
                    var offsetY = (height / 2) % scaledGridStep
                    // fixed values used in for loops
                    var xInit = 0
                    var yInit = 0
                    for(var i = 0; i < nrows+1; i++){   // Draw dotted rows
                        ctx.moveTo(xInit, (scaledGridStep * i) + yInit)
                        ctx.lineTo(width, (scaledGridStep * i) + yInit)
                    }

                    var ncols = width / scaledGridStep  // Draw dotted columns
                    var offsetX = (width / 2) % scaledGridStep
                    xInit = 0
                    yInit = 0
                    for(var j = 0; j < ncols+1; j++) {
                        ctx.moveTo((scaledGridStep * j) + xInit, yInit)
                        ctx.lineTo((scaledGridStep * j) + xInit, height)
                    }

                    ctx.closePath()
                    ctx.stroke()

                    // Draw the existing shapes
                    ctx.beginPath()
                    var lastPoint = points.get(0)
                    for(var i = 1; i < points.count; ++ i) {
                        var point = points.get(i);
                        ctx.moveTo(lastPoint.x * scaledGridStep, lastPoint.y * scaledGridStep)
                        ctx.lineTo(point.x * scaledGridStep, point.y * scaledGridStep)
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

                    onClicked: (mouse) => {
                        var point = {
                            "x": Math.round((items.viewSize*mouse.x) / (items.gridStep*items.mainSize)),
                            "y": Math.round((items.viewSize*mouse.y) / (items.gridStep*items.mainSize))
                        }
                        points.append(point)
                        sceneGrid.requestPaint()
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
