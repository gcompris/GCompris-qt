/* GCompris - ChooseDiceBar.qml
 *
 * SPDX-FileCopyrightText: 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "reversecount.js" as Activity

Item {
    id: chooseDiceBar
    z: 1000
    width: barRow.width
    height: barRow.height

    property alias value1: domino.value1
    property alias value2: domino.value2
    property alias valueMax: domino.valueMax
    property alias mode: domino.mode
    property GCSfx audioEffects

    function click() {
        ok.buttonClicked()
    }

    Row {
        id: barRow
        spacing: 8
        anchors.centerIn: parent

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 75 * ApplicationInfo.ratio
            sourceSize.width: width
            visible: true
            anchors {
                right: undefined
                rightMargin: undefined
                top: undefined
                topMargin: undefined
            }
            enabled: items.tuxCanMove && !bonus.isPlaying
            onClicked: Activity.moveTux(domino.value1 + domino.value2)
        }

        Domino {
            id: domino
            height: ok.height
            width: height * 2
            isClickable: ok.enabled
            audioEffects: activity.audioEffects
        }
    }
}

