/* GCompris - Hexagon.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtQuick 2.1
import QtGraphicalEffects 1.0
import "hexagon.js" as Activity
import "../../core"
import GCompris 1.0

Item {
    id: hexagon
    property GCAudio audioEffects
    property ParticleSystemStar particles
    property alias color: colorOverlay.color
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
    }


    Image {
      id: border
      anchors.fill: parent
      source: Activity.url + "hexagon_border.svgz"

      onOpacityChanged: if(opacity == 0) Activity.strawberryFound()

      Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    Image {
      id: canvas
      anchors.fill: parent
      source: Activity.url + "hexagon.svgz"

      onOpacityChanged: if(opacity == 0) Activity.strawberryFound()
      opacity: 0.65

      Behavior on opacity { PropertyAnimation { duration: 500 } }

      ColorOverlay {
          id: colorOverlay
          anchors.fill: parent
          source: canvas
      }
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
        ParticleSystemStar
        {
            id: particles
            clip: false
        }
    }

    property bool isTouched: false
    function touched() {
        if(hasStrawberry && !isTouched) {
            canvas.opacity = 0
            isTouched = true
            strawberry.source = Activity.url + "strawberry.svgz"
            audioEffects.play("qrc:/gcompris/src/activities/clickgame/resource/drip.wav")
            Activity.strawberryFound()
            particleLoader.item.emitter.burst(40)
        } else {
            hexagon.color =
                    Activity.getColor(Activity.getDistance(hexagon.ix, hexagon.iy))
        }
    }
}
