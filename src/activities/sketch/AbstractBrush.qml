/* GCompris - AbstractBrush.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

// Gather common properties for all the brushes
Item {
    id: abstractBrush
    property int toolSize: 1
    property int defaultToolSize: 1
    property int minToolSize: 1
    property int maxToolSize: 100
    property int sizeSliderStepSize: 1
    property int timerInterval: 30
    property real toolOpacity: 0.5
    property real defaultToolOpacity: 0.5

    property int eraserSize: 1
    property int defaultEraserSize: 1
    property real eraserOpacity: 1
    property real defaultEraserOpacity: 1

    readonly property real actualToolSize: (items.eraserMode ? eraserSize : toolSize) / items.devicePixelRatio
    readonly property real actualToolOpacity: items.eraserMode ? eraserOpacity : toolOpacity
    readonly property real radiusSize: actualToolSize * 0.5
}
