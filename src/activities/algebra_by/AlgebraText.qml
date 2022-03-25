/* GCompris - Algebra.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtGraphicalEffects 1.0

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

    DropShadow {
        anchors.fill: text
        cached: true
        horizontalOffset: 1
        verticalOffset: 1
        radius: 3.0
        samples: 16
        color: "#422a2a2a"
        source: text
    }
}
