/* GCompris - ParticleSystemStarLoader.qml
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
import QtQuick 2.6
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
        if(active)
            item.emitter.burst(val)
    }
    onLoaded: item.clip = clip
    source: "ParticleSystemStar.qml"
}
