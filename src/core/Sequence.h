/* GCompris - Sequence.h
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef SEQUENCE_H
#define SEQUENCE_H

#include <QList>
#include <QString>
#include <utility>

using Sequence = QList<std::pair<QString, QStringList>>;
// struct Sequence
// {
//     //    activity name, dataset names
//     QList<QMap<QString, QStringList>> sequences;
// };

#endif // SEQUENCE_H
