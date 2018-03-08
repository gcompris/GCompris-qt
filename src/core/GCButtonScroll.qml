/* GCompris - GCButtonScroll.qml
 *
 * Copyright (C) 2017 Timothée Giet <animtim@gcompris.net>
 *               2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import GCompris 1.0

/**
 * A QML component representing GCompris' scroll buttons.
 * @ingroup components
 *
 * @inherit QtQuick.Image
 */
Rectangle {
    id: scrollButtons
    color: "#00000000"
    width: (isHorizontal ? 110 : 50) * ApplicationInfo.ratio
    height: (isHorizontal ? 50 : 110) * ApplicationInfo.ratio
    
    signal up
    signal down
    
    property bool upVisible: false
    property bool downVisible: false

    property bool isHorizontal: false
    property real heightRatio: isHorizontal ? (50 / 110) : (110 / 50)
    property real widthRatio: 1 / heightRatio
    
    BarButton {
        id: scrollUp
        width: isHorizontal ? parent.height : parent.width
        height: width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        sourceSize.width: scrollUp.width
        sourceSize.height: scrollUp.height
        rotation: 180
        anchors.top: isHorizontal ? undefined : parent.top
        anchors.left: isHorizontal ? parent.left : undefined
        onClicked: up()
        visible: upVisible
    }
    
    BarButton {
        id: scrollDown
        width: isHorizontal ? parent.height : parent.width
        height: width
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        sourceSize.width: scrollDown.width
        sourceSize.height: scrollDown.height
        anchors.bottom: parent.bottom
        anchors.right: isHorizontal ? parent.right : undefined
        onClicked: down()
        visible: downVisible
    }
}
