import QtQuick 2.0
import "align4-2players.js" as Activity

import GCompris 1.0

Image {
    id: piece

    property Item back
    property int index

    width: back.width * 0.075
    height: back.height * 0.116
    opacity: 1.0

    states: [
        State {
            name: "invisible"
            PropertyChanges {
                target: piece
                opacity: 0
            }

        },
        State {
            name: "red"
            PropertyChanges{
                target: piece
                opacity: 1.0
                source: Activity.url + "stone_2.svg"
            }
        },
        State {
            name: "green"
            PropertyChanges {
                target: piece
                opacity: 1.0
                source: Activity.url + "stone_1.svg"
            }
        },
        State {
            name: "crossed"
            PropertyChanges {
                target: piece
                opacity: 1.0
                source: Activity.url + "win.svg"
            }
        }
    ]
}
