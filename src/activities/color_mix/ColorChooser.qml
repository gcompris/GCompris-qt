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
import GCompris 1.0

import "colormix.js" as Activity
import "."

Image {
    id: chooser
    z: 1

    property int maxSteps: 10
    property int currentStep: 0
    property string brushHue
    onCurrentStepChanged: setSliderX();

    Image {
        id: intensityScreen
        source: activity.modeRGB ? Activity.url + "flashlight2" + brushHue + ".svg" : "qrc:/gcompris/src/core/resource/empty.svg"
        sourceSize.height: parent.sourceSize.height
        sourceSize.width: parent.sourceSize.width
        z: 2
        opacity: currentStep / maxSteps
        visible: activity.modeRGB
    }

    Image {
        id: intensityBrush
        source: Activity.url + (activity.modeRGB ? 
                    "light" + brushHue + ".svg" : "brush" + brushHue + ".svg")
        sourceSize.height: parent.sourceSize.height * 0.25 + currentStep / maxSteps * 15
        z: 2
        anchors {
            left: parent.right
            leftMargin: activity.modeRGB ? -20 * ApplicationInfo.ratio : 0
            verticalCenter: parent.verticalCenter
        }
        opacity: activity.modeRGB ? currentStep / maxSteps * 2 : 1
        visible: currentStep > 0
        fillMode: Image.PreserveAspectFit
    }

    ColorButton {
        id: plusButton
        source: Activity.url + "plus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: parent.width * 0.2
        }
        onClicked: currentStep = Math.min(currentStep + 1, maxSteps);
    }

    Item {
        id: sliderLayout
        height: parent.height * 0.25
        anchors {
            verticalCenter: parent.verticalCenter
            left: minusButton.right
            right: plusButton.left
        }
    }

    Rectangle {
        id: sliderArea
        z: 100
        height: sliderLayout.height
        width: sliderLayout.width * 0.8
        anchors.centerIn: sliderLayout
        color: "#B0FFFFFF"
        radius: height * 0.2
        border.width: height * 0.1
        border.color: "#888888"
        property int maxLimit: width - sliderHandle.width
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
        id: minusButton
        source: Activity.url + "minus.svg"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: parent.width * 0.3
        }
        onClicked: currentStep = Math.max(currentStep - 1, 0);
    }
}
