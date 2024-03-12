/* GCompris - Sequence.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

Planegame {

    property string zeroTooltip: qsTr("Catch the numbers starting from 0.")
    property string tenTooltip: qsTr("Catch the numbers starting from 10.")

    dataset: [
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: true,
            toolTipText: zeroTooltip
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: true,
            toolTipText: tenTooltip
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: false,
            toolTipText: zeroTooltip
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: false,
            toolTipText: tenTooltip
        }
    ]
}
