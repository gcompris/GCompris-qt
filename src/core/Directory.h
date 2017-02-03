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
 * @short A helper component to get the names of files
 *        present in a given location
 * Use - call files.getFiles(":input/path/")
 */

class Directory : public QObject
{
    Q_OBJECT

public:
    /**
     * Constructor
    */
    Directory();

    /**
      * Returns the names of all the files in a given path
      *
      * @param location : The path of the directory
      *
      * @returns Names of all the files present in the
      *          given location, separated by a space
      */
    Q_INVOKABLE QStringList getFiles(const QString& location);
    static void init();

};

#endif
