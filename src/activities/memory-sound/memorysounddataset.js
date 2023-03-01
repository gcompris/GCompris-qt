/* GCompris
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.import GCompris 1.0 as GCompris

var url = "qrc:/gcompris/src/activities/memory-sound/resource/"

var memory_sounds =
        [
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_melody.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_melody.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son1.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son1.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son2.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son2.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son3.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son3.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son4.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'guitar_son4.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRApplauses_1_LA_cut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRApplauses_1_LA_cut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRBark_1_LA_cut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRBark_1_LA_cut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRBuddhist_gong_05_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRBuddhist_gong_05_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRDoor_Open_2_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRDoor_Open_2_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_01_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_01_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_02_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_02_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_03_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_03_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_04_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_04_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_05_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_05_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_06_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFactory_noise_06_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFrogsInPondDuringStormLACut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRFrogsInPondDuringStormLACut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRHeart_beat_01_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRHeart_beat_01_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRLaPause_short.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRLaPause_short.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRObject_falling_01_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRObject_falling_01_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRObject_falling_02_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRObject_falling_02_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRRain_in_garden_01_LA_cut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRRain_in_garden_01_LA_cut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRRing_01_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRRing_01_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRStartAndStopCarEngine1LACut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRStartAndStopCarEngine1LACut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRTrain_slowing_down_01_LA_cut.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRTrain_slowing_down_01_LA_cut.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_1_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_1_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_2_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_2_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_3_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_3_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_4_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_4_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_5_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_5_LA.$CA')],
            [ GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_6_LA.$CA'), GCompris.ApplicationInfo.getAudioFilePath(url + 'LRWeird_6_LA.$CA')]
        ]


var images = []

var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                sounds: memory_sounds,
                images: images
            },
            { // Level 2
                columns: 4,
                rows: 2,
                sounds: memory_sounds,
                images: images
            },
            { // Level 3
                columns: 5,
                rows: 2,
                sounds: memory_sounds,
                images: images
            },
            { // Level 4
                columns: 4,
                rows: 3,
                sounds: memory_sounds,
                images: images
            },
            { // Level 5
                columns: 5,
                rows: 6,
                sounds: memory_sounds,
                images: images
            },
            { // Level 6
                columns: 5,
                rows: 4,
                sounds: memory_sounds,
                images: images
            },
            { // Level 7
                columns: 6,
                rows: 4,
                sounds: memory_sounds,
                images: images
            },
        ]




function get() {
    // Images are the same, create a list as large as memory_sounds
    for(var i in memory_sounds)
        images.push([url + 'audio_note.svg', url + 'audio_note.svg'])

    return memory_cards
}
