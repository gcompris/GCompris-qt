/* GCompris - align4-2players.qml
 *
 * SPDX-FileCopyrightText: 2014 Bharath M S <brat.197@gmail.com>
 *
 * Authors:
 *   Laurent Lacheny <laurent.lacheny@wanadoo.fr> (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "align4.js" as Activity

import GCompris 1.0

Image {
    id: piece
    fillMode: Image.PreserveAspectFit

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
            name: "2" // Player 2
            PropertyChanges{
                target: piece
                opacity: 1.0
                source: Activity.url + "stone_2.svg"
            }
        },
        State {
            name: "1" // Player 1
            PropertyChanges {
                target: piece
                opacity: 1.0
                source: Activity.url + "stone_1.svg"
            }
        },
        State {
            name: "crossed1"
            PropertyChanges {
                target: piece
                opacity: 1.0
                source: Activity.url + "win1.svg"
            }
        },
        State {
            name: "crossed2"
            PropertyChanges {
                target: piece
                opacity: 1.0
                source: Activity.url + "win2.svg"
            }
        }
    ]
}
