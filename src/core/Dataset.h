/* GCompris - Dataset.h
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
class Dataset : public QObject
{
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
    /**
     * If the dataset is enabled.
     */
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

public:
    /// @cond INTERNAL_DOCS
    explicit Dataset(QObject *parent = nullptr);

    QString objective() const;
    void setObjective(const QString &);
    quint32 difficulty() const;
    void setDifficulty(const quint32 &);
    QVariant data() const;
    void setData(const QVariant &);
    bool enabled() const;
    void setEnabled(const bool &);
    /// @endcond
Q_SIGNALS:
    void objectiveChanged();
    void difficultyChanged();
    void dataChanged();
    void enabledChanged();

private:
    QString m_objective;
    quint32 m_difficulty;
    QVariant m_data;
    bool m_enabled;
};

#endif // DATASET_H
