/* GCompris - ApplicationSettings.cpp
 *
 * SPDX-FileCopyrightText: 2014-2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "ApplicationSettings.h"
#include "ApplicationInfo.h"

#include "DownloadManager.h"

#include <qmath.h>
#include <QGuiApplication>
#include <QScreen>
#include <QRect>

#include <QtQml>

namespace {
    const char *GC_DEFAULT_FONT = "Andika-R.ttf";
    constexpr int GC_DEFAULT_FONT_CAPITALIZATION = 0; // Font.MixedCase
    constexpr int GC_DEFAULT_FONT_LETTER_SPACING = 0;

    const char *GENERAL_GROUP_KEY = "General";
    const char *ADMIN_GROUP_KEY = "Admin";
    const char *INTERNAL_GROUP_KEY = "Internal";
    const char *FAVORITE_GROUP_KEY = "Favorite";
    const char *LEVELS_GROUP_KEY = "Levels";

    const char *FULLSCREEN_KEY = "fullscreen";
    const char *PREVIOUS_HEIGHT_KEY = "previousHeight";
    const char *PREVIOUS_WIDTH_KEY = "previousWidth";
    const char *ENABLE_AUDIO_VOICES_KEY = "enableAudioVoices";
    const char *ENABLE_AUDIO_EFFECTS_KEY = "enableAudioEffects";
    const char *ENABLE_BACKGROUND_MUSIC_KEY = "enableBackgroundMusic";
    const char *VIRTUALKEYBOARD_KEY = "virtualKeyboard";
    const char *LOCALE_KEY = "locale";
    const char *FONT_KEY = "font";
    const char *IS_CURRENT_FONT_EMBEDDED = "isCurrentFontEmbedded";
    const char *ENABLE_AUTOMATIC_DOWNLOADS = "enableAutomaticDownloads";
    const char *FILTERED_BACKGROUND_MUSIC_KEY = "filteredBackgroundMusic";
    const char *BACKGROUND_MUSIC_VOLUME_KEY = "backgroundMusicVolume";
    const char *AUDIO_EFFECTS_VOLUME_KEY = "audioEffectsVolume";

    const char *DOWNLOAD_SERVER_URL_KEY = "downloadServerUrl";
    const char *CACHE_PATH_KEY = "cachePath";
    const char *USERDATA_PATH_KEY = "userDataPath";
    const char *RENDERER_KEY = "renderer";

    const char *EXE_COUNT_KEY = "exeCount";
    const char *LAST_GC_VERSION_RAN = "lastGCVersionRan";

    const char *FILTER_LEVEL_MIN = "filterLevelMin";
    const char *FILTER_LEVEL_MAX = "filterLevelMax";

    const char *BASE_FONT_SIZE_KEY = "baseFontSize";
    const char *FONT_CAPITALIZATION = "fontCapitalization";
    const char *FONT_LETTER_SPACING = "fontLetterSpacing";

    const char *DEFAULT_CURSOR = "defaultCursor";
    const char *NO_CURSOR = "noCursor";
    const char *KIOSK_KEY = "kiosk";
    const char *SECTION_VISIBLE = "sectionVisible";
    const char *EXIT_CONFIRMATION = "exitConfirmation";

    const char *PROGRESS_KEY = "progress";

    const char *DEFAULT_DOWNLOAD_SERVER = "https://cdn.kde.org/gcompris";
}

ApplicationSettings *ApplicationSettings::m_instance = nullptr;

ApplicationSettings::ApplicationSettings(const QString &configPath, QObject *parent) :
    QObject(parent),
    m_baseFontSizeMin(-7), m_baseFontSizeMax(7),
    m_fontLetterSpacingMin(0.0), m_fontLetterSpacingMax(8.0),
    m_config(configPath, QSettings::IniFormat)
{
    const QRect &screenSize = QGuiApplication::screens().at(0)->availableGeometry();
    // initialize from settings file or default

    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
    m_isAudioEffectsEnabled = m_config.value(ENABLE_AUDIO_EFFECTS_KEY, true).toBool();
    m_isBackgroundMusicEnabled = m_config.value(ENABLE_BACKGROUND_MUSIC_KEY, true).toBool();
    m_isFullscreen = m_config.value(FULLSCREEN_KEY, true).toBool();
    m_previousHeight = m_config.value(PREVIOUS_HEIGHT_KEY, screenSize.height()).toUInt();
    m_previousWidth = m_config.value(PREVIOUS_WIDTH_KEY, screenSize.width()).toUInt();
    m_isAudioVoicesEnabled = m_config.value(ENABLE_AUDIO_VOICES_KEY, true).toBool();
    m_isVirtualKeyboard = m_config.value(VIRTUALKEYBOARD_KEY,
                                         ApplicationInfo::getInstance()->isMobile())
                              .toBool();
    m_locale = m_config.value(LOCALE_KEY, GC_DEFAULT_LOCALE).toString();
    m_font = m_config.value(FONT_KEY, QLatin1String(GC_DEFAULT_FONT)).toString();
    if (m_font == QLatin1String("Andika-R.otf"))
        m_font = "Andika-R.ttf";
    m_fontCapitalization = m_config.value(FONT_CAPITALIZATION, GC_DEFAULT_FONT_CAPITALIZATION).toUInt();
    m_fontLetterSpacing = m_config.value(FONT_LETTER_SPACING, GC_DEFAULT_FONT_LETTER_SPACING).toReal();
    m_isEmbeddedFont = m_config.value(IS_CURRENT_FONT_EMBEDDED, true).toBool();
    m_filteredBackgroundMusic = m_config.value(FILTERED_BACKGROUND_MUSIC_KEY, ApplicationInfo::getInstance()->getBackgroundMusicFromRcc()).toStringList();
    m_backgroundMusicVolume = m_config.value(BACKGROUND_MUSIC_VOLUME_KEY, 0.2).toReal();
    m_audioEffectsVolume = m_config.value(AUDIO_EFFECTS_VOLUME_KEY, 0.7).toReal();

#if defined(WITH_KIOSK_MODE)
    m_isKioskMode = m_config.value(KIOSK_KEY, true).toBool();
#else
    m_isKioskMode = m_config.value(KIOSK_KEY, false).toBool();
#endif

    m_sectionVisible = m_config.value(SECTION_VISIBLE, true).toBool();
    m_exitConfirmation = m_config.value(EXIT_CONFIRMATION, ApplicationInfo::getInstance()->isMobile() ? true : false).toBool();

    m_isAutomaticDownloadsEnabled = m_config.value(ENABLE_AUTOMATIC_DOWNLOADS,
                                                   !ApplicationInfo::getInstance()->isMobile() && ApplicationInfo::isDownloadAllowed())
                                        .toBool();
    m_filterLevelMin = m_config.value(FILTER_LEVEL_MIN, 1).toUInt();
    m_filterLevelMax = m_config.value(FILTER_LEVEL_MAX, 6).toUInt();
    m_defaultCursor = m_config.value(DEFAULT_CURSOR, false).toBool();
    m_noCursor = m_config.value(NO_CURSOR, false).toBool();
    m_baseFontSize = m_config.value(BASE_FONT_SIZE_KEY, 0).toInt();

    m_config.sync(); // make sure all defaults are written back
    m_config.endGroup();

    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_downloadServerUrl = m_config.value(DOWNLOAD_SERVER_URL_KEY, QLatin1String(DEFAULT_DOWNLOAD_SERVER)).toString();
    if (m_downloadServerUrl == "http://gcompris.net") {
        setDownloadServerUrl(DEFAULT_DOWNLOAD_SERVER);
    }
    m_cachePath = m_config.value(CACHE_PATH_KEY, QStandardPaths::writableLocation(QStandardPaths::CacheLocation)).toString();
#if defined(UBUNTUTOUCH)
    m_userDataPath = m_config.value(USERDATA_PATH_KEY, QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).toString();
#else
    m_userDataPath = m_config.value(USERDATA_PATH_KEY, QString(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QLatin1String("/GCompris"))).toString();
#endif
    m_renderer = m_config.value(RENDERER_KEY, GRAPHICAL_RENDERER).toString();
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_exeCount = m_config.value(EXE_COUNT_KEY, 0).toUInt();
    m_lastGCVersionRan = m_config.value(LAST_GC_VERSION_RAN, 0).toUInt();
    m_config.endGroup();

    // no group
    m_isBarHidden = false;

    connect(this, &ApplicationSettings::audioVoicesEnabledChanged, this, &ApplicationSettings::notifyAudioVoicesEnabledChanged);
    connect(this, &ApplicationSettings::audioEffectsEnabledChanged, this, &ApplicationSettings::notifyAudioEffectsEnabledChanged);
    connect(this, &ApplicationSettings::backgroundMusicEnabledChanged, this, &ApplicationSettings::notifyBackgroundMusicEnabledChanged);
    connect(this, &ApplicationSettings::filteredBackgroundMusicChanged, this, &ApplicationSettings::notifyFilteredBackgroundMusicChanged);
    connect(this, &ApplicationSettings::fullscreenChanged, this, &ApplicationSettings::notifyFullscreenChanged);
    connect(this, &ApplicationSettings::previousHeightChanged, this, &ApplicationSettings::notifyPreviousHeightChanged);
    connect(this, &ApplicationSettings::previousWidthChanged, this, &ApplicationSettings::notifyPreviousWidthChanged);
    connect(this, &ApplicationSettings::localeChanged, this, &ApplicationSettings::notifyLocaleChanged);
    connect(this, &ApplicationSettings::fontChanged, this, &ApplicationSettings::notifyFontChanged);
    connect(this, &ApplicationSettings::virtualKeyboardChanged, this, &ApplicationSettings::notifyVirtualKeyboardChanged);
    connect(this, &ApplicationSettings::automaticDownloadsEnabledChanged, this, &ApplicationSettings::notifyAutomaticDownloadsEnabledChanged);
    connect(this, &ApplicationSettings::filterLevelMinChanged, this, &ApplicationSettings::notifyFilterLevelMinChanged);
    connect(this, &ApplicationSettings::filterLevelMaxChanged, this, &ApplicationSettings::notifyFilterLevelMaxChanged);
    connect(this, &ApplicationSettings::sectionVisibleChanged, this, &ApplicationSettings::notifySectionVisibleChanged);
    connect(this, &ApplicationSettings::exitConfirmationChanged, this, &ApplicationSettings::notifyExitConfirmationChanged);
    connect(this, &ApplicationSettings::kioskModeChanged, this, &ApplicationSettings::notifyKioskModeChanged);
    connect(this, &ApplicationSettings::downloadServerUrlChanged, this, &ApplicationSettings::notifyDownloadServerUrlChanged);
    connect(this, &ApplicationSettings::cachePathChanged, this, &ApplicationSettings::notifyCachePathChanged);
    connect(this, &ApplicationSettings::userDataPathChanged, this, &ApplicationSettings::notifyUserDataPathChanged);
    connect(this, &ApplicationSettings::rendererChanged, this, &ApplicationSettings::notifyRendererChanged);
    connect(this, &ApplicationSettings::exeCountChanged, this, &ApplicationSettings::notifyExeCountChanged);
    connect(this, &ApplicationSettings::barHiddenChanged, this, &ApplicationSettings::notifyBarHiddenChanged);
    connect(this, &ApplicationSettings::lastGCVersionRanChanged, this, &ApplicationSettings::notifyLastGCVersionRanChanged);
    connect(this, &ApplicationSettings::backgroundMusicVolumeChanged, this, &ApplicationSettings::notifyBackgroundMusicVolumeChanged);
    connect(this, &ApplicationSettings::audioEffectsVolumeChanged, this, &ApplicationSettings::notifyAudioEffectsVolumeChanged);
}

ApplicationSettings::~ApplicationSettings()
{
    // make sure settings file is up2date:
    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
    m_config.setValue(ENABLE_AUDIO_VOICES_KEY, m_isAudioVoicesEnabled);
    m_config.setValue(ENABLE_BACKGROUND_MUSIC_KEY, m_isBackgroundMusicEnabled);
    m_config.setValue(FILTERED_BACKGROUND_MUSIC_KEY, m_filteredBackgroundMusic);
    m_config.setValue(BACKGROUND_MUSIC_VOLUME_KEY, m_backgroundMusicVolume);
    m_config.setValue(AUDIO_EFFECTS_VOLUME_KEY, m_audioEffectsVolume);
    m_config.setValue(LOCALE_KEY, m_locale);
    m_config.setValue(FONT_KEY, m_font);
    m_config.setValue(IS_CURRENT_FONT_EMBEDDED, m_isEmbeddedFont);
    m_config.setValue(FULLSCREEN_KEY, m_isFullscreen);
    m_config.setValue(PREVIOUS_HEIGHT_KEY, m_previousHeight);
    m_config.setValue(PREVIOUS_WIDTH_KEY, m_previousWidth);
    m_config.setValue(VIRTUALKEYBOARD_KEY, m_isVirtualKeyboard);
    m_config.setValue(ENABLE_AUTOMATIC_DOWNLOADS, m_isAutomaticDownloadsEnabled);
    if (!m_filterLevelOverridedByCommandLineOption) {
        m_config.setValue(FILTER_LEVEL_MIN, m_filterLevelMin);
        m_config.setValue(FILTER_LEVEL_MAX, m_filterLevelMax);
    }
    m_config.setValue(KIOSK_KEY, m_isKioskMode);
    m_config.setValue(SECTION_VISIBLE, m_sectionVisible);
    m_config.setValue(EXIT_CONFIRMATION, m_exitConfirmation);
    m_config.setValue(DEFAULT_CURSOR, m_defaultCursor);
    m_config.setValue(NO_CURSOR, m_noCursor);
    m_config.setValue(BASE_FONT_SIZE_KEY, m_baseFontSize);
    m_config.setValue(FONT_CAPITALIZATION, m_fontCapitalization);
    m_config.setValue(FONT_LETTER_SPACING, m_fontLetterSpacing);
    m_config.endGroup();

    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_config.setValue(DOWNLOAD_SERVER_URL_KEY, m_downloadServerUrl);
    m_config.setValue(CACHE_PATH_KEY, m_cachePath);
    m_config.setValue(USERDATA_PATH_KEY, m_userDataPath);
    m_config.setValue(RENDERER_KEY, m_renderer);
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_config.setValue(EXE_COUNT_KEY, m_exeCount);
    m_config.setValue(LAST_GC_VERSION_RAN, m_lastGCVersionRan);
    m_config.endGroup();

    m_config.sync();

    m_instance = nullptr;
}

void ApplicationSettings::notifyAudioVoicesEnabledChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, ENABLE_AUDIO_VOICES_KEY, m_isAudioVoicesEnabled);
    qDebug() << "notifyAudioVoices: " << m_isAudioVoicesEnabled;
}

void ApplicationSettings::notifyAudioEffectsEnabledChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, ENABLE_AUDIO_EFFECTS_KEY, m_isAudioEffectsEnabled);
    qDebug() << "notifyAudioEffects: " << m_isAudioEffectsEnabled;
}

void ApplicationSettings::notifyBackgroundMusicEnabledChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, ENABLE_BACKGROUND_MUSIC_KEY, m_isBackgroundMusicEnabled);
    qDebug() << "notifyBackgroundMusic: " << m_isBackgroundMusicEnabled;
}

void ApplicationSettings::notifyFilteredBackgroundMusicChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FILTERED_BACKGROUND_MUSIC_KEY, m_filteredBackgroundMusic);
    qDebug() << "filteredBackgroundMusic: " << m_filteredBackgroundMusic;
}

void ApplicationSettings::notifyBackgroundMusicVolumeChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, BACKGROUND_MUSIC_VOLUME_KEY, m_backgroundMusicVolume);
    qDebug() << "backgroundMusicVolume: " << m_backgroundMusicVolume;
}

void ApplicationSettings::notifyAudioEffectsVolumeChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, AUDIO_EFFECTS_VOLUME_KEY, m_audioEffectsVolume);
    qDebug() << "audioEffectsVolume: " << m_audioEffectsVolume;
}

void ApplicationSettings::notifyLocaleChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, LOCALE_KEY, m_locale);
    qDebug() << "new locale: " << m_locale;
}

void ApplicationSettings::notifyFontChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FONT_KEY, m_font);
    qDebug() << "new font: " << m_font;
}

void ApplicationSettings::notifyEmbeddedFontChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, IS_CURRENT_FONT_EMBEDDED, m_isEmbeddedFont);
    qDebug() << "new font is embedded: " << m_isEmbeddedFont;
}

void ApplicationSettings::notifyFontCapitalizationChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FONT_CAPITALIZATION, m_fontCapitalization);
    qDebug() << "new fontCapitalization: " << m_fontCapitalization;
}

void ApplicationSettings::notifyFontLetterSpacingChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FONT_LETTER_SPACING, m_fontLetterSpacing);
    qDebug() << "new fontLetterSpacing: " << m_fontLetterSpacing;
}

void ApplicationSettings::notifyFullscreenChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FULLSCREEN_KEY, m_isFullscreen);
    qDebug() << "fullscreen set to: " << m_isFullscreen;
}

void ApplicationSettings::notifyPreviousHeightChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, PREVIOUS_HEIGHT_KEY, m_previousHeight);
    qDebug() << "previous height set to: " << m_previousHeight;
}

void ApplicationSettings::notifyPreviousWidthChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, PREVIOUS_WIDTH_KEY, m_previousWidth);
    qDebug() << "previous width set to: " << m_previousWidth;
}

void ApplicationSettings::notifyVirtualKeyboardChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, VIRTUALKEYBOARD_KEY, m_isVirtualKeyboard);
    qDebug() << "virtualkeyboard set to: " << m_isVirtualKeyboard;
}

bool ApplicationSettings::isAutomaticDownloadsEnabled() const
{
    return m_isAutomaticDownloadsEnabled && ApplicationInfo::isDownloadAllowed();
}
void ApplicationSettings::setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled)
{
    if (ApplicationInfo::isDownloadAllowed()) {
        m_isAutomaticDownloadsEnabled = newIsAutomaticDownloadsEnabled;
        Q_EMIT automaticDownloadsEnabledChanged();
    }
}
void ApplicationSettings::notifyAutomaticDownloadsEnabledChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, ENABLE_AUTOMATIC_DOWNLOADS, m_isAutomaticDownloadsEnabled);
    qDebug() << "enableAutomaticDownloads set to: " << m_isAutomaticDownloadsEnabled;
}

void ApplicationSettings::notifyFilterLevelMinChanged()
{
    qDebug() << "filterLevelMin set to: " << m_filterLevelMin;
    if (!m_filterLevelOverridedByCommandLineOption) {
        updateValueInConfig(GENERAL_GROUP_KEY, FILTER_LEVEL_MIN, m_filterLevelMin);
    }
}

void ApplicationSettings::notifyFilterLevelMaxChanged()
{
    qDebug() << "filterLevelMax set to: " << m_filterLevelMax;
    if (!m_filterLevelOverridedByCommandLineOption) {
        updateValueInConfig(GENERAL_GROUP_KEY, FILTER_LEVEL_MAX, m_filterLevelMax);
    }
}

void ApplicationSettings::notifyKioskModeChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, KIOSK_KEY, m_isKioskMode);
    qDebug() << "notifyKioskMode: " << m_isKioskMode;
}

void ApplicationSettings::notifySectionVisibleChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, SECTION_VISIBLE, m_sectionVisible);
    qDebug() << "notifySectionVisible: " << m_sectionVisible;
}

void ApplicationSettings::notifyExitConfirmationChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, EXIT_CONFIRMATION, m_exitConfirmation);
}

void ApplicationSettings::notifyDownloadServerUrlChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, DOWNLOAD_SERVER_URL_KEY, m_downloadServerUrl);
    qDebug() << "downloadServerUrl set to: " << m_downloadServerUrl;
}

void ApplicationSettings::notifyCachePathChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, CACHE_PATH_KEY, m_cachePath);
    qDebug() << "cachePath set to: " << m_cachePath;
}

void ApplicationSettings::notifyUserDataPathChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, USERDATA_PATH_KEY, m_userDataPath);
    qDebug() << "userDataPath set to: " << m_userDataPath;
}

void ApplicationSettings::notifyRendererChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, RENDERER_KEY, m_renderer);
    qDebug() << "renderer set to: " << m_renderer;
}

void ApplicationSettings::notifyExeCountChanged()
{
    updateValueInConfig(INTERNAL_GROUP_KEY, EXE_COUNT_KEY, m_exeCount);
    qDebug() << "exeCount set to: " << m_exeCount;
}

void ApplicationSettings::notifyLastGCVersionRanChanged()
{
    updateValueInConfig(INTERNAL_GROUP_KEY, LAST_GC_VERSION_RAN, m_lastGCVersionRan);
    qDebug() << "lastVersionRan set to: " << m_lastGCVersionRan;
}

void ApplicationSettings::notifyBarHiddenChanged()
{
    qDebug() << "is bar hidden: " << m_isBarHidden;
}

void ApplicationSettings::saveBaseFontSize()
{
    updateValueInConfig(GENERAL_GROUP_KEY, BASE_FONT_SIZE_KEY, m_baseFontSize);
}

void ApplicationSettings::saveActivityConfiguration(const QString &activity, const QVariantMap &data)
{
    qDebug() << "save configuration for:" << activity;
    QMapIterator<QString, QVariant> i(data);
    while (i.hasNext()) {
        i.next();
        updateValueInConfig(activity, i.key(), i.value(), false);
    }
    m_config.sync();
}

QVariantMap ApplicationSettings::loadActivityConfiguration(const QString &activity)
{
    qDebug() << "load configuration for:" << activity;
    m_config.beginGroup(activity);
    const QStringList keys = m_config.childKeys();
    QVariantMap data;
    for (const QString &key: keys) {
        data[key] = m_config.value(key);
    }
    m_config.endGroup();
    return data;
}

void ApplicationSettings::setFavorite(const QString &activity, bool favorite)
{
    updateValueInConfig(FAVORITE_GROUP_KEY, activity, favorite);
}

bool ApplicationSettings::isFavorite(const QString &activity)
{
    m_config.beginGroup(FAVORITE_GROUP_KEY);
    bool favorite = m_config.value(activity, false).toBool();
    m_config.endGroup();
    return favorite;
}

void ApplicationSettings::setCurrentLevels(const QString &activity, const QStringList &level, bool sync)
{
    if (!m_filterLevelOverridedByCommandLineOption) {
        updateValueInConfig(LEVELS_GROUP_KEY, activity, level, sync);
    }
}

QStringList ApplicationSettings::currentLevels(const QString &activity)
{
    m_config.beginGroup(LEVELS_GROUP_KEY);
    QStringList level = m_config.value(activity, QStringList()).toStringList();
    m_config.endGroup();
    return level;
}

template <class T>
void ApplicationSettings::updateValueInConfig(const QString &group,
                                              const QString &key, const T &value, bool sync)
{
    m_config.beginGroup(group);
    m_config.setValue(key, value);
    m_config.endGroup();
    if (sync) {
        m_config.sync();
    }
}

void ApplicationSettings::sync()
{
    m_config.sync();
}

int ApplicationSettings::loadActivityProgress(const QString &activity)
{
    int progress = 0;
    m_config.beginGroup(activity);
    progress = m_config.value(PROGRESS_KEY, 0).toInt();
    m_config.endGroup();
    qDebug() << "loaded progress for activity" << activity << ":" << progress;
    return progress;
}

void ApplicationSettings::saveActivityProgress(const QString &activity, int progress)
{
    updateValueInConfig(activity, PROGRESS_KEY, progress);
}

bool ApplicationSettings::useExternalWordset()
{
    return DownloadManager::getInstance()->isDataRegistered("words-webp");
}

QObject *ApplicationSettings::applicationSettingsProvider(QQmlEngine *engine,
                                                          QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    ApplicationSettings *appSettings = getInstance();
    return appSettings;
}

#include "moc_ApplicationSettings.cpp"
