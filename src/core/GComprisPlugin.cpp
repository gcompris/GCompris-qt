/* GCompris - GComprisPlugin.cpp
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
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

    qmlRegisterSingletonType<QObject>(uri, versionMajor, versionMinor,
                                      "ActivityInfoTree", ActivityInfoTree::menuTreeProvider);
    qmlRegisterType<ActivityInfo>(uri, versionMajor, versionMinor, "ActivityInfo");

    qmlRegisterSingletonType<ApplicationSettings>(uri, versionMajor, versionMinor,
                                                  "ApplicationSettings", ApplicationSettings::applicationSettingsProvider);
    qmlRegisterSingletonType<DownloadManager>(uri, versionMajor, versionMinor,
                                              "DownloadManager", DownloadManager::downloadManagerProvider);

    qmlRegisterSingletonType<GSynth>(uri, versionMajor, versionMinor,
                                     "GSynth", GSynth::synthProvider);

}
