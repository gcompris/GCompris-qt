/* GCompris
 *
 * Copyright (C) 2014 Bruno Coudoin
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

var url = "qrc:/gcompris/src/activities/memory-sound/resource/"

var memory_sounds =
        [
            [ url + 'guitar_melody.ogg', url + 'guitar_melody.ogg'],
            [ url + 'guitar_son1.ogg', url + 'guitar_son1.ogg'],
            [ url + 'guitar_son2.ogg', url + 'guitar_son2.ogg'],
            [ url + 'guitar_son3.ogg', url + 'guitar_son3.ogg'],
            [ url + 'guitar_son4.ogg', url + 'guitar_son4.ogg'],
            [ url + 'LRApplauses_1_LA_cut.ogg', url + 'LRApplauses_1_LA_cut.ogg'],
            [ url + 'LRBark_1_LA_cut.ogg', url + 'LRBark_1_LA_cut.ogg'],
            [ url + 'LRBark_3_LA_cut.ogg', url + 'LRBark_3_LA_cut.ogg'],
            [ url + 'LRBuddhist_gong_05_LA.ogg', url + 'LRBuddhist_gong_05_LA.ogg'],
            [ url + 'LRDoor_Open_2_LA.ogg', url + 'LRDoor_Open_2_LA.ogg'],
            [ url + 'LRFactory_noise_01_LA.ogg', url + 'LRFactory_noise_01_LA.ogg'],
            [ url + 'LRFactory_noise_02_LA.ogg', url + 'LRFactory_noise_02_LA.ogg'],
            [ url + 'LRFactory_noise_03_LA.ogg', url + 'LRFactory_noise_03_LA.ogg'],
            [ url + 'LRFactory_noise_04_LA.ogg', url + 'LRFactory_noise_04_LA.ogg'],
            [ url + 'LRFactory_noise_05_LA.ogg', url + 'LRFactory_noise_05_LA.ogg'],
            [ url + 'LRFactory_noise_06_LA.ogg', url + 'LRFactory_noise_06_LA.ogg'],
            [ url + 'LRFireballs_01_LA.ogg', url + 'LRFireballs_01_LA.ogg'],
            [ url + 'LRFrogsInPondDuringStormLACut.ogg', url + 'LRFrogsInPondDuringStormLACut.ogg'],
            [ url + 'LRHeart_beat_01_LA.ogg', url + 'LRHeart_beat_01_LA.ogg'],
            [ url + 'LRHits_01_LA.ogg', url + 'LRHits_01_LA.ogg'],
            [ url + 'LRLaPause_short.ogg', url + 'LRLaPause_short.ogg'],
            [ url + 'LRObject_falling_01_LA.ogg', url + 'LRObject_falling_01_LA.ogg'],
            [ url + 'LRObject_falling_02_LA.ogg', url + 'LRObject_falling_02_LA.ogg'],
            [ url + 'LRRain_in_garden_01_LA_cut.ogg', url + 'LRRain_in_garden_01_LA_cut.ogg'],
            [ url + 'LRRing_01_LA.ogg', url + 'LRRing_01_LA.ogg'],
            [ url + 'LRStartAndStopCarEngine1LACut.ogg', url + 'LRStartAndStopCarEngine1LACut.ogg'],
            [ url + 'LRTrain_slowing_down_01_LA_cut.ogg', url + 'LRTrain_slowing_down_01_LA_cut.ogg'],
            [ url + 'LRWeird_1_LA.ogg', url + 'LRWeird_1_LA.ogg'],
            [ url + 'LRWeird_2_LA.ogg', url + 'LRWeird_2_LA.ogg'],
            [ url + 'LRWeird_3_LA.ogg', url + 'LRWeird_3_LA.ogg'],
            [ url + 'LRWeird_4_LA.ogg', url + 'LRWeird_4_LA.ogg'],
            [ url + 'LRWeird_5_LA.ogg', url + 'LRWeird_5_LA.ogg'],
            [ url + 'LRWeird_6_LA.ogg', url + 'LRWeird_6_LA.ogg']
        ]

var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                sounds: memory_sounds
            },
            { // Level 2
                columns: 4,
                rows: 2,
                sounds: memory_sounds
            },
            { // Level 3
                columns: 5,
                rows: 2,
                sounds: memory_sounds
            },
            { // Level 4
                columns: 4,
                rows: 3,
                sounds: memory_sounds
            },
            { // Level 5
                columns: 5,
                rows: 6,
                sounds: memory_sounds
            },
            { // Level 6
                columns: 5,
                rows: 4,
                sounds: memory_sounds
            },
            { // Level 7
                columns: 6,
                rows: 4,
                sounds: memory_sounds
            },
        ]




function get() {
    return memory_cards
}
