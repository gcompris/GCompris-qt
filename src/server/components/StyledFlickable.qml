/* GCompris - StyledFlickable.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Flickable {
    id: styledFlickable
    width: parent.width
    height: parent.height
    contentWidth: contentItem.width
    contentHeight: contentItem.height
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    property bool showHorizontalBar: contentWidth > width
    property bool showVerticalBar: contentHeight > height

    ScrollBar.horizontal: ScrollBar {
        policy: ScrollBar.AsNeeded
        rightPadding: styledFlickable.showVerticalBar ? 10 : 0
        contentItem: Rectangle {
            implicitHeight: 6
            radius: height
            opacity: styledFlickable.showHorizontalBar ? 1 : 0
            color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
        }
    }

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        bottomPadding: styledFlickable.showHorizontalBar ? 10 : 0
        contentItem: Rectangle {
            implicitWidth: 6
            radius: width
            opacity: styledFlickable.showVerticalBar ? 1 : 0
            color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
        }
    }
}
