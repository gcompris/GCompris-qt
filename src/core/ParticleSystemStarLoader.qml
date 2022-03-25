/* GCompris - ParticleSystemStarLoader.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
 * A QML loader that wraps ParticleSystemStar.
 * @ingroup components
 *
 * Wrapper loading/activating a @ref ParticleSystemStarLoader only if
 * the Android systems supports fragment shaders according to
 * ApplicationInfo.hasShader.
 *
 * @inherit QtQuick.Loader
 * @sa ParticleSystemStar ApplicationInfo.hasShader
 */
Loader {
    anchors.fill: parent
    active: ApplicationInfo.hasShader

    /**
     * Emits count particles from the particle emitter immediately.
     *
     * Cf. Emitter.burst
     */
    function burst(val) {
        if(active) {
            item.opacity = 1
            item.start()
            item.emitter.burst(val)
            stopParticleSystem.restart()
        }
    }

    Timer {
        id: stopParticleSystem
        interval: (item && item.emitter) ? item.emitter.lifeSpan + item.emitter.lifeSpanVariation : 0
        repeat: false
        onTriggered: {
            item.stop()
            item.opacity = 0
        }
    }
    onLoaded: item.clip = clip
    source: "ParticleSystemStar.qml"
}
