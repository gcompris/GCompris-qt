/* GCompris - ServerSettings.h
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SERVERSETTINGS_H
#define SERVERSETTINGS_H

#include <QObject>
#include <QQmlEngine>
#include <QDebug>

#include <QSettings>
#include <QStandardPaths>

#define GCOMPRIS_SERVER_APPLICATION_NAME "gcompris-server"

/**
 * @class ServerSettings
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
 *
 * Besides these global settings there is one group for each activity that
 * stores persistent settings.
 *
 * Settings defaults are defined in the source code.
 *
 */
class ServerSettings : public QObject
{
    Q_OBJECT

    /* General group */

    /**
     * Database file storing the information.
     */
    Q_PROPERTY(QString databaseFile READ databaseFile WRITE setDatabaseFile NOTIFY databaseFileChanged)

public:
    explicit ServerSettings(const QString &configPath = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation)
                                     + "/gcompris/" + GCOMPRIS_SERVER_APPLICATION_NAME + ".conf",
                                 QObject *parent = 0);
    virtual ~ServerSettings();
    // It is not recommended to create a singleton of Qml Singleton registered
    // object but we could not found a better way to let us access ApplicationInfo
    // on the C++ side. All our test shows that it works.
    static ServerSettings *getInstance()
    {
        if (!m_instance) {
            m_instance = new ServerSettings();
        }
        return m_instance;
    }
    static QObject *serverSettingsProvider(QQmlEngine *engine,
                                           QJSEngine *scriptEngine);

    QString databaseFile() const
    {
        return m_databaseFile;
    }
    void setDatabaseFile(const QString &newDatabaseFile)
    {
        m_databaseFile = newDatabaseFile;
        emit databaseFileChanged();
    }

protected slots:

    Q_INVOKABLE void notifyDatabaseFileChanged();
    /**
     * Synchronize the changes done in the application in the configuration file.
     */
    Q_INVOKABLE void sync();

signals:
    void databaseFileChanged();

protected:
    static ServerSettings *m_instance;

private:
    // Update in configuration the couple {key, value} in the group.
    template <class T>
    void updateValueInConfig(const QString &group,
                             const QString &key, const T &value, bool sync = true);

    QString m_databaseFile;

    QSettings m_config;
};

#endif // SERVERSETTINGS_H
