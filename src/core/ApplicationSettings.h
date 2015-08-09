/* GCompris - ApplicationSettingsDefault.cpp
 *
 * Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <qqml.h>
#include <QtCore/QObject>
#include <QQmlEngine>
#include <QUrl>
#include <QtGlobal>
#include <QDebug>

#include <QSettings>

#define GC_DEFAULT_LOCALE "system"

/**
 * @class ApplicationSettings
 * @short Singleton that contains GCompris' persistent settings.
 * @ingroup infrastructure
 *
 * Settings are persisted using QSettings, which stores them in platform
 * specific locations.
 *
 * The settings are subdivided in different groups of settings.
 *
 * <em>[General]</em> settings are mostly changeable by users in the DialogConfig
 * dialog.
 *
 * <em>[Admin]</em> and <em>[Internal]</em> settings are not changeable by the
 * user and used for internal purposes. Should only be changed if you really know
 * what you are doing.
 *
 * The <em>[Favorite]</em> group is auto-generated from the favorite activities
 * selected by a user.
 *
 * Besides these global settings there is one group for each activity that
 * stores persistent settings.
 *
 * Settings defaults are defined in the source code.
 *
 * @sa DialogActivityConfig
 */
class ApplicationSettings : public QObject
{
	Q_OBJECT

	/* General group */

	/**
	 * Whether to show locked activities.
	 * False if in Demo mode, true otherwise.
	 */
    Q_PROPERTY(bool showLockedActivities READ showLockedActivities WRITE setShowLockedActivities NOTIFY showLockedActivitiesChanged)

    /**
     * Whether audio voices/speech should be enabled.
     */
	Q_PROPERTY(bool isAudioVoicesEnabled READ isAudioVoicesEnabled WRITE setIsAudioVoicesEnabled NOTIFY audioVoicesEnabledChanged)

    /**
     * Whether audio effects should be enabled.
     */
	Q_PROPERTY(bool isAudioEffectsEnabled READ isAudioEffectsEnabled WRITE setIsAudioEffectsEnabled NOTIFY audioEffectsEnabledChanged)

	/**
	 * Whether GCompris should run in fullscreen mode.
	 */
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)

    /**
     * Whether on-screen keyboard should be enabled per default in activities
     * that use it.
     */
    Q_PROPERTY(bool isVirtualKeyboard READ isVirtualKeyboard WRITE setVirtualKeyboard NOTIFY virtualKeyboardChanged)

    /**
     * Locale string for currently active language.
     */
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)

    /**
     * Currently selected font.
     */
    Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)

    /**
     * Whether currently active font is a shipped font (or a system font).
     *
     * Updated automatically.
     * @sa font
     */
    Q_PROPERTY(bool isEmbeddedFont READ isEmbeddedFont WRITE setIsEmbeddedFont NOTIFY embeddedFontChanged)

    /**
     * Font Capitalization
     *
     * Force all texts to be rendered in UpperCase, LowerCase or MixedCase (default)
     * @sa font
     */
    Q_PROPERTY(quint32 fontCapitalization READ fontCapitalization WRITE setFontCapitalization NOTIFY fontCapitalizationChanged)

    /**
     * Whether downloads/updates of resource files should be done automatically,
     * without user-interaction.
     *
     * Note, that on Android GCompris currently can't distinguish Wifi
     * from mobile data connections (cf. Qt ticket #30394).
     */
    Q_PROPERTY(bool isAutomaticDownloadsEnabled READ isAutomaticDownloadsEnabled WRITE setIsAutomaticDownloadsEnabled NOTIFY automaticDownloadsEnabledChanged)

    /**
     * Minimum value for difficulty level filter.
     */
    Q_PROPERTY(quint32 filterLevelMin READ filterLevelMin WRITE setFilterLevelMin NOTIFY filterLevelMinChanged)

    /**
     * Maximum value for difficulty level filter.
     */
    Q_PROPERTY(quint32 filterLevelMax READ filterLevelMax WRITE setFilterLevelMax NOTIFY filterLevelMaxChanged)

    /**
     * Whether in demo mode.
     */
    Q_PROPERTY(bool isDemoMode READ isDemoMode WRITE setDemoMode NOTIFY demoModeChanged)

    /**
     * Whether kiosk mode is currently active.
     */
    Q_PROPERTY(bool isKioskMode READ isKioskMode WRITE setKioskMode NOTIFY kioskModeChanged)

    /**
     * Whether the section selection row is visible in the menu view.
     */
    Q_PROPERTY(bool sectionVisible READ sectionVisible WRITE setSectionVisible NOTIFY sectionVisibleChanged)

    /**
     * Current base font-size used for font scaling.
     *
     * This setting is the basis for application-wide font-scaling. A value
     * of 0 means to use the font-size as set by the application. Other values
     * between @ref baseFontSizeMin and @ref baseFontSizeMax enforce
     * font-scaling.
     *
     * @sa GCText.fontSize baseFontSizeMin baseFontSizeMax
     */
    Q_PROPERTY(int baseFontSize READ baseFontSize WRITE setBaseFontSize NOTIFY baseFontSizeChanged)

    /**
     * Minimum allowed value for font-scaling.
     *
     * Constant value: -7
     */
    Q_PROPERTY(int baseFontSizeMin READ baseFontSizeMin CONSTANT)

    /**
     * Maximum allowed value for font-scaling.
     *
     * Constant value: +7
     */
    Q_PROPERTY(int baseFontSizeMax READ baseFontSizeMax CONSTANT)

    // admin group

    /**
     * Base-URL for resource downloads.
     *
     * @sa DownloadManager
     */
    Q_PROPERTY(QString downloadServerUrl READ downloadServerUrl WRITE setDownloadServerUrl NOTIFY downloadServerUrlChanged)

    // internal group
    Q_PROPERTY(quint32 exeCount READ exeCount WRITE setExeCount NOTIFY exeCountChanged)

	// no group
	Q_PROPERTY(bool isBarHidden READ isBarHidden WRITE setBarHidden NOTIFY barHiddenChanged)

public:
	/// @cond INTERNAL_DOCS
    explicit ApplicationSettings(QObject *parent = 0);
    ~ApplicationSettings();
    static void init();
    // It is not recommended to create a singleton of Qml Singleton registered
    // object but we could not found a better way to let us access ApplicationInfo
    // on the C++ side. All our test shows that it works.
    static ApplicationSettings *getInstance() {
        if(!m_instance) {
            m_instance = new ApplicationSettings();
        }
        return m_instance;
    }
    static QObject *systeminfoProvider(QQmlEngine *engine,
                                       QJSEngine *scriptEngine);

    bool showLockedActivities() const { return m_showLockedActivities; }
    void setShowLockedActivities(const bool newMode) {
        m_showLockedActivities = newMode;
        emit showLockedActivitiesChanged();
    }

    bool isAudioVoicesEnabled() const { return m_isAudioVoicesEnabled; }
    void setIsAudioVoicesEnabled(const bool newMode) {
        m_isAudioVoicesEnabled = newMode;
        emit audioVoicesEnabledChanged();
    }

	bool isAudioEffectsEnabled() const { return m_isAudioEffectsEnabled; }
	void setIsAudioEffectsEnabled(const bool newMode) {
		m_isAudioEffectsEnabled = newMode;
		emit audioEffectsEnabledChanged();
    }

    bool isFullscreen() const { return m_isFullscreen; }
    void setFullscreen(const bool newMode) {
        if(m_isFullscreen != newMode) {
            m_isFullscreen = newMode;
            emit fullscreenChanged();
        }
    }

    bool isVirtualKeyboard() const { return m_isVirtualKeyboard; }
    void setVirtualKeyboard(const bool newMode) {
        m_isVirtualKeyboard = newMode;
        emit virtualKeyboardChanged();
    }

    QString locale() const {
        return m_locale;
    }
    void setLocale(const QString newLocale) {
        m_locale = newLocale;
        emit localeChanged();
    }

    QString font() const { return m_font; }
    void setFont(const QString newFont) {
        m_font = newFont;
        emit fontChanged();
    }

    bool isEmbeddedFont() const { return m_isEmbeddedFont; }
    void setIsEmbeddedFont(const bool newIsEmbeddedFont) {
        m_isEmbeddedFont = newIsEmbeddedFont;
        emit embeddedFontChanged();
    }

    quint32 fontCapitalization() const { return m_fontCapitalization; }
    void setFontCapitalization(quint32 newFontCapitalization) {
        m_fontCapitalization = newFontCapitalization;
        emit fontCapitalizationChanged();
    }

    bool isAutomaticDownloadsEnabled() const;
    void setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled);

    quint32 filterLevelMin() const { return m_filterLevelMin; }
    void setFilterLevelMin(const quint32 newFilterLevelMin) {
        m_filterLevelMin = newFilterLevelMin;
        emit filterLevelMinChanged();
    }

    quint32 filterLevelMax() const { return m_filterLevelMax; }
    void setFilterLevelMax(const quint32 newFilterLevelMax) {
        m_filterLevelMax = newFilterLevelMax;
        emit filterLevelMaxChanged();
    }

    bool isDemoMode() const { return m_isDemoMode; }
    void setDemoMode(const bool newMode);

    bool isKioskMode() const { return m_isKioskMode; }
    void setKioskMode(const bool newMode) {
        m_isKioskMode = newMode;
        emit kioskModeChanged();
    }

    // Payment API
    // Call a payment system to sync our demoMode state with it
    void checkPayment();
    // Called by the payment system
    void bought(const bool isBought) {
        if(m_isDemoMode != !isBought) {
            m_isDemoMode = !isBought;
            emit demoModeChanged();
        }
	}

	bool sectionVisible() const { return m_sectionVisible; }
	void setSectionVisible(const bool newMode) {
		qDebug() << "c++ setSectionVisible=" << newMode;
		m_sectionVisible = newMode;
		emit sectionVisibleChanged();
	}

	QString downloadServerUrl() const { return m_downloadServerUrl; }
    void setDownloadServerUrl(const QString newDownloadServerUrl) {
        m_downloadServerUrl = newDownloadServerUrl;
        emit downloadServerUrlChanged();
    }

    quint32 exeCount() const { return m_exeCount; }
    void setExeCount(const quint32 newExeCount) {
        m_exeCount = newExeCount;
        emit exeCountChanged();
    }

    bool isBarHidden() const { return m_isBarHidden; }
    void setBarHidden(const bool newBarHidden) {
        m_isBarHidden = newBarHidden;
        emit barHiddenChanged();
    }

    int baseFontSize() const { return m_baseFontSize; }
    void setBaseFontSize(const int newBaseFontSize) {
        m_baseFontSize = qMax(qMin(newBaseFontSize, baseFontSizeMax()), baseFontSizeMin());
        emit baseFontSizeChanged();
    }

    int baseFontSizeMin() const { return m_baseFontSizeMin; }
    int baseFontSizeMax() const { return m_baseFontSizeMax; }

protected slots:

    Q_INVOKABLE void notifyShowLockedActivitiesChanged();
	Q_INVOKABLE void notifyAudioVoicesEnabledChanged();
	Q_INVOKABLE void notifyAudioEffectsEnabledChanged();
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void notifyVirtualKeyboardChanged();
    Q_INVOKABLE void notifyLocaleChanged();
    Q_INVOKABLE void notifyFontChanged();
    Q_INVOKABLE void notifyFontCapitalizationChanged();
    Q_INVOKABLE void notifyEmbeddedFontChanged();
    Q_INVOKABLE void notifyAutomaticDownloadsEnabledChanged();
    Q_INVOKABLE void notifyFilterLevelMinChanged();
    Q_INVOKABLE void notifyFilterLevelMaxChanged();
    Q_INVOKABLE void notifyDemoModeChanged();
    Q_INVOKABLE void notifyKioskModeChanged();
    Q_INVOKABLE void notifySectionVisibleChanged();

    Q_INVOKABLE void notifyDownloadServerUrlChanged();

    Q_INVOKABLE void notifyExeCountChanged();

    Q_INVOKABLE void notifyBarHiddenChanged();

public slots:
	Q_INVOKABLE bool isFavorite(const QString &activity);
	Q_INVOKABLE void setFavorite(const QString &activity, bool favorite);
    Q_INVOKABLE void saveBaseFontSize();
    /// @endcond

    /**
     * Stores per-activity configuration @p data for @p activity.
     *
     * @param activity Name of the activity that wants to persist settings.
     * @param data Map of configuration data so save.
     */
    Q_INVOKABLE void saveActivityConfiguration(const QString &activity, const QVariantMap &data);

    /**
     * Loads per-activity configuration data for @p activity.
     *
     * @param activity Name of the activity that wants to persist settings.
     * @returns Map of configuration items.
     */
    Q_INVOKABLE QVariantMap loadActivityConfiguration(const QString &activity);

signals:
    void showLockedActivitiesChanged();
	void audioVoicesEnabledChanged();
	void audioEffectsEnabledChanged();
    void fullscreenChanged();
    void virtualKeyboardChanged();
    void localeChanged();
    void fontChanged();
    void fontCapitalizationChanged();
    void embeddedFontChanged();
    void automaticDownloadsEnabledChanged();
    void filterLevelMinChanged();
    void filterLevelMaxChanged();
    void demoModeChanged();
    void kioskModeChanged();
    void sectionVisibleChanged();
    void baseFontSizeChanged();

    void downloadServerUrlChanged();

    void exeCountChanged();

    void barHiddenChanged();

private:

    // Update in configuration the couple {key, value} in the group.
    template<class T> void updateValueInConfig(const QString& group,
                                         const QString& key, const T& value);

    static ApplicationSettings *m_instance;

    bool m_showLockedActivities;
    bool m_isAudioVoicesEnabled;
	bool m_isAudioEffectsEnabled;
    bool m_isFullscreen;
    bool m_isVirtualKeyboard;
    bool m_isAutomaticDownloadsEnabled;
    bool m_isEmbeddedFont;
    quint32 m_fontCapitalization;
    quint32 m_filterLevelMin;
    quint32 m_filterLevelMax;
	bool m_defaultCursor;
	bool m_noCursor;
    QString m_locale;
    QString m_font;
    bool m_isDemoMode;
    bool m_isKioskMode;
    bool m_sectionVisible;
	int m_baseFontSize;
	const int m_baseFontSizeMin;
	const int m_baseFontSizeMax;

    QString m_downloadServerUrl;

    quint32 m_exeCount;

    bool m_isBarHidden;

    QSettings m_config;
};

#endif // APPLICATIONSETTINGS_H
