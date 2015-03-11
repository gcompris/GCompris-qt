/* GCompris - File.h
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
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

class File : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

public:
    explicit File(QObject *parent = 0);

    QString name() const;
    void setName(const QString &str);

    Q_INVOKABLE QString read(const QString& name = QString());
    Q_INVOKABLE bool write(const QString& data, const QString& name = QString());
    Q_INVOKABLE static bool exists(const QString& path);

    static void init();

signals:
    void nameChanged();
    void error(const QString& msg);

private:
    QString m_name;

    static QString sanitizeUrl(const QString& url);
};

#endif
