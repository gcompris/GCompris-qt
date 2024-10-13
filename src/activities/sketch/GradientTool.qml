/* GCompris - GradientTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

// NOTE: Gradients are not made using Canvas, as they can have a glitch where the center of radial gradients has a random transparent hole.
// Using gradients on a Shape instead is more stable.

Item {
    id: gradientTool
    property Item selectedMode: linearGradient // NOTE init default value on start
    readonly property bool usePositionChanged: true

    property alias linearGradient: linearGradient
    property alias radialGradient: radialGradient
    property alias invertedRadialGradient: invertedRadialGradient

    readonly property string radiusString: qsTr("Inner Circle Size")

    onSelectedModeChanged: {
        if(tempCanvas.ctx)
            toolInit();
    }

    function drawLinearGradient() {
        linearGradientFill.x2 = canvasInput.currentPoint.x;
        linearGradientFill.y2 = canvasInput.currentPoint.y;
    }

    function drawRadialGradient() {
        var outsideRadius = Math.sqrt(Math.pow(canvasInput.currentPoint.x - canvasInput.lastPoint.x, 2) +
                                            Math.pow(canvasInput.currentPoint.y - canvasInput.lastPoint.y, 2));
        radialGradientFill.centerRadius = outsideRadius;
    }

    function toolInit() {
        items.outlineCursorRadius = 0;
        tempCanvas.opacity = selectedMode.toolOpacity;
        tempCanvas.ctx.lineCap = tempCanvas.ctx.lineJoin = "round";
        tempCanvas.ctx.strokeStyle = Qt.rgba(0.5,0.5,0.5,0.5);
        tempCanvas.ctx.lineWidth = 2 / items.devicePixelRatio;
        tempCanvas.ctx.globalAlpha = 1;
        items.colorStop1 = items.colorStop2 = items.foregroundColor;
        items.colorStop2.a = 0
        if(gradientTool.selectedMode == invertedRadialGradient) {
            radialGradientFill.isInverted = true;
        } else {
            radialGradientFill.isInverted = false;
        }
    }

    function toolStart() {
        canvasInput.lastPoint = canvasInput.savePoint();
        if(gradientTool.selectedMode == linearGradient) {
            linearGradientFill.x1 = linearGradientFill.x2 = canvasInput.lastPoint.x;
            linearGradientFill.y1 = linearGradientFill.y2 = canvasInput.lastPoint.y;
            gradientShapePath.fillGradient = linearGradientFill;
        } else {
            radialGradientFill.centerX = canvasInput.lastPoint.x;
            radialGradientFill.centerY = canvasInput.lastPoint.y;
            radialGradientFill.focalRadius = selectedMode.toolRadius / items.devicePixelRatio;
            radialGradientFill.centerRadius = selectedMode.toolRadius / items.devicePixelRatio;
            gradientShapePath.fillGradient = radialGradientFill;
        }
    }

    function toolProcess() {
        var newPoint = canvasInput.savePoint();
        if(canvasInput.currentPoint.x == newPoint.x && canvasInput.currentPoint.y == newPoint.y) {
            return;
        }
        canvasInput.currentPoint = newPoint;
        tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);
        if(selectedMode.isLinear) {
            drawLinearGradient();
        } else {
            drawRadialGradient();
        }
        tempCanvas.ctx.beginPath();
        tempCanvas.ctx.moveTo(canvasInput.lastPoint.x, canvasInput.lastPoint.y);
        tempCanvas.ctx.lineTo(canvasInput.currentPoint.x, canvasInput.currentPoint.y);
        tempCanvas.ctx.stroke();
        tempCanvas.requestPaint();
        gradientShape.visible = true;
    }

    function toolStop() {
        tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);
        tempCanvas.requestPaint();
        canvasInput.resetPoints();
        tempCanvas.paintActionFinished();
    }

    Item {
        id: linearGradient
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1

        property bool isLinear: true

        function modeInit() {
            gradientTool.defaultModeInit();
        }

        function start() {
            gradientTool.defaultModeStart();
        }

        function process() {
            gradientTool.defaultModeProcess();
        }

        function stop() {
            gradientTool.defaultModeStop();
        }

    }

    Item {
        id: radialGradient
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolRadius: 0
        readonly property int defaultToolRadius: 0
        readonly property int maxToolRadius: 300

        function modeInit() {
            gradientTool.defaultModeInit();
        }

        function start() {
            gradientTool.defaultModeStart();
        }

        function process() {
            gradientTool.defaultModeProcess();
        }

        function stop() {
            gradientTool.defaultModeStop();
        }
    }

    Item {
        id: invertedRadialGradient
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolRadius: 0
        readonly property int defaultToolRadius: 0
        readonly property int maxToolRadius: 300

        function modeInit() {
            gradientTool.defaultModeInit();
        }

        function start() {
            gradientTool.defaultModeStart();
        }

        function process() {
            gradientTool.defaultModeProcess();
        }

        function stop() {
            gradientTool.defaultModeStop();
        }
    }

}
