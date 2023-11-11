/* GCompris - DownloadManager.cpp
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
#include <QCoreApplication>

const QString DownloadManager::contentsFilename = QLatin1String("Contents");
DownloadManager *DownloadManager::_instance = nullptr;

const QString DownloadManager::localFolderForData = QLatin1String("data3/");
/* Public interface: */

DownloadManager::DownloadManager() :
    accessManager(this), serverUrl(ApplicationSettings::getInstance()->downloadServerUrl())
{
    // Manually add the "ISRG Root X1" certificate to download on older android
    // Check https://bugs.kde.org/show_bug.cgi?id=447572 for more info
#if defined(Q_OS_ANDROID)
    // Starting Qt5.15, we can directly use addCaCertificate (https://doc.qt.io/qt-5/qsslconfiguration.html#addCaCertificate)
    auto sslConfig = QSslConfiguration::defaultConfiguration();
    QList<QSslCertificate> certificates = sslConfig.caCertificates();
    // Certificate downloaded from https://letsencrypt.org/certificates/#root-certificates
    QFile file(":/gcompris/src/core/resource/isrgrootx1.pem");
    QIODevice::OpenMode openMode = QIODevice::ReadOnly | QIODevice::Text;
    if (!file.open(openMode)) {
        qDebug() << "Error opening " << file;
    }
    else {
        certificates << QSslCertificate::fromData(file.readAll(), QSsl::Pem);
        sslConfig.setCaCertificates(certificates);
        QSslConfiguration::setDefaultConfiguration(sslConfig);
    }
#endif
}

DownloadManager::~DownloadManager()
{
    shutdown();
    _instance = nullptr;
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
DownloadManager *DownloadManager::getInstance()
{
    if (_instance == nullptr)
        _instance = new DownloadManager;
    return _instance;
}

QObject *DownloadManager::downloadManagerProvider(QQmlEngine *engine,
                                                  QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return getInstance();
}

bool DownloadManager::downloadIsRunning() const
{
    return !activeJobs.empty();
}

void DownloadManager::abortDownloads()
{
    if (downloadIsRunning()) {
        QMutexLocker locker(&jobsMutex);
        QMutableListIterator<DownloadJob *> iter(activeJobs);
        while (iter.hasNext()) {
            DownloadJob *job = iter.next();
            if (!job->downloadFinished && job->reply != nullptr) {
                disconnect(job->reply, SIGNAL(finished()), this, SLOT(finishDownload()));
                disconnect(job->reply, SIGNAL(error(QNetworkReply::NetworkError)),
                           this, SLOT(handleError(QNetworkReply::NetworkError)));
                if (job->reply->isRunning()) {
                    qDebug() << "Aborting download job:" << job->url << job->resourceType;
                    job->reply->abort();
                    job->file.close();
                    job->file.remove();
                }
                job->reply->deleteLater();
            }
            delete job;
            iter.remove();
        }
        locker.unlock();
        Q_EMIT error(QNetworkReply::OperationCanceledError, QObject::tr("Download cancelled by user"));
    }
}

void DownloadManager::initializeAssets()
{
    const QStringList files = {
        localFolderForData + QLatin1String("Contents"),
        localFolderForData + QLatin1String("voices-" COMPRESSED_AUDIO "/Contents"),
        localFolderForData + QLatin1String("backgroundMusic/Contents"),
        localFolderForData + QLatin1String("words/Contents")
    };
    for (const QString &contentsFolder: files) {
        QFileInfo fi(getAbsoluteResourcePath(contentsFolder));
        if (fi.exists()) {
            DownloadJob job(GCompris::ResourceType::NONE);
            job.file.setFileName(fi.filePath());
            parseContents(&job);
        }
        else {
            qDebug() << fi.filePath() << "does not exist, cannot parse Contents for " << contentsFolder;
        }
    }

    connect(this, &DownloadManager::allDownloadsFinished, this, &DownloadManager::finishAllDownloads);
}

QString DownloadManager::getVoicesResourceForLocale(const QString &locale) const
{
    const QString localeName = ApplicationInfo::getInstance()->getVoicesLocale(locale);
    qDebug() << "Get voices for " << locale << ", " << localeName;
    return getResourcePath(GCompris::ResourceType::VOICES, { { "locale", localeName } });
}

QString DownloadManager::getBackgroundMusicResources() const
{
    return getResourcePath(GCompris::ResourceType::BACKGROUND_MUSIC, {});
}

inline QString DownloadManager::getAbsoluteResourcePath(const QString &path) const
{
    for (const QString &base: getSystemResourcePaths()) {
        if (QFile::exists(base + '/' + path))
            return QString(base + '/' + path);
    }
    return QString();
}

// @FIXME should support a variable subpath length like data2/full.rcc"
inline QString DownloadManager::getRelativeResourcePath(const QString &path) const
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
    QStringList parts = path.split('/', Qt::SkipEmptyParts);
#else
    QStringList parts = path.split('/', QString::SkipEmptyParts);
#endif
    if (parts.size() < 3)
        return QString();
    return QString(parts[parts.size() - 3] + '/' + parts[parts.size() - 2]
                   + '/' + parts[parts.size() - 1]);
}

bool DownloadManager::haveLocalResource(const QString &path) const
{
    return (!getAbsoluteResourcePath(path).isEmpty());
}

QString DownloadManager::getLocalSubFolderForData(const GCompris::ResourceType &rt) const
{
    switch (rt) {
    case GCompris::ResourceType::WORDSET:
        return localFolderForData + QLatin1String("words/");
        break;
    case GCompris::ResourceType::BACKGROUND_MUSIC:
        return localFolderForData + QLatin1String("backgroundMusic/");
        break;
    case GCompris::ResourceType::VOICES:
        return localFolderForData + QLatin1String("voices-" COMPRESSED_AUDIO "/");
        break;
    case GCompris::ResourceType::FULL:
        return localFolderForData;
        break;
    }
    return QString();
}

QString DownloadManager::getResourcePath(/*const GCompris::ResourceType &rt*/ int rt, const QVariantMap &data) const
{
    // qDebug() << "getResourcePath" << GCompris::ResourceType(rt) << resourceTypeToLocalFileName << data["locale"].toString();
    GCompris::ResourceType resource = GCompris::ResourceType(rt);
    switch (resource) {
    case GCompris::ResourceType::WORDSET:
        if (resourceTypeToLocalFileName.contains("words")) {
            return getLocalSubFolderForData(resource) + resourceTypeToLocalFileName["words"];
        }
        break;
    case GCompris::ResourceType::BACKGROUND_MUSIC:
        if (resourceTypeToLocalFileName.contains("backgroundMusic-" COMPRESSED_AUDIO)) {
            return getLocalSubFolderForData(resource) + resourceTypeToLocalFileName["backgroundMusic-" COMPRESSED_AUDIO];
        }
        break;
    case GCompris::ResourceType::VOICES:
        if (resourceTypeToLocalFileName.contains(data["locale"].toString())) {
            return getLocalSubFolderForData(resource) + resourceTypeToLocalFileName[data["locale"].toString()];
        }
        break;
    case GCompris::ResourceType::FULL:
        if (resourceTypeToLocalFileName.contains("full-" COMPRESSED_AUDIO)) {
            return getLocalSubFolderForData(resource) + resourceTypeToLocalFileName["full-" COMPRESSED_AUDIO];
        }
        break;
    }
    return QString();
}

bool DownloadManager::updateResource(/*const GCompris::ResourceType &*/ int rt, const QVariantMap &extra)
{
    if (checkDownloadRestriction())
        return downloadResource(rt, extra); // check for updates and register

    QString resourcePath = getResourcePath(rt, extra);
    QString absPath = getAbsoluteResourcePath(resourcePath);
    // automatic download prohibited -> register if available
    if (!resourcePath.isEmpty())
        return registerResourceAbsolute(absPath);

    qDebug() << "No such local resource and download prohibited: "
             << GCompris::ResourceType(rt) << extra;
    return false;
}

bool DownloadManager::downloadResource(int rt, const QVariantMap &extra)
{
    DownloadJob *job = nullptr;
    GCompris::ResourceType resourceType = GCompris::ResourceType(rt);
    {
        QMutexLocker locker(&jobsMutex);
        if (getJobByType_locked(resourceType, extra) != nullptr) {
            qDebug() << "Download of" << resourceType << "is already running, skipping second attempt.";
            return false;
        }
        job = new DownloadJob(resourceType, extra);
        activeJobs.append(job);
    }

    qDebug() << "downloadResource" << resourceType << extra;
    if (!download(job)) {
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
        return false;
    }
    return true;
}

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

bool DownloadManager::download(DownloadJob *job)
{
    QNetworkRequest request;

    // First download Contents file for verification if not yet done:
    if (!job->contents.contains(job->url.fileName()) /*|| job->url.fileName().contains("Contents")*/) {
        QUrl contentsUrl;
        if (!job->url.isEmpty()) {
            int len = job->url.fileName().length();
            contentsUrl = QUrl(job->url.toString().remove(job->url.toString().length() - len, len)
                               + contentsFilename);
        }
        else {
            switch (job->resourceType) {
            case GCompris::ResourceType::BACKGROUND_MUSIC:
                contentsUrl = QUrl(serverUrl.toString() + '/' + localFolderForData + "backgroundMusic/" + contentsFilename);
                break;
            case GCompris::ResourceType::VOICES:
                contentsUrl = QUrl(serverUrl.toString() + '/' + localFolderForData + "voices-" COMPRESSED_AUDIO + '/' + contentsFilename);
                break;
            case GCompris::ResourceType::WORDSET:
                contentsUrl = QUrl(serverUrl.toString() + '/' + localFolderForData + "words/" + contentsFilename);
                break;
            default:
                break;
            }
        }
        if (!job->knownContentsUrls.contains(contentsUrl)) {
            // Note: need to track already tried Contents files or we can end
            // up in an infinite loop if corresponding Contents file does not
            // exist upstream
            job->knownContentsUrls.append(contentsUrl);
            // qDebug() << "Postponing rcc download, first fetching Contents" << contentsUrl;
            job->queue.prepend(job->url);
            job->url = contentsUrl;
        }
    }

    QFileInfo fi(getFilenameForUrl(job->url));
    // make sure target path exists:
    QDir dir;
    if (!dir.exists(fi.path()) && !dir.mkpath(fi.path())) {
        // qDebug() << "Could not create resource path " << fi.path();
        Q_EMIT error(QNetworkReply::ProtocolUnknownError, QObject::tr("Could not create resource path"));
        return false;
    }

    job->file.setFileName(tempFilenameForFilename(fi.filePath()));
    if (!job->file.open(QIODevice::WriteOnly)) {
        Q_EMIT error(QNetworkReply::ProtocolUnknownError,
                     QObject::tr("Could not open target file %1").arg(job->file.fileName()));
        return false;
    }

    // start download:
    request.setUrl(job->url);
    qDebug() << "Now downloading" << job->url << "to" << fi.filePath() << "...";
    QNetworkReply *reply = accessManager.get(request);
    job->reply = reply;
    connect(reply, SIGNAL(finished()), this, SLOT(finishDownload()));
    connect(reply, &QNetworkReply::readyRead, this, &DownloadManager::downloadReadyRead);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(handleError(QNetworkReply::NetworkError)));
    if (job->url.fileName() != contentsFilename) {
        connect(reply, &QNetworkReply::downloadProgress,
                this, &DownloadManager::downloadInProgress);
        Q_EMIT downloadStarted(job->url.toString().remove(0, serverUrl.toString().length()));
    }

    return true;
}

inline DownloadManager::DownloadJob *DownloadManager::getJobByType_locked(GCompris::ResourceType rt, const QVariantMap &data) const
{
    for (auto activeJob: activeJobs)
        if (activeJob->resourceType == rt && activeJob->extraInfos == data) // || activeJob->queue.indexOf(url) != -1)
            return activeJob;
    return nullptr;
}

inline DownloadManager::DownloadJob *DownloadManager::getJobByReply(QNetworkReply *r)
{
    QMutexLocker locker(&jobsMutex);
    for (auto activeJob: qAsConst(activeJobs))
        if (activeJob->reply == r)
            return activeJob;
    return nullptr; // should never happen!
}

void DownloadManager::downloadReadyRead()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    DownloadJob *job = getJobByReply(reply);
    job->file.write(reply->readAll());
}

inline QString DownloadManager::getFilenameForUrl(const QUrl &url) const
{
    QString relPart = url.toString().remove(0, serverUrl.toString().length());
    return QString(getSystemDownloadPath() + relPart);
}

inline QUrl DownloadManager::getUrlForFilename(const QString &filename) const
{
    return QUrl(serverUrl.toString() + '/' + getRelativeResourcePath(filename));
}

inline QString DownloadManager::getSystemDownloadPath() const
{
    return ApplicationSettings::getInstance()->cachePath();
}

inline const QStringList DownloadManager::getSystemResourcePaths() const
{

    QStringList results({
        QCoreApplication::applicationDirPath() + '/' + QString(GCOMPRIS_DATA_FOLDER) + "/rcc/",
            getSystemDownloadPath(),
            QStandardPaths::writableLocation(QStandardPaths::CacheLocation),
#if defined(Q_OS_ANDROID)
            "assets:",
#endif
#if defined(UBUNTUTOUCH)
            QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + '/' + GCOMPRIS_APPLICATION_NAME
#else
            QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + '/' + GCOMPRIS_APPLICATION_NAME
#endif
    });

    // Append standard application directories (like /usr/share/KDE/gcompris-qt)
    results += QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);

    return results;
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
    return ApplicationSettings::getInstance()->isAutomaticDownloadsEnabled() && ApplicationInfo::getInstance()->isDownloadAllowed();
}

void DownloadManager::handleError(QNetworkReply::NetworkError code)
{
    Q_UNUSED(code);
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    qDebug() << reply->errorString() << " " << reply->error();
    Q_EMIT error(reply->error(), reply->errorString());
}

bool DownloadManager::parseContents(DownloadJob *job)
{
    if (job->file.isOpen())
        job->file.close();

    if (!job->file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file " << job->file.fileName();
        return false;
    }

    /*
     * We expect the line-syntax, that md5sum and colleagues creates:
     * <MD5SUM>  <FILENAME>
     * 53f0a3eb206b3028500ca039615c5f84  voices-en.rcc
     */
    QTextStream in(&job->file);
    while (!in.atEnd()) {
        QString line = in.readLine();
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
        QStringList parts = line.split(' ', Qt::SkipEmptyParts);
#else
        QStringList parts = line.split(' ', QString::SkipEmptyParts);
#endif
        if (parts.size() != 2) {
            qWarning() << "Invalid format of Contents file!";
            return false;
        }
        job->contents[parts[1]] = parts[0];
        if (parts[1].startsWith(QLatin1String("voices"))) {
            QString locale = parts[1];
            locale.remove(0, locale.indexOf('-') + 1); // Remove "voices-" prefix
            locale = locale.left(locale.indexOf('-')); // Remove the date and ".rcc" suffix
            // Retrieve locale from filename
            resourceTypeToLocalFileName[locale] = parts[1];
            qDebug() << "Contents: " << locale << " -> " << parts[1];
        }
        else if (parts[1].startsWith(QLatin1String("words"))) {
            QString type = parts[1];
            type = type.left(type.indexOf('-'));
            resourceTypeToLocalFileName[type] = parts[1];
            qDebug() << "Contents: " << type << " -> " << parts[1];
        }
        else {
            QString type = parts[1];
            type = type.section('-', 0, 1); // keep backgroundMusic-$CA or full-$CA
            resourceTypeToLocalFileName[type] = parts[1];
            qDebug() << "Contents: " << type << " -> " << parts[1];
        }
        // qDebug() << "Contents: " << parts[1] << " -> " << parts[0];
    }
    job->file.close();
    return true;
}

bool DownloadManager::checksumMatches(DownloadJob *job, const QString &filename) const
{
    Q_ASSERT(!job->contents.empty());

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
    // qDebug() << "Checking file-hash ~ contents-hash: " << fileHash << " ~ " << job->contents[basename];

    return (fileHash == job->contents[basename]);
}

void DownloadManager::unregisterResource_locked(const QString &filename)
{
    if (!QResource::unregisterResource(filename))
        qDebug() << "Error unregistering resource file" << filename;
    else {
        qDebug() << "Successfully unregistered resource file" << filename;
        registeredResources.removeOne(filename);
    }
}

inline bool DownloadManager::isRegistered(const QString &filename) const
{
    return (registeredResources.indexOf(filename) != -1);
}

/*
 * Registers an rcc file given by absolute path
 */
bool DownloadManager::registerResourceAbsolute(const QString &filename)
{
    QMutexLocker locker(&rcMutex);
    if (isRegistered(filename))
        unregisterResource_locked(filename);

    if (!QResource::registerResource(filename)) {
        qDebug() << "Error registering resource file" << filename;
        return false;
    }

    qDebug() << "Successfully registered resource"
             << filename;
    registeredResources.append(filename);

    locker.unlock(); /* note: we unlock before emitting to prevent
                      * potential deadlocks */

    const QString relativeFilename = getRelativeResourcePath(filename);
    Q_EMIT resourceRegistered(relativeFilename);

    QString v = getVoicesResourceForLocale(
        ApplicationSettings::getInstance()->locale());
    QString musicPath = getBackgroundMusicResources();

    if (v == relativeFilename)
        Q_EMIT voicesRegistered();
    else if (musicPath == relativeFilename)
        Q_EMIT backgroundMusicRegistered();
    return true;
}

/*
 * Registers an rcc file given by a relative resource path
 */
bool DownloadManager::registerResource(const QString &filename)
{
    QString absPath = getAbsoluteResourcePath(filename);
    if (!absPath.isEmpty()) {
        return registerResourceAbsolute(getAbsoluteResourcePath(filename));
    }
    else {
        qDebug() << "Error while registering" << filename;
        return false;
    }
}

bool DownloadManager::isDataRegistered(const QString &data) const
{
    QString res = QString(":/gcompris/data/%1").arg(data);
    return !QDir(res).entryList().empty();
}

bool DownloadManager::areVoicesRegistered(const QString &locale) const
{
    QString resource = QString("voices-" COMPRESSED_AUDIO "/%1").arg(ApplicationInfo::getInstance()->getVoicesLocale(locale));
    return isDataRegistered(resource);
}

void DownloadManager::downloadInProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    DownloadJob *job = nullptr;
    // don't call getJobByReply to not cause deadlock with mutex
    for (auto activeJob: qAsConst(activeJobs)) {
        if (activeJob->reply == reply) {
            job = activeJob;
            break;
        }
    }
    if (!job) {
        return;
    }
    job->bytesReceived = bytesReceived;
    job->bytesTotal = bytesTotal;
    qint64 allJobsBytesReceived = 0;
    qint64 allJobsBytesTotal = 0;
    for (auto activeJob: qAsConst(activeJobs)) {
        allJobsBytesReceived += activeJob->bytesReceived;
        allJobsBytesTotal += activeJob->bytesTotal;
    }
    Q_EMIT downloadProgress(allJobsBytesReceived, allJobsBytesTotal);
}

void DownloadManager::finishAllDownloads(int code)
{
    QList<QString> registeredFiles = resourceTypeToLocalFileName.values();
    // Remove all previous rcc for this kind of download
    for (auto *job: activeJobs) {
        QString subfolder = getLocalSubFolderForData(job->resourceType);
        if (subfolder.isEmpty()) {
            continue;
        }
        QDirIterator it(getSystemDownloadPath() + '/' + subfolder);
        while (it.hasNext()) {
            QString filename = it.next();
            QFileInfo fi = it.fileInfo();
            if (fi.isFile() && (filename.endsWith(QLatin1String(".rcc")))) {
                if (!registeredFiles.contains(fi.fileName())) {
                    if (!QFile::remove(filename)) {
                        qDebug() << "Unable to remove" << filename;
                    }
                }
            }
        }
        delete job;
    }
    activeJobs.clear();
}

void DownloadManager::finishDownload()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    DownloadFinishedCode code = Success;
    DownloadJob *job = getJobByReply(reply);
    bool allFinished = false;
    if (job->file.isOpen()) {
        job->file.flush(); // note: important, or checksums might be wrong!
        job->file.close();
    }

    if (reply->error() != 0 && job->file.exists()) {
        job->file.remove();
    }
    else {
        // active temp file
        QString tFilename = filenameForTempFilename(job->file.fileName());
        if (QFile::exists(tFilename)) {
            QFile::remove(tFilename);
        }
        if (!job->file.rename(tFilename)) {
            qWarning() << "Could not rename temporary file to" << tFilename;
        }
    }

    QString targetFilename = getFilenameForUrl(job->url);
    if (job->url.fileName() == contentsFilename) {
        // Contents
        if (reply->error() != 0) {
            qWarning() << "Error downloading Contents from" << job->url
                       << ":" << reply->error() << ":" << reply->errorString();
            // note: errorHandler() emit's error!
            goto outError;
        }
        // qDebug() << "Download of Contents finished successfully: " << job->url;
        if (!parseContents(job)) {
            qWarning() << "Invalid format of Contents file" << job->url;
            Q_EMIT error(QNetworkReply::UnknownContentError, QObject::tr("Invalid format of Contents file"));
            goto outError;
        }
    }
    else {
        QUrl redirect = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
        // RCC file
        if (reply->error() != 0) {
            qWarning() << "Error downloading RCC file from " << job->url
                       << ":" << reply->error() << ":" << reply->errorString();
            // note: errorHandler() emit's error!
            code = Error;
            // register already existing files (if not yet done):
            if (QFile::exists(targetFilename) && !isRegistered(targetFilename))
                registerResourceAbsolute(targetFilename);
        }
        // In case the file does not exist on the server, it is redirected to
        // an error page and this error page is downloaded but on our case
        // this is an error as we don't have the expected rcc.
        else if (!redirect.isEmpty()) {
            qWarning() << QString("The url %1 does not exist.").arg(job->url.toString());
            Q_EMIT error(QNetworkReply::UnknownContentError,
                         QObject::tr("The url %1 does not exist.")
                             .arg(job->url.toString()));
            code = Error;
            if (QFile::exists(targetFilename)) {
                QFile::remove(targetFilename);
            }
        }
        else {
            qDebug() << "Download of RCC file finished successfully: " << job->url;
            if (!checksumMatches(job, targetFilename)) {
                qWarning() << "Checksum of downloaded file does not match: "
                           << targetFilename;
                Q_EMIT error(QNetworkReply::UnknownContentError,
                             QObject::tr("Checksum of downloaded file does not match: %1")
                                 .arg(targetFilename));
                code = Error;
            }
            else
                registerResourceAbsolute(targetFilename);
        }
    }

    // try next:
    while (!job->queue.isEmpty()) {
        job->url = job->queue.takeFirst();
        if (job->url.isEmpty() && job->resourceType != GCompris::ResourceType::NONE) {
            QString nextDownload = getResourcePath(job->resourceType, job->extraInfos);
            if (!nextDownload.isEmpty()) {
                job->url = QUrl(serverUrl.toString() + '/' + nextDownload);
            }
            else {
                if (job->resourceType == GCompris::ResourceType::VOICES) {
                    const QString localeName = job->extraInfos["locale"].toString();
                    const QLocale locale(localeName);
                    Q_EMIT error(QNetworkReply::UnknownContentError,
                                 QObject::tr("No voices found for %1.")
                                     .arg(locale.nativeLanguageName()));
                }
                else {
                    Q_EMIT error(QNetworkReply::UnknownContentError,
                                 QObject::tr("No data found for %1.")
                                     .arg(GCompris::ResourceType(job->resourceType)));
                }
                code = Error;
                continue;
            }
        }
        QString relPath = getRelativeResourcePath(getFilenameForUrl(job->url));
        // check in each resource-path for an up2date rcc file:
        for (const QString &base: getSystemResourcePaths()) {
            QString filename = base + '/' + relPath;
            if (QFile::exists(filename)
                && checksumMatches(job, filename)) {
                // file is up2date, register! necessary:
                qDebug() << "Local resource is up-to-date:"
                         << QFileInfo(filename).fileName();
                if (!isRegistered(filename)) // no update and already registered -> noop
                    registerResourceAbsolute(filename);
                code = NoChange;
                break;
            }
        }
        if (code != NoChange) // nothing is up2date locally -> download it
            if (download(job))
                goto outNext;
    }

    // none left, DownloadJob finished
    job->downloadFinished = true;
    job->downloadResult = code;
    if (job->file.isOpen())
        job->file.close();
    Q_EMIT downloadFinished(code);
    reply->deleteLater();

    allFinished = std::all_of(activeJobs.constBegin(), activeJobs.constEnd(),
                              [](const DownloadJob *job) { return job->downloadFinished; });
    if (allFinished) {
        QMutexLocker locker(&jobsMutex);
        DownloadFinishedCode allCode = Success;
        std::for_each(activeJobs.constBegin(), activeJobs.constEnd(),
                      [&allCode](const DownloadJob *job) {
                          if (job->downloadResult == Error)
                              allCode = Error;
                      });
        Q_EMIT allDownloadsFinished(allCode);
    }
    return;

outError:
    if (job->url.fileName() == contentsFilename) {
        // if we could not download the contents file register local existing
        // files for outstanding jobs:
        QUrl nUrl;
        while (!job->queue.isEmpty()) {
            nUrl = job->queue.takeFirst();
            QString relPath = getResourcePath(job->resourceType, job->extraInfos);;
            for (const QString &base: getSystemResourcePaths()) {
                QString filename = base + '/' + relPath;
                if (QFile::exists(filename))
                    registerResourceAbsolute(filename);
            }
        }
    }

    if (job->file.isOpen())
        job->file.close();

    {
        QMutexLocker locker(&jobsMutex);
        activeJobs.removeOne(job);
    }

    reply->deleteLater();
    delete job;
    return;

outNext:
    // next sub-job started
    reply->deleteLater();
    return;
}

#if 0
// vvv might be helpful later with other use-cases:
void DownloadManager::registerLocalResources()
{
    QStringList filenames = getLocalResources();
    if (filenames.empty()) {
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
    if (filenames.empty()) {
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

QStringList DownloadManager::getLocalResources()
{
    QStringList result;

    for (const QString &path : getSystemResourcePaths()) {
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
#endif

#include "moc_DownloadManager.cpp"
