/* GCompris - Directory.h
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
    explicit Directory(QObject *parent = nullptr);

    /**
     * Returns the names of all the files and directories in a given path
     *
     * @param location the path of the directory
     * @param nameFilters name filters to apply to the filenames
     *
     * @returns list of the names of all the files and directories
     *          in the directory.
     */
    Q_INVOKABLE QStringList getFiles(const QString &location, const QStringList &nameFilters = QStringList());
};

#endif
