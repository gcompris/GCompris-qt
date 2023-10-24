/* GCompris - ApplicationSettings.h
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <QObject>
#include <QQmlEngine>

#include <QSettings>
#include <QStandardPaths>

#include <config.h>

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
 * The <em>[Levels]</em> group is auto-generated from the levels chosen by
 * a user (if the activity provides multiple datasets).
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
     * Whether audio voices/speech should be enabled.
     */
    Q_PROPERTY(bool isAudioVoicesEnabled READ isAudioVoicesEnabled WRITE setIsAudioVoicesEnabled NOTIFY audioVoicesEnabledChanged)

    /**
     * Whether audio effects should be enabled.
     */
    Q_PROPERTY(bool isAudioEffectsEnabled READ isAudioEffectsEnabled WRITE setIsAudioEffectsEnabled NOTIFY audioEffectsEnabledChanged)

    /** Whether background music should be enabled.
     */
    Q_PROPERTY(bool isBackgroundMusicEnabled READ isBackgroundMusicEnabled WRITE setIsBackgroundMusicEnabled NOTIFY backgroundMusicEnabledChanged)

    /**
     * Whether GCompris should run in fullscreen mode.
     */
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)

    /**
     * Window Height on Application's Startup
     */
    Q_PROPERTY(quint32 previousHeight READ previousHeight WRITE setPreviousHeight NOTIFY previousHeightChanged)

    /**
     * Window Width on Application's Startup
     */
    Q_PROPERTY(quint32 previousWidth READ previousWidth WRITE setPreviousWidth NOTIFY previousWidthChanged)

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
     * Font letter spacing
     *
     * Change the letter spacing of all the texts
     * @sa font
     */
    Q_PROPERTY(qreal fontLetterSpacing READ fontLetterSpacing WRITE setFontLetterSpacing NOTIFY fontLetterSpacingChanged)

    /**
     * Minimum allowed value for font spacing letter.
     *
     * Constant value: +0.0
     */
    Q_PROPERTY(qreal fontLetterSpacingMin READ fontLetterSpacingMin CONSTANT)

    /**
     * Maximum allowed value for font spacing letter.
     *
     * Constant value: +8.0
     */
    Q_PROPERTY(qreal fontLetterSpacingMax READ fontLetterSpacingMax CONSTANT)

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
     * Boolean to know if the difficulty level filter has been set via command-line option.
     * In this case, we hide the possibility to change the level in the configuration and we never override the levels in the GCompris config file.
     */
    Q_PROPERTY(bool filterLevelOverridedByCommandLineOption READ filterLevelOverridedByCommandLineOption WRITE setFilterLevelOverridedByCommandLineOption NOTIFY filterLevelOverridedByCommandLineOptionChanged)

    /**
     * Whether kiosk mode is currently active.
     */
    Q_PROPERTY(bool isKioskMode READ isKioskMode WRITE setKioskMode NOTIFY kioskModeChanged)

    /**
     * Whether the section selection row is visible in the menu view.
     */
    Q_PROPERTY(bool sectionVisible READ sectionVisible WRITE setSectionVisible NOTIFY sectionVisibleChanged)

    /**
     * When true a dialog will pop up when we try to exit asking for confirmation. In mobile devices, it will be true by default and on desktops, it will be false.
     */
    Q_PROPERTY(bool exitConfirmation READ exitConfirmation WRITE setExitConfirmation NOTIFY exitConfirmationChanged)

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
     * Stores the background music volume set by the user.
     */
    Q_PROPERTY(qreal backgroundMusicVolume READ backgroundMusicVolume WRITE setBackgroundMusicVolume NOTIFY backgroundMusicVolumeChanged)

    /**
     * Stores the audio effects volume set by the user.
     */
    Q_PROPERTY(qreal audioEffectsVolume READ audioEffectsVolume WRITE setAudioEffectsVolume NOTIFY audioEffectsVolumeChanged)

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

    /**
     * Path where resources are downloaded and stored.
     *
     * @sa DownloadManager
     */
    Q_PROPERTY(QString cachePath READ cachePath WRITE setCachePath NOTIFY cachePathChanged)

    /**
     * Return the platform specific path for storing data shared between apps
     *
     * On Android: /storage/emulated/0/GCompris (>= Android 4.2),
     *             /storage/sdcard0/GCompris (< Android 4.2)
     * On Linux: $HOME/local/share/GCompris
     */
    Q_PROPERTY(QString userDataPath READ userDataPath WRITE setUserDataPath NOTIFY userDataPathChanged)

    /**
     * Define the renderer used.
     * Either openGL or software renderer (only for Qt >= 5.8)
     */
    Q_PROPERTY(QString renderer READ renderer WRITE setRenderer NOTIFY rendererChanged)

    /**
     * Stores the filtered background music playlist by the user.
     */
    Q_PROPERTY(QStringList filteredBackgroundMusic READ filteredBackgroundMusic WRITE setFilteredBackgroundMusic NOTIFY filteredBackgroundMusicChanged)

    // internal group
    Q_PROPERTY(quint32 exeCount READ exeCount WRITE setExeCount NOTIFY exeCountChanged)

    // keep last version ran. If different than ApplicationInfo.GCVersionCode(), it means a new version is running
    Q_PROPERTY(int lastGCVersionRan READ lastGCVersionRan WRITE setLastGCVersionRan NOTIFY lastGCVersionRanChanged)

    // no group
    Q_PROPERTY(bool isBarHidden READ isBarHidden WRITE setBarHidden NOTIFY barHiddenChanged)

public:
    /// @cond INTERNAL_DOCS
#if defined(UBUNTUTOUCH)
    explicit ApplicationSettings(const QString &configPath = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation)
                                     + "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                                 QObject *parent = 0);
#else
    explicit ApplicationSettings(const QString &configPath = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation)
                                     + "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                                 QObject *parent = nullptr);
#endif
    virtual ~ApplicationSettings();
    // It is not recommended to create a singleton of Qml Singleton registered
    // object but we could not found a better way to let us access ApplicationInfo
    // on the C++ side. All our test shows that it works.
    static ApplicationSettings *getInstance()
    {
        if (!m_instance) {
            m_instance = new ApplicationSettings();
        }
        return m_instance;
    }
    static QObject *applicationSettingsProvider(QQmlEngine *engine,
                                                QJSEngine *scriptEngine);

    bool isAudioVoicesEnabled() const { return m_isAudioVoicesEnabled; }
    void setIsAudioVoicesEnabled(const bool newMode)
    {
        m_isAudioVoicesEnabled = newMode;
        Q_EMIT audioVoicesEnabledChanged();
    }

    bool isAudioEffectsEnabled() const { return m_isAudioEffectsEnabled; }
    void setIsAudioEffectsEnabled(const bool newMode)
    {
        m_isAudioEffectsEnabled = newMode;
        Q_EMIT audioEffectsEnabledChanged();
    }

    bool isBackgroundMusicEnabled() const { return m_isBackgroundMusicEnabled; }
    void setIsBackgroundMusicEnabled(const bool newMode)
    {
        m_isBackgroundMusicEnabled = newMode;
        Q_EMIT backgroundMusicEnabledChanged();
    }

    bool isFullscreen() const { return m_isFullscreen; }
    void setFullscreen(const bool newMode)
    {
        if (m_isFullscreen != newMode) {
            m_isFullscreen = newMode;
            Q_EMIT fullscreenChanged();
        }
    }

    quint32 previousHeight() const { return m_previousHeight; }
    void setPreviousHeight(quint32 height)
    {
        if (m_previousHeight != height) {
            m_previousHeight = height;
            Q_EMIT previousHeightChanged();
        }
    }

    quint32 previousWidth() const { return m_previousWidth; }
    void setPreviousWidth(quint32 width)
    {
        if (m_previousWidth != width) {
            m_previousWidth = width;
            Q_EMIT previousWidthChanged();
        }
    }

    bool isVirtualKeyboard() const { return m_isVirtualKeyboard; }
    void setVirtualKeyboard(const bool newMode)
    {
        m_isVirtualKeyboard = newMode;
        Q_EMIT virtualKeyboardChanged();
    }

    QString locale() const
    {
        return m_locale;
    }
    void setLocale(const QString &newLocale)
    {
        m_locale = newLocale;
        Q_EMIT localeChanged();
    }

    QString font() const { return m_font; }
    void setFont(const QString &newFont)
    {
        m_font = newFont;
        Q_EMIT fontChanged();
    }

    bool isEmbeddedFont() const { return m_isEmbeddedFont; }
    void setIsEmbeddedFont(const bool newIsEmbeddedFont)
    {
        m_isEmbeddedFont = newIsEmbeddedFont;
        Q_EMIT embeddedFontChanged();
    }

    quint32 fontCapitalization() const { return m_fontCapitalization; }
    void setFontCapitalization(quint32 newFontCapitalization)
    {
        m_fontCapitalization = newFontCapitalization;
        Q_EMIT fontCapitalizationChanged();
    }

    qreal fontLetterSpacing() const { return m_fontLetterSpacing; }
    void setFontLetterSpacing(qreal newFontLetterSpacing)
    {
        m_fontLetterSpacing = newFontLetterSpacing;
        Q_EMIT fontLetterSpacingChanged();
    }

    qreal fontLetterSpacingMin() const { return m_fontLetterSpacingMin; }
    qreal fontLetterSpacingMax() const { return m_fontLetterSpacingMax; }

    bool isAutomaticDownloadsEnabled() const;
    void setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled);

    quint32 filterLevelMin() const { return m_filterLevelMin; }
    void setFilterLevelMin(const quint32 newFilterLevelMin)
    {
        m_filterLevelMin = newFilterLevelMin;
        Q_EMIT filterLevelMinChanged();
    }

    quint32 filterLevelMax() const { return m_filterLevelMax; }
    void setFilterLevelMax(const quint32 newFilterLevelMax)
    {
        m_filterLevelMax = newFilterLevelMax;
        Q_EMIT filterLevelMaxChanged();
    }

    bool filterLevelOverridedByCommandLineOption() const { return m_filterLevelOverridedByCommandLineOption; }
    void setFilterLevelOverridedByCommandLineOption(const bool newValue)
    {
        m_filterLevelOverridedByCommandLineOption = newValue;
        Q_EMIT filterLevelOverridedByCommandLineOptionChanged();
    }

    bool isKioskMode() const { return m_isKioskMode; }
    void setKioskMode(const bool newMode)
    {
        m_isKioskMode = newMode;
        Q_EMIT kioskModeChanged();
    }

    bool sectionVisible() const { return m_sectionVisible; }
    void setSectionVisible(const bool newMode)
    {
        m_sectionVisible = newMode;
        Q_EMIT sectionVisibleChanged();
    }

    bool exitConfirmation() const { return m_exitConfirmation; }
    void setExitConfirmation(const bool newMode)
    {
        m_exitConfirmation = newMode;
        Q_EMIT exitConfirmationChanged();
    }

    QString downloadServerUrl() const { return m_downloadServerUrl; }
    void setDownloadServerUrl(const QString &newDownloadServerUrl)
    {
        m_downloadServerUrl = newDownloadServerUrl;
        Q_EMIT downloadServerUrlChanged();
    }

    QString cachePath() const { return m_cachePath; }
    void setCachePath(const QString &newCachePath)
    {
        m_cachePath = newCachePath;
        Q_EMIT cachePathChanged();
    }

    QString userDataPath() const { return m_userDataPath; }
    void setUserDataPath(const QString &newUserDataPath)
    {
        m_userDataPath = newUserDataPath;
        Q_EMIT userDataPathChanged();
    }
    quint32 exeCount() const { return m_exeCount; }
    void setExeCount(const quint32 newExeCount)
    {
        m_exeCount = newExeCount;
        Q_EMIT exeCountChanged();
    }

    bool isBarHidden() const { return m_isBarHidden; }
    void setBarHidden(const bool newBarHidden)
    {
        m_isBarHidden = newBarHidden;
        Q_EMIT barHiddenChanged();
    }

    int baseFontSize() const { return m_baseFontSize; }
    void setBaseFontSize(const int newBaseFontSize)
    {
        m_baseFontSize = qMax(qMin(newBaseFontSize, baseFontSizeMax()), baseFontSizeMin());
        Q_EMIT baseFontSizeChanged();
    }

    int baseFontSizeMin() const { return m_baseFontSizeMin; }
    int baseFontSizeMax() const { return m_baseFontSizeMax; }

    qreal backgroundMusicVolume() const { return m_backgroundMusicVolume; }
    void setBackgroundMusicVolume(const qreal newBackgroundMusicVolume)
    {
        m_backgroundMusicVolume = newBackgroundMusicVolume;
        Q_EMIT backgroundMusicVolumeChanged();
    }

    qreal audioEffectsVolume() const { return m_audioEffectsVolume; }
    void setAudioEffectsVolume(const qreal newAudioEffectsVolume)
    {
        m_audioEffectsVolume = newAudioEffectsVolume;
        Q_EMIT audioEffectsVolumeChanged();
    }

    int lastGCVersionRan() const { return m_lastGCVersionRan; }
    void setLastGCVersionRan(const int newLastGCVersionRan)
    {
        m_lastGCVersionRan = newLastGCVersionRan;
        Q_EMIT lastGCVersionRanChanged();
    }

    QString renderer() const { return m_renderer; }
    void setRenderer(const QString &newRenderer)
    {
        m_renderer = newRenderer;
        Q_EMIT rendererChanged();
    }

    QStringList filteredBackgroundMusic() const { return m_filteredBackgroundMusic; }
    void setFilteredBackgroundMusic(const QStringList &newFilteredBackgroundMusic)
    {
        m_filteredBackgroundMusic = newFilteredBackgroundMusic;
        Q_EMIT filteredBackgroundMusicChanged();
    }

    /**
     * Check if we use the external wordset for activity based on lang_api
     * @returns  true if wordset is loaded
     *           false if wordset is not loaded
     */
    Q_INVOKABLE bool useExternalWordset();

    void setDifficultyFromCommandLine(quint32 newFilterLevelMin, quint32 newFilterLevelMax)
    {
        m_filterLevelOverridedByCommandLineOption = true;
        setFilterLevelMin(newFilterLevelMin);
        setFilterLevelMax(newFilterLevelMax);
    }

protected Q_SLOTS:

    Q_INVOKABLE void notifyAudioVoicesEnabledChanged();
    Q_INVOKABLE void notifyAudioEffectsEnabledChanged();
    Q_INVOKABLE void notifyBackgroundMusicEnabledChanged();
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void notifyPreviousHeightChanged();
    Q_INVOKABLE void notifyPreviousWidthChanged();
    Q_INVOKABLE void notifyVirtualKeyboardChanged();
    Q_INVOKABLE void notifyLocaleChanged();
    Q_INVOKABLE void notifyFontChanged();
    Q_INVOKABLE void notifyFontCapitalizationChanged();
    Q_INVOKABLE void notifyFontLetterSpacingChanged();
    Q_INVOKABLE void notifyEmbeddedFontChanged();
    Q_INVOKABLE void notifyAutomaticDownloadsEnabledChanged();
    Q_INVOKABLE void notifyFilterLevelMinChanged();
    Q_INVOKABLE void notifyFilterLevelMaxChanged();
    Q_INVOKABLE void notifyKioskModeChanged();
    Q_INVOKABLE void notifySectionVisibleChanged();
    Q_INVOKABLE void notifyExitConfirmationChanged();
    Q_INVOKABLE void notifyFilteredBackgroundMusicChanged();
    Q_INVOKABLE void notifyBackgroundMusicVolumeChanged();
    Q_INVOKABLE void notifyAudioEffectsVolumeChanged();

    Q_INVOKABLE void notifyDownloadServerUrlChanged();
    Q_INVOKABLE void notifyCachePathChanged();
    Q_INVOKABLE void notifyUserDataPathChanged();
    Q_INVOKABLE void notifyExeCountChanged();

    Q_INVOKABLE void notifyLastGCVersionRanChanged();
    Q_INVOKABLE void notifyRendererChanged();

    Q_INVOKABLE void notifyBarHiddenChanged();

public Q_SLOTS:
    Q_INVOKABLE bool isFavorite(const QString &activity);
    Q_INVOKABLE void setFavorite(const QString &activity, bool favorite);
    Q_INVOKABLE void setCurrentLevels(const QString &activity, const QStringList &level, bool sync = true);
    Q_INVOKABLE QStringList currentLevels(const QString &activity);

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

    /**
     * Loads per-activity progress using the default "progress" key.
     *
     * @param activity Name of the activity to load progress for.
     * @returns Last started level of the activity, 0 if none saved.
     */
    Q_INVOKABLE int loadActivityProgress(const QString &activity);

    /**
     * Saves per-activity progress using the default "progress" key.
     *
     * @param activity Name of the activity that wants to persist settings.
     * @param progress Last started level to save as progress value.
     */
    Q_INVOKABLE void saveActivityProgress(const QString &activity, int progress);
    /**
     * Synchronize the changes done in the application in the configuration file.
     */
    Q_INVOKABLE void sync();

Q_SIGNALS:
    void audioVoicesEnabledChanged();
    void audioEffectsEnabledChanged();
    void backgroundMusicEnabledChanged();
    void fullscreenChanged();
    void previousHeightChanged();
    void previousWidthChanged();
    void virtualKeyboardChanged();
    void localeChanged();
    void fontChanged();
    void fontCapitalizationChanged();
    void fontLetterSpacingChanged();
    void embeddedFontChanged();
    void automaticDownloadsEnabledChanged();
    void filterLevelMinChanged();
    void filterLevelMaxChanged();
    void filterLevelOverridedByCommandLineOptionChanged();
    void kioskModeChanged();
    void sectionVisibleChanged();
    void exitConfirmationChanged();
    void baseFontSizeChanged();
    void filteredBackgroundMusicChanged();
    void backgroundMusicVolumeChanged();
    void audioEffectsVolumeChanged();

    void downloadServerUrlChanged();
    void cachePathChanged();
    void userDataPathChanged();

    void exeCountChanged();

    void lastGCVersionRanChanged();
    void rendererChanged();
    void barHiddenChanged();

protected:
    static ApplicationSettings *m_instance;

private:
    // Update in configuration the couple {key, value} in the group.
    template <class T>
    void updateValueInConfig(const QString &group,
                             const QString &key, const T &value, bool sync = true);

    bool m_isAudioVoicesEnabled;
    bool m_isAudioEffectsEnabled;
    bool m_isBackgroundMusicEnabled;
    bool m_isFullscreen;
    quint32 m_previousHeight;
    quint32 m_previousWidth;
    bool m_isVirtualKeyboard;
    bool m_isAutomaticDownloadsEnabled;
    bool m_isEmbeddedFont;
    quint32 m_fontCapitalization;
    qreal m_fontLetterSpacing;
    quint32 m_filterLevelMin;
    quint32 m_filterLevelMax;
    bool m_filterLevelOverridedByCommandLineOption = false;
    bool m_defaultCursor;
    bool m_noCursor;
    QString m_locale;
    QString m_font;
    bool m_isKioskMode;
    bool m_sectionVisible;
    bool m_exitConfirmation;
    QStringList m_filteredBackgroundMusic;
    qreal m_backgroundMusicVolume;
    qreal m_audioEffectsVolume;
    int m_baseFontSize;
    const int m_baseFontSizeMin;
    const int m_baseFontSizeMax;
    const qreal m_fontLetterSpacingMin;
    const qreal m_fontLetterSpacingMax;

    QString m_downloadServerUrl;
    QString m_cachePath;
    QString m_userDataPath;

    quint32 m_exeCount;

    int m_lastGCVersionRan;
    QString m_renderer;

    bool m_isBarHidden;

    QSettings m_config;
};

#endif // APPLICATIONSETTINGS_H
