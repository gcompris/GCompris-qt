/* GCompris - ColorChooser.qml
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"
import "colormix.js" as Activity
import "."

Image {
    id: chooser
    z: 1

    property int maxSteps: 10
    property int currentStep: 0
    property string brushHue
    onCurrentStepChanged: setSliderX();
    width: height * 2
    sourceSize.width: width
    sourceSize.height: height

    Image {
        id: intensityScreen
        source: activity.modeRGB ? Activity.url + "flashlight2" + brushHue + ".svg" : "qrc:/gcompris/src/core/resource/empty.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        opacity: currentStep / maxSteps
        visible: activity.modeRGB
    }

    Image {
        id: intensityBrush
        source: Activity.url + (activity.modeRGB ? 
                    "light" + brushHue + ".svg" : "brush" + brushHue + ".svg")
        height: (activity.modeRGB ? parent.height * 1.1 : parent.height * 0.25) * (currentStep / maxSteps)
        width: activity.modeRGB ? parent.width * 0.25 : height
        sourceSize.width: width
        sourceSize.height: height
        anchors {
            left: parent.right
            leftMargin: activity.modeRGB ? - parent.width * 0.18 : 0
            verticalCenter: parent.verticalCenter
        }
        opacity: activity.modeRGB ? currentStep / maxSteps * 2 : 1
        visible: currentStep > 0
    }

    Item {
        id: controlsArea
        width: parent.width * 0.8
        height: parent.height * 0.4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    Rectangle {
        id: sliderArea
        height: controlsArea.height
        anchors {
            verticalCenter: controlsArea.verticalCenter
            left: minusButton.right
            right: plusButton.left
        }
        color: "#00FFFFFF"
        radius: height * 0.2
        border.width: GCStyle.midBorder
        border.color: GCStyle.grayBorder
        property int maxLimit: width - sliderHandle.width
        onWidthChanged: setSliderX();
        Rectangle {
            z: -1
            radius: parent.radius
            anchors.left: sliderHandle.left
            anchors.top: sliderArea.top
            anchors.bottom: sliderArea.bottom
            anchors.right: sliderArea.right
            anchors.margins: parent.border.width * 0.5
            color: "#B0FFFFFF"
        }
        Rectangle {
            id: sliderHandle
            width: parent.width * 0.1
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            color: "#535353"
            radius: height * 0.2
            x: 0
        }
        MouseArea {
            anchors.fill: parent
            enabled: !items.buttonsBlocked
            drag.target: sliderHandle
            onPositionChanged: {
                if(sliderHandle.x < 0)
                    sliderHandle.x = 0;
                if(sliderHandle.x > sliderArea.maxLimit)
                    sliderHandle.x = sliderArea.maxLimit;
                currentStep = Math.round(sliderHandle.x / sliderArea.maxLimit * maxSteps);
                setSliderX();
            }
        }
    }

    function setSliderX() {
        sliderHandle.x = currentStep * sliderArea.maxLimit / maxSteps;
    }

    ColorButton {
        id: plusButton
        source: Activity.url + "plus.svg"
        anchors {
            verticalCenter: controlsArea.verticalCenter
            right: controlsArea.right
        }
        onClicked: currentStep = Math.min(currentStep + 1, maxSteps);
    }

    ColorButton {
        id: minusButton
        rotation: parent.rotation
        source: Activity.url + "minus.svg"
        anchors {
            verticalCenter: controlsArea.verticalCenter
            left: controlsArea.left
        }
        onClicked: currentStep = Math.max(currentStep - 1, 0);
    }
}
