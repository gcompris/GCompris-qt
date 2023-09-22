/* GCompris - instruments.js
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

var colors =
        [
            [ // Level 1
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/clarinet.svg",
                "text": qsTr("Find the clarinet"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/clarinet.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.svg",
                "text": qsTr("Find the transverse flute"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/guitar.svg",
                "text": qsTr("Find the guitar"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/guitar.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/harp.svg",
                "text": qsTr("Find the harp"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/harp.$CA")
            }
            ],
            [ // Level 2
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/piano.svg",
                "text": qsTr("Find the piano"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/piano.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/saxophone.svg",
                "text": qsTr("Find the saxophone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/saxophone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trombone.svg",
                "text": qsTr("Find the trombone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trombone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trumpet.svg",
                "text": qsTr("Find the trumpet"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trumpet.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/violin.svg",
                "text": qsTr("Find the violin"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/violin.$CA")
            }
            ],
            [ // Level
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/clarinet.svg",
                "text": qsTr("Find the clarinet"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/clarinet.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.svg",
                "text": qsTr("Find the transverse flute"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/guitar.svg",
                "text": qsTr("Find the guitar"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/guitar.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/harp.svg",
                "text": qsTr("Find the harp"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/harp.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/piano.svg",
                "text": qsTr("Find the piano"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/piano.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/saxophone.svg",
                "text": qsTr("Find the saxophone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/saxophone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trombone.svg",
                "text": qsTr("Find the trombone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trombone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trumpet.svg",
                "text": qsTr("Find the trumpet"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trumpet.$CA")
            }
            ],
            [ // Level 4
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/violin.svg",
                "text": qsTr("Find the violin"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/violin.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.svg",
                "text": qsTr("Find the transverse flute"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/flute_traversiere.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/guitar.svg",
                "text": qsTr("Find the guitar"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/guitar.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/harp.svg",
                "text": qsTr("Find the harp"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/harp.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/piano.svg",
                "text": qsTr("Find the piano"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/piano.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/saxophone.svg",
                "text": qsTr("Find the saxophone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/saxophone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trombone.svg",
                "text": qsTr("Find the trombone"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trombone.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/trumpet.svg",
                "text": qsTr("Find the trumpet"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/trumpet.$CA")
            }
            ],
            [ // Level 5
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/drum_kit.svg",
                "text": qsTr("Find the drum kit"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/drum_kit.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/accordion.svg",
                "text": qsTr("Find the accordion"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/accordion.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/banjo.svg",
                "text": qsTr("Find the banjo"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/banjo.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/bongo.svg",
                "text": qsTr("Find the bongos"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/bongo.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/electric_guitar.svg",
                "text": qsTr("Find the electric guitar"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/electric_guitar.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/castanets.svg",
                "text": qsTr("Find the castanets"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/castanets.$CA")
            }
            ],
            [ // Level 6
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/drum_kit.svg",
                "text": qsTr("Find the drum kit"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/drum_kit.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/accordion.svg",
                "text": qsTr("Find the accordion"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/accordion.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/banjo.svg",
                "text": qsTr("Find the banjo"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/banjo.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/cymbal.svg",
                "text": qsTr("Find the cymbal"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/cymbal.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/cello.svg",
                "text": qsTr("Find the cello"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/cello.$CA")
            }
            ],
            [ // Level 7

            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/bongo.svg",
                "text": qsTr("Find the bongos"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/bongo.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/electric_guitar.svg",
                "text": qsTr("Find the electric guitar"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/electric_guitar.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/harmonica.svg",
                "text": qsTr("Find the harmonica"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/harmonica.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/horn.svg",
                "text": qsTr("Find the horn"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/horn.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/maracas.svg",
                "text": qsTr("Find the maracas"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/maracas.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/organ.svg",
                "text": qsTr("Find the organ"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/organ.$CA")
            }
            ],
            [ // Level 8

            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/snare_drum.svg",
                "text": qsTr("Find the snare drum"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/snare_drum.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/timpani.svg",
                "text": qsTr("Find the timpani"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/timpani.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/triangle.svg",
                "text": qsTr("Find the triangle"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/triangle.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/horn.svg",
                "text": qsTr("Find the horn"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/horn.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/maracas.svg",
                "text": qsTr("Find the maracas"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/maracas.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/organ.svg",
                "text": qsTr("Find the organ"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/organ.$CA")
            }
            ],
            [ // Level 9

            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/snare_drum.svg",
                "text": qsTr("Find the snare drum"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/snare_drum.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/timpani.svg",
                "text": qsTr("Find the timpani"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/timpani.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/triangle.svg",
                "text": qsTr("Find the triangle"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/triangle.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/tambourine.svg",
                "text": qsTr("Find the tambourine"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/tambourine.$CA")
            },
            {
                "image": "qrc:/gcompris/src/activities/instruments/resource/tuba.svg",
                "text": qsTr("Find the tuba"),
                "audio": ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/instruments/resource/tuba.$CA")
            }
            ]
        ]

function get() {
    return colors
}
