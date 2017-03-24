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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
    width: 50 * ApplicationInfo.ratio
    height: 110 * ApplicationInfo.ratio
    
    signal up
    signal down
    
    property bool upVisible: false
    property bool downVisible: false
    
    BarButton {
        id: scrollUp
        source: "qrc:/gcompris/src/core/resource/scroll_up.svg";
        sourceSize.width: parent.width
        anchors.top: parent.top
        onClicked: up()
        visible: upVisible
    }
    
    BarButton {
        id: scrollDown
        source: "qrc:/gcompris/src/core/resource/scroll_down.svg";
        sourceSize.width: parent.width
        anchors.bottom: parent.bottom
        onClicked: down()
        visible: downVisible
    }
}
