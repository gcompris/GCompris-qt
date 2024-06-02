/* GCompris - TopPanel.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../singletons"

Item {

    property string text

    anchors {
        top: parent.top
        left: (serverSettings.navigationPanelRight) ? parent.left : navigationBar.right
        right: (serverSettings.navigationPanelRight) ? navigationBar.left : parent.right
    }
    height: Style.heightTopPanel

    Rectangle {
        anchors.fill: parent
        color: Style.colorNavigationBarBackground

        Text {
            id: topBannerTitleText
            anchors.fill: parent
            leftPadding: 20
            font.pixelSize: Style.pixelSizeTopPanelText

            color: Style.colorNavigationBarFont
            text: topBanner.text
            verticalAlignment: Text.AlignVCenter
        }
    }
}
