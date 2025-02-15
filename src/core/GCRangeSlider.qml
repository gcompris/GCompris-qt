/* GCompris - GCRangeSlider.qml
 *
 * SPDX-FileCopyrightText: 2023 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import core 1.0

/**
  * A RangeSlider component with GCompris' style.
  * @ingroup components
  *
  * @inherit QtQuick.Controls.RangeSlider
  */ 
RangeSlider {
    id: control
    focusPolicy: Qt.NoFocus
    snapMode: Slider.SnapAlways
    stepSize: 1

    first.handle: Rectangle {
        x: control.leftPadding + control.first.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight * 0.5 - height * 0.5
        implicitWidth: radius * 2
        implicitHeight: radius * 2
        radius: 10 * ApplicationInfo.ratio
        color: control.first.pressed || activeFocus ? GCStyle.sliderPressed : GCStyle.sliderHandle
        border.color: GCStyle.sliderBorder
        border.width: GCStyle.thinnestBorder
    }

    second.handle: Rectangle {
        x: control.leftPadding + control.second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: radius * 2
        implicitHeight: radius * 2
        radius: 10 * ApplicationInfo.ratio
        color: control.second.pressed || activeFocus ? GCStyle.sliderPressed : GCStyle.sliderHandle
        border.color: GCStyle.sliderBorder
        border.width: GCStyle.thinnestBorder
    }
    
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        radius: height * 0.5
        width: control.availableWidth
        height: implicitHeight
        implicitWidth: 250 * ApplicationInfo.ratio
        implicitHeight: first.handle.height * 0.5
        anchors.verticalCenter: parent.verticalCenter
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.sliderBorder
        color: GCStyle.sliderEmpty

        Rectangle {
            x: first.handle.x + first.handle.width * 0.5
            width: second.handle.x - first.handle.x
            height: parent.height
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.sliderBorder
            radius: 0
            color: GCStyle.sliderFill
        }
    }
}
