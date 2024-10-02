/* GCompris - TextTool.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: textTool
    property alias selectedMode: textTool
    property bool usePositionChanged: true
    property string textString: ""

    property real toolOpacity: 1
    property real defaultToolOpacity: 1
    property int toolRotation: 0
    property int defaultToolRotation: 0
    property int maxToolRotation: 360
    property int rotationSliderStepSize: 15
    property int toolSize: 20
    property int defaultToolSize: 20
    property int minToolSize: 10
    property int maxToolSize: 100
    property int sizeSliderStepSize: 1


    function toolInit() {
        tempCanvas.opacity = 1;
        textShape.text = textString;
        textShape.rotation = toolRotation;
        textShape.fontSize = toolSize;
    }

    function placeText() {
        canvasInput.lastPoint = canvasInput.savePoint();
        textShape.x = canvasInput.lastPoint.x - tempCanvas.width * 0.5;
        textShape.y = canvasInput.lastPoint.y - tempCanvas.height * 0.5;
    }

    function toolStart() {
        placeText();
        textShape.opacity = 0.5;
        textShape.visible = true;
    }

    function toolProcess() {
        placeText();
    }

    function toolStop() {
        textShape.opacity = toolOpacity;
        canvasInput.resetPoints();
        tempCanvas.paintActionFinished();
    }

}
