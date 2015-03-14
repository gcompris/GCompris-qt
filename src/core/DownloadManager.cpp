/* GCompris - DownloadManager.cpp
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

#include "DownloadManager.h"
#include "ApplicationSettings.h"
#include "ApplicationInfo.h"

#include <QFile>
#include <QDir>
#include <QResource>
#include <QStandardPaths>
#include <QMutexLocker>
#include <QNetworkConfiguration>
#include <QDirIterator>

const QString DownloadManager::contentsFilename = QString("Contents");
DownloadManager* DownloadManager::_instance = 0;

/* Public interface: */

DownloadManager::DownloadManager()
  : accessManager(this), serverUrl(ApplicationSettings::getInstance()->downloadServerUrl())
{
}

DownloadManager::~DownloadManager()
{
    shutdown();
    _instance = 0;
}

void DownloadManager::shutdown()
{
    qDebug() << "DownloadManager: shutting down," << activeJobs.size() << "active jobs";
    abortDownloads();
}

// It is not recommended to create a singleton of Qml Singleton registered
// object but we could not found a better way to let us access DownloadManager
// on the C++ side. All our test shows that it works.
// Using the singleton after the QmlEngine has been destroyed is forbidden!
DownloadManager* DownloadManager::getInstance()
{
    if (!_instance)
        _instance = new DownloadManager;
    return _instance;
}

QObject *DownloadManager::systeminfoProvider(QQmlEngine *engine,
        QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return getInstance();
}

void DownloadManager::init()
{
    qmlRegisterSingletonType<DownloadManager>("GCompris", 1, 0,
            "DownloadManager",
            systeminfoProvider);
}

bool DownloadManager::downloadIsRunning() const
{
    return (activeJobs.size() > 0);
}

void DownloadManager::abortDownloads()
{
    if (activeJobs.size() > 0) {
        QMutexLocker locker(&jobsMutex);
        QMutableListIterator<DownloadJob*> iter(activeJobs);
        while (iter.hasNext()) {
            DownloadJob *job = iter.next();
            if (job->reply) {
                disconnect(job->reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
                disconnect(job->reply, SIGNAL(error(QNetworkReply::NetworkError)),
                        this, SLOT(handleError(QNetworkReply::NetworkError)));
                if (job->reply->isRunning()) {
                    qDebug() << "Aborting download job:" << job->url;
                    job->reply->abort();
                    job->file.close();
                    job->file.remove();
                }
                delete job->reply;
            }
            iter.remove();
        }
        locker.unlock();
        emit error(QNetworkReply::OperationCanceledError, "Download cancelled by user");
    }
}

/** Helper generating a relative voices resources file-path for a given locale
 *
 * @param locale  Locale name string of the form <language>_<country>. */
QString DownloadManager::getVoicesResourceForLocale(const QString& locale) const
{
    return QString("data/voices-" COMPRESSED_AUDIO "/voices-%1.rcc").arg(locale);
}

/** Transform the passed relative path to an absolute resource path of an
 * existing .rcc file, honouring the order of the systemResourcePaths
 *
 * @returns The absolute path of the .rcc file if it exists, QString() otherwise
 */
inline QString DownloadManager::getAbsoluteResourcePath(const QString& path) const
{
    foreach (const QString &base, getSystemResourcePaths()) {
        if (QFile::exists(base + '/' + path))
            return QString(base + '/' + path);
    }
    return QString();
}

/** Transform the passed absolute relative path to a relative resource path if possible
 *
 * @returns The relative path if it could be generated, QString() otherwise
 */
inline QString DownloadManager::getRelativeResourcePath(const QString& path) const
{
    QStringList parts = path.split('/', QString::SkipEmptyParts);
    if (parts.size() < 3)
        return QString();
    return QString(parts[parts.size()-3] + '/' + parts[parts.size()-2]
                   + '/' + parts[parts.size()-1]);
}

/** Check if the given relative resource path exists locally */
bool DownloadManager::haveLocalResource(const QString& path) const
{
    return (!getAbsoluteResourcePath(path).isEmpty());
}

/** Update resource from server if not prohibited by the settings and register
 * it if possible
 *
 * @returns success*/
bool DownloadManager::updateResource(const QString& path)
{
    if (checkDownloadRestriction())
        return downloadResource(path);  // check for updates and register
    else {
        QString absPath = getAbsoluteResourcePath(path);
        // automatic download prohibited -> register if available
        if (!absPath.isEmpty())
            return registerResource(absPath);
        else {
            qDebug() << "No such local resource and download prohibited:"
                << path;
            return false;
        }
    }
}

/** Download a resource based on the passed relative resource path and register
 * it if possible
 *
 * If a corresponding local resource exists, an update will only be downloaded
 * if it is not up2date according to checksum comparison. Whenever at the end
 * we have a valid .rcc file it will be registered.
 *
 * @returns success*/
bool DownloadManager::downloadResource(const QString& path)
{
    qDebug() << "Downloading resource file" << path;
    DownloadJob* job = new DownloadJob(QUrl(serverUrl.toString() + '/' + path));

    {
        QMutexLocker locker(&jobsMutex);
        activeJobs.append(job);
    }

    if (!download(job)) {
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
        return false;
    }
    return true;
}

#if 0
// vvv might be helpful later with other use-cases:
void DownloadManager::registerLocalResources()
{
    QStringList filenames = getLocalResources();
    if (filenames == QStringList()) {
        qDebug() << "No local resources found";
        return;
    }

    QList<QString>::const_iterator iter;
    for (iter = filenames.constBegin(); iter != filenames.constEnd(); iter++)
        registerResource(*iter);
}

bool DownloadManager::checkForUpdates()
{
    QStringList filenames = getLocalResources();
    if (filenames == QStringList()) {
        qDebug() << "No local resources found";
        return true;
    }

    if (!checkDownloadRestriction()) {
        qDebug() << "Can't download with current network connection (" <<
                networkConfiguration.bearerTypeName() << ")!";
        return false;
    }

    QList<QString>::const_iterator iter;
    DownloadJob *job = new DownloadJob();
    for (iter = filenames.constBegin(); iter != filenames.constEnd(); iter++) {
        QUrl url = getUrlForFilename(*iter);
        qDebug() << "Scheduling resource for update: " << url;
        job->queue.append(url);
    }
    job->url = job->queue.takeFirst();

    {
        QMutexLocker locker(&jobsMutex);
        activeJobs.append(job);
    }

    if (!download(job)) {
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
        return false;
    }
    return true;

}
#endif

/* Private: */

inline QString DownloadManager::tempFilenameForFilename(const QString &filename) const
{
    return QString(filename).append("_");
}

inline QString DownloadManager::filenameForTempFilename(const QString &tempFilename) const
{
    if (tempFilename.endsWith(QLatin1String("_")))
        return tempFilename.left(tempFilename.length() - 1);
    return tempFilename;
}

/** Start a new download specified by the passed DownloadJob */
bool DownloadManager::download(DownloadJob* job)
{
    QNetworkRequest request;

    // First download Contents file for verification if not yet done:
    if (!job->contents.contains(job->url.fileName())) {
        int len = job->url.fileName().length();
        QUrl contentsUrl = QUrl(job->url.toString().remove(job->url.toString().length() - len, len)
                + contentsFilename);
        if (!job->knownContentsUrls.contains(contentsUrl)) {
            // Note: need to track already tried Contents files or we can end
            // up in an infinite loop if corresponding Contents file does not
            // exist upstream
            job->knownContentsUrls.append(contentsUrl);
            //qDebug() << "Postponing rcc download, first fetching Contents" << contentsUrl;
            job->queue.prepend(job->url);
            job->url = contentsUrl;
        }
    }

    QFileInfo fi(getFilenameForUrl(job->url));
    // make sure target path exists:
    QDir dir;
    if (!dir.exists(fi.path()) && !dir.mkpath(fi.path())) {
        qDebug() << "Could not create resource path " << fi.path();
        emit error(QNetworkReply::InternalServerError, "Could not create resource path");
        return false;
    }

    job->file.setFileName(tempFilenameForFilename(fi.filePath()));
    if (!job->file.open(QIODevice::WriteOnly)) {
        emit error(QNetworkReply::InternalServerError,
                QString("Could not open target file %1").arg(job->file.fileName()));
        return false;
    }

    // start download:
    request.setUrl(job->url);
    //qDebug() << "Now downloading" << job->url << "to" << fi.filePath() << "...";
    QNetworkReply *reply = accessManager.get(request);
    job->reply = reply;
    connect(reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
    connect(reply, SIGNAL(readyRead()), this, SLOT(downloadReadyRead()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(handleError(QNetworkReply::NetworkError)));
    if (job->url.fileName() != contentsFilename) {
        connect(reply, SIGNAL(downloadProgress(qint64,qint64)),
                this, SIGNAL(downloadProgress(qint64,qint64)));
        emit downloadStarted(job->url.toString().remove(0, serverUrl.toString().length()));
    }

    return true;
}

inline DownloadManager::DownloadJob* DownloadManager::getJobByReply(QNetworkReply *r)
{
    QMutexLocker locker(&jobsMutex);
    for (int i = 0; i < activeJobs.size(); i++)
        if (activeJobs[i]->reply == r)
            return activeJobs[i];
    return NULL;  // should never happen!
}

void DownloadManager::downloadReadyRead()
{
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());
    DownloadJob *job = getJobByReply(reply);
    job->file.write(reply->readAll());
}

inline QString DownloadManager::getFilenameForUrl(const QUrl& url) const
{
    QString relPart = url.toString().remove(0, serverUrl.toString().length());
    return QString(getSystemDownloadPath() + relPart);
}

inline QUrl DownloadManager::getUrlForFilename(const QString& filename) const
{
    return QUrl(serverUrl.toString() + '/' + getRelativeResourcePath(filename));
}

inline QString DownloadManager::getResourceRootForFilename(const QString& filename) const
{
    QStringList parts = QFileInfo(filename).path()
            .remove("-" COMPRESSED_AUDIO) // krazy:excludeall=doublequote_chars
            .split('/', QString::SkipEmptyParts);
    return QString("/gcompris") + '/' + parts[parts.size()-2] +
            '/' + parts[parts.size()-1];
}

/** Get platform-specific path storing downloaded resources
 *
 * Uses QStandardPaths::writableLocation(QStandardPaths::DataLocation)
 * which returns
 *   - on desktop $HOME/.local/share/KDE/gcompris-qt/
 *   - on android /data/data/net.gcompris/files
 *
 */
inline QString  DownloadManager::getSystemDownloadPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DataLocation);
}

/** Get all paths that are used for storing resources
 *
 * The caller should keep list order when looking for resources.
 *
 * For now returns
 * 1. getSystemdDownloadPath()
 * 2. QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)/gcompris-qt
 *    which is
 *    - $HOME/.local/share/gcompris-qt (on linux desktop)
 *    - /storage/sdcard0/GCompris (on android)
 *
 */
inline QStringList DownloadManager::getSystemResourcePaths() const
{
    return QStringList({
        getSystemDownloadPath(),
#if defined(Q_OS_ANDROID)
        "assets:",
#endif
        QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) +
            '/' + GCOMPRIS_APPLICATION_NAME
    });
}

bool DownloadManager::checkDownloadRestriction() const
{
#if 0
    // note: Something like the following can be used once bearer mgmt
    // has been implemented for android (cf. Qt bug #30394)
    QNetworkConfiguration::BearerType conn = networkConfiguration.bearerType();
    qDebug() << "Bearer type: "<<  conn << ": "<< networkConfiguration.bearerTypeName();
	if (!ApplicationSettings::getInstance()->isMobileNetworkDownloadsEnabled() &&
        conn != QNetworkConfiguration::BearerEthernet &&
        conn != QNetworkConfiguration::QNetworkConfiguration::BearerWLAN)
        return false;
    return true;
#endif
    return ApplicationSettings::getInstance()->isAutomaticDownloadsEnabled();
}

void DownloadManager::handleError(QNetworkReply::NetworkError code)
{
    Q_UNUSED(code);
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());
    emit error(reply->error(), reply->errorString());
}

/** Parse upstream Contents file and build checksum map
 *
 * We expect the line-syntax, that md5sum and colleagues creates:
 *
 * <MD5SUM>  <FILENAME>
 * 53f0a3eb206b3028500ca039615c5f84  voices-en.rcc
 */
bool DownloadManager::parseContents(DownloadJob *job)
{
    if (job->file.isOpen())
        job->file.close();

    if (!job->file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file " << job->file.fileName();
        return false;
    }

    QTextStream in(&job->file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split(' ', QString::SkipEmptyParts);
        if (parts.size() != 2) {
            qWarning() << "Invalid format of Contents file!";
            return false;
        }
        job->contents[parts[1]] = parts[0];
        //qDebug() << "Contents: " << parts[1] << " -> " << parts[0];
    }
    job->file.close();
    return true;
}

/** Compares the checksum of the file in filename with the contents map in the
 * passed DownloadJob */
bool DownloadManager::checksumMatches(DownloadJob *job, const QString& filename) const
{
    Q_ASSERT(job->contents != (QMap<QString, QString>()));

    if (!QFile::exists(filename))
        return false;

    QString basename = QFileInfo(filename).fileName();
    if (!job->contents.contains(basename))
        return false;

    QFile file(filename);
    file.open(QIODevice::ReadOnly);
    QCryptographicHash fileHasher(hashMethod);
    if (!fileHasher.addData(&file)) {
        qWarning() << "Could not read file for hashing: " << filename;
        return false;
    }
    file.close();
    QByteArray fileHash = fileHasher.result().toHex();
    //qDebug() << "Checking file-hash ~ contents-hash: " << fileHash << " ~ " << job->contents[basename];

    return (fileHash == job->contents[basename]);
}

/** Unregister the passed resource
 *
 * Caller must lock rcMutex
 */
void DownloadManager::unregisterResource_locked(const QString& filename)
{
    if (!QResource::unregisterResource(filename, getResourceRootForFilename(filename)))
            qDebug() << "Error unregistering resource file" << filename;
    else {
        qDebug() << "Successfully unregistered resource file" << filename;
        registeredResources.removeOne(filename);
    }
}

inline bool DownloadManager::isRegistered(const QString& filename) const
{
    return (registeredResources.indexOf(filename) != -1);
}

bool DownloadManager::registerResource(const QString& filename)
{
    QMutexLocker locker(&rcMutex);
    if (isRegistered(filename))
        unregisterResource_locked(filename);

    if (!QResource::registerResource(filename, getResourceRootForFilename(filename))) {
        qDebug() << "Error registering resource file" << filename;
        return false;
    } else {
        qDebug() << "Successfully registered resource"
                << filename
                << "(rcRoot=" << getResourceRootForFilename(filename) << ")";
        registeredResources.append(filename);

        QString relPath = getRelativeResourcePath(filename);
        emit resourceRegistered(relPath);

        QString v = getVoicesResourceForLocale(
                ApplicationSettings::getInstance()->locale());
        if (v == relPath)
            emit voicesRegistered();
        return false;
    }
}

bool DownloadManager::isResourceRegistered(const QString& resource) const
{
    for (auto &base: getSystemResourcePaths())
        if (isRegistered(base + '/' + resource))
            return true;
    return false;
}

bool DownloadManager::areVoicesRegistered() const
{
    QString relFilename = getVoicesResourceForLocale(
            ApplicationSettings::getInstance()->locale());
    return isResourceRegistered(relFilename);
}

/** Handle a finished download
 *
 * Called whenever a single download (sub-job) has finished. Responsible for
 * iterating over possibly remaining sub-jobs of our DownloadJob.
 */
void DownloadManager::downloadFinished()
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());
    DownloadFinishedCode code = Success;
    DownloadJob *job = getJobByReply(reply);
    if (job->file.isOpen()) {
        job->file.flush();  // note: important, or checksums might be wrong!
        job->file.close();
    }
    if (reply->error() && job->file.exists())
        job->file.remove();
    else {
        // active temp file
        QString tFilename = filenameForTempFilename(job->file.fileName());
        if (QFile::exists(tFilename))
            QFile::remove(tFilename);
        if (!job->file.rename(tFilename))
            qWarning() << "Could not rename temporary file to" << tFilename;
    }

    QString targetFilename = getFilenameForUrl(job->url);
    if (job->url.fileName() == contentsFilename) {
        // Contents
        if (reply->error()) {
            qWarning() << "Error downloading Contents from" << job->url
                    << ":" << reply->error() << ":" << reply->errorString();
            // note: errorHandler() emit's error!
            code = Error;
            goto outError;
        }
        //qDebug() << "Download of Contents finished successfully: " << job->url;
        if (!parseContents(job)) {
            qWarning() << "Invalid format of Contents file" << job->url;
            emit error(QNetworkReply::UnknownContentError, "Invalid format of Contents file");
            code = Error;
            goto outError;
        }
    } else {
        // RCC file
        if (reply->error()) {
            qWarning() << "Error downloading RCC file from " << job->url
                << ":" << reply->error() << ":" << reply->errorString();
            // note: errorHandler() emit's error!
            code = Error;
            // register already existing files:
            if (QFile::exists(targetFilename))
                registerResource(targetFilename);
        } else {
            qDebug() << "Download of RCC file finished successfully: " << job->url;
            if (!checksumMatches(job, targetFilename)) {
                qWarning() << "Checksum of downloaded file does not match: "
                        << targetFilename;
                emit error(QNetworkReply::UnknownContentError,
                        QString("Checksum of downloaded file does not match: %1")
                            .arg(targetFilename));
                code = Error;
            } else
                registerResource(targetFilename);
        }
    }

    // try next:
    while (!job->queue.isEmpty()) {
        job->url = job->queue.takeFirst();
        QString relPath = getRelativeResourcePath(getFilenameForUrl(job->url));
        // check in each resource-path for an up2date rcc file:
        foreach (const QString &base, getSystemResourcePaths()) {
            QString filename = base + '/' + relPath;
            if (QFile::exists(filename)
                && checksumMatches(job, filename))
            {
                // file is up2date, register! necessary:
                qDebug() << "Local resource is up-to-date:"
                        << QFileInfo(filename).fileName();
                registerResource(filename);
                code = NoChange;
                break;
            }
        }
        if (code != NoChange)  // nothing is up2date locally -> download it
            if (download(job))
                goto outNext;
    }

    // none left, DownloadJob finished
    if (job->file.isOpen())
        job->file.close();
    { // note: must remove before signalling downloadFinished(), otherwise race condition for the Qt.quit() case
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
    }
    emit downloadFinished(code);
    delete reply;
    delete job;
    return;

  outError:
    if (job->url.fileName() == contentsFilename) {
        // if we could not download the contents file register local existing
        // files for outstanding jobs:
        QUrl nUrl;
        while (!job->queue.isEmpty()) {
            nUrl = job->queue.takeFirst();
            QString relPath = getRelativeResourcePath(getFilenameForUrl(nUrl));
            foreach (const QString &base, getSystemResourcePaths()) {
                QString filename = base + '/' + relPath;
                if (QFile::exists(filename))
                    registerResource(filename);
                }
        }
    }

    if (job->file.isOpen())
        job->file.close();

    {
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
    }

    delete reply;
    delete job;
    return;

  outNext:
    // next sub-job started
    delete reply;
    return;
}

QStringList DownloadManager::getLocalResources()
{
    QStringList result;

    foreach (const QString &path, getSystemResourcePaths()) {
        QDir dir(path);
        if (!dir.exists(path) && !dir.mkpath(path)) {
            qWarning() << "Could not create resource path " << path;
            continue;
        }

        QDirIterator it(dir, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            QString filename = it.next();
            QFileInfo fi = it.fileInfo();
            if (fi.isFile() &&
                    (filename.endsWith(QLatin1String(".rcc"))))
                result.append(filename);
        }
    }
    return result;
}
