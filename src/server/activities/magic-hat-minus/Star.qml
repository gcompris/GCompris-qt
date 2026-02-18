/* GCompris - Star.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../../singletons"

Item {
    id: mainItem
    required property int index
    required property bool selected
    required property string starsColor

    width: Style.controlSize
    height: Style.controlSize

    Rectangle {
        id: contour
        anchors.fill: parent
        border.color: Style.selectedPalette.text
        border.width: mainItem.selected ? 1 : 0
        opacity: 1
        color: "#4a4a4a" // hardcoded to always keep not selected stars visible
    }

    Image {
        id: starImg
        source: "qrc:/gcompris/src/server/resource/magic-hat/star-" + starsColor +
                                        (mainItem.selected ? ".svg" : "-off.svg")
        width: Style.iconSize
        height: Style.iconSize
        sourceSize.width: width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        opacity: mainItem.selected ? 1 : 0.2
    }
}
