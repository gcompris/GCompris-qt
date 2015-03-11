/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). <qt@digia.org>
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

#include "ApplicationInfo.h"

#include <QtCore/QtMath>
#include <QtCore/QUrl>
#include <QtCore/QUrlQuery>
#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QtCore/QLocale>
#include <QtQuick/QQuickWindow>

#include <qmath.h>
#include <QDebug>

#include <QFontDatabase>
#include <QDir>

QQuickWindow *ApplicationInfo::m_window = NULL;
ApplicationInfo *ApplicationInfo::m_instance = NULL;

ApplicationInfo::ApplicationInfo(QObject *parent): QObject(parent)
{

    m_isMobile = false;
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    m_isMobile = true;
#endif

#if defined(Q_OS_LINUX) || defined(Q_OS_UNIX)
    m_platform = Linux;
#elif defined(Q_OS_WIN)
    m_platform = Windows;
#elif defined(Q_OS_MAC)
    m_platform = MacOSX;
#elif defined(Q_OS_ANDROID)
    m_platform = Android;
#elif defined(Q_OS_IOS)
    m_platform = Ios;
#elif defined(Q_OS_BLACKBERRY)
    m_platform = Blackberry;
#endif

    QRect rect = qApp->primaryScreen()->geometry();
//    m_ratio = 2;
//    m_ratio = 2.56;
    m_ratio = m_isMobile ? qMin(qMax(rect.width(), rect.height())/800. , qMin(rect.width(), rect.height())/520.) : 1;
    // calculate a factor for font-scaling, cf.
    // http://doc.qt.io/qt-5/scalability.html#calculating-scaling-ratio
    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = qApp->primaryScreen()->logicalDotsPerInch();
    m_fontRatio = m_isMobile ? qMax(qreal(1.0), qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth))) : 1;
    m_sliderHandleWidth = getSizeWithRatio(70);
    m_sliderHandleHeight = getSizeWithRatio(87);
    m_sliderGapWidth = getSizeWithRatio(100);
    m_isPortraitMode = m_isMobile ? rect.height() > rect.width() : false;
    m_hMargin =  m_isPortraitMode ? 20 * ratio() : 50 * ratio();
    m_applicationWidth = m_isMobile ? rect.width() : 1120;

    if (m_isMobile)
        connect(qApp->primaryScreen(), SIGNAL(physicalSizeChanged(QSizeF)), this, SLOT(notifyPortraitMode()));

    // Get all symbol fonts to remove them
    QFontDatabase database;
    m_excludedFonts = database.families(QFontDatabase::Symbol);

    // Get fonts from rcc
    const QStringList fontFilters = {"*.otf", "*.ttf"};
    m_fontsFromRcc = QDir(":/gcompris/src/core/resource/fonts").entryList(fontFilters);

}

ApplicationInfo::~ApplicationInfo()
{
    m_instance = NULL;
}

void ApplicationInfo::setApplicationWidth(const int newWidth)
{
    if (newWidth != m_applicationWidth) {
        m_applicationWidth = newWidth;
        emit applicationWidthChanged();
    }
}

QString ApplicationInfo::getResourceDataPath()
{
    return QString("qrc:/gcompris/data");
}

QString ApplicationInfo::getFilePath(const QString &file)
{
#if defined(Q_OS_ANDROID)
    return QString("assets:/%1").arg(file);
#else
    return QString("%1/%2/rcc/%3").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER, file);
#endif
}

QString ApplicationInfo::getAudioFilePath(const QString &file)
{
    QString localeName = getVoicesLocale(ApplicationSettings::getInstance()->locale());

    QString filename = file;
    filename.replace("$LOCALE", localeName);
    return getResourceDataPath() + '/' + filename;
}

// Given a file name, if it contains $LOCALE it is replaced by
// the current locale like 'en' while in the English locale.
// e.g. qrc:/foo/bar_$LOCALE.json => qrc:/foo/bar_en.json
// FIXME should check long locale first
QString ApplicationInfo::getLocaleFilePath(const QString &file)
{
    QString localeShortName = localeShort();

    QString filename = file;
    filename.replace("$LOCALE", localeShortName);
    return filename;
}

QStringList ApplicationInfo::getSystemExcludedFonts()
{
    return m_excludedFonts;
}

QStringList ApplicationInfo::getFontsFromRcc()
{
    return m_fontsFromRcc;
}

void ApplicationInfo::notifyPortraitMode()
{
    int width = qApp->primaryScreen()->geometry().width();
    int height = qApp->primaryScreen()->geometry().height();
    setIsPortraitMode(height > width);
}

void ApplicationInfo::setIsPortraitMode(const bool newMode)
{
    if (m_isPortraitMode != newMode) {
        m_isPortraitMode = newMode;
        m_hMargin = m_isPortraitMode ? 20 * ratio() : 50 * ratio();
        emit portraitModeChanged();
        emit hMarginChanged();
    }
}

void ApplicationInfo::setWindow(QQuickWindow *window)
{
    m_window = window;
}

void ApplicationInfo::screenshot(QString const &path)
{
    QImage img = m_window->grabWindow();
    img.save(path);
}

void ApplicationInfo::notifyFullscreenChanged()
{
    if(ApplicationSettings::getInstance()->isFullscreen())
        m_window->showFullScreen();
    else
        m_window->showNormal();
}

// return the shortest possible locale name for the given locale, describing
// a unique voices dataset
QString ApplicationInfo::getVoicesLocale(const QString &locale)
{
    QString _locale = locale;
    if(_locale == GC_DEFAULT_LOCALE) {
        _locale = QLocale::system().name();
    }
    // locales we have country-specific voices for:
    if (_locale.startsWith(QLatin1String("pt_BR")) || _locale.startsWith(QLatin1String("zh_CN")))
        return QLocale(_locale).name();
    // short locale for all the rest:
    return localeShort(_locale);
}

QObject *ApplicationInfo::systeminfoProvider(QQmlEngine *engine,
                                             QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    /*
     * Connect the fullscreen change signal to applicationInfo in order to change
     * the QQuickWindow value
     */
    ApplicationInfo* appInfo = getInstance();
    connect(ApplicationSettings::getInstance(), SIGNAL(fullscreenChanged()), appInfo,
            SLOT(notifyFullscreenChanged()));
    return appInfo;
}

void ApplicationInfo::init()
{
    qmlRegisterSingletonType<ApplicationInfo>("GCompris", 1, 0,
                                              "ApplicationInfo", systeminfoProvider);
}
