/* GCompris - GComprisPlugin.cpp
 *
 * SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include "GComprisPlugin.h"
#include "ApplicationInfo.h"
#include "ActivityInfoTree.h"
#include "ApplicationSettings.h"
#include "File.h"
#include "Directory.h"
#include "DownloadManager.h"
#include "synth/GSynth.h"
#include <QQmlComponent>

const int versionMajor = 1;
const int versionMinor = 0;

GComprisPlugin::GComprisPlugin(QObject *parent) :
    QQmlExtensionPlugin(parent)
{
}

void GComprisPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<File>(uri, versionMajor, versionMinor,
                          "File");
    qmlRegisterType<Directory>(uri, versionMajor, versionMinor,
                               "Directory");

    qmlRegisterSingletonType<ApplicationInfo>(uri, versionMajor, versionMinor,
                                              "ApplicationInfo", ApplicationInfo::applicationInfoProvider);

    qmlRegisterSingletonType<ActivityInfoTree>(uri, versionMajor, versionMinor,
                                               "ActivityInfoTree", ActivityInfoTree::menuTreeProvider);
    qmlRegisterType<Dataset>(uri, versionMajor, versionMinor, "Data");
    qmlRegisterType<ActivityInfo>(uri, versionMajor, versionMinor, "ActivityInfo");
    qmlRegisterSingletonType<ApplicationSettings>(uri, versionMajor, versionMinor,
                                                  "ApplicationSettings", ApplicationSettings::applicationSettingsProvider);
    qmlRegisterSingletonType<DownloadManager>(uri, versionMajor, versionMinor,
                                              "DownloadManager", DownloadManager::downloadManagerProvider);
    qmlRegisterUncreatableMetaObject(GCompris::staticMetaObject,
                                     uri, versionMajor, versionMinor, "GCompris", "");

    qmlRegisterSingletonType<GSynth>(uri, versionMajor, versionMinor,
                                     "GSynth", GSynth::synthProvider);
}

#include "moc_GComprisPlugin.cpp"
