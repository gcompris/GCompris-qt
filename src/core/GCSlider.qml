/* GCompris - GCSlider.qml
 *
 * SPDX-FileCopyrightText: 2018 Alexis Breton <alexis95150@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Alexis Breton <alexis95150@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import core 1.0

/**
  * A Slider component with GCompris' style.
  * @ingroup components
  *
  * @inherit QtQuick.Controls.Slider
  */
Slider {
    id: control

    focusPolicy: Qt.NoFocus
    snapMode: Slider.SnapAlways
    stepSize: 1

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight * 0.5 - height * 0.5
        implicitWidth: 2 * radius
        implicitHeight: 2 * radius
        radius: 10 * ApplicationInfo.ratio
        color: control.pressed || activeFocus ? GCStyle.sliderPressed : GCStyle.sliderHandle
        border.color: GCStyle.sliderBorder
        border.width: GCStyle.thinnestBorder
    }

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight * 0.5 - height * 0.5
        radius: height * 0.5
        width: control.availableWidth
        height: implicitHeight
        implicitWidth: 250 * ApplicationInfo.ratio
        implicitHeight: handle.height * 0.5
        anchors.verticalCenter: parent.verticalCenter
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.sliderBorder
        color: GCStyle.sliderEmpty

        Rectangle {
            width: handle.x + handle.width * 0.5
            height: parent.height
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.sliderBorder
            radius: height * 0.5
            color: GCStyle.sliderFill
        }
    }
}
