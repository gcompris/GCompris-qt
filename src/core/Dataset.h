/* GCompris - Dataset.h
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

#ifndef DATASET_H
#define DATASET_H

#include <QObject>
#include <QString>
#include <QVariant>

/**
 * @class Dataset
 * @short A QML component holding meta information about a dataset.
 * @ingroup components
 *
 * Each GCompris activity may provide some datasets for its content.
 * This class stores all the meta information required to define a dataset.
 * This data will be displayed in the Activity Configuration panel (difficulty + objective)
 * and used in the activity itself (data).
 *
 * @sa ActivityInfo
 */
class Dataset : public QObject {
    Q_OBJECT

    /**
     * Objective of this dataset.
     */
    Q_PROPERTY(QString objective READ objective WRITE setObjective NOTIFY objectiveChanged)

    /**
     * Difficulty of the dataset.
     *
     * A difficulty level from 1 (easiest) to 6 (most difficult).
     */
    Q_PROPERTY(quint32 difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    /**
     * Content of the dataset (json array).
     */
    Q_PROPERTY(QVariant data READ data WRITE setData NOTIFY dataChanged)

public:
    /// @cond INTERNAL_DOCS
    explicit Dataset(QObject *parent = 0);

    QString objective() const;
    void setObjective(const QString &);
    quint32 difficulty() const;
    void setDifficulty(const quint32 &);
    QVariant data() const;
    void setData(const QVariant &data);

signals:
    void objectiveChanged();
    void difficultyChanged();
    void dataChanged();

private:
    QString m_objective;
    quint32 m_difficulty;
    QVariant m_data;
};

#endif // DATASET_H
