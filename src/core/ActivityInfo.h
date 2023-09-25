/* GCompris - ActivityInfo.h
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef ACTIVITYINFO_H
#define ACTIVITYINFO_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlListProperty>
#include "Dataset.h"

/**
 * @class ActivityInfo
 * @short A QML component holding meta information about an activity.
 * @ingroup components
 *
 * Each GCompris activity has to provide some meta data about itself in form
 * of an ActivityInfo definition. This data will be used to register it in the
 * ActivityInfoTree, and populate the full screen help dialog.
 *
 * @sa DialogHelp
 */
class ActivityInfo : public QObject
{
    Q_OBJECT

    /**
     * Name of the main activity QML file.
     *
     * Example: "activity/Activity.qml"
     */
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

    /**
     * Section(s) this activity belongs to.
     *
     * An activity can belong to one or multiple activity sections
     * (separated by whitespace) out of:
     * computer, discovery, experiment, fun, math, puzzle,
     * reading, strategy.
     */
    Q_PROPERTY(QString section READ section WRITE setSection NOTIFY sectionChanged)

    /**
     * Difficulty of the activity.
     *
     * A difficulty level from 1 (easiest) to 6 (most difficult).
     */
    Q_PROPERTY(quint32 difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)

    /**
     * Minimal difficulty of the activity dataset.
     *
     * A difficulty level from 1 (easiest) to 6 (most difficult).
     */
    Q_PROPERTY(quint32 minimalDifficulty READ minimalDifficulty WRITE setMinimalDifficulty NOTIFY minimalDifficultyChanged)

    /**
     * Maximal difficulty of the activity dataset.
     *
     * A difficulty level from 1 (easiest) to 6 (most difficult).
     */
    Q_PROPERTY(quint32 maximalDifficulty READ maximalDifficulty WRITE setMaximalDifficulty NOTIFY maximalDifficultyChanged)

    /**
     * Relative path to the icon of the activity.
     *
     * Example: "activity/activity.svg"
     */
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)

    /**
     * Author of the activity.
     */
    Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)

    /**
     * Title of the activity.
     */
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

    /**
     * Description of the activity.
     */
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

    /**
     * Goal that this activity wants to achieve.
     */
    Q_PROPERTY(QString goal READ goal WRITE setGoal NOTIFY goalChanged)

    /**
     * Prerequisite for using this activity.
     */
    Q_PROPERTY(QString prerequisite READ prerequisite WRITE setPrerequisite NOTIFY prerequisiteChanged)

    /**
     * Manual describing the activity's usage.
     */
    Q_PROPERTY(QString manual READ manual WRITE setManual NOTIFY manualChanged)

    /**
     * Credits to third parties.
     */
    Q_PROPERTY(QString credit READ credit WRITE setCredit NOTIFY creditChanged)

    Q_PROPERTY(bool favorite READ favorite WRITE setFavorite NOTIFY favoriteChanged)

    /**
     * This activity is enabled.
     */
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    /**
     * Version in which this activity has been created
     */
    Q_PROPERTY(int createdInVersion READ createdInVersion WRITE setCreatedInVersion NOTIFY createdInVersionChanged)

    /**
     * Contains a list of string defining the folder names for the different datasets.
     */
    Q_PROPERTY(QStringList levels READ levels WRITE setLevels NOTIFY levelsChanged)

    /**
     * Current datasets used for the activity (it is among the 'levels' list)
     */
    Q_PROPERTY(QStringList currentLevels READ currentLevels WRITE setCurrentLevels NOTIFY currentLevelsChanged)

    /**
     * True if the activity has a configuration
     */
    Q_PROPERTY(bool hasConfig READ hasConfig CONSTANT)

    /**
     * True if the activity has a dataset
     */
    Q_PROPERTY(bool hasDataset READ hasDataset CONSTANT)

public:
    /// @cond INTERNAL_DOCS
    explicit ActivityInfo(QObject *parent = nullptr);

    QString name() const;
    void setName(const QString &);
    QString section() const;
    void setSection(const QString &);
    quint32 difficulty() const;
    void setDifficulty(const quint32 &);
    quint32 minimalDifficulty() const;
    void setMinimalDifficulty(const quint32 &);
    quint32 maximalDifficulty() const;
    void setMaximalDifficulty(const quint32 &);
    QString icon() const;
    void setIcon(const QString &);
    QString author() const;
    void setAuthor(const QString &);
    QString title() const;
    void setTitle(const QString &);
    QString description() const;
    void setDescription(const QString &);
    QString goal() const;
    void setGoal(const QString &);
    QString prerequisite() const;
    void setPrerequisite(const QString &);
    QString manual() const;
    void setManual(const QString &);
    QString credit() const;
    void setCredit(const QString &);
    bool favorite() const;
    void setFavorite(const bool);
    bool enabled() const;
    void setEnabled(const bool);
    int createdInVersion() const;
    void setCreatedInVersion(const int);
    QStringList levels() const;
    void setLevels(const QStringList &);
    QStringList currentLevels() const;
    void setCurrentLevels(const QStringList &);
    bool hasConfig() const;
    bool hasDataset() const;
    QQmlListProperty<Dataset> datasets();
    void fillDatasets(QQmlEngine *engine);
    void enableDatasetsBetweenDifficulties(quint32 levelMin, quint32 levelMax);

    void addDataset(const QString &name, Dataset *dataset);
    Q_INVOKABLE Dataset *getDataset(const QString &name) const;

    /*
     * Reset all the current levels to be enabled.
     */
    void resetLevels();

Q_SIGNALS:
    void nameChanged();
    void sectionChanged();
    void difficultyChanged();
    void minimalDifficultyChanged();
    void maximalDifficultyChanged();
    void iconChanged();
    void authorChanged();
    void titleChanged();
    void descriptionChanged();
    void goalChanged();
    void prerequisiteChanged();
    void manualChanged();
    void creditChanged();
    void favoriteChanged();
    void enabledChanged();
    void createdInVersionChanged();
    void levelsChanged();
    void currentLevelsChanged();
    void datasetsChanged();
    /// @endcond

private:
    QString m_name;
    QString m_section;
    quint32 m_difficulty;
    quint32 m_minimalDifficulty;
    quint32 m_maximalDifficulty;
    QString m_icon;
    QString m_author;
    QString m_title;
    QString m_description;
    QString m_goal;
    QString m_prerequisite;
    QString m_manual;
    QString m_credit;
    bool m_favorite;
    bool m_enabled;
    int m_createdInVersion;
    QStringList m_levels;
    QStringList m_currentLevels;

    /* The key is the name of the dataset */
    QMap<QString, Dataset *> m_datasets;
    /*
     * Set current level once we have the name and the levels
     */
    void setCurrentLevels();

    /*
     * Compute minimal and maximal difficulty depending on the current levels.
     */
    void computeMinMaxDifficulty();
};

#endif // ACTIVITYINFO_H
