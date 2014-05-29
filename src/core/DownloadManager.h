/* GCompris - DownloadManager.h
 *
 * Copyright (C) 2014 Holger Kaelberer
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

#ifndef DOWNLOADMANAGER_H_
#define DOWNLOADMANAGER_H_

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

        DownloadJob() : DownloadJob(QUrl()) {}
        DownloadJob(QUrl u) : url(u), file(), reply(0),
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

    QString getSystemResourcePath() const;
    QString getResourceRootForFilename(const QString& filename) const;
    QString getFilenameForUrl(const QUrl& url) const;
    QUrl getUrlForFilename(const QString& filename) const;

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
    void downloadFinished(QNetworkReply*);
    void downloadReadyRead();
    void handleError(QNetworkReply::NetworkError code);

public:
    // public interface:
    virtual ~DownloadManager();

    static void init();
    static QObject *systeminfoProvider(QQmlEngine *engine,
            QJSEngine *scriptEngine);
    static DownloadManager* getInstance();

    Q_INVOKABLE QString getVoicesResourceForLocale(const QString& locale) const;
    Q_INVOKABLE bool haveLocalResource(const QString& path) const;

public slots:
    Q_INVOKABLE bool updateResource(const QString& path);
    Q_INVOKABLE bool downloadResource(const QString& path);

#if 0
    Q_INVOKABLE bool checkForUpdates();  // might be helpful later with other use-cases!
    Q_INVOKABLE void registerLocalResources();
#endif

signals:
    void error(const QString& msg);
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished();
};

#endif /* DOWNLOADMANAGER_H_ */
