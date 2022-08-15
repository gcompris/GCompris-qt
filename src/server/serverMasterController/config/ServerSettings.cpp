/* GCompris - ServerSettings.cpp
 *
 * SPDX-FileCopyrightText: 2014-2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "ServerSettings.h"

#define DEFAULT_DATABASE_PATH "." // TODO Put in userpath?
// Either QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) or 
// QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QLatin1String("/GCompris")

static const char *ADMIN_GROUP_KEY = "Admin";

static const char *DATABASE_PATH_KEY = "databaseFile";

ServerSettings *ServerSettings::m_instance = nullptr;

ServerSettings::ServerSettings(const QString &configPath, QObject *parent) :
    QObject(parent),
    m_config(configPath, QSettings::IniFormat)
{
    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    if(m_config.contains(DATABASE_PATH_KEY)) {
        m_databaseFile = m_config.value(DATABASE_PATH_KEY).toString();
    }
    else {
        m_config.setValue(DATABASE_PATH_KEY, QLatin1String(DEFAULT_DATABASE_PATH));
    }
    //QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    //QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QLatin1String("/GCompris");

    m_config.endGroup();
    m_config.sync(); // make sure all defaults are written back
    connect(this, &ServerSettings::databaseFileChanged, this, &ServerSettings::notifyDatabaseFileChanged);
}

ServerSettings::~ServerSettings()
{
    // make sure settings file is up2date:
    // admin group
    m_config.beginGroup(ADMIN_GROUP_KEY);
    m_config.setValue(DATABASE_PATH_KEY, m_databaseFile);
    m_config.endGroup();

    m_config.sync();

    m_instance = nullptr;
}

void ServerSettings::notifyDatabaseFileChanged()
{
    updateValueInConfig(ADMIN_GROUP_KEY, DATABASE_PATH_KEY, m_databaseFile);
    qDebug() << "new databaseFile: " << m_databaseFile;
}

template <class T>
void ServerSettings::updateValueInConfig(const QString &group,
                                              const QString &key, const T &value, bool sync)
{
    m_config.beginGroup(group);
    m_config.setValue(key, value);
    m_config.endGroup();
    if (sync) {
        m_config.sync();
    }
}

void ServerSettings::sync()
{
    m_config.sync();
}

QObject *ServerSettings::serverSettingsProvider(QQmlEngine *engine,
                                                QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    ServerSettings *appSettings = getInstance();
    return appSettings;
}
