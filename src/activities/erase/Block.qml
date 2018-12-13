/* GCompris - Block.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtQuick 2.6
import "erase.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: block
    property Item main
    property Item bar
    property Item background
    property double ix
    property double iy
    property int nbx
    property int nby

    x: ix * main.width / nbx
    y: iy * (main.height - bar.height) / (nby + getMultipleOfRatioToAdjustHeight() * ApplicationInfo.ratio)
    width: main.width / nbx
    height: (main.height - bar.height) / (nby + getMultipleOfRatioToAdjustHeight() * ApplicationInfo.ratio)

    signal enter
    signal leave
    property string type
    property int counter: 0

    function getMultipleOfRatioToAdjustHeight() {
        return (background.width >= background.height + 40 * ApplicationInfo.ratio) ? 0.125 : 0.625
    }

    onEnter: {
        if(opacity == 1.0) {
            playSound()
            block.opacity = 0
        }
    }

    onLeave: {
        if(opacity != 0) {
            block.opacity = 1.0
        }
    }

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    onOpacityChanged: {
        if (opacity == 0) {
            mouseArea.enabled = false
            mouseArea.hoverEnabled = false
            Activity.blockKilled()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: block.type !== "erase" || !ApplicationInfo.isMobile
        hoverEnabled: block.type === "erase" && !ApplicationInfo.isMobile
        onClicked: {
            if(block.type === "click") {
                enabled = false
                block.enter()
            }
        }
        onDoubleClicked: {
            if(block.type === "double_click") {
                enabled = false
                block.enter()
            }
        }
        onEntered: {
            if(block.type === "erase") {
                block.enter()
            }
        }
        onExited: {
            if(block.type === "erase") {
                block.leave()
            }
        }
    }

    function playSound()
    {
        activity.audioEffects.play(
                    ix % 2 ? "qrc:/gcompris/src/activities/erase/resource/eraser1.wav" :
                             "qrc:/gcompris/src/activities/erase/resource/eraser2.wav")
    }

}
