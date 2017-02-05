/* GCompris - Directory.cpp
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#include "Directory.h"
#include <QDir>
#include <QQmlComponent>

Directory::Directory(QObject *parent) : QObject(parent)
{
}

QStringList Directory::getFiles(const QString& location, const QStringList &nameFilters)
{
    QDir dir(location);
    return dir.entryList(nameFilters);
}

void Directory::init()
{
    qmlRegisterType<Directory>("GCompris", 1, 0, "Directory");
}
