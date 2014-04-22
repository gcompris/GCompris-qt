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

#include <KConfigGroup>

#include "ApplicationSettings.h"
#include <QDebug>

#define GC_DEFAULT_LOCALE "en_US.UTF-8"

ApplicationSettings::ApplicationSettings(QObject *parent): QObject(parent),
     m_config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + "/gcompris/GCompris.conf")

{
    KConfigGroup generalGroup(&m_config, "General");
    // Default values if file does not exist
    if(!m_config.hasGroup(generalGroup.name())) {
        generalGroup.writeEntry("enableEffects", true);
        generalGroup.writeEntry("fullscreen", false);
        generalGroup.writeEntry("enableSounds", true);
         // Todo get locale, if "C", put default locale
        generalGroup.writeEntry("locale", GC_DEFAULT_LOCALE);
        m_config.sync();
    }

    m_isEffectEnabled = generalGroup.readEntry("enableEffects", true);
    m_isFullscreen = generalGroup.readEntry("fullscreen", false);
    m_isAudioEnabled = generalGroup.readEntry("enableSounds", false);
    m_locale = generalGroup.readEntry("locale");

    connect(this, SIGNAL(audioEnabledChanged()), this, SLOT(notifyAudioEnabledChanged()));
    connect(this, SIGNAL(localeChanged()), this, SLOT(notifyLocaleChanged()));
}

void ApplicationSettings::notifyAudioEnabledChanged()
{
    // Load settings from KConfig
    KConfigGroup generalGroup = KConfigGroup(&m_config, "General");
    generalGroup.writeEntry("enableSounds", m_isAudioEnabled);

    // Save in config
    qDebug() << "notifyAudio: " << m_isAudioEnabled;
    m_config.sync();
}

void ApplicationSettings::notifyLocaleChanged()
{
    // Load settings from KConfig
    KConfigGroup generalGroup = KConfigGroup(&m_config, "General");
    generalGroup.writeEntry("locale", m_locale);

    // Save in config
    qDebug() << "new locale: " << m_locale;
    m_config.sync();
}
