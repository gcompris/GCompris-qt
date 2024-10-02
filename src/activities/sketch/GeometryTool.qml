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
    property bool usePositionChanged: true

    property alias rectangleMode: rectangleMode
    property alias squareMode: squareMode
    property alias ovalMode: ovalMode
    property alias circleMode: circleMode
    property alias freeLineMode: freeLineMode
    property alias hortoLineMode: hortoLineMode

    //: Rectangle or Square radius size
    property string radiusString: qsTr("Rounded Corners")

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

    function defaultStart() {
        canvasInput.lastPoint = canvasInput.savePoint();
        geometryShape.x = canvasInput.lastPoint.x;
        geometryShape.y = canvasInput.lastPoint.y;
        geometryShape.width = 0;
        geometryShape.height = 0;
        geometryShape.visible = true;
    }

    function defaultProcess() {
        canvasInput.currentPoint = canvasInput.savePoint();
        geometryShape.width = Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x);
        geometryShape.height = Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y);
        if(canvasInput.lastPoint.x < canvasInput.currentPoint.x) {
            geometryShape.x = canvasInput.lastPoint.x;
        } else {
            geometryShape.x = canvasInput.currentPoint.x;
        }
        if(canvasInput.lastPoint.y < canvasInput.currentPoint.y) {
            geometryShape.y = canvasInput.lastPoint.y;
        } else {
            geometryShape.y = canvasInput.currentPoint.y;
        }
    }

    Item {
        id: rectangleMode
        property real toolOpacity: 1
        property real defaultToolOpacity: 1
        property int toolRadius: 0
        property int defaultToolRadius: 0
        property int maxToolRadius: 100
        property int toolRotation: 0
        property int defaultToolRotation: 0
        property int maxToolRotation: 180
        property int rotationSliderStepSize: 5

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart();
        }

        function process() {
            geometryTool.defaultProcess();
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }


    Item {
        id: squareMode
        property real toolOpacity: 1
        property real defaultToolOpacity: 1
        property int toolRadius: 0
        property int defaultToolRadius: 0
        property int maxToolRadius: 100
        property int toolRotation: 0
        property int defaultToolRotation: 0
        property int maxToolRotation: 180
        property int rotationSliderStepSize: 5

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart();
        }

        function process() {
            canvasInput.currentPoint = canvasInput.savePoint();

            var squareSize = Math.min(Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x),
                                      Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y));

            geometryShape.width = geometryShape.height = squareSize;
            if(canvasInput.lastPoint.x < canvasInput.currentPoint.x) {
                geometryShape.x = canvasInput.lastPoint.x;
            } else {
                geometryShape.x = canvasInput.lastPoint.x - squareSize;
            }
            if(canvasInput.lastPoint.y < canvasInput.currentPoint.y) {
                geometryShape.y = canvasInput.lastPoint.y;
            } else {
                geometryShape.y = canvasInput.lastPoint.y - squareSize;
            }
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }


    Item {
        id: ovalMode
        property real toolOpacity: 1
        property real defaultToolOpacity: 1
        property int toolRotation: 0
        property int defaultToolRotation: 0
        property int maxToolRotation: 180
        property int rotationSliderStepSize: 5

        function modeInit() {
            tempCanvas.opacity = selectedMode.toolOpacity;
            ovalShape.rotation = selectedMode.toolRotation;
        }

        function start() {
            canvasInput.lastPoint = canvasInput.savePoint();
            ovalShape.x = canvasInput.lastPoint.x;
            ovalShape.y = canvasInput.lastPoint.y;
            ovalShape.width = 0;
            ovalShape.height = 0;
            ovalShape.visible = true;
        }

        function process() {
            canvasInput.currentPoint = canvasInput.savePoint();
            ovalShape.width = Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x);
            ovalShape.height = Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y);
            if(canvasInput.lastPoint.x < canvasInput.currentPoint.x) {
                ovalShape.x = canvasInput.lastPoint.x;
            } else {
                ovalShape.x = canvasInput.currentPoint.x;
            }
            if(canvasInput.lastPoint.y < canvasInput.currentPoint.y) {
                ovalShape.y = canvasInput.lastPoint.y;
            } else {
                ovalShape.y = canvasInput.currentPoint.y;
            }
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }

    Item {
        id: circleMode
        property real toolOpacity: 1
        property real defaultToolOpacity: 1
        property int radius: 0

        function modeInit() {
            geometryTool.defaultModeInit();
        }

        function start() {
            geometryTool.defaultStart();
        }

        function process() {
            canvasInput.currentPoint = canvasInput.savePoint();

            var squareSize = Math.min(Math.abs(canvasInput.lastPoint.x - canvasInput.currentPoint.x),
                                      Math.abs(canvasInput.lastPoint.y - canvasInput.currentPoint.y));

            geometryShape.width = geometryShape.height = squareSize;
            if(canvasInput.lastPoint.x < canvasInput.currentPoint.x) {
                geometryShape.x = canvasInput.lastPoint.x;
            } else {
                geometryShape.x = canvasInput.lastPoint.x - squareSize;
            }
            if(canvasInput.lastPoint.y < canvasInput.currentPoint.y) {
                geometryShape.y = canvasInput.lastPoint.y;
            } else {
                geometryShape.y = canvasInput.lastPoint.y - squareSize;
            }
            geometryShape.radius = squareSize * 0.5;
        }

        function stop() {
            tempCanvas.paintActionFinished();
        }
    }

    Item {
        id: freeLineMode
        property real toolOpacity: 1
        property real defaultToolOpacity: 1
        property int toolSize: 2
        property int defaultToolSize: 2
        property int minToolSize: 1
        property int maxToolSize: 100
        property int sizeSliderStepSize: 1
        property real actualToolSize: toolSize / items.devicePixelRatio

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
        property real defaultToolOpacity: 1
        property int toolSize: 2
        property int defaultToolSize: 2
        property int minToolSize: 1
        property int maxToolSize: 100
        property int sizeSliderStepSize: 1
        property real actualToolSize: toolSize / items.devicePixelRatio

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
