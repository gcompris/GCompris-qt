/* GCompris - Panel.qml
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
    property alias headerText: title.text
    property alias contentComponent: contentLoader.sourceComponent

    implicitWidth: parent.width - Style.sizeShadowOffset
    implicitHeight: headerBackground.height + contentLoader.implicitHeight + (Style.sizeControlSpacing * 2) + Style.sizeShadowOffset

    Rectangle {
        id: shadow
        width: parent.width
        height: parent.height
        x: Style.sizeShadowOffset
        y: Style.sizeShadowOffset
        color: Style.colourShadow
    }

    Rectangle {
        id: headerBackground
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: Style.heightPanelHeader
        color: Style.colourPanelHeaderBackground

        Text {
            id: title
            text: "Set Me!"
            anchors {
                fill: parent
                margins: Style.heightDataControls / 4
            }
            color: Style.colourPanelHeaderFont
            font.pixelSize: Style.pixelSizePanelHeader
            verticalAlignment: Qt.AlignVCenter
        }
    }

    Rectangle {
        id: contentBackground
        anchors {
            top: headerBackground.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: Style.colourPanelBackground

        Loader {
            id: contentLoader
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: Style.sizeControlSpacing
            }
        }
    }
}
