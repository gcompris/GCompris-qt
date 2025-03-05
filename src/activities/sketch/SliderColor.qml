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
    height: toolsPanel.settingsDoubleLineHeight

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
        height: toolsPanel.settingsLineHeight
        anchors.left: parent.left
        anchors.top: parent.top
        color: items.contentColor
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignLeft
    }

    // horizontal bar to select value
    Rectangle {
        // slider container for borders
        anchors.left: parent.left
        anchors.leftMargin: items.baseMargins
        anchors.right: parent.right
        anchors.rightMargin: items.baseMargins
        anchors.top: sliderTitle.bottom
        height: toolsPanel.settingsLineHeight
        color: items.contentColor

        Rectangle {
            id: valueSlider
            anchors.fill: parent
            anchors.margins: 2 * ApplicationInfo.ratio
            gradient: sliderColor.gradient

            Rectangle {
                id: sliderHandle
                height: parent.height + 8 * ApplicationInfo.ratio
                width: 6 * ApplicationInfo.ratio
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: valueSlider.width * value - 3 *  ApplicationInfo.ratio
                color: items.contentColor
                property real value: 0
                Rectangle {
                    height: valueSlider.height
                    width: 2 * ApplicationInfo.ratio
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
