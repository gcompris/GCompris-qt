/* GCompris - BrushTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: brushTool
    property Item selectedMode: roundBrush // NOTE init default value on start
    property bool usePositionChanged: false
    property real fullCircle: 2 * Math.PI

    property alias roundBrush: roundBrush
    property alias fillBrush: fillBrush
    property alias airBrush: airBrush
    property alias sketchBrush: sketchBrush
    property alias sprayBrush: sprayBrush
    property alias circlesBrush: circlesBrush
    property var pattern

    onSelectedModeChanged: {
        if(tempCanvas.ctx)
            selectedMode.modeInit()
    }

    function toolInit() {
        selectedMode.modeInit()
    }

    function toolStart() {
        selectedMode.start()
    }

    function toolProcess() {
        selectedMode.process()
    }

    function toolStop() {
        selectedMode.stop()
    }

    // functions used in modes
    function midPointBtw(p1, p2) {
        return {
            x: (p1.x + p2.x) * 0.5,
            y: (p1.y + p2.y) * 0.5
        };
    }

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function defaultModeInit() {
        processTimer.interval = selectedMode.timerInterval
        tempCanvas.opacity = selectedMode.actualToolOpacity
        tempCanvas.ctx.lineCap = tempCanvas.ctx.lineJoin = "round"
        tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = items.foregroundColor
        tempCanvas.ctx.globalAlpha = 1
    }

    // default functions used in most modes
    function defaultModeStart() {
        canvasInput.currentPoint = canvasInput.savePoint()
        tempCanvas.ctx.beginPath()
        tempCanvas.ctx.arc(canvasInput.currentPoint.x, canvasInput.currentPoint.y, selectedMode.radiusSize, 0, brushTool.fullCircle)
        tempCanvas.ctx.fill()
        tempCanvas.requestPaint()
        tempCanvas.ctx.moveTo(canvasInput.currentPoint.x, canvasInput.currentPoint.y)
        tempCanvas.ctx.beginPath()
    }

    // Using quadraticCurveTo using midPoint instead of simple lineTo avoids broken/angular curves on fast lines, especially on mobile.
    function defaultModeProcess() {
        var newPoint = canvasInput.savePoint()
        if(canvasInput.currentPoint.x == newPoint.x && canvasInput.currentPoint.y == newPoint.y) {
            return
        }
        canvasInput.lastPoint = canvasInput.currentPoint
        canvasInput.currentPoint = canvasInput.savePoint()
        canvasInput.midPoint = midPointBtw(canvasInput.lastPoint, canvasInput.currentPoint)
        tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height)
        tempCanvas.ctx.quadraticCurveTo(canvasInput.lastPoint.x, canvasInput.lastPoint.y, canvasInput.midPoint.x, canvasInput.midPoint.y)
        tempCanvas.ctx.stroke()
        tempCanvas.requestPaint()
    }

    function defaultModeStop() {
        processTimer.stop()
        canvasInput.resetPoints()
        tempCanvas.paintActionFinished()
    }

    // All brush presets, one item for each
    Item {
        id: roundBrush
        // note: toolSize range between 1 and 100
        // NOTE: if changing values, don't forget to also change initial values in BrushToolSettings !!!
        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 5
        property int defaultToolSize: 5
        property int minToolSize: 1
        property int maxToolSize: 100
        property int sizeSliderStepSize: 1
        property real radiusSize: actualToolSize * 0.5
        property int timerInterval: 15 * (items.eraserMode ? eraserSmoothing : toolSmoothing)
        property int toolPattern: 0
        property int defaultToolPattern: 0
        // TODO for later, try to make a less laggy smoothing method...
        property int toolSmoothing: 2
        property int defaultToolSmoothing: 2

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 10
        property int defaultEraserSize: 10
        property int eraserPattern: 0
        property int defaultEraserPattern: 0
        // TODO for later, try to make a less laggy smoothing method...
        property int eraserSmoothing: 2
        property int defaultEraserSmoothing: 2

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio
        property int actualPattern: items.eraserMode ? eraserPattern : toolPattern

        function modeInit() {
            tempCanvas.ctx.lineWidth = actualToolSize
            brushTool.defaultModeInit()
            if(actualPattern > 0) {
                brushTool.pattern = tempCanvas.ctx.createPattern(items.foregroundColor, items.patternList[selectedMode.actualPattern])
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = brushTool.pattern
            }
        }

        function start() {
            brushTool.defaultModeStart()
            processTimer.restart()
        }

        function process() {
            brushTool.defaultModeProcess()
        }

        function stop() {
            brushTool.defaultModeStop()
        }
    }

    Item {
        id: fillBrush
        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 1
        property int defaultToolSize: 1
        property int minToolSize: 1
        property int maxToolSize: 5
        property int sizeSliderStepSize: 1
        property real radiusSize: toolSize * 0.5
        property int timerInterval: 15 * (items.eraserMode ? toolSmoothing : eraserSmoothing)
        property int toolPattern: 0
        property int defaultToolPattern: 0
        // TODO for later, try to make a less laggy smoothing method...
        property int toolSmoothing: 2
        property int defaultToolSmoothing: 2

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 1
        property int defaultEraserSize: 1
        property int eraserPattern: 0
        property int defaultEraserPattern: 0
        // TODO for later, try to make a less laggy smoothing method...
        property int eraserSmoothing: 2
        property int defaultEraserSmoothing: 2

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio
        property int actualPattern: items.eraserMode ? eraserPattern : toolPattern

        function modeInit() {
            tempCanvas.ctx.lineWidth = actualToolSize
            brushTool.defaultModeInit()
            if(actualPattern > 0) {
                brushTool.pattern = tempCanvas.ctx.createPattern(items.foregroundColor, items.patternList[selectedMode.actualPattern])
            }
        }

        function start() {
            brushTool.defaultModeStart()
            processTimer.restart()
        }

        function process() {
            brushTool.defaultModeProcess()
        }

        function stop() {
            if(actualPattern > 0) {
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = brushTool.pattern
                tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height)
                tempCanvas.ctx.stroke()
                tempCanvas.ctx.fill()
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = items.foregroundColor
            } else {
                tempCanvas.ctx.fill()
            }
            tempCanvas.requestPaint()
            brushTool.defaultModeStop()
        }
    }

    Item {
        id: airBrush
        // note: toolSize range between 10 and 300
        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 150
        property int defaultToolSize: 150
        property int minToolSize: 10
        property int maxToolSize: 300
        property int sizeSliderStepSize: 10
        property real radiusSize: actualToolSize * 0.5
        property int timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 10
        property int defaultToolSpeed: 10
        property real density: (items.eraserMode ? eraserDensity : toolDensity) * 0.1
        property int toolDensity: 5
        property int defaultToolDensity: 5

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 150
        property int defaultEraserSize: 150
        property int eraserSpeed: 10
        property int defaultEraserSpeed: 10
        property int eraserDensity: 10
        property int defaultEraserDensity: 10

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio

        function drawRadialGradient() {
            var newPoint = canvasInput.savePoint()
            if(canvasInput.currentPoint.x == newPoint.x && canvasInput.currentPoint.y == newPoint.y) {
                return
            }
            canvasInput.currentPoint = newPoint
            var gradient = tempCanvas.ctx.createRadialGradient(canvasInput.currentPoint.x, canvasInput.currentPoint.y, 1, canvasInput.currentPoint.x,                                                                       canvasInput.currentPoint.y, radiusSize)
            gradient.addColorStop(0, items.colorStop1)
            gradient.addColorStop(1, items.colorStop2)
            tempCanvas.ctx.fillStyle = gradient;
            tempCanvas.ctx.fillRect(canvasInput.currentPoint.x - radiusSize, canvasInput.currentPoint.y - radiusSize, actualToolSize, actualToolSize)
            tempCanvas.requestPaint()
        }

        function modeInit() {
            brushTool.defaultModeInit()
            processTimer.interval = timerInterval
            items.colorStop1 = items.foregroundColor
            items.colorStop1.a = density
            items.colorStop2 = items.foregroundColor
            items.colorStop2.a = 0
        }

        function start() {
            drawRadialGradient();
            processTimer.restart()
        }

        function process() {
            drawRadialGradient();
        }

        function stop() {
            brushTool.defaultModeStop()
        }
    }

    Item {
        id: sketchBrush
        // note: toolSize range between 1 and 10
        property var connectedPoints: []
        property int distance: 1000 * actualToolSize

        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 2
        property int defaultToolSize: 2
        property int minToolSize: 1
        property int maxToolSize: 10
        property int sizeSliderStepSize: 1
        property real radiusSize: actualToolSize * 0.5
        property int timerInterval: 15
        // NOTE: don't go below 0.05, else it can produce huge color deviations with accumulations...
        property real density: (items.eraserMode ? eraserDensity : toolDensity) * 0.05
        property int toolDensity: 5
        property int defaultToolDensity: 5

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 2
        property int defaultEraserSize: 2
        property int eraserDensity: 10
        property int defaultEraserDensity: 10

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio

        function modeInit() {
            tempCanvas.ctx.lineWidth = actualToolSize
            brushTool.defaultModeInit()
            tempCanvas.ctx.globalAlpha = density
            connectedPoints = []
        }

        function start() {
            brushTool.defaultModeStart()
            connectedPoints.push(canvasInput.savePoint())
            processTimer.restart()
        }

        /*
         * Sketch Brush concept based on Harmony project https://github.com/mrdoob/harmony/
         */

        function process() {
            var newPoint = canvasInput.savePoint()

            // make sure there is at least one point in connectedPoints...
            if(connectedPoints.length == 0) {
                connectedPoints.push(newPoint)
                return
            }

            if(newPoint.x == connectedPoints[connectedPoints.length - 1].x && newPoint.y == connectedPoints[connectedPoints.length - 1].y ) {
                return
            }

            connectedPoints.push(newPoint)

            var p1 = connectedPoints[connectedPoints.length - 1]
            var p2 = connectedPoints[connectedPoints.length - 2]

            if(!p1 || !p2) {
                return
            }

            tempCanvas.ctx.beginPath();
            tempCanvas.ctx.moveTo(p2.x, p2.y);
            tempCanvas.ctx.lineTo(p1.x, p1.y);
            tempCanvas.ctx.stroke();

            for (var i = 0; i < connectedPoints.length; i++)
            {
                var dx = connectedPoints[i].x - p1.x;
                var dy = connectedPoints[i].y - p1.y;
                var d = dx * dx + dy * dy;

                if (d < 4000 && Math.random() > (d / 2000))
                {
                    tempCanvas.ctx.beginPath();
                    tempCanvas.ctx.moveTo( p1.x + (dx * 0.3), p1.y + (dy * 0.3));
                    tempCanvas.ctx.lineTo( connectedPoints[i].x - (dx * 0.3), connectedPoints[i].y - (dy * 0.3));
                    tempCanvas.ctx.stroke();
                }
            }

            tempCanvas.requestPaint()
        }

        function stop() {
            connectedPoints = []
            brushTool.defaultModeStop()
        }
    }

    Item {
        id: sprayBrush
        // settings: brush size, opacity, speed, circles (dots) size
        // note: toolSize range between 10 and 300 (actual radius is * 2...)
        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 150
        property int defaultToolSize: 150
        property int minToolSize: 10
        property int maxToolSize: 300
        property int sizeSliderStepSize: 10
        property real radiusSize: actualToolSize * 0.5
        property int timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 3
        property int defaultToolSpeed: 3
        property int dotsSize: 3
        property int defaultDotsSize: 3

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 150
        property int defaultEraserSize: 150
        property int eraserSpeed: 3
        property int defaultEraserSpeed: 3
        property int eraserDotsSize: 3
        property int defaultEraserDotsSize: 3

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio
        property real actualDotsSize: (items.eraserMode ? eraserDotsSize : dotsSize) / items.devicePixelRatio

        property int numberOfParticles: (actualToolSize * actualToolSize) / 100
        property real dotsRadius: actualDotsSize * 0.5
        property real pixelSize: 1 / items.devicePixelRatio
        property real toolSizeSquare: Math.pow(actualToolSize, 2)

        function sprayPixels() {
            canvasInput.currentPoint = canvasInput.savePoint()
            for(var i = numberOfParticles; i--; i > 0) {
                var radius = actualToolSize
                var offsetX = brushTool.getRandomInt(-radius, radius);
                var offsetY = brushTool.getRandomInt(-radius, radius);
                if(Math.pow(offsetX, 2) + Math.pow(offsetY, 2) <= toolSizeSquare) {
                    tempCanvas.ctx.fillRect(canvasInput.currentPoint.x + offsetX, canvasInput.currentPoint.y + offsetY, pixelSize, pixelSize);
                }
            }
            tempCanvas.requestPaint()
        }

        function sprayCircles() {
            canvasInput.currentPoint = canvasInput.savePoint()
            tempCanvas.ctx.beginPath()
            for(var i = numberOfParticles; i--; i > 0) {
                var radius = actualToolSize
                var offsetX = brushTool.getRandomInt(-radius, radius);
                var offsetY = brushTool.getRandomInt(-radius, radius);
                if(Math.pow(offsetX, 2) + Math.pow(offsetY, 2) <= toolSizeSquare) {
                    tempCanvas.ctx.roundedRect(canvasInput.currentPoint.x + offsetX, canvasInput.currentPoint.y + offsetY, actualDotsSize, actualDotsSize, dotsRadius, dotsRadius);
                }
            }
            tempCanvas.ctx.fill()
            tempCanvas.requestPaint()
        }

        function modeInit() {
            brushTool.defaultModeInit()
            processTimer.interval = timerInterval
        }

        function start() {
            process()
            processTimer.restart()
        }

        function process() {
            if(actualDotsSize > 1){
                sprayCircles()
            } else {
                sprayPixels()
            }
        }

        function stop() {
            brushTool.defaultModeStop()
        }
    }

    Item {
        id: circlesBrush
        // note: toolSize range between 5 and 150
        property real toolOpacity: 0.5
        property real defaultToolOpacity: 0.5
        property int toolSize: 50
        property int defaultToolSize: 50
        property int minToolSize: 5
        property int maxToolSize: 150
        property int sizeSliderStepSize: 5
        property real radiusSize: actualToolSize * 0.5
        property int timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 10
        property int defaultToolSpeed: 10

        // eraserMode
        property real eraserOpacity: 1
        property real defaultEraserOpacity: 1
        property int eraserSize: 50
        property int defaultEraserSize: 50
        property int eraserSpeed: 10
        property int defaultEraserSpeed: 10

        property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
        property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio

        function drawCircle() {
            canvasInput.currentPoint = canvasInput.savePoint()
            tempCanvas.ctx.beginPath()
            tempCanvas.ctx.arc(canvasInput.currentPoint.x, canvasInput.currentPoint.y, radiusSize, 0, brushTool.fullCircle)
            tempCanvas.ctx.fill()
            tempCanvas.ctx.stroke()
            tempCanvas.requestPaint()
        }

        function modeInit() {
            tempCanvas.ctx.lineWidth = 1.5 / items.devicePixelRatio
            processTimer.interval = timerInterval
            tempCanvas.ctx.lineCap = tempCanvas.ctx.lineJoin = "round"
            tempCanvas.ctx.strokeStyle = Qt.rgba(1,1,1,1)
            tempCanvas.ctx.fillStyle = items.foregroundColor
            tempCanvas.ctx.globalAlpha = actualToolOpacity
            tempCanvas.opacity = selectedMode.actualToolOpacity
        }

        function start() {
            processTimer.restart()
        }

        function process() {
            drawCircle()
        }

        function stop() {
            brushTool.defaultModeStop()
        }
    }
}
