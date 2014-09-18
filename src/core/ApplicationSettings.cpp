/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtCore/qmath.h>
#include <QtCore/QUrl>
#include <QtCore/QUrlQuery>
#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QtCore/QLocale>

#include <QSettings>
#include <QStandardPaths>
#include "ApplicationSettings.h"
#include "ApplicationInfo.h"
#include <QDebug>

#define GC_DEFAULT_LOCALE "en_US.UTF-8"
#define GC_DEFAULT_FONT "Andika-R.ttf"

static const QString GENERAL_GROUP_KEY = "General";
static const QString ADMIN_GROUP_KEY = "Admin";
static const QString INTERNAL_GROUP_KEY = "Internal";

static const QString FULLSCREEN_KEY = "fullscreen";
static const QString ENABLE_AUDIO_VOICES_KEY = "enableAudioVoices";
static const QString ENABLE_AUDIO_EFFECTS_KEY = "enableAudioEffects";
static const QString VIRTUALKEYBOARD_KEY = "virtualKeyboard";
static const QString LOCALE_KEY = "locale";
static const QString FONT_KEY = "font";
static const QString IS_CURRENT_FONT_EMBEDDED = "isCurrentFontEmbedded";
static const QString ENABLE_AUTOMATIC_DOWNLOADS = "enableAutomaticDownloads";

static const QString DOWNLOAD_SERVER_URL_KEY = "downloadServerUrl";

static const QString EXE_COUNT_KEY = "exeCount";

static const QString FILTER_LEVEL_MIN = "filterLevelMin";
static const QString FILTER_LEVEL_MAX = "filterLevelMax";

ApplicationSettings *ApplicationSettings::m_instance = NULL;

ApplicationSettings::ApplicationSettings(QObject *parent): QObject(parent),
     m_config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + "/gcompris/GCompris.conf", QSettings::IniFormat)

{
    // initialize from settings file or default

    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
	m_isAudioEffectsEnabled = m_config.value(ENABLE_AUDIO_EFFECTS_KEY, true).toBool();
    m_isFullscreen = m_config.value(FULLSCREEN_KEY, true).toBool();
	m_isAudioVoicesEnabled = m_config.value(ENABLE_AUDIO_VOICES_KEY, true).toBool();
    m_isVirtualKeyboard = m_config.value(VIRTUALKEYBOARD_KEY,
            ApplicationInfo::getInstance()->isMobile()).toBool();
    m_locale = m_config.value(LOCALE_KEY,
            QLocale::system() == QLocale::c() ? GC_DEFAULT_LOCALE : QString(QLocale::system().name() + ".UTF-8")).toString();
    m_font = m_config.value(FONT_KEY, GC_DEFAULT_FONT).toString();
    m_isEmbeddedFont = m_config.value(IS_CURRENT_FONT_EMBEDDED, true).toBool();

    m_isAutomaticDownloadsEnabled = m_config.value(ENABLE_AUTOMATIC_DOWNLOADS,
            !ApplicationInfo::getInstance()->isMobile()).toBool();
    m_filterLevelMin = m_config.value(FILTER_LEVEL_MIN, 1).toUInt();
    m_filterLevelMax = m_config.value(FILTER_LEVEL_MAX, 6).toUInt();
    m_config.sync();  // make sure all defaults are written back
    m_config.endGroup();

    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_downloadServerUrl = m_config.value(DOWNLOAD_SERVER_URL_KEY, "http://gcompris.net").toString();
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_exeCount = m_config.value(EXE_COUNT_KEY, 0).toUInt();
    m_config.endGroup();

	connect(this, SIGNAL(audioVoicesEnabledChanged()), this, SLOT(notifyAudioVoicesEnabledChanged()));
	connect(this, SIGNAL(audioEffectsEnabledChanged()), this, SLOT(notifyAudioEffectsEnabledChanged()));
	connect(this, SIGNAL(fullscreenChanged()), this, SLOT(notifyFullscreenChanged()));
    connect(this, SIGNAL(localeChanged()), this, SLOT(notifyLocaleChanged()));
    connect(this, SIGNAL(fontChanged()), this, SLOT(notifyFontChanged()));
    connect(this, SIGNAL(virtualKeyboardChanged()), this, SLOT(notifyVirtualKeyboardChanged()));
    connect(this, SIGNAL(automaticDownloadsEnabledChanged()), this, SLOT(notifyAutomaticDownloadsEnabledChanged()));
    connect(this, SIGNAL(filterLevelMinChanged()), this, SLOT(notifyFilterLevelMinChanged()));
    connect(this, SIGNAL(filterLevelMaxChanged()), this, SLOT(notifyFilterLevelMaxChanged()));
    connect(this, SIGNAL(downloadServerUrlChanged()), this, SLOT(notifyDownloadServerUrlChanged()));
    connect(this, SIGNAL(exeCountChanged()), this, SLOT(notifyExeCountChanged()));
}

ApplicationSettings::~ApplicationSettings()
{
    // make sure settings file is up2date:
    // general group
    m_config.beginGroup(GENERAL_GROUP_KEY);
	m_config.setValue(ENABLE_AUDIO_VOICES_KEY, m_isAudioVoicesEnabled);
    m_config.setValue(LOCALE_KEY, m_locale);
    m_config.setValue(FONT_KEY, m_font);
    m_config.setValue(IS_CURRENT_FONT_EMBEDDED, m_isEmbeddedFont);
    m_config.setValue(FULLSCREEN_KEY, m_isFullscreen);
    m_config.setValue(VIRTUALKEYBOARD_KEY, m_isVirtualKeyboard);
    m_config.setValue(ENABLE_AUTOMATIC_DOWNLOADS, m_isAutomaticDownloadsEnabled);
    m_config.setValue(FILTER_LEVEL_MIN, m_filterLevelMin);
    m_config.setValue(FILTER_LEVEL_MAX, m_filterLevelMax);
    m_config.endGroup();

    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_config.setValue(DOWNLOAD_SERVER_URL_KEY, m_downloadServerUrl);
    m_config.endGroup();

    // internal group
    m_config.beginGroup(INTERNAL_GROUP_KEY);
    m_config.setValue(EXE_COUNT_KEY, m_exeCount);
    m_config.endGroup();

    m_config.sync();

    m_instance = NULL;
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

void ApplicationSettings::notifyFullscreenChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, FULLSCREEN_KEY, m_isFullscreen);
    qDebug() << "fullscreen set to: " << m_isFullscreen;
}

void ApplicationSettings::notifyVirtualKeyboardChanged()
{
    updateValueInConfig(GENERAL_GROUP_KEY, VIRTUALKEYBOARD_KEY, m_isVirtualKeyboard);
    qDebug() << "virtualkeyboard set to: " << m_isVirtualKeyboard;
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

void ApplicationSettings::notifyDownloadServerUrlChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, DOWNLOAD_SERVER_URL_KEY, m_downloadServerUrl);
    qDebug() << "downloadServerUrl set to: " << m_downloadServerUrl;
}

void ApplicationSettings::notifyExeCountChanged()
{
    updateValueInConfig(INTERNAL_GROUP_KEY, EXE_COUNT_KEY, m_exeCount);
    qDebug() << "exeCount set to: " << m_exeCount;
}

template<class T> void ApplicationSettings::updateValueInConfig(const QString& group,
                                              const QString& key, const T& value)
{
    m_config.beginGroup(group);
    m_config.setValue(key, value);
    m_config.endGroup();
    m_config.sync();
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
