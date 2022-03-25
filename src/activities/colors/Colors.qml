/* GCompris - Colors.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges <pascal.georges1@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "colors.js" as Dataset

FindIt {
    mode: "Colors"
    dataset: Dataset
    backgroundImg: "qrc:/gcompris/src/activities/colors/resource/background.svg"
}
