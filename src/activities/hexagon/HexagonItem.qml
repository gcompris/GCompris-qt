/* GCompris - Hexagon.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (add mode without OpenGL, port to QtQuick.Shapes)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Shapes 1.5
import "hexagon.js" as Activity
import "../../core"
import GCompris 1.0

Item {
    id: hexagon
    property ParticleSystemStar particles
    property alias color: cellColor.fillColor
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
        z: 1000
        opacity: 0
        onSourceChanged: opacity = 1
        Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.OutQuad } }
    }

    ShapePath {
        id: cellColor
        strokeWidth: 0
        strokeColor: "transparent"
        startX: hexagon.x + border.width * 0.02; startY: hexagon.y + border.height * 0.25
        PathLine { x: hexagon.x + border.width * 0.51 ; y: hexagon.y + border.height * 0.02 }
        PathLine { x: hexagon.x + border.width * 0.99 ; y: hexagon.y + border.height * 0.22 }
        PathLine { x: hexagon.x + border.width * 0.99 ; y: hexagon.y + border.height * 0.77 }
        PathLine { x: hexagon.x + border.width * 0.51 ; y: hexagon.y + border.height * 0.97 }
        PathLine { x: hexagon.x + border.width * 0.02 ; y: hexagon.y + border.height * 0.75 }
        PathLine { x: hexagon.x + border.width * 0.02 ; y: hexagon.y + border.height * 0.25 }
        Component.onCompleted: items.shapeData.push(cellColor)
    }

    Image {
        id: border
        anchors.fill: parent
        sourceSize.width: width
        source: Activity.url + "hexagon_border.svg"
        Behavior on opacity { PropertyAnimation { duration: 100 } }
        onOpacityChanged: if(opacity == 0) Activity.strawberryFound()
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
        if(isTouched) {
            return
        } else if(hasStrawberry) {
            items.inputLocked = true
            hexagon.color = "transparent"
            border.opacity = 0
            isTouched = true
            strawberry.source = Activity.url + "strawberry.svg"
            items.winSound.play()
            Activity.strawberryFound()
            particleLoader.item.burst(40)
        } else {
            hexagon.color =
                    Activity.getColor(Activity.getDistance(hexagon.ix, hexagon.iy))
        }
    }
}
