/* GCompris - Algebra.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Effects

import "../../core"

Item {

    width: text.width
    height: text.height

    property alias text: text.text

    GCText {
        id: text
        fontSize: hugeSize
        font.bold: true
        style: Text.Outline
        styleColor: "white"
        color: "black"
    }

    MultiEffect {
        anchors.fill: text
        source: text
        shadowEnabled: true
        shadowBlur: 1.0
        blurMax: 6
        shadowHorizontalOffset: 1
        shadowVerticalOffset: 1
        shadowOpacity: 0.25
    }
}
