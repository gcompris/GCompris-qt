/* GCompris - GCSoundEffect.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtMultimedia
import core 1.0

/**
 * A QML component for sfx playback.
 * @ingroup components
 *
 * Wrapper component around QtQuick's SoundEffect element, handling all sfx
 * playback in GCompris uniformly.
 *
 *
 * @inherit QtMultimedia.SoundEffect
 */
SoundEffect {
    id: gcSoundEffect
    muted: (!ApplicationSettings.isAudioEffectsEnabled && !isMusicalActivityRunning) || mobileAndInactive
    volume: ApplicationSettings.audioEffectsVolume
    readonly property bool mobileAndInactive: ApplicationInfo.isMobile && applicationState !== Qt.ApplicationActive

    /**
     * Emitted when playback of sound has finished.
     */
    signal done

    onPlayingChanged: {
        if(!playing){
            gcSoundEffect.done();
        }
    }
}
