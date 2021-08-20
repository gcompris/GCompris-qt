/* GCompris - DatabaseElement.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef DATABASEELEMENT_H
#define DATABASEELEMENT_H

#include <QObject>

/**
 * @class DatabaseElement
 * @short Default class from an element that can be retrieved/stored in database
 *
 * A DatabaseElement contains an unique identifier
 *
 */
class DatabaseElement : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int primaryKey MEMBER m_primaryKey)

public:
    DatabaseElement(int primaryKey = 0) :
        m_primaryKey(primaryKey) {};
    ~DatabaseElement() = default;

    const int &getPrimaryKey() const { return m_primaryKey; };
    void setPrimaryKey(int key) { m_primaryKey = key; };

private:
    int m_primaryKey;
};

#endif
