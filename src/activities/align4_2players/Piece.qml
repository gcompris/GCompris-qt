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

Image {
    id: piece
    fillMode: Image.PreserveAspectFit

    opacity: 1.0
    required property string url

    states: [
        State {
            name: "invisible"
            PropertyChanges {
                piece {
                    opacity: 0
                }
            }
        },
        State {
            name: "2" // Player 2
            PropertyChanges {
                piece {
                    opacity: 1.0
                    source: piece.url + "stone_2.svg"
                }
            }
        },
        State {
            name: "1" // Player 1
            PropertyChanges {
                piece {
                    opacity: 1.0
                    source: piece.url + "stone_1.svg"
                }
            }
        },
        State {
            name: "crossed1"
            PropertyChanges {
                piece {
                    opacity: 1.0
                    source: piece.url + "win1.svg"
                }
            }
        },
        State {
            name: "crossed2"
            PropertyChanges {
                piece {
                    opacity: 1.0
                    source: piece.url + "win2.svg"
                }
            }
        }
    ]
}
