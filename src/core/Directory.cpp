/* GCompris - Directory.cpp
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "Directory.h"
#include <QDir>

Directory::Directory(QObject *parent) :
    QObject(parent)
{
}

QStringList Directory::getFiles(const QString &location, const QStringList &nameFilters)
{
    QDir dir(location);
    return dir.entryList(nameFilters, (QDir::NoDotAndDotDot | QDir::AllEntries));
}

#include "moc_Directory.cpp"
