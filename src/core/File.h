/* GCompris - File.h
 *
 * SPDX-FileCopyrightText: 2014, 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
    explicit File(QObject *parent = nullptr);

    /**
     * Reads contents of a file.
     *
     * @param name [optional] Filename to read from. If omitted reads from
     *             the file specified by the member name.
     * @returns Whole file contents.
     * @sa name
     */
    Q_INVOKABLE QString read(const QString &name = QString());

    /**
     * Writes @p data to a file.
     *
     * @param data Text data to write.
     * @param name [optional] Filename to write to. If omitted writes to
     *             the file specified by the member name.
     * @returns success of the operation.
     * @sa name
     */
    Q_INVOKABLE bool write(const QString &data, const QString &name = QString());

    /**
     * Appends @p data to a file.
     *
     * @param data Text data to append.
     * @param name [optional] Filename to append to. If omitted writes to
     *             the file specified by the member name.
     * @returns success of the operation.
     * @sa name
     */
    Q_INVOKABLE bool append(const QString &data, const QString &name = QString());
    /**
     * Checks whether file @p path exists.
     *
     * @param path Filename to check.
     * @returns @c true if @p path exists, @c false otherwise.
     */
    Q_INVOKABLE static bool exists(const QString &path);

    /**
     * Creates directory @p path.
     *
     * Creates also all parent directories necessary to create the directory.
     *
     * @param path Directory to create.
     * @returns success
     */
    Q_INVOKABLE static bool mkpath(const QString &path);

    /**
     * Deletes a file @p path.
     *
     * @param path file to delete.
     * @returns success
     */
    Q_INVOKABLE static bool rmpath(const QString &path);

    /// @cond INTERNAL_DOCS
    QString name() const;
    void setName(const QString &str);
    /// @endcond

Q_SIGNALS:
    /**
     * Emitted when the name changes.
     */
    void nameChanged();

    /**
     * Emitted when an error occurs.
     *
     * @param msg Error message.
     */
    void error(const QString &msg);

private:
    QString m_name;

    static QString sanitizeUrl(const QString &url);
};

#endif
