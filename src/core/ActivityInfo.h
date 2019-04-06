/* GCompris - ActivityInfo.h
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
#ifndef ACTIVITYINFO_H
#define ACTIVITYINFO_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlListProperty>

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
     * Whether the activity is part of the demo version of GCompris.
     */
    Q_PROPERTY(bool demo READ demo WRITE setDemo NOTIFY demoChanged)

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
     * Current dataset used for the activity (it is among the 'levels' list)
     */
    Q_PROPERTY(QString currentLevel READ currentLevel WRITE setCurrentLevel NOTIFY currentLevelChanged)

public:
	/// @cond INTERNAL_DOCS
	explicit ActivityInfo(QObject *parent = 0);

	QString name() const;
	void setName(const QString &);
	QString section() const;
	void setSection(const QString &);
        quint32 difficulty() const;
	void setDifficulty(const quint32 &);
	QString icon() const;
	void setIcon(const QString &);
	QString author() const;
	void setAuthor(const QString &);
	bool demo() const;
	void setDemo(const bool &);
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
        void setLevels(const QStringList&);
        QString currentLevel() const;
        void setCurrentLevel(const QString&);

signals:
	void nameChanged();
	void sectionChanged();
	void difficultyChanged();
	void iconChanged();
	void authorChanged();
	void demoChanged();
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
	void currentLevelChanged();
	/// @endcond
private:
	QString m_name;
	QString m_section;
	quint32 m_difficulty;
	QString m_icon;
	QString m_author;
	bool m_demo;
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
	QString m_currentLevel;

	/*
         * Set current level once we have the name and the levels
         */
	void setCurrentLevel();
};

#endif // ACTIVITYINFO_H
