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
import QtQuick
import core 1.0
import "../../core"
import "reversecount.js" as Activity

Item {
    id: chooseDiceBar
    z: 1000

    property alias value1: domino.value1
    property alias value2: domino.value2
    property alias valueMax: domino.valueMax
    property alias mode: domino.mode

    function moveTux() {
        if(ok.enabled) {
            Activity.moveTux(domino.value1 + domino.value2)
        }
    }


    GCSoundEffect {
        id: dominoScroll
        source: 'qrc:/gcompris/src/core/resource/sounds/scroll.wav'
    }

    Row {
        id: barRow
        spacing: GCStyle.baseMargins
        anchors.centerIn: parent

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            width: Math.min(GCStyle.bigButtonHeight,
                            chooseDiceBar.width / 3 - GCStyle.baseMargins,
                            chooseDiceBar.height)
            visible: true
            anchors {
                right: undefined
                rightMargin: undefined
                top: undefined
                topMargin: undefined
            }

            enabled: chooseDiceBar.enabled
            onClicked: chooseDiceBar.moveTux();
        }

        Domino {
            id: domino
            width: ok.width * 2
            isClickable: chooseDiceBar.enabled
            soundEffects: dominoScroll
        }
    }
}

