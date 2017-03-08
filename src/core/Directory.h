/* GCompris - Directory.h
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

#ifndef DIRECTORY_H
#define DIRECTORY_H

#include <QString>
#include <QStringList>
#include <QObject>

/**
 * @class Directory
 * @short A helper component for accessing directories from QML.
 * @ingroup components
 */
class Directory : public QObject
{
    Q_OBJECT

public:
    /**
     * Constructor
    */
    explicit Directory(QObject *parent = 0);

    /**
      * Returns the names of all the files and directories in a given path
      *
      * @param location: the path of the directory
      * @param nameFilters: name filters to apply to the filenames
      *
      * @returns list of the names of all the files and directories
      *          in the directory.
      */
    Q_INVOKABLE QStringList getFiles(const QString& location, const QStringList &nameFilters = QStringList());

    /// @cond INTERNAL_DOCS
    static void init();
    /// @endcond
};

#endif
