/* GCompris - ColorDialog.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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

import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "drawing.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: picker
    width: background.width * 0.20
    height: background.height * 0.33
    color: "transparent"

    signal colorChanged()
    
    property real hue
    property real saturation
    property real lightness

    property real barHeight: height
    property real barWidth: width * 0.25

    property color currentColorCode: picker.currentColor()

    function currentColor() {
        picker.colorChanged()
        return Qt.hsla(picker.hue, picker.saturation, picker.lightness, 1.0)
    }

    function updateColor(color) {
        // QML does not expose any way of getting the components of a color
        // parsed by Qt, thus we have to to the parsing ourselves (this breaks
        // named colors)
        if (color[0] == '"') {
            color = color.slice(1, 8);
        }
        if (color[0] == '#') {
            color = color.slice(1);
        }

        var r = parseInt(color.slice(0, 2), 16) / 255;
        var g = parseInt(color.slice(2, 4), 16) / 255;
        var b = parseInt(color.slice(4, 6), 16) / 255;

        // Formulae taken from ColorPicker.qml, Plasma Workspace,
        // Copyright 2013 Marco Martin <mart@kde.org>
        var min = Math.min(r, Math.min(g, b))
        var max = Math.max(r, Math.max(g, b))
        var c = max - min
        var h

        if (c == 0) {
            h = 0
        } else if (max == r) {
            h = ((g - b) / c) % 6
        } else if (max == g) {
            h = ((b - r) / c) + 2
        } else if (max == b) {
            h = ((r - g) / c) + 4
        }

        picker.hue = (1 / 6) * h
        if(picker.hue < 0) {
            picker.hue = 1 + picker.hue
        }

        console.log(picker.hue)
        picker.saturation = (c / (1 - Math.abs(2 * ((max + min) / 2) - 1)))
        picker.lightness = (max + min) / 2
        sMarker.y = saturation * barHeight
        hsMarker.y = hue * barHeight
        lsMarker.y = (1 - lightness) * barHeight

        return true;
    }

    // Vertical bar that displays the hue of the color
    MouseArea {
        id: hueBar
        width: picker.barWidth
        height: picker.barHeight
        anchors.left: parent.left
        anchors.leftMargin: 10

        onPositionChanged: {
            picker.hue = mouse.y / height
            hsMarker.y = mouse.y > hueBar.y+hueBar.height ? Math.min(hueBar.y + hueBar.height - 2 , mouse.y) :
                                                            Math.max(hueBar.y, mouse.y)
        }
        // Display the colors
        Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: "#eeeeee"
            gradient: Gradient {
                GradientStop { position: 0.0/6.0; color: Qt.hsla(0.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 1.0/6.0; color: Qt.hsla(1.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 2.0/6.0; color: Qt.hsla(2.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 3.0/6.0; color: Qt.hsla(3.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 4.0/6.0; color: Qt.hsla(4.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 5.0/6.0; color: Qt.hsla(5.0/6.0, 1, picker.lightness, 1) }
                GradientStop { position: 6.0/6.0; color: Qt.hsla(6.0/6.0, 1, picker.lightness, 1) }
            }
        }

        // Marker
        Rectangle {
            id: hsMarker
            width: picker.barWidth
            height: 10
            radius: 2
            y: hueBar.y + hueBar.height / 2
            anchors.horizontalCenter: hueBar.horizontalCenter
            color: "transparent"
            border {
                color: "white"
                width: 2
            }
        }
    }

    //Vertical bar that displays the saturation of the color
    MouseArea {
        id: saturationBar
        width: picker.barWidth
        height: picker.barHeight
        anchors.left: hueBar.right
        anchors.leftMargin: 10

        onPositionChanged: {
            picker.saturation = mouse.y / height
            sMarker.y = mouse.y > saturationBar.y+saturationBar.height ? Math.min(saturationBar.y + saturationBar.height - 2 , mouse.y) :
                                                                         Math.max(saturationBar.y, mouse.y)
        }

        Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: "#eeeeee"
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.hsla(picker.hue, 0, picker.lightness, 0) }
                GradientStop { position: 1.0; color: Qt.hsla(picker.hue, 1, picker.lightness, 1) }
            }
        }
        Rectangle {
            id: sMarker
            width: picker.barWidth
            height: 10
            radius: 2
            y: saturationBar.height * (1 - picker.saturation)
            color: "transparent"
            border {
                color: "white"
                width: 2
            }
        }
    }

    // Vertical bar that displays the lightness of the color
    MouseArea {
        id: lightnessBar
        width: picker.barWidth
        height: picker.barHeight
        anchors.left: saturationBar.right
        anchors.leftMargin: 7

        onPositionChanged: {
            picker.lightness = 1 - mouse.y / height
            lsMarker.y = lightnessBar.height * (1 - picker.lightness)
        }

        Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: "#eeeeee"
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.hsla(picker.hue, picker.saturation, 1, 1) }
                GradientStop { position: 0.5; color: Qt.hsla(picker.hue, picker.saturation, 0.5, 1) }
                GradientStop { position: 1.0; color: Qt.hsla(picker.hue, picker.saturation, 0, 1) }
            }
        }
        Rectangle {
            id: lsMarker
            width: picker.barWidth
            height: 10
            radius: 2
            y: lightnessBar.height * (1 - picker.lightness)
            color: "transparent"
            border {
                color: "white"
                width: 2
            }
        }
    }
}
