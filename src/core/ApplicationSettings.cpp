/* GCompris - ApplicationSettings.cpp
 *
 * Copyright (C) 2014-2016 Johnny Jazeix <jazeix@gmail.com>
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

#include "ApplicationSettings.h"
#include "ApplicationInfo.h"

#include "DownloadManager.h"

#include <qmath.h>
#include <QUrl>
#include <QUrlQuery>
#include <QGuiApplication>
#include <QScreen>
#include <QLocale>
#include <QApplication>
#include <QRect>
#include <QDesktopWidget>

#include <QSettings>
#include <QStandardPaths>
#include <QDebug>

#include <QtQml>

#define GC_DEFAULT_FONT "Andika-R.otf"
#define GC_DEFAULT_FONT_CAPITALIZATION 0 // Font.MixedCase
#define GC_DEFAULT_FONT_LETTER_SPACING 0

static const QString GENERAL_GROUP_KEY = "General";
static const QString ADMIN_GROUP_KEY = "Admin";
static const QString INTERNAL_GROUP_KEY = "Internal";
static const QString FAVORITE_GROUP_KEY = "Favorite";

static const QString FULLSCREEN_KEY = "fullscreen";
static const QString PREVIOUS_HEIGHT_KEY = "previousHeight";
static const QString PREVIOUS_WIDTH_KEY = "previousWidth";
static const QString SHOW_LOCKED_ACTIVITIES_KEY = "showLockedActivities";
static const QString ENABLE_AUDIO_VOICES_KEY = "enableAudioVoices";
static const QString ENABLE_AUDIO_EFFECTS_KEY = "enableAudioEffects";
static const QString VIRTUALKEYBOARD_KEY = "virtualKeyboard";
static const QString LOCALE_KEY = "locale";
static const QString FONT_KEY = "font";
static const QString IS_CURRENT_FONT_EMBEDDED = "isCurrentFontEmbedded";
static const QString ENABLE_AUTOMATIC_DOWNLOADS = "enableAutomaticDownloads";

static const QString DOWNLOAD_SERVER_URL_KEY = "downloadServerUrl";
static const QString CACHE_PATH_KEY = "cachePath";

static const QString EXE_COUNT_KEY = "exeCount";
static const QString LAST_GC_VERSION_RAN = "lastGCVersionRan";

static const QString FILTER_LEVEL_MIN = "filterLevelMin";
static const QString FILTER_LEVEL_MAX = "filterLevelMax";

static const QString BASE_FONT_SIZE_KEY = "baseFontSize";
static const QString FONT_CAPITALIZATION = "fontCapitalization";
static const QString FONT_LETTER_SPACING = "fontLetterSpacing";

static const QString DEFAULT_CURSOR = "defaultCursor";
static const QString NO_CURSOR = "noCursor";
static const QString DEMO_KEY = "demo";
static const QString CODE_KEY = "key";
static const QString KIOSK_KEY = "kiosk";
static const QString SECTION_VISIBLE = "sectionVisible";
static const QString WORDSET = "wordset";

static const QString PROGRESS_KEY = "progress";

ApplicationSettings *ApplicationSettings::m_instance = NULL;

ApplicationSettings::ApplicationSettings(QObject *parent): QObject(parent),
     m_baseFontSizeMin(-7), m_baseFontSizeMax(7),
     m_fontLetterSpacingMin(0.0), m_fontLetterSpacingMax(8.0),
     m_config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) +
              "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf", QSettings::IniFormat)
{
    const QRect &screenSize = QApplication::desktop()->screenGeometry();

    // initialize from settings file or default

    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
    m_isAudioEffectsEnabled = m_config.value(ENABLE_AUDIO_EFFECTS_KEY, true).toBool();
    m_isFullscreen = m_config.value(FULLSCREEN_KEY, true).toBool();
    m_previousHeight = m_config.value(PREVIOUS_HEIGHT_KEY, screenSize.height()).toUInt();
    m_previousWidth = m_config.value(PREVIOUS_WIDTH_KEY, screenSize.width()).toUInt();
    m_isAudioVoicesEnabled = m_config.value(ENABLE_AUDIO_VOICES_KEY, true).toBool();
    m_isVirtualKeyboard = m_config.value(VIRTUALKEYBOARD_KEY,
            ApplicationInfo::getInstance()->isMobile()).toBool();
    m_locale = m_config.value(LOCALE_KEY, GC_DEFAULT_LOCALE).toString();
    m_font = m_config.value(FONT_KEY, GC_DEFAULT_FONT).toString();
    if(m_font == "Andika-R.ttf")
        m_font = "Andika-R.otf";
    m_fontCapitalization = m_config.value(FONT_CAPITALIZATION, GC_DEFAULT_FONT_CAPITALIZATION).toUInt();
    setFontLetterSpacing(m_config.value(FONT_LETTER_SPACING, GC_DEFAULT_FONT_LETTER_SPACING).toReal());
    m_isEmbeddedFont = m_config.value(IS_CURRENT_FONT_EMBEDDED, true).toBool();

    // Init the activation mode
    if(QLatin1String(ACTIVATION_MODE) == "no")
        m_activationMode = 0;
    else if(QLatin1String(ACTIVATION_MODE) == "inapp")
        m_activationMode = 1;
    else if(QLatin1String(ACTIVATION_MODE) == "internal")
        m_activationMode = 2;
    else
        qFatal("Unknown activation mode");

    // Set the demo mode
    if(QLatin1String(ACTIVATION_MODE) != "no")
        m_isDemoMode = m_config.value(DEMO_KEY, true).toBool();
    else
        m_isDemoMode = false;
    m_codeKey = m_config.value(CODE_KEY, "").toString();

#if defined(WITH_KIOSK_MODE)
    m_isKioskMode = m_config.value(KIOSK_KEY, true).toBool();
#else
    m_isKioskMode = m_config.value(KIOSK_KEY, false).toBool();
#endif

    // Option only useful if we are in demo mode (else all the activities are available and unlocked)
    // By default, all the activities are displayed (even locked ones)
    m_showLockedActivities = m_config.value(SHOW_LOCKED_ACTIVITIES_KEY, m_isDemoMode).toBool();
    m_sectionVisible = m_config.value(SECTION_VISIBLE, true).toBool();
    m_wordset = m_config.value(WORDSET, "").toString();
    m_isAutomaticDownloadsEnabled = m_config.value(ENABLE_AUTOMATIC_DOWNLOADS,
            !ApplicationInfo::getInstance()->isMobile() && ApplicationInfo::isDownloadAllowed()).toBool();
    m_filterLevelMin = m_config.value(FILTER_LEVEL_MIN, 1).toUInt();
    m_filterLevelMax = m_config.value(FILTER_LEVEL_MAX, 6).toUInt();
    m_defaultCursor = m_config.value(DEFAULT_CURSOR, false).toBool();
    m_noCursor = m_config.value(NO_CURSOR, false).toBool();
    setBaseFontSize(m_config.value(BASE_FONT_SIZE_KEY, 0).toInt());

    m_config.sync();  // make sure all defaults are written back
    m_config.endGroup();

    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_downloadServerUrl = m_config.value(DOWNLOAD_SERVER_URL_KEY, "http://gcompris.net").toString();
    m_cachePath = m_config.value(CACHE_PATH_KEY, QStandardPaths::writableLocation(QStandardPaths::CacheLocation)).toString();
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_exeCount = m_config.value(EXE_COUNT_KEY, 0).toUInt();
    m_lastGCVersionRan = m_config.value(LAST_GC_VERSION_RAN, 0).toUInt();
    m_config.endGroup();

    // no group
    m_isBarHidden = false;

    connect(this, &ApplicationSettings::showLockedActivitiesChanged, this, &ApplicationSettings::notifyShowLockedActivitiesChanged);
	connect(this, &ApplicationSettings::audioVoicesEnabledChanged, this, &ApplicationSettings::notifyAudioVoicesEnabledChanged);
	connect(this, &ApplicationSettings::audioEffectsEnabledChanged, this, &ApplicationSettings::notifyAudioEffectsEnabledChanged);
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
    connect(this, &ApplicationSettings::wordsetChanged, this, &ApplicationSettings::notifyWordsetChanged);
    connect(this, &ApplicationSettings::demoModeChanged, this, &ApplicationSettings::notifyDemoModeChanged);
    connect(this, &ApplicationSettings::codeKeyChanged, this, &ApplicationSettings::notifyCodeKeyChanged);
    connect(this, &ApplicationSettings::kioskModeChanged, this, &ApplicationSettings::notifyKioskModeChanged);
    connect(this, &ApplicationSettings::downloadServerUrlChanged, this, &ApplicationSettings::notifyDownloadServerUrlChanged);
    connect(this, &ApplicationSettings::cachePathChanged, this, &ApplicationSettings::notifyCachePathChanged);
    connect(this, &ApplicationSettings::exeCountChanged, this, &ApplicationSettings::notifyExeCountChanged);
    connect(this, &ApplicationSettings::barHiddenChanged, this, &ApplicationSettings::notifyBarHiddenChanged);
    connect(this, &ApplicationSettings::lastGCVersionRanChanged, this, &ApplicationSettings::notifyLastGCVersionRanChanged);
}

ApplicationSettings::~ApplicationSettings()
{
    // make sure settings file is up2date:
    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
    m_config.setValue(SHOW_LOCKED_ACTIVITIES_KEY, m_showLockedActivities);
    m_config.setValue(ENABLE_AUDIO_VOICES_KEY, m_isAudioVoicesEnabled);
    m_config.setValue(LOCALE_KEY, m_locale);
    m_config.setValue(FONT_KEY, m_font);
    m_config.setValue(IS_CURRENT_FONT_EMBEDDED, m_isEmbeddedFont);
    m_config.setValue(FULLSCREEN_KEY, m_isFullscreen);
    m_config.setValue(PREVIOUS_HEIGHT_KEY, m_previousHeight);
    m_config.setValue(PREVIOUS_WIDTH_KEY, m_previousWidth);
    m_config.setValue(VIRTUALKEYBOARD_KEY, m_isVirtualKeyboard);
    m_config.setValue(ENABLE_AUTOMATIC_DOWNLOADS, m_isAutomaticDownloadsEnabled);
    m_config.setValue(FILTER_LEVEL_MIN, m_filterLevelMin);
    m_config.setValue(FILTER_LEVEL_MAX, m_filterLevelMax);
    m_config.setValue(DEMO_KEY, m_isDemoMode);
    m_config.setValue(CODE_KEY, m_codeKey);
    m_config.setValue(KIOSK_KEY, m_isKioskMode);
    m_config.setValue(SECTION_VISIBLE, m_sectionVisible);
    m_config.setValue(WORDSET, m_wordset);
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
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_config.setValue(EXE_COUNT_KEY, m_exeCount);
    m_config.setValue(LAST_GC_VERSION_RAN, m_lastGCVersionRan);
    m_config.endGroup();

    m_config.sync();

    m_instance = NULL;
}

void ApplicationSettings::notifyShowLockedActivitiesChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, SHOW_LOCKED_ACTIVITIES_KEY, m_showLockedActivities);
    qDebug() << "notifyShowLockedActivitiesChanged: " << m_showLockedActivities;
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

bool ApplicationSettings::isAutomaticDownloadsEnabled() const {
    return m_isAutomaticDownloadsEnabled && ApplicationInfo::isDownloadAllowed();
}
void ApplicationSettings::setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled) {
    if(ApplicationInfo::isDownloadAllowed()) {
        m_isAutomaticDownloadsEnabled = newIsAutomaticDownloadsEnabled;
        emit automaticDownloadsEnabledChanged();
    }
}

void ApplicationSettings::notifyAutomaticDownloadsEnabledChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, ENABLE_AUTOMATIC_DOWNLOADS, m_isAutomaticDownloadsEnabled);
    qDebug() << "enableAutomaticDownloads set to: " << m_isAutomaticDownloadsEnabled;
}

void ApplicationSettings::notifyFilterLevelMinChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FILTER_LEVEL_MIN, m_filterLevelMin);
    qDebug() << "filterLevelMin set to: " << m_filterLevelMin;
}

void ApplicationSettings::notifyFilterLevelMaxChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FILTER_LEVEL_MAX, m_filterLevelMax);
    qDebug() << "filterLevelMax set to: " << m_filterLevelMax;
}

void ApplicationSettings::notifyDemoModeChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, DEMO_KEY, m_isDemoMode);
    qDebug() << "notifyDemoMode: " << m_isDemoMode;
}

void ApplicationSettings::notifyCodeKeyChanged()
{
    checkPayment();
    if(!m_isDemoMode)
        updateValueInConfig(GENERAL_GROUP_KEY, CODE_KEY, m_codeKey);
    qDebug() << "notifyCodeKey: " << m_codeKey;
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

void ApplicationSettings::notifyWordsetChanged()
{
    if(!m_wordset.isEmpty() &&
       DownloadManager::getInstance()->haveLocalResource(m_wordset) &&
       !DownloadManager::getInstance()->isDataRegistered("words")) {
        // words.rcc is there -> register old file first
        // then try to update in the background
        DownloadManager::getInstance()->updateResource(m_wordset);
    }

    updateValueInConfig(GENERAL_GROUP_KEY, WORDSET, m_wordset);
    qDebug() << "notifyWordset: " << m_wordset;
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
        updateValueInConfig(activity, i.key(), i.value());
    }
}

QVariantMap ApplicationSettings::loadActivityConfiguration(const QString &activity)
{
    qDebug() << "load configuration for:" << activity;
    m_config.beginGroup(activity);
    QStringList keys = m_config.childKeys();
    QVariantMap data;
    foreach(const QString &key, keys) {
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

template<class T> void ApplicationSettings::updateValueInConfig(const QString& group,
                                              const QString& key, const T& value)
{
    m_config.beginGroup(group);
    m_config.setValue(key, value);
    m_config.endGroup();
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
    return !m_wordset.isEmpty() && DownloadManager::getInstance()->isDataRegistered("words");
}

QObject *ApplicationSettings::systeminfoProvider(QQmlEngine *engine,
                                                 QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    ApplicationSettings* appSettings = getInstance();
    return appSettings;
}

void ApplicationSettings::init()
{
	qmlRegisterSingletonType<ApplicationSettings>("GCompris", 1, 0,
												  "ApplicationSettings", systeminfoProvider);
}

