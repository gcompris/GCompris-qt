/* GCompris - find_the_day.qml
 *
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../calendar"
import "find_the_day_dataset.js" as Dataset

Calendar {
    dataset: Dataset

}
