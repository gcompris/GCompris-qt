/* GCompris - Dataset.cpp
 *
 * Copyright (C) 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
#include "Dataset.h"

Dataset::Dataset(QObject *parent):
    QObject(parent),
    m_objective(""),
    m_difficulty(0)
{
}

QString Dataset::objective() const
{
    return m_objective;
}

void Dataset::setObjective(const QString &objective)
{
    m_objective = objective;
    emit objectiveChanged();
}

quint32 Dataset::difficulty() const
{
    return m_difficulty;
}
void Dataset::setDifficulty(const quint32 &difficulty)
{
    m_difficulty = difficulty;
    emit difficultyChanged();
}

QVariant Dataset::data() const
{
    return m_data;
}
void Dataset::setData(const QVariant &data)
{
    m_data = data;
    emit dataChanged();
}
