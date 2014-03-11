/* GCompris - ParticleSystemStar.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick.Particles 2.0
import GCompris 1.0

ParticleSystem {
    id: particles
    anchors.fill: parent
    property alias emitter: clickedEmitter
    property alias clip: imageParticle.clip

    Emitter {
        id: clickedEmitter
        anchors.fill: parent
        emitRate: 20
        lifeSpan: 800
        lifeSpanVariation: 400
        sizeVariation: 12
        size: 24 * ApplicationInfo.ratio
        system: particles
        velocity: PointDirection {xVariation: 100; yVariation: 100;}
        acceleration: PointDirection {xVariation: 50; yVariation: 50;}
        velocityFromMovement: 50
        enabled: false
    }
    ImageParticle {
        id: imageParticle
        source: "qrc:/gcompris/src/core/resource/star.png"
        sizeTable: "qrc:/gcompris/src/core/resource/sizeTable.png"
        anchors.fill: parent
        color: "white"
        blueVariation: 0.5
        greenVariation: 0.5
        redVariation: 0.5
        clip: true
        smooth: false
        autoRotation: true
    }
}
