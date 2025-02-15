/* GCompris - BrushTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

Item {
    id: brushTool
    property Item selectedMode: roundBrush // NOTE init default value on start
    readonly property bool usePositionChanged: false
    readonly property real fullCircle: 2 * Math.PI

    property alias roundBrush: roundBrush
    property alias fillBrush: fillBrush
    property alias airBrush: airBrush
    property alias sketchBrush: sketchBrush
    property alias sprayBrush: sprayBrush
    property alias circlesBrush: circlesBrush
    property var pattern

    onSelectedModeChanged: {
        if(tempCanvas.ctx)
            selectedMode.modeInit();
    }

    function toolInit() {
        selectedMode.modeInit();
    }

    function toolStart() {
        selectedMode.start();
    }

    function toolProcess() {
        selectedMode.process();
    }

    function toolStop() {
        selectedMode.stop();
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

    // functions for brush smoothing (adapted from https://lazybrush.dulnan.net/)
    function ease(x) {
        return 1 - Math.sqrt(1 - x * x);
    }

    function equalsTo(pointA, pointB) {
        return pointA.x === pointB.x && pointA.y === pointB.y;
    }

    function getDifferenceTo(pointA, pointB) {
        return { x: pointA.x - pointB.x, y: pointA.y - pointB.y };
    }

    function getDistanceTo(pointA, pointB) {
        var diff = getDifferenceTo(pointA, pointB);
        return Math.sqrt(diff.x * diff.x + diff.y * diff.y);
    }

    function getAngleTo(pointA, pointB) {
        var diff = getDifferenceTo(pointA, pointB);
        return Math.atan2(diff.y, diff.x);
    }

    function moveByAngle(origin, angle, distance, friction) {
        // Rotate the angle based on the coordinate system ([0,0] in the top left)
        const angleRotated = angle + Math.PI * 0.5;
        var x = origin.x + Math.sin(angleRotated) * distance * ease(1 - friction);
        var y = origin.y - Math.cos(angleRotated) * distance * ease(1 - friction);
        return { x: x, y: y };
    }

    // Using quadraticCurveTo using midPoint instead of simple lineTo avoids broken/angular curves on fast lines, especially on mobile.
    function smoothedProcess() {
        var newPoint = canvasInput.savePoint();
        // if there's smoothing, check if it's outside smoothingRadius
        if(selectedMode.smoothingRadius > 0) {
            var distance = getDistanceTo(newPoint, canvasInput.midPoint);
            var isOutside =  Math.round((distance - selectedMode.smoothingRadius) * 10) / 10 > 0;
            if(isOutside){
                var angle = getAngleTo(newPoint, canvasInput.midPoint);
                canvasInput.lastPoint = canvasInput.currentPoint;
                canvasInput.currentPoint = brushTool.moveByAngle(
                    canvasInput.midPoint,
                    angle,
                    distance - selectedMode.smoothingRadius,
                    selectedMode.smoothingFriction
                )
            } else {
                return;
            }
        } else {
            if(equalsTo(newPoint, canvasInput.currentPoint)) {
                return;
            }
            canvasInput.lastPoint = canvasInput.currentPoint;
            canvasInput.currentPoint = newPoint;
        }
        canvasInput.midPoint = midPointBtw(canvasInput.lastPoint, canvasInput.currentPoint);
        tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);
        tempCanvas.ctx.quadraticCurveTo(canvasInput.lastPoint.x, canvasInput.lastPoint.y, canvasInput.midPoint.x, canvasInput.midPoint.y);
        tempCanvas.ctx.stroke();
        tempCanvas.requestPaint();
    }
    //

    function defaultModeInit() {
        processTimer.interval = selectedMode.timerInterval;
        tempCanvas.opacity = selectedMode.actualToolOpacity;
        tempCanvas.ctx.lineCap = tempCanvas.ctx.lineJoin = "round";
        tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = items.foregroundColor;
        tempCanvas.ctx.globalAlpha = 1;
    }

    // default functions used in most modes
    function defaultModeStart() {
        canvasInput.currentPoint = canvasInput.lastPoint = canvasInput.midPoint = canvasInput.savePoint();
        tempCanvas.ctx.beginPath();
        tempCanvas.ctx.arc(canvasInput.currentPoint.x, canvasInput.currentPoint.y, selectedMode.radiusSize, 0, brushTool.fullCircle);
        tempCanvas.ctx.fill();
        tempCanvas.requestPaint();
        tempCanvas.ctx.moveTo(canvasInput.currentPoint.x, canvasInput.currentPoint.y);
        tempCanvas.ctx.beginPath();
    }

    function defaultModeStop() {
        processTimer.stop();
        canvasInput.resetPoints();
        tempCanvas.paintActionFinished();
    }

    // All brush presets, one item for each
    AbstractBrush {
        id: roundBrush
        // note: toolSize range between 1 and 100
        // NOTE: if changing values, don't forget to also change initial values in BrushToolSettings !!!
        toolSize: 5
        defaultToolSize: 5
        minToolSize: 1
        maxToolSize: 100
        sizeSliderStepSize: 1
        timerInterval: 15
        property int toolPattern: 0
        readonly property int defaultToolPattern: 0
        // on mobile, the smoothing can actually make it worse, so better set it to 0 by default there...
        property int toolSmoothing: ApplicationInfo.isMobile ? 0 : 1
        readonly property int defaultToolSmoothing: ApplicationInfo.isMobile ? 0 : 1

        // eraserMode
        eraserSize: 10
        defaultEraserSize: 10
        property int eraserPattern: 0
        readonly property int defaultEraserPattern: 0
        property int eraserSmoothing: ApplicationInfo.isMobile ? 0 : 1
        readonly property int defaultEraserSmoothing: ApplicationInfo.isMobile ? 0 : 1

        readonly property int smoothingRadius: (items.eraserMode ? eraserSmoothing : toolSmoothing) * 5
        readonly property real smoothingFriction: 0.05
        readonly property int actualPattern: items.eraserMode ? eraserPattern : toolPattern

        function modeInit() {
            items.outlineCursorRadius = Math.max(smoothingRadius, radiusSize);
            tempCanvas.ctx.lineWidth = actualToolSize;
            brushTool.defaultModeInit();
            if(actualPattern > 0) {
                brushTool.pattern = tempCanvas.ctx.createPattern(items.foregroundColor, items.patternList[selectedMode.actualPattern]);
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = brushTool.pattern;
            }
        }

        function start() {
            brushTool.defaultModeStart();
            processTimer.restart();
        }

        function process() {
            brushTool.smoothedProcess();

        }

        function stop() {
            brushTool.defaultModeStop();
        }
    }

    AbstractBrush {
        id: fillBrush
        toolSize: 1
        defaultToolSize: 1
        minToolSize: 1
        maxToolSize: 5
        sizeSliderStepSize: 1
        timerInterval: 15
        property int toolPattern: 0
        readonly property int defaultToolPattern: 0
        property int toolSmoothing: ApplicationInfo.isMobile ? 0 : 1
        readonly property int defaultToolSmoothing: ApplicationInfo.isMobile ? 0 : 1

        // eraserMode
        eraserSize: 1
        defaultEraserSize: 1
        property int eraserPattern: 0
        readonly property int defaultEraserPattern: 0
        property int eraserSmoothing: ApplicationInfo.isMobile ? 0 : 1
        readonly property int defaultEraserSmoothing: ApplicationInfo.isMobile ? 0 : 1

        readonly property int smoothingRadius: (items.eraserMode ? eraserSmoothing : toolSmoothing) * 5
        readonly property real smoothingFriction: 0.05
        readonly property int actualPattern: items.eraserMode ? eraserPattern : toolPattern

        function modeInit() {
            items.outlineCursorRadius = Math.max(smoothingRadius, radiusSize);
            tempCanvas.ctx.lineWidth = actualToolSize;
            brushTool.defaultModeInit();
            if(actualPattern > 0) {
                brushTool.pattern = tempCanvas.ctx.createPattern(items.foregroundColor, items.patternList[selectedMode.actualPattern]);
            }
        }

        function start() {
            brushTool.defaultModeStart();
            processTimer.restart();
        }

        function process() {
            brushTool.smoothedProcess();
        }

        function stop() {
            if(actualPattern > 0) {
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = brushTool.pattern;
                tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);
                tempCanvas.ctx.stroke();
                tempCanvas.ctx.fill();
                tempCanvas.ctx.strokeStyle = tempCanvas.ctx.fillStyle = items.foregroundColor;
            } else {
                tempCanvas.ctx.fill();
            }
            tempCanvas.requestPaint();
            brushTool.defaultModeStop();
        }
    }

    AbstractBrush {
        id: airBrush
        // note: toolSize range between 10 and 300
        toolSize: 150
        defaultToolSize: 150
        minToolSize: 10
        maxToolSize: 300
        sizeSliderStepSize: 10
        readonly property int timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 10
        readonly property int defaultToolSpeed: 10
        readonly property real density: (items.eraserMode ? eraserDensity : toolDensity) * 0.1
        property int toolDensity: 5
        readonly property int defaultToolDensity: 5

        // eraserMode
        eraserSize: 150
        defaultEraserSize: 150
        property int eraserSpeed: 10
        readonly property int defaultEraserSpeed: 10
        property int eraserDensity: 10
        readonly property int defaultEraserDensity: 10

        function drawRadialGradient() {
            var newPoint = canvasInput.savePoint();
            if(brushTool.equalsTo(canvasInput.currentPoint, newPoint)) {
                return;
            }
            canvasInput.currentPoint = newPoint;
            var gradient = tempCanvas.ctx.createRadialGradient(canvasInput.currentPoint.x,
                                                               canvasInput.currentPoint.y, 1,
                                                               canvasInput.currentPoint.x,
                                                               canvasInput.currentPoint.y, radiusSize);
            gradient.addColorStop(0, items.colorStop1);
            gradient.addColorStop(1, items.colorStop2);
            tempCanvas.ctx.fillStyle = gradient;
            tempCanvas.ctx.fillRect(canvasInput.currentPoint.x - radiusSize,
                                    canvasInput.currentPoint.y - radiusSize,
                                    actualToolSize, actualToolSize);
            tempCanvas.requestPaint();
        }

        function modeInit() {
            items.outlineCursorRadius = radiusSize
            brushTool.defaultModeInit();
            processTimer.interval = timerInterval;
            items.colorStop1 = items.foregroundColor;
            items.colorStop1.a = density;
            items.colorStop2 = items.foregroundColor;
            items.colorStop2.a = 0;
        }

        function start() {
            drawRadialGradient();
            processTimer.restart();
        }

        function process() {
            drawRadialGradient();
        }

        function stop() {
            brushTool.defaultModeStop();
        }
    }

    AbstractBrush {
        id: sketchBrush
        // note: toolSize range between 1 and 10
        property var connectedPoints: []
        property int distance: 1000 * actualToolSize

        toolSize: 2
        defaultToolSize: 2
        minToolSize: 1
        maxToolSize: 10
        sizeSliderStepSize: 1
        timerInterval: 15
        // NOTE: don't go below 0.05, else it can produce huge color deviations with accumulations...
        readonly property real density: (items.eraserMode ? eraserDensity : toolDensity) * 0.05
        property int toolDensity: 5
        readonly property int defaultToolDensity: 5

        // eraserMode
        eraserSize: 2
        defaultEraserSize: 2
        property int eraserDensity: 10
        readonly property int defaultEraserDensity: 10

        function modeInit() {
            items.outlineCursorRadius = radiusSize
            tempCanvas.ctx.lineWidth = actualToolSize;
            brushTool.defaultModeInit();
            tempCanvas.ctx.globalAlpha = density;
            connectedPoints = [];
        }

        function start() {
            brushTool.defaultModeStart();
            connectedPoints.push(canvasInput.savePoint());
            processTimer.restart();
        }

         // Sketch Brush concept based on Harmony project https://mrdoob.com/projects/harmony/
        function process() {
            var newPoint = canvasInput.savePoint();
            // make sure there is at least one point in connectedPoints...
            if(connectedPoints.length == 0) {
                connectedPoints.push(newPoint);
                return;
            }

            if(brushTool.equalsTo(newPoint, connectedPoints[connectedPoints.length - 1])) {
                return;
            }

            connectedPoints.push(newPoint);
            var p1 = connectedPoints[connectedPoints.length - 1];
            var p2 = connectedPoints[connectedPoints.length - 2];
            if(!p1 || !p2) {
                return;
            }

            tempCanvas.ctx.beginPath();
            tempCanvas.ctx.moveTo(p2.x, p2.y);
            tempCanvas.ctx.lineTo(p1.x, p1.y);
            tempCanvas.ctx.stroke();

            for(var i = 0; i < connectedPoints.length; i++) {
                var dx = connectedPoints[i].x - p1.x;
                var dy = connectedPoints[i].y - p1.y;
                var d = dx * dx + dy * dy;

                if(d < 4000 && Math.random() > (d / 2000)) {
                    tempCanvas.ctx.beginPath();
                    tempCanvas.ctx.moveTo( p1.x + (dx * 0.3), p1.y + (dy * 0.3));
                    tempCanvas.ctx.lineTo( connectedPoints[i].x - (dx * 0.3), connectedPoints[i].y - (dy * 0.3));
                    tempCanvas.ctx.stroke();
                }
            }

            tempCanvas.requestPaint();
        }

        function stop() {
            connectedPoints = [];
            brushTool.defaultModeStop();
        }
    }

    AbstractBrush {
        id: sprayBrush
        // settings: brush size, opacity, speed, circles (dots) size
        // note: toolSize range between 10 and 300 (actual radius is * 2...)
        toolSize: 150
        defaultToolSize: 150
        minToolSize: 10
        maxToolSize: 300
        sizeSliderStepSize: 10
        timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 3
        readonly property int defaultToolSpeed: 3
        property int toolDensity: 10
        readonly property int defaultToolDensity: 10
        property int dotsSize: 3
        readonly property int defaultDotsSize: 3

        // eraserMode
        eraserSize: 150
        defaultEraserSize: 150
        property int eraserSpeed: 3
        readonly property int defaultEraserSpeed: 3
        property int eraserDensity: 10
        readonly property int defaultEraserDensity: 10
        property int eraserDotsSize: 3
        readonly property int defaultEraserDotsSize: 3

        readonly property real actualDotsSize: (items.eraserMode ? eraserDotsSize : dotsSize) / items.devicePixelRatio
        readonly property int actualDensity: items.erasermode ? eraserDensity : toolDensity

        readonly property int numberOfParticles: Math.max(1, (actualToolSize * actualToolSize) * 0.001) * actualDensity
        readonly property real dotsRadius: actualDotsSize * 0.5
        readonly property real pixelSize: 1 / items.devicePixelRatio
        readonly property real toolSizeSquare: actualToolSize * actualToolSize

        function sprayPixels() {
            canvasInput.currentPoint = canvasInput.savePoint();
            for(var i = numberOfParticles; i--; i > 0) {
                var radius = actualToolSize;
                var offsetX = brushTool.getRandomInt(-radius, radius);
                var offsetY = brushTool.getRandomInt(-radius, radius);
                if(offsetX * offsetX + offsetY * offsetY <= toolSizeSquare) {
                    tempCanvas.ctx.fillRect(canvasInput.currentPoint.x + offsetX, canvasInput.currentPoint.y + offsetY, pixelSize, pixelSize);
                }
            }
            tempCanvas.requestPaint();
        }

        function sprayCircles() {
            canvasInput.currentPoint = canvasInput.savePoint();
            tempCanvas.ctx.beginPath();
            for(var i = numberOfParticles; i--; i > 0) {
                var radius = actualToolSize;
                var offsetX = brushTool.getRandomInt(-radius, radius);
                var offsetY = brushTool.getRandomInt(-radius, radius);
                if(offsetX * offsetX + offsetY * offsetY <= toolSizeSquare) {
                    tempCanvas.ctx.roundedRect(canvasInput.currentPoint.x + offsetX,
                                               canvasInput.currentPoint.y + offsetY,
                                               actualDotsSize, actualDotsSize,
                                               dotsRadius, dotsRadius);
                }
            }
            tempCanvas.ctx.fill();
            tempCanvas.requestPaint();
        }

        function modeInit() {
            items.outlineCursorRadius = actualToolSize
            brushTool.defaultModeInit();
            processTimer.interval = timerInterval;
        }

        function start() {
            process();
            processTimer.restart();
        }

        function process() {
            if(actualDotsSize > 1){
                sprayCircles();
            } else {
                sprayPixels();
            }
        }

        function stop() {
            brushTool.defaultModeStop();
        }
    }

    AbstractBrush {
        id: circlesBrush
        // note: toolSize range between 5 and 150
        toolSize: 50
        defaultToolSize: 50
        minToolSize: 5
        maxToolSize: 150
        sizeSliderStepSize: 5
        readonly property int timerInterval: 300 / (items.eraserMode ? eraserSpeed : toolSpeed)
        property int toolSpeed: 3
        readonly property int defaultToolSpeed: 3

        // eraserMode
        eraserSize: 50
        defaultEraserSize: 50
        property int eraserSpeed: 3
        readonly property int defaultEraserSpeed: 3

        function drawCircle() {
            canvasInput.currentPoint = canvasInput.savePoint();
            tempCanvas.ctx.beginPath();
            tempCanvas.ctx.arc(canvasInput.currentPoint.x, canvasInput.currentPoint.y, radiusSize, 0, brushTool.fullCircle);
            tempCanvas.ctx.fill();
            tempCanvas.ctx.stroke();
            tempCanvas.requestPaint();
        }

        function modeInit() {
            items.outlineCursorRadius = radiusSize
            tempCanvas.ctx.lineWidth = 1.5 / items.devicePixelRatio;
            processTimer.interval = timerInterval;
            tempCanvas.ctx.lineCap = tempCanvas.ctx.lineJoin = "round";
            tempCanvas.ctx.strokeStyle = Qt.rgba(1,1,1,1);
            tempCanvas.ctx.fillStyle = items.foregroundColor;
            tempCanvas.ctx.globalAlpha = actualToolOpacity;
            tempCanvas.opacity = selectedMode.actualToolOpacity;
        }

        function start() {
            processTimer.restart();
        }

        function process() {
            drawCircle();
        }

        function stop() {
            brushTool.defaultModeStop();
        }
    }
}
