/* GCompris - chess_2players.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12

import "../../core"
import "../chess"

Chess {
    twoPlayers: false
    difficultyByLevel: false
    displayTakenPiecesButton: false
    fen: [
        ["Horde", "7k/pppppppp/8/8/PPPPPPPP/PPPPPPPP/PPPPPPPP/7K w - - 0 1"],
        ["PawnPromotion","7k/2pppppp/q1pppppp/1P1ppppp/8/8/5PPP/7K w - - 0 1"],
        ["Rook", "7k/4pppp/4pppp/8/8/8/1PPPPPPP/6RK w - - 0 1"],
        ["Knight","3r1r2/N2r1b2/2qp1p2/3pkp1N/R7/3q4/1PPPP3/2N3K1 w - - 0 1"],
        ["Queen", "7k/4pppp/5ppp/8/8/PPPPP3/Q7/K7 w - - 0 1"],
        ["Bishops", "3bkb2/1p2bb2/8/8/8/8/8/3BB2K w - - 0 1"],
        ["Overpowered", "1r1k4/n4bpp/8/8/2q5/8/PPPN2PP/2R1QBBK w - - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"],
        ["Ignore", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"]
    ]
}
 
