/* GCompris - GCButtonStyle.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

/**
 * Provides styling for GCompris' Buttons.
 * @ingroup components
 *
 * @inherit QtQuick.Controls.Styles.ButtonStyle
 */
ButtonStyle {
    /**
     * type:real
     * Fixed font size of the label in pt.
     *
     * Set to a value > 0 for enforcing a fixed font.pointSize for the label,
     * that won't be updated with ApplicationSettings.baseFontSize.
     * @sa ApplicationSettings.baseFontSize, GCText.fixFontSize
     */
    property real fixedFontSize: -1

    background: Rectangle {
        border.width: control.activeFocus ? 4 : 2
        border.color: "black"
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0 ; color: control.pressed ? "#87ff5c" : "#ffe85c" }
            GradientStop { position: 1 ; color: control.pressed ? "#44ff00" : "#f8d600" }
        }
    }
    label: Item {
        id: labelItem
        anchors.fill: parent
        implicitWidth: labelText.implicitWidth
        implicitHeight: labelText.implicitHeight

        GCText {
            id: labelText
            text: control.text
            fontSize: regularSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap

            Component.onCompleted: {
                if (fixedFontSize > 0) {
                    labelText.fixFontSize = true;
                    labelText.fontSize = fixedFontSize;
                }
            }
        }
    }
}
