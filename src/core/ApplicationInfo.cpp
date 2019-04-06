/* GCompris - ApplicationInfo.cpp
 *
 * Copyright (C) 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This file was originally created from Digia example code under BSD license
 * and heavily modified since then.
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

#include "ApplicationInfo.h"

#include <QtQml>
#include <QtMath>
#include <QUrl>
#include <QUrlQuery>
#include <QGuiApplication>
#include <QScreen>
#include <QLocale>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QSensor>

#include <qmath.h>
#include <QDebug>

#include <QFontDatabase>
#include <QDir>

QQuickWindow *ApplicationInfo::m_window = nullptr;
ApplicationInfo *ApplicationInfo::m_instance = nullptr;

ApplicationInfo::ApplicationInfo(QObject *parent): QObject(parent)
{

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY) || defined(SAILFISHOS)
    m_isMobile = true;
#else
    m_isMobile = false;
#endif

#if defined(Q_OS_ANDROID)
    // Put android before checking linux/unix as it is also a linux
    m_platform = Android;
#elif defined(Q_OS_MAC)
    m_platform = MacOSX;
#elif (defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
    m_platform = Linux;
#elif defined(Q_OS_WIN)
    m_platform = Windows;
#elif defined(Q_OS_IOS)
    m_platform = Ios;
#elif defined(Q_OS_BLACKBERRY)
    m_platform = Blackberry;
#elif defined(SAILFISHOS)
    m_platform = SailfishOS;
#else // default is Linux
    m_platform = Linux;
#endif

    m_isBox2DInstalled = false;

    QRect rect = qApp->primaryScreen()->geometry();
    m_ratio = qMin(qMax(rect.width(), rect.height())/800. , qMin(rect.width(), rect.height())/520.);
    // calculate a factor for font-scaling, cf.
    // http://doc.qt.io/qt-5/scalability.html#calculating-scaling-ratio
    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = qApp->primaryScreen()->logicalDotsPerInch();
    m_fontRatio = qMax(qreal(1.0), qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth)));
    m_isPortraitMode = m_isMobile ? rect.height() > rect.width() : false;
    m_applicationWidth = m_isMobile ? rect.width() : 1120;

    m_useOpenGL = true;

    if (m_isMobile)
        connect(qApp->primaryScreen(), &QScreen::physicalSizeChanged, this, &ApplicationInfo::notifyPortraitMode);

// @FIXME this does not work on iOS: https://bugreports.qt.io/browse/QTBUG-50624
#if not defined(Q_OS_IOS)
    // Get all symbol fonts to remove them
    QFontDatabase database;
    m_excludedFonts = database.families(QFontDatabase::Symbol);
#endif
    // Get fonts from rcc
    const QStringList fontFilters = {"*.otf", "*.ttf"};
    m_fontsFromRcc = QDir(":/gcompris/src/core/resource/fonts").entryList(fontFilters);
}

ApplicationInfo::~ApplicationInfo()
{
    m_instance = nullptr;
}

bool ApplicationInfo::sensorIsSupported(const QString& sensorType)
{
    return QSensor::sensorTypes().contains(sensorType.toUtf8());
}

Qt::ScreenOrientation ApplicationInfo::getNativeOrientation()
{
    return QGuiApplication::primaryScreen()->nativeOrientation();
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
    return QString("assets:/share/GCompris/rcc/%1").arg(file);
#elif defined(Q_OS_MACX)
    return QString("%1/../Resources/rcc/%2").arg(QCoreApplication::applicationDirPath(), file);
#elif defined(Q_OS_IOS)
    return QString("%1/rcc/%2").arg(QCoreApplication::applicationDirPath(), file);
#else
    return QString("%1/%2/rcc/%3").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER, file);
#endif
}

QString ApplicationInfo::getAudioFilePath(const QString &file)
{
    QString localeName = getVoicesLocale(ApplicationSettings::getInstance()->locale());
    return getAudioFilePathForLocale(file, localeName);
}

QString ApplicationInfo::getAudioFilePathForLocale(const QString &file,
                                                   const QString &localeName)
{
    QString filename = file;
    filename.replace("$LOCALE", localeName);
    filename.replace("$CA", CompressedAudio());

    if(file.startsWith('/') || file.startsWith(QLatin1String("qrc:")) || file.startsWith(':'))
        return filename;
    return getResourceDataPath() + '/' + filename;
}

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
        emit portraitModeChanged();
    }
}

void ApplicationInfo::setWindow(QQuickWindow *window)
{
    m_window = window;
}

void ApplicationInfo::screenshot(const QString &file)
{
    QImage img = m_window->grabWindow();
    img.save(file);
}

void ApplicationInfo::notifyFullscreenChanged()
{
    if(ApplicationSettings::getInstance()->isFullscreen())
        m_window->showFullScreen();
    else
        m_window->showNormal();
}

// Would be better to create a component importing Box2D 2.0 using QQmlContext and test if it exists but it does not work.
void ApplicationInfo::setBox2DInstalled(const QQmlEngine &engine) {
    /*
      QQmlContext *context = new QQmlContext(engine.rootContext());
      context->setContextObject(&myDataSet);

      QQmlComponent component(&engine);
      component.setData("import QtQuick 2.0\nimport Box2D 2.0\nItem { }", QUrl());
      component.create(context);
      box2dInstalled = (component != nullptr);
    */
    bool box2dInstalled = false;
    for(const QString &folder: engine.importPathList()) {
        if(QDir(folder).entryList().contains(QStringLiteral("Box2D.2.0"))) {
            if(QDir(folder+"/Box2D.2.0").entryList().contains("qmldir")) {
                qDebug() << "Found box2d in " << folder;
                box2dInstalled = true;
                break;
            }
        }
    }
    m_isBox2DInstalled = box2dInstalled;
    emit isBox2DInstalledChanged();
}

// return the shortest possible locale name for the given locale, describing
// a unique voices dataset
QString ApplicationInfo::getVoicesLocale(const QString &locale)
{
    QString _locale = locale;
    if(_locale == GC_DEFAULT_LOCALE) {
        _locale = QLocale::system().name();
        if(_locale == "C")
            _locale = "en_US";
    }
    // locales we have country-specific voices for:
    if (_locale.startsWith(QLatin1String("pt_BR")) ||
        _locale.startsWith(QLatin1String("zh_CN")) ||
        _locale.startsWith(QLatin1String("zh_TW")))
        return QLocale(_locale).name();
    // short locale for all the rest:
    return localeShort(_locale);
}

QVariantList ApplicationInfo::localeSort(QVariantList list,
                                         const QString& locale) const
{
    std::sort(list.begin(), list.end(),
              [&locale,this](const QVariant& a, const QVariant& b) {
        return (localeCompare(a.toString(), b.toString(), locale) < 0);
    });
    return list;
}

QObject *ApplicationInfo::applicationInfoProvider(QQmlEngine *engine,
                                             QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    /*
     * Connect the fullscreen change signal to applicationInfo in order to change
     * the QQuickWindow value
     */
    ApplicationInfo* appInfo = getInstance();
    connect(ApplicationSettings::getInstance(), &ApplicationSettings::fullscreenChanged, appInfo,
            &ApplicationInfo::notifyFullscreenChanged);

    return appInfo;
}
