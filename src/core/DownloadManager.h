/* GCompris - DownloadManager.h
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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

#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QCryptographicHash>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMutex>
#include <QNetworkConfiguration>
#include <QString>
#include <QUrl>
#include <QVariant>
#include <QQmlEngine>
#include <QJSEngine>

class DownloadManager : public QObject
{
    Q_OBJECT

private:
    DownloadManager();  // prohibit external creation, we are a singleton!
    static DownloadManager* _instance;  // singleton instance

    /** Container for a full download job */
    typedef struct DownloadJob
    {
        QUrl url;              ///< url of the currently running sub-job
        QFile file;            ///< target file for the currently running sub-job
        QNetworkReply *reply;  ///< reply object for the currently running sub-job
        QList<QUrl> queue;     ///< q of remaining sub jobs (QList for convenience)
        QMap<QString,QString> contents;  ///< checksum map for download verification
        QList<QUrl> knownContentsUrls;   ///< store already tried upstream Contents files (for infinite loop protection)

        DownloadJob(QUrl u = QUrl()) : url(u), file(), reply(0),
                queue(QList<QUrl>()) {}
    } DownloadJob;

    QList<DownloadJob*> activeJobs;  // track active jobs to allow for parallel downloads
    QMutex jobsMutex;       // not sure if we need to expect concurrent access, better lockit!

    static const QString contentsFilename;
    static const QCryptographicHash::Algorithm hashMethod = QCryptographicHash::Md5;

    QList<QString> registeredResources;
    QMutex rcMutex;        // not sure if we need to expect concurrent access, better lockit!

    QNetworkAccessManager accessManager;
    QUrl serverUrl;

    QString getSystemDownloadPath() const;
    QStringList getSystemResourcePaths() const;
    QString getResourceRootForFilename(const QString& filename) const;
    QString getFilenameForUrl(const QUrl& url) const;
    QUrl getUrlForFilename(const QString& filename) const;
    QString getAbsoluteResourcePath(const QString& path) const;
    QString getRelativeResourcePath(const QString& path) const;
    QString tempFilenameForFilename(const QString &filename) const;
    QString filenameForTempFilename(const QString &tempFilename) const;

    bool checkDownloadRestriction() const;
    DownloadJob* getJobByReply(QNetworkReply *r);
    bool download(DownloadJob* job);
    bool parseContents(DownloadJob *job);
    bool checksumMatches(DownloadJob *job, const QString& filename) const;

    bool registerResource(const QString& filename);
    void unregisterResource_locked(const QString& filename);
    bool isRegistered(const QString& filename) const;

    QStringList getLocalResources();

private slots:
    void downloadFinished();
    void downloadReadyRead();
    void handleError(QNetworkReply::NetworkError code);

public:
    // public interface:
    enum DownloadFinishedCode {
        Success = 0,  // download executed successfully
        Error   = 1,  // download error
        NoChange = 2  // local files are up-to-date, no download was needed
    };

    virtual ~DownloadManager();

    static void init();
    static QObject *systeminfoProvider(QQmlEngine *engine,
            QJSEngine *scriptEngine);
    static DownloadManager* getInstance();

    Q_INVOKABLE QString getVoicesResourceForLocale(const QString& locale) const;
    Q_INVOKABLE bool haveLocalResource(const QString& path) const;
    Q_INVOKABLE bool downloadIsRunning() const;
    Q_INVOKABLE bool isResourceRegistered(const QString& resource) const;  // checks whether the passed relative resource filename is registered
    Q_INVOKABLE bool areVoicesRegistered() const;  // special case of the former: checks whether voices for the currently active locale are registered

public slots:
    Q_INVOKABLE bool updateResource(const QString& path);
    Q_INVOKABLE bool downloadResource(const QString& path);
    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void abortDownloads();

#if 0
    Q_INVOKABLE bool checkForUpdates();  // might be helpful later with other use-cases!
    Q_INVOKABLE void registerLocalResources();
#endif

signals:
    void error(int code, const QString& msg); // note: code is actually a enum NetworkError, but this would not be exposed well to the QML layer
    void downloadStarted(const QString& resource);
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(int code); // note: when using DownloadFinishedCode instead of int the code will not be passed to the QML layer
    void resourceRegistered(const QString& resource);  // emitted when a resource is registered
    void voicesRegistered(); // special case of the former: emitted when voices for current locale have been registered
};

#endif /* DOWNLOADMANAGER_H */
