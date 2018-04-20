/* GCompris - Hexagon.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (add mode without OpenGL)
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
import QtGraphicalEffects 1.0
import "hexagon.js" as Activity
import "../../core"
import GCompris 1.0

Item {
    id: hexagon
    property GCSfx audioEffects
    property ParticleSystemStar particles
    property alias color: softCanvas.color
    property bool hasStrawberry: false
    property double ix
    property double iy
    property int nbx
    property int nby
    // Warning testing parent here, just to avoid an error at deletion time
    property double r: parent ? Math.min(parent.width / nbx / 2, (parent.height - 10) / nby / 2) : 0
    property double offsetX: parent ? (parent.width % (width * nbx)) / 2 : 0
    property double offsetY: parent ? (parent.height % (height * nby)) / 2 : 0
    x: (iy % 2 ? width * ix + width / 2 : width * ix) + offsetX
    y: height * iy - (Math.sin((Math.PI * 2) / 12) * r * 2 * iy) / 2 + offsetY
    width: Math.cos((Math.PI * 2) / 12) * r * 2
    height: r * 2

    Image {
        id: strawberry
        anchors.fill: parent
        opacity: 0
        onSourceChanged: opacity = 1
        Behavior on opacity { PropertyAnimation { duration: 2000; easing.type: Easing.OutQuad } }
    }

    Image {
      id: border
      anchors.fill: parent
      source: Activity.url + "hexagon_border.svg"
      Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    Image {
      id: canvas
      anchors.fill: parent
      source: Activity.url + "hexagon.svg"
      visible: false
    }
    
    Rectangle {
        id:softCanvas
        width: parent.width * 0.8
        height: width
        radius: width * 0.5
        anchors.centerIn: parent
        opacity: strawberry.opacity == 0 ? 0.65 : 0
        visible: ApplicationInfo.useOpenGL ? false : true
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: canvas
        source: canvas
        onOpacityChanged: if(opacity == 0) Activity.strawberryFound()
        color: softCanvas.color
        opacity: 0.65
        Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    // Create a particle only for the strawberry
    Loader {
        id: particleLoader
        anchors.fill: parent
        active: hasStrawberry
        sourceComponent: particle
    }

    Component {
        id: particle
        ParticleSystemStarLoader
        {
            id: particles
            clip: false
        }
    }

    property bool isTouched: false
    function touched() {
        if(hasStrawberry && !isTouched) {
            colorOverlay.opacity = 0
            border.opacity = 0
            isTouched = true
            strawberry.source = Activity.url + "strawberry.svg"
            audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
            Activity.strawberryFound()
            particleLoader.item.burst(40)
        } else {
            hexagon.color =
                    Activity.getColor(Activity.getDistance(hexagon.ix, hexagon.iy))
        }
    }
}
