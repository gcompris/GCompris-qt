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
        ["", "4k3/8/8/8/8/8/8/K4QQ1 w - - 0 1"],
        ["", "1k6/8/8/8/8/8/8/K4RR1 w - - 0 1"],
        ["", "8/8/8/1B6/1R6/8/8/k3K3 w - - 0 1"],
        ["", "8/8/8/3N4/3N4/3B4/3B4/k3K3 w - - 0 1"],
        ["checkmate in 1", "8/8/8/8/8/6K1/4Q3/6k1 w - - 2 1"],
        ["mate in 1", "5k2/8/5K2/4Q3/5P2/8/8/8 w - - 3 1"],
        ["zugzwang", "8/8/p1p5/1p5p/1P5p/8/PPP2K1p/4R1rk w - - 0 1"],
        ["earlyish", "rnq1nrk1/pp3pbp/6p1/3p4/3P4/5N2/PP2BPPP/R1BQK2R w KQ - 0 1"],
        ["checkmate in 2", "4kb2/3r1p2/2R3p1/6B1/p6P/P3p1P1/P7/5K2 w - - 0 1"],
        ["leonid's position", "q2k2q1/2nqn2b/1n1P1n1b/2rnr2Q/1NQ1QN1Q/3Q3B/2RQR2B/Q2K2Q1 w - - 0 1"],
        ["sufficient material - opposing bishops", "8/6BK/7B/6b1/7B/8/B7/7k w - - 0 1"],
        ["checkmate in 1", "rnbqkr2/ppppbp1p/8/3NQ3/8/8/PPPP1nPP/R1B1KBNR w - - 0 1"],
        ["checkmate in 2", "6k1/p4p2/1p4p1/2p4p/4Pnq1/1PQ5/P1P2PPP/3R2K1 w - - 0 1"],
        ["checkmate in 5, sacrifice your queen", "5rk1/1p3p1p/6p1/q2P4/2n5/P6Q/KB2p3/2R5 w - - 0 1"]
    ]
}
