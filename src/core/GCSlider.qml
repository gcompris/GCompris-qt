/* GCompris - GCSlider.qml
 *
 * SPDX-FileCopyrightText: 2018 Alexis Breton <alexis95150@gmail.com>
 *
 * Authors:
 *   Alexis Breton <alexis95150@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import GCompris 1.0

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
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 2 * radius
        implicitHeight: 2 * radius
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }

	background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
		radius: height / 2
        width: control.availableWidth
        height: implicitHeight
        implicitWidth: 250 * ApplicationInfo.ratio
        implicitHeight: 8 * ApplicationInfo.ratio
        anchors.verticalCenter: parent.verticalCenter
        border.width: 1
        border.color: "#888"
        gradient: Gradient {
            GradientStop { color: "#bbb" ; position: 0 }
            GradientStop { color: "#ccc" ; position: 0.6 }
            GradientStop { color: "#ccc" ; position: 1 }
        }

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            border.color: Qt.darker("#f8d600", 1.2)
            radius: height/2
            gradient: Gradient {
                GradientStop { color: "#ffe85c"; position: 0 }
                GradientStop { color: "#f8d600"; position: 1.4 }
            }
        }
    }
}
