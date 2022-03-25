/* GCompris - ElectricalComponent.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../../core"
import "../analog_electricity.js" as Activity

Image {
    id: electricalComponent
    property double posX
    property double posY
    property double imgWidth
    property double imgHeight
    property string information
    property string toolTipTxt
    property string labelText1: ""
    property string labelText2: ""
    property int componentIndex
    property int noOfConnectionPoints
    property var terminalConnected: 0
    property int rotationAngle: 0
    property int initialAngle: 0
    property int startingAngle: 0
    property double terminalSize
    property bool destructible
    property bool showLabel: false

    property alias rotateComponent: rotateComponent

    x: posX * parent.width
    y: posY * parent.height
    sourceSize.width: imgWidth * parent.sizeMultiplier
    sourceSize.height: imgHeight * parent.sizeMultiplier
    width: sourceSize.width
    height: sourceSize.height
    fillMode: Image.PreserveAspectFit

    z: 2
    mipmap: true
    antialiasing: true

    onPaintedWidthChanged: {
        updateDragConstraints();
        Activity.updateWires(componentIndex);
    }

    PropertyAnimation {
        id: rotateComponent
        target: electricalComponent
        property: "rotation"
        from: initialAngle; to: initialAngle + rotationAngle
        duration: 1
        onStarted:{ Activity.animationInProgress = true }
        onStopped: {
            initialAngle = initialAngle + rotationAngle;
            Activity.updateWires(componentIndex);
            if(initialAngle == startingAngle + rotationAngle * 45) {
                if(initialAngle == 360 || initialAngle == -360)
                    initialAngle = 0;
                startingAngle = initialAngle;
                Activity.animationInProgress = false;
                updateDragConstraints();
            }
            else
                rotateComponent.start();
        }
        easing.type: Easing.InOutQuad;
    }

    function updateDragConstraints() {
        if(initialAngle == 0 || initialAngle == 180 || initialAngle == 360 || initialAngle == -360
           || initialAngle == -180) {
            mouseArea.drag.minimumX = (electricalComponent.paintedWidth - electricalComponent.width)/2;
            mouseArea.drag.minimumY = (electricalComponent.paintedHeight - electricalComponent.height)/2;

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedWidth)/2;
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedHeight)/2;
        }
        else {
            mouseArea.drag.minimumX = (electricalComponent.paintedHeight - electricalComponent.width)/2;
            mouseArea.drag.minimumY = (electricalComponent.paintedWidth - electricalComponent.height)/2;

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedHeight)/2;
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedWidth)/2;
        }
    }

    MouseArea {
        id: mouseArea
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.centerIn: parent
        drag.target: electricalComponent
        onPressed: {
            Activity.updateToolTip(toolTipTxt);
            Activity.componentSelected(componentIndex);
        }
        onClicked: {
            if(Activity.toolDelete) {
                if (destructible) {
                    Activity.removeComponent(componentIndex);
                } else {
                    Activity.deselect();
                }
            } else if(typeof isBroken !== "undefined") {
                // Repair broken bulb and LED on click
                if(isBroken && terminalConnected < noOfConnectionPoints)
                    repairComponent();
            }
        }
        onReleased: {
            parent.posX = parent.x / parent.parent.width;
            parent.posY = parent.y / parent.parent.height;
            Activity.updateToolTip("");
        }

        onPositionChanged: {
            updateDragConstraints();
            Activity.updateWires(componentIndex);
        }
    }

    Rectangle {
        id: componentLabel
        z: 100
        width: 80 * ApplicationInfo.ratio
        height: 40 * ApplicationInfo.ratio
        radius: height * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        color: "#80000000"
        visible: showLabel
        rotation: electricalComponent.rotation * -1
        GCText {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            font.pointSize: NaN  // need to clear font.pointSize explicitly
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            font.pixelSize: componentLabel.width * 0.2
            color: "white"
            text: labelText1 + "<br>" + labelText2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
