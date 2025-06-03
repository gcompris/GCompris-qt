/* GCompris - TopPanel.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"
import "../components"

Item {

    property string text

    anchors {
        top: parent.top
        left: (serverSettings.navigationPanelRight) ? parent.left : navigationBar.right
        right: (serverSettings.navigationPanelRight) ? navigationBar.left : parent.right
    }
    height: Style.bigControlSize

    Rectangle {
        anchors.fill: parent
        color: Style.selectedPalette.alternateBase

        DefaultLabel {
            anchors {
                left: parent.left
                right: parent.right
                margins: Style.margins
                verticalCenter: parent.verticalCenter
            }
            height: Style.bigTextSize
            color: Style.selectedPalette.text
            font.bold: true
            text: topBanner.text
        }
    }
}
