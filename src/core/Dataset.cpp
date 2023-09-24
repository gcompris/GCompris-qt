/* GCompris - Dataset.cpp
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include "Dataset.h"

Dataset::Dataset(QObject *parent) :
    QObject(parent),
    m_objective(""),
    m_difficulty(0),
    m_enabled(true)
{
}

QString Dataset::objective() const
{
    return m_objective;
}

void Dataset::setObjective(const QString &objective)
{
    m_objective = objective;
    Q_EMIT objectiveChanged();
}

quint32 Dataset::difficulty() const
{
    return m_difficulty;
}
void Dataset::setDifficulty(const quint32 &difficulty)
{
    m_difficulty = difficulty;
    Q_EMIT difficultyChanged();
}

QVariant Dataset::data() const
{
    return m_data;
}
void Dataset::setData(const QVariant &data)
{
    m_data = data;
    Q_EMIT dataChanged();
}

bool Dataset::enabled() const
{
    return m_enabled;
}
void Dataset::setEnabled(const bool &enabled)
{
    m_enabled = enabled;
    Q_EMIT enabledChanged();
}

#include "moc_Dataset.cpp"
