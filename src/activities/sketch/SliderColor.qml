/* GCompris - SliderColor.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"

Item {
    id: sliderColor
    width: parent.width
    height: 50 // Set proper value on instance

    property string title
    property Gradient gradient

    signal valueChanged(newValue: real)

    function setValue(value) {
        if(value < 0) {
            value = 0;
        } else if(value > 1) {
            value = 1;
        }
        sliderHandle.value = value;
    }

    function sliderValueChanged(mouseXPosition) {
        if(mouseXPosition < 0) {
            mouseXPosition = 0;
        }
        if(mouseXPosition > valueSlider.width) {
            mouseXPosition = valueSlider.width;
        }
        sliderHandle.value = mouseXPosition / valueSlider.width;
        valueChanged(sliderHandle.value);
    }

    GCText {
        id: sliderTitle
        text: sliderColor.title
        width: parent.width
        height: parent.height * 0.5
        anchors.left: parent.left
        anchors.top: parent.top
        color: GCStyle.contentColor
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignLeft
    }

    // horizontal bar to select value
    Rectangle {
        // slider container for borders
        anchors.left: parent.left
        anchors.leftMargin: GCStyle.halfMargins
        anchors.right: parent.right
        anchors.rightMargin: GCStyle.halfMargins
        anchors.top: sliderTitle.bottom
        height: sliderTitle.height
        color: GCStyle.contentColor

        Rectangle {
            id: valueSlider
            anchors.fill: parent
            anchors.margins: GCStyle.thinBorder
            gradient: sliderColor.gradient

            Rectangle {
                id: sliderHandle
                height: parent.height + GCStyle.fatBorder
                width: 2 * GCStyle.midBorder
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: valueSlider.width * value - GCStyle.midBorder
                color: GCStyle.contentColor
                property real value: 0
                Rectangle {
                    height: valueSlider.height
                    width: GCStyle.thinBorder
                    anchors.centerIn: parent
                    color: Qt.rgba(1,1,1,1)
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: (mouse) => {
                    sliderValueChanged(mouse.x);
                }
                onPositionChanged: (mouse) => {
                    sliderValueChanged(mouse.x);
                }
            }
        }
    }
}
