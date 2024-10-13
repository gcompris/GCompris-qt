/* GCompris - GeometryTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: geometryTool
    property Item selectedMode: rectangleMode // NOTE init default value on start
    readonly property bool usePositionChanged: true

    property alias rectangleMode: rectangleMode
    property alias squareMode: squareMode
    property alias ovalMode: ovalMode
    property alias circleMode: circleMode
    property alias freeLineMode: freeLineMode
    property alias hortoLineMode: hortoLineMode

    //: Rectangle or Square radius size
    readonly property string radiusString: qsTr("Rounded Corners")

    onSelectedModeChanged: {
        if(tempCanvas.ctx)
            selectedMode.modeInit();
    }

    function toolInit() {
        items.outlineCursorRadius = 0;
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

    function defaultModeInit() {
        tempCanvas.opacity = selectedMode.toolOpacity;
        geometryShape.radius = selectedMode.toolRadius / items.devicePixelRatio;
        geometryShape.rotation = selectedMode.toolRotation ? selectedMode.toolRotation : 0;
    }

    function defaultStart(shape) {
        canvasInput.lastPoint = canvasInput.savePoint();
        shape.x = canvasInput.lastPoint.x;
        shape.y = canvasInput.lastPoint.y;
        shape.width = 0;
        shape.height = 0;
        shape.visible = true;
    }

    function rectangleProcess(shape) {
        canvasInput.currentPoint = canvasInput.savePoint();
        shape.width = Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x) * 2;
        shape.height = Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y) * 2;
        shape.x = canvasInput.lastPoint.x - shape.width * 0.5;
        shape.y = canvasInput.lastPoint.y - shape.height * 0.5;
    }

    function squareProcess(isCircle = false) {
        canvasInput.currentPoint = canvasInput.savePoint();
        var squareHalf = Math.min(Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x),
                                  Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y));

        geometryShape.width = geometryShape.height = squareHalf * 2;
        geometryShape.x = canvasInput.lastPoint.x - geometryShape.width * 0.5;
        geometryShape.y = canvasInput.lastPoint.y - geometryShape.height * 0.5;
        if(isCircle) {
            geometryShape.radius = squareHalf
        }
    }

    Item {
        id: rectangleMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolRadius: 0
        readonly property int defaultToolRadius: 0
        readonly property int maxToolRadius: 100
        property int toolRotation: 0
        readonly property int defaultToolRotation: 0
        readonly property int maxToolRotation: 180
        readonly property int rotationSliderStepSize: 5

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart(geometryShape);
        }

        function process() {
            geometryTool.rectangleProcess(geometryShape)
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }


    Item {
        id: squareMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolRadius: 0
        readonly property int defaultToolRadius: 0
        readonly property int maxToolRadius: 100
        property int toolRotation: 0
        readonly property int defaultToolRotation: 0
        readonly property int maxToolRotation: 180
        readonly property int rotationSliderStepSize: 5

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart(geometryShape);
        }

        function process() {
            geometryTool.squareProcess();
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }


    Item {
        id: ovalMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolRotation: 0
        readonly property int defaultToolRotation: 0
        readonly property int maxToolRotation: 180
        readonly property int rotationSliderStepSize: 5

        function modeInit() {
            tempCanvas.opacity = selectedMode.toolOpacity;
            ovalShape.rotation = selectedMode.toolRotation;
        }

        function start() {
            geometryTool.defaultStart(ovalShape);
        }

        function process() {
            geometryTool.rectangleProcess(ovalShape);
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }

    Item {
        id: circleMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int radius: 0

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart(geometryShape);
        }

        function process() {
            geometryTool.squareProcess(true);
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }

    Item {
        id: freeLineMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolSize: 2
        readonly property int defaultToolSize: 2
        readonly property int minToolSize: 1
        readonly property int maxToolSize: 100
        readonly property int sizeSliderStepSize: 1
        readonly property real actualToolSize: toolSize / items.devicePixelRatio

        function modeInit() {
            tempCanvas.opacity = selectedMode.toolOpacity;
            lineShapePath.strokeWidth = actualToolSize;
        }

        function start() {
            canvasInput.lastPoint = canvasInput.savePoint();
            lineShapePath.startX = canvasInput.lastPoint.x;
            lineShapePath.startY = canvasInput.lastPoint.y;
            lineShapeEnd.x = canvasInput.lastPoint.x;
            lineShapeEnd.y = canvasInput.lastPoint.y;
            lineShape.visible = true;
        }

        function process() {
            canvasInput.currentPoint = canvasInput.savePoint();
            lineShapeEnd.x = canvasInput.currentPoint.x;
            lineShapeEnd.y = canvasInput.currentPoint.y;
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }

    Item {
        id: hortoLineMode
        property real toolOpacity: 1
        readonly property real defaultToolOpacity: 1
        property int toolSize: 2
        readonly property int defaultToolSize: 2
        readonly property int minToolSize: 1
        readonly property int maxToolSize: 100
        readonly property int sizeSliderStepSize: 1
        readonly property real actualToolSize: toolSize / items.devicePixelRatio

        function modeInit() {
            tempCanvas.opacity = selectedMode.toolOpacity;
            lineShapePath.strokeWidth = actualToolSize;
        }

        function start() {
            canvasInput.lastPoint = canvasInput.savePoint();
            lineShapePath.startX = canvasInput.lastPoint.x;
            lineShapePath.startY = canvasInput.lastPoint.y;
            lineShapeEnd.x = canvasInput.lastPoint.x;
            lineShapeEnd.y = canvasInput.lastPoint.y;
            lineShape.visible = true;
        }

        function process() {
            canvasInput.currentPoint = canvasInput.savePoint();
            var boxWidth = Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x);
            var boxHeight = Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y);
            if(boxWidth > boxHeight) {
                lineShapeEnd.x = canvasInput.currentPoint.x;
                lineShapeEnd.y = canvasInput.lastPoint.y;
            } else {
                lineShapeEnd.x = canvasInput.lastPoint.x;
                lineShapeEnd.y = canvasInput.currentPoint.y;
            }
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }
}
