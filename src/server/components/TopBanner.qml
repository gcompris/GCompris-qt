/* GCompris - TopBanner.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import "../../core"

Item {

    property string text

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    width: parent.width
    height: parent.height/13

    Rectangle {
        anchors.fill: parent
        color: Style.colourNavigationBarBackground

        Text {
            id: topBanneTitleText
            anchors.fill:parent
            leftPadding: 20
            font {
                pixelSize: Style.pixelSizeTopBannerText
            }
            color: Style.colourNavigationBarFont
            text: topBanner.text
            verticalAlignment: Text.AlignVCenter
        }
    }
}
