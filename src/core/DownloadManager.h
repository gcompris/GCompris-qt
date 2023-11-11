/* GCompris - DownloadManager.h
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QCryptographicHash>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMutex>
#include <QString>
#include <QUrl>
#include <QQmlEngine>
#include <QJSEngine>

namespace GCompris {
    Q_NAMESPACE
    enum ResourceType {
        NONE,
        VOICES,
        WORDSET,
        BACKGROUND_MUSIC,
        FULL
    };
    Q_ENUM_NS(ResourceType);
}

/**
 * @class DownloadManager
 * @short A singleton class responsible for downloading, updating and
 *        maintaining remote resources.
 * @ingroup infrastructure
 *
 * DownloadManager is responsible for downloading, updating and registering
 * additional resources (in Qt's binary .rcc format) used by GCompris.
 * It downloads from a upstream URL (ApplicationSettings.downloadServerUrl) to the
 * default local writable location. Downloads are based on common relative
 * resource paths, such that a URL of the form
 *
 * <tt>https://\<server-base\>/\<path/to/my/resource.rcc\></tt>
 *
 * will be downloaded to a local path
 *
 * <tt>/\<ApplicationSettings::getInstance()->cachePath()\>/\<path/to/my/resource.rcc\></tt>
 *
 * and registered with a resource root path
 *
 * <tt>qrc:/\<path/to/my\>/</tt>
 *
 * Internally resources are uniquely identified by their <em>relative resource
 * path</em>
 *
 * <tt>\<path/to/my/resource.rcc\></tt>
 * (e.g. <tt>data3/voices-ogg/voices-en.rcc></tt>)
 *
 * Downloading and verification of local files is controlled by MD5
 * checksums that are expected to be stored in @c Contents files in each
 * upstream directory according to the syntax produced by the @c md5sum
 * tool. The checksums are used for checking whether a local rcc file is
 * up-to-date (to avoid unnecesary rcc downloads) and to verify that the
 * transfer was complete. Only valid rcc files (with correct checksums)
 * are registered.
 *
 * A resource file must reference the "/gcompris/data" prefix with
 * \<qresource prefix="/gcompris/data"\>. All data are loaded and referenced
 * from this prefix. It is possible to check if a data is registered with
 * isDataRegistered.
 *
 * @sa DownloadDialog, ApplicationSettings.downloadServerUrl,
 *     ApplicationSettings.isAutomaticDownloadsEnabled,
 *     ApplicationSettings.cachePath
 */
class DownloadManager : public QObject
{
    Q_OBJECT

    friend class DownloadManagerTest;

private:
    DownloadManager(); // prohibit external creation, we are a singleton!
    static DownloadManager *_instance; // singleton instance

    /** Container for a full download job */
    typedef struct DownloadJob
    {
        QUrl url; ///< url of the currently running sub-job
        QFile file; ///< target file for the currently running sub-job
        QNetworkReply *reply = nullptr; ///< reply object for the currently running sub-job
        QList<QUrl> queue; ///< q of remaining sub jobs (QList for convenience)
        QMap<QString, QString> contents; ///< checksum map for download verification
        QList<QUrl> knownContentsUrls; ///< store already tried upstream Contents files (for infinite loop protection)

        GCompris::ResourceType resourceType = GCompris::ResourceType::NONE;
        QVariantMap extraInfos = {};

        qint64 bytesReceived = 0;
        qint64 bytesTotal = 0;
        bool downloadFinished = false;
        int downloadResult = 0;
        explicit DownloadJob(const GCompris::ResourceType rt, const QVariantMap &extra = {}) :
            resourceType(rt), extraInfos(extra) { }
    } DownloadJob;

    QList<DownloadJob *> activeJobs; ///< track active jobs to allow for parallel downloads
    QMutex jobsMutex; ///< not sure if we need to expect concurrent access, better lockit!

    static const QString contentsFilename;
    static const QString localFolderForData;
    static const QCryptographicHash::Algorithm hashMethod = QCryptographicHash::Md5;

    QList<QString> registeredResources;
    QMutex rcMutex; ///< not sure if we need to expect concurrent access, better lockit!

    QNetworkAccessManager accessManager;
    QUrl serverUrl;

    QMap<QString, QString> resourceTypeToLocalFileName; ///< Key constructed from Contents file, values are the filenames in local

    /**
     * Get the platform-specific path storing downloaded resources.
     *
     * Uses QStandardPaths::writableLocation(QStandardPaths::CacheLocation)
     * which returns
     *   - on desktop linux $HOME/.cache/KDE/gcompris-qt/
     *   - on other platforms check <https://doc.qt.io/qt-5/qstandardpaths.html>
     *
     * @return An absolute path.
     */
    QString getSystemDownloadPath() const;

    /**
     * Get all paths that are used for storing resources.
     *
     * @returns A list of absolute paths used for storing local resources.
     *          The caller should keep the returned list order when looking for
     *          resources, for now the lists contains:
     *          1. data folder in the application path
     *          2. getSystemDownloadPath()
     *          3. QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)/gcompris-qt
     *             which is
     *             - $HOME/.local/share/gcompris-qt (on linux desktop)
     *             - /storage/sdcard0/GCompris (on android)
     *          4. [QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation)]/gcompris-qt
     *             which is on GNU/Linux
     *             - $HOME/.local/share/KDE/gcompris-qt
     *             - $HOME/.local/share/gcompris-qt
     *             - $HOME/.local/share/applications/gcompris-qt
     *             - /usr/local/share/KDE/gcompris-qt
     *             - /usr/share/KDE/gcompris-qt
     */
    const QStringList getSystemResourcePaths() const;
    QString getResourceRootForFilename(const QString &filename) const;
    QString getFilenameForUrl(const QUrl &url) const;
    QUrl getUrlForFilename(const QString &filename) const;

    QString getLocalSubFolderForData(const GCompris::ResourceType &rt) const;
    /**
     * Transforms the passed relative path to an absolute resource path of an
     * existing .rcc file, honouring the order of the systemResourcePaths
     *
     * @returns The absolute path of the .rcc file if it exists, QString()
     *          otherwise
     */
    QString getAbsoluteResourcePath(const QString &path) const;

    /**
     * Transforms the passed absolute path to a relative resource path if
     * possible.
     *
     * @returns The relative path if it could be generated, QString() otherwise.
     */
    QString getRelativeResourcePath(const QString &path) const;
    QString tempFilenameForFilename(const QString &filename) const;
    QString filenameForTempFilename(const QString &tempFilename) const;

    bool checkDownloadRestriction() const;
    DownloadJob *getJobByReply(QNetworkReply *r);
    DownloadJob *getJobByType_locked(GCompris::ResourceType rt, const QVariantMap &data) const;

    /** Start a new download specified by the passed DownloadJob */
    bool download(DownloadJob *job);

    /** Parses upstream Contents file and build checksum map. */
    bool parseContents(DownloadJob *job);

    /** Compares the checksum of the file in filename with the contents map in
     * the passed DownloadJob */
    bool checksumMatches(DownloadJob *job, const QString &filename) const;

    bool registerResourceAbsolute(const QString &filename);

    /** Unregisters the passed resource
     *
     * Caller must lock rcMutex.
     */
    void unregisterResource_locked(const QString &filename);
    bool isRegistered(const QString &filename) const;

#if 0
    QStringList getLocalResources();
#endif

private Q_SLOTS:

    /** Handle a finished download.
     *
     * Called whenever a single download (sub-job) has finished. Responsible
     * for iterating over possibly remaining sub-jobs of our DownloadJob.
     */
    void finishDownload();
    void finishAllDownloads(int code);
    void downloadReadyRead();
    void handleError(QNetworkReply::NetworkError code);

public:
    // public interface:

    /**
     * Possible return codes of a finished download
     */
    enum DownloadFinishedCode {
        Success = 0, /**< Download finished successfully */
        Error = 1, /**< Download error */
        NoChange = 2 /**< Local files are up-to-date, no download was needed */
    };

    virtual ~DownloadManager();

    /**
     * Registers DownloadManager singleton in the QML engine.
     */
    static QObject *downloadManagerProvider(QQmlEngine *engine,
                                            QJSEngine *scriptEngine);
    static DownloadManager *getInstance();

    /**
     * Generates a relative voices resources file-path for a given @p locale.
     *
     * @param locale Locale name string of the form \<language\>_\<country\>.
     *
     * @returns A relative voices resource path.
     */
    Q_INVOKABLE QString getVoicesResourceForLocale(const QString &locale) const;

    Q_INVOKABLE QString getResourcePath(/*const GCompris::ResourceType &*/ int rt, const QVariantMap &data) const;

    // @returns A relative background music resource path.
    Q_INVOKABLE QString getBackgroundMusicResources() const;
    /**
     * Checks whether the given relative resource @p path exists locally.
     *
     * @param path A relative resource path.
     */
    Q_INVOKABLE bool haveLocalResource(const QString &path) const;

    /**
     * For each external dataset type check if there is a Contents file to load
     * and load its data if there is one
     */
    Q_INVOKABLE void initializeAssets();
    /**
     * Whether any download is currently running.
     */
    Q_INVOKABLE bool downloadIsRunning() const;

    /**
     * Whether the passed relative @p data is registered.
     *
     * For example, if you have a resource file which loads files under the
     * 'words' path like 'words/one.png'. You can call this method with 'words/one.png'
     * or with 'words'.
     *
     * @param data Relative resource path (file or directory).
     *
     * @sa areVoicesRegistered
     */
    Q_INVOKABLE bool isDataRegistered(const QString &data) const;

    /**
     * Whether voices for the locale passed in parameter are registered.
     *
     * @sa isDataRegistered
     */
    Q_INVOKABLE bool areVoicesRegistered(const QString &locale) const;

    /**
     * Registers a rcc resource file given by a relative resource path
     *
     * @param filename  Relative resource path.
     */
    Q_INVOKABLE bool registerResource(const QString &filename);

public Q_SLOTS:

    /** Emitted when a download in progressing.
     *
     * Job is retrieved using sender() method.
     *
     * @param bytesReceived Downloaded bytes for this job.
     * @param bytesTotal Total bytes to download for this job.
     */
    void downloadInProgress(qint64 bytesReceived, qint64 bytesTotal);

    /**
     * Updates a resource @p path from the upstream server unless prohibited
     * by the settings and registers it if possible.
     *
     * If not prohibited by the setting 'isAutomaticDownloadsEnabled' checks
     * for an available upstream resource specified by @p path.
     * If the corresponding local resource does not exist or is out of date,
     * the resource is downloaded and registered.
     *
     * If automatic downloads/updates are prohibited and a local copy of the
     * specified resource exists, it is registered.
     *
     * @param path A relative resource path.
     *
     * @returns success
     */
    Q_INVOKABLE bool updateResource(/*const GCompris::ResourceType &*/ int rt, const QVariantMap &extra);

    /**
     * Download a resource specified by the relative resource @p path and
     * register it if possible.
     *
     * If a corresponding local resource exists, an update will only be
     * downloaded if it is not up-to-date according to checksum comparison.
     * Whenever at the end we have a valid .rcc file it will be registered.
     *
     * @param path A relative resource path.
     *
     * @returns success
     */
    Q_INVOKABLE bool downloadResource(int rt, const QVariantMap &extra = {});

    /**
     * Shutdown DownloadManager instance.
     *
     * Aborts all currently running downloads.
     */
    Q_INVOKABLE void shutdown();

    /**
     * Abort all currently running downloads.
     */
    Q_INVOKABLE void abortDownloads();

#if 0
    Q_INVOKABLE bool checkForUpdates();  // might be helpful later with other use-cases!
    Q_INVOKABLE void registerLocalResources();
#endif

Q_SIGNALS:

    /** Emitted when a download error occurs.
     *
     * @param code enum NetworkError code.
     * @param msg Error string.
     */
    void error(int code, const QString &msg);

    /** Emitted when a download has started.
     *
     * @param resource Relative resource path of the started download.
     */
    void downloadStarted(const QString &resource);

    /** Emitted during a running download.
     *
     * All values refer to the currently active sub-job.
     *
     * @param bytesReceived Downloaded bytes.
     * @param bytesTotal Total bytes to download.
     */
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);

    /** Emitted when a download has finished.
     *
     * Also emitted in error cases.
     *
     * @param code DownloadFinishedCode. FIXME: when using DownloadFinishedCode
     *             instead of int the code will not be passed to the QML layer,
     *             use QENUMS?
     */
    void downloadFinished(int code);

    /** Emitted when all downloads have finished.
     *
     * If all downloads are successful, code is Success.
     * Else if at least one download is in error, code is Error.
     */
    void allDownloadsFinished(int code);

    /** Emitted when a resource has been registered.
     *
     * @param resource Relative resource path of the registered resource.
     *
     * @sa voicesRegistered
     */
    void resourceRegistered(const QString &resource);

    /** Emitted when voices resources for current locale have been registered.
     *
     * Convenience signal and special case of resourceRegistered.
     *
     * @sa resourceRegistered
     */
    void voicesRegistered();

    /** Emitted when background music has been registered.
     *
     * Convenience signal and special case of resourceRegistered.
     *
     * @sa resourceRegistered
     */
    void backgroundMusicRegistered();
};

#endif /* DOWNLOADMANAGER_H */
