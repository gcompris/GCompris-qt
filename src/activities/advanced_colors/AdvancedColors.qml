/* GCompris - AdvancedColors.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges <pascal.georges1@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

import "../colors"
import "advanced_colors.js" as Dataset

FindIt {
    mode: "AdvancedColors"
    dataset: Dataset.get()
    backgroundImg: "qrc:/gcompris/src/activities/menu/resource/background.svg"
}
