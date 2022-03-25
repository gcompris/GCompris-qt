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
    sourceSize.width: width
    sourceSize.height: height

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
