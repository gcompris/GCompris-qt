/* GCompris - File.cpp
 *
 * Copyright (C) 2014 Holger Kaelberer
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

#include "File.h"

#include <QFile>
#include <QString>
#include <QTextStream>
#include <QtQml>

File::File(QObject *parent) : QObject(parent)
{
}

QString File::name() const
{
    return m_name;
}

QString File::sanitizeUrl(const QString &str)
{
    QString target(str);

    // make sure we strip off invalid URL schemes:
    if (target.startsWith("file://"))
        target.remove(0, 7);
    else if (target.startsWith("qrc:/"))
        target.remove(0, 3);

    return target;
}

void File::setName(const QString &str)
{
    QString target = sanitizeUrl(str);

    if (target != m_name) {
        m_name = target;
        emit nameChanged();
    }
}

QString File::read(const QString& name)
{
    if (name != QString())
        setName(name);

    if (m_name.isEmpty()){
        emit error("source is empty");
        return QString();
    }

    QFile file(m_name);
    QString fileContent;
    if (file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t(&file);
        /* Force utf-8 : for some languages, it seems to be loaded in other
          encoding even if the file is in utf-8 */
        t.setCodec("UTF-8");

        do {
            line = t.readLine();
            fileContent += line;
         } while (!line.isNull());

        file.close();
    } else {
        emit error("Unable to open the file");
        return QString();
    }
    return fileContent;
}

bool File::write(const QString& data, const QString& name)
{
    if (name != QString())
        setName(name);

    if (m_name.isEmpty()) {
        emit error("source is empty");
        return false;
    }

    QFile file(m_name);
    if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
        emit error("could not open file " + m_name);
        return false;
    }

    QTextStream out(&file);
    out << data;

    file.close();

    return true;
}

void File::init()
{
    qmlRegisterType<File>("GCompris", 1, 0, "File");
}

bool File::exists(const QString& path)
{
    return QFile::exists(sanitizeUrl(path));
}
