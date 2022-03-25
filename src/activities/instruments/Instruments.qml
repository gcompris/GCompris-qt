/* GCompris - Instruments.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Sylvain Dechy <syl.1@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../colors"
import "instruments.js" as Dataset

FindIt {
    mode: "Instruments"
    dataset: Dataset
    backgroundImg: "qrc:/gcompris/src/activities/instruments/resource/background.svg"
    isMusicalActivity: true
}
