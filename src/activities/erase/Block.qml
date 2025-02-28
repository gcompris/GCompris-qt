/* GCompris - Block.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "erase.js" as Activity

Image {
    id: block
    property Item blockBackground
    property double ix
    property double iy
    property int nbx
    property int nby
    required property Bar bar
    required property GCSoundEffect eraser1Sound
    required property GCSoundEffect eraser2Sound

    x: ix * width
    y: iy * height
    width: blockBackground.width / nbx
    height: (blockBackground.height - bar.height) / (nby + getMultipleOfRatioToAdjustHeight() * ApplicationInfo.ratio)
    sourceSize.width: width
    sourceSize.height: height
    opacity: 1.0

    signal enter
    signal leave
    property string type

    function getMultipleOfRatioToAdjustHeight(): real {
        return (blockBackground.width >= blockBackground.height + 4 * GCStyle.baseMargins) ? 0.125 : 0.625
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
        if (ix % 2)
            eraser1Sound.play()
        else
            eraser2Sound.play()
    }

}
