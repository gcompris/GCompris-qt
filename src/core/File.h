/* GCompris - File.h
 *
 * Copyright (C) 2014,2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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

#ifndef FILE_H
#define FILE_H

#include <QObject>
#include <QString>

/**
 * @class File
 * @short A helper component for accessing local files from QML.
 * @ingroup components
 *
 */
class File : public QObject
{
    Q_OBJECT

    /**
     * Filename
     *
     * Accepted are absolute paths and URLs starting with the schemes
     * 'file://' and 'qrc://'.
     */
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

public:
    /**
     * Constructor
     */
    explicit File(QObject *parent = 0);

    /**
     * Reads contents of a file.
     *
     * @param name [optional] Filename to read from. If omitted reads from
     *             the file specified by the member name.
     * @returns Whole file contents.
     * @sa name
     */
    Q_INVOKABLE QString read(const QString& name = QString());

    /**
     * Writes @p data to a file.
     *
     * @param data Text data to write.
     * @param name [optional] Filename to write to. If omitted writes to
     *             the file specified by the member name.
     * @returns success of the operation.
     * @sa name
     */
    Q_INVOKABLE bool write(const QString& data, const QString& name = QString());

    /**
     * Checks whether file @p path exists.
     *
     * @param path Filename to check.
     * @returns @c true if @p path exists, @c false otherwise.
     */
    Q_INVOKABLE static bool exists(const QString& path);

    /**
     * Creates directory @p path.
     *
     * Creates also all parent directories necessary to create the directory.
     *
     * @param path Directory to create.
     * @returns success
     */
    Q_INVOKABLE static bool mkpath(const QString& path);

    /// @cond INTERNAL_DOCS
    static void init();
    QString name() const;
    void setName(const QString &str);
    /// @endcond

signals:
    /**
     * Emitted when the name changes.
     */
    void nameChanged();

    /**
     * Emitted when an error occurs.
     *
     * @param msg Error message.
     */
    void error(const QString& msg);

private:
    QString m_name;

    static QString sanitizeUrl(const QString& url);
};

#endif
