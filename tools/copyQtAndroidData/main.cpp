/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the tools applications of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QCoreApplication>
#include <QStringList>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QDebug>
#include <QXmlStreamReader>
#include <QXmlStreamAttribute>
#include <QXmlStreamAttributes>
#include <QDateTime>
#include <QStandardPaths>
#include <QUuid>

#include <algorithm>
static const bool mustReadOutputAnyway = true; // pclose seems to return the wrong error code unless we read the output

void deleteRecursively(const QString &dirName)
{
    QDir dir(dirName);
    if (!dir.exists())
        return;

    QFileInfoList entries = dir.entryInfoList(QDir::NoDotAndDotDot | QDir::Files | QDir::Dirs);
    foreach (QFileInfo entry, entries) {
        if (entry.isDir())
            deleteRecursively(entry.absoluteFilePath());
        else
            QFile::remove(entry.absoluteFilePath());
    }

    QDir().rmdir(dirName);
}

struct Options
{
    Options()
        : helpRequested(false)
        , verbose(false)
        , minimumAndroidVersion(-1)
        , targetAndroidVersion(-1)
        , deploymentMechanism(Bundled)
        , releasePackage(false)
        , digestAlg(QLatin1String("SHA1"))
        , sigAlg(QLatin1String("SHA1withRSA"))
        , internalSf(false)
        , sectionsOnly(false)
        , protectedAuthenticationPath(false)
        , installApk(false)
        , fetchedRemoteModificationDates(false)
    {}

    ~Options()
    {
        if (!temporaryDirectoryName.isEmpty())
            deleteRecursively(temporaryDirectoryName);
    }

    enum DeploymentMechanism
    {
        Bundled,
        Ministro,
        Debug
    };

    bool helpRequested;
    bool verbose;

    // External tools
    QString sdkPath;
    QString ndkPath;
    QString antTool;
    QString jdkPath;

    // Build paths
    QString qtInstallDirectory;
    QString androidSourceDirectory;
    QString outputDirectory;
    QString inputFileName;
    QString applicationBinary;

    // Build information
    QString androidPlatform;
    QString architecture;
    QString toolchainVersion;
    QString toolchainPrefix;
    QString toolPrefix;
    QString ndkHost;

    // Package information
    int minimumAndroidVersion;
    int targetAndroidVersion;
    DeploymentMechanism deploymentMechanism;
    QString appName;
    QString packageName;
    QStringList supportedOrientations;
    QStringList extraLibs;

    // Signing information
    bool releasePackage;
    QString keyStore;
    QString keyStorePassword;
    QString keyStoreAlias;
    QString storeType;
    QString keyPass;
    QString sigFile;
    QString signedJar;
    QString digestAlg;
    QString sigAlg;
    QString tsaUrl;
    QString tsaCert;
    bool internalSf;
    bool sectionsOnly;
    bool protectedAuthenticationPath;

    // Installation information
    bool installApk;
    QString installLocation;

    // Collected information
    typedef QPair<QString, QString> BundledFile;
    QList<BundledFile> bundledFiles;
    QStringList qtDependencies;
    QStringList localLibs;
    QStringList localJars;
    QStringList initClasses;
    QString temporaryDirectoryName;
    bool fetchedRemoteModificationDates;
    QHash<QString, QDateTime> remoteModificationDates;
};

Options parseOptions()
{
    Options options;

    QStringList arguments = QCoreApplication::arguments();
    for (int i=0; i<arguments.size(); ++i) {
        const QString &argument = arguments.at(i);
        if (argument.compare(QLatin1String("--output"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.outputDirectory = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--input"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.inputFileName = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--install"), Qt::CaseInsensitive) == 0) {
            options.installApk = true;
        } else if (argument.compare(QLatin1String("--android-platform"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.androidPlatform = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--help"), Qt::CaseInsensitive) == 0) {
            options.helpRequested = true;
        } else if (argument.compare(QLatin1String("--verbose"), Qt::CaseInsensitive) == 0) {
            options.verbose = true;
        } else if (argument.compare(QLatin1String("--ant"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.antTool = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--deployment"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size()) {
                options.helpRequested = true;
            } else {
                QString deploymentMechanism = arguments.at(++i);
                if (deploymentMechanism.compare(QLatin1String("ministro"), Qt::CaseInsensitive) == 0) {
                    options.deploymentMechanism = Options::Ministro;
                } else if (deploymentMechanism.compare(QLatin1String("debug"), Qt::CaseInsensitive) == 0) {
                    options.deploymentMechanism = Options::Debug;

                    QString temporaryDirectoryName = QStandardPaths::standardLocations(QStandardPaths::TempLocation).at(0)
                            + QLatin1String("/android-build-")
                            + QUuid::createUuid().toString();
                    if (QFileInfo(temporaryDirectoryName).exists()) {
                        fprintf(stderr, "Temporary directory '%s' already exists. Bailing out.\n",
                                qPrintable(temporaryDirectoryName));
                        options.helpRequested = true;
                    } else {
                        options.temporaryDirectoryName = temporaryDirectoryName;
                    }

                } else if (deploymentMechanism.compare(QLatin1String("bundled"), Qt::CaseInsensitive) == 0) {
                    options.deploymentMechanism = Options::Bundled;
                } else {
                    fprintf(stderr, "Unrecognized deployment mechanism: %s\n", qPrintable(deploymentMechanism));
                    options.helpRequested = true;
                }
            }
        } else if (argument.compare(QLatin1String("--device"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.installLocation = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--release"), Qt::CaseInsensitive) == 0) {
            options.releasePackage = true;
        } else if (argument.compare(QLatin1String("--jdk"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.jdkPath = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--sign"), Qt::CaseInsensitive) == 0) {
            if (i + 2 >= arguments.size()) {
                options.helpRequested = true;
            } else {
                options.releasePackage = true;
                options.keyStore = arguments.at(++i);
                options.keyStoreAlias = arguments.at(++i);
            }
        } else if (argument.compare(QLatin1String("--storepass"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.keyStorePassword = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--storetype"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.storeType = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--keypass"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.keyPass = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--sigfile"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.sigFile = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--digestalg"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.digestAlg = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--sigalg"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.sigAlg = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--tsa"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.tsaUrl = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--tsacert"), Qt::CaseInsensitive) == 0) {
            if (i + 1 == arguments.size())
                options.helpRequested = true;
            else
                options.tsaCert = arguments.at(++i);
        } else if (argument.compare(QLatin1String("--internalsf"), Qt::CaseInsensitive) == 0) {
            options.internalSf = true;
        } else if (argument.compare(QLatin1String("--sectionsonly"), Qt::CaseInsensitive) == 0) {
            options.sectionsOnly = true;
        } else if (argument.compare(QLatin1String("--protected"), Qt::CaseInsensitive) == 0) {
            options.protectedAuthenticationPath = true;
        }
    }

    if (options.inputFileName.isEmpty())
        options.inputFileName = QString::fromLatin1("android-lib%1.so-deployment-settings.json").arg(QDir::current().dirName());

    return options;
}

void printHelp()
{//                 "012345678901234567890123456789012345678901234567890123456789012345678901"
    fprintf(stderr, "Syntax: %s --output <destination> [options]\n"
                    "\n"
                    "  Creates an Android package in the build directory <destination> and\n"
                    "  builds it into an .apk file.\n\n"
                    "  Optional arguments:\n"
                    "    --input <inputfile>: Reads <inputfile> for options generated by\n"
                    "       qmake. A default file name based on the current working\n"
                    "       directory will be used if nothing else is specified.\n"
                    "    --deployment <mechanism>: Supported deployment mechanisms:\n"
                    "       bundled (default): Include Qt files in stand-alone package.\n"
                    "       ministro: Use the Ministro service to manage Qt files.\n"
                    "       debug: Copy Qt files to device for quick debugging.\n"
                    "    --install: Installs apk to device/emulator. By default this step is\n"
                    "       not taken.\n"
                    "    --device [device ID]: Use specified device for deployment. Default\n"
                    "       is the device selected by default by adb.\n"
                    "    --android-platform <platform>: Builds against the given android\n"
                    "       platform. By default, the highest available version will be\n"
                    "       used.\n"
                    "    --ant <path/to/ant>: If unspecified, ant from the PATH will be\n"
                    "       used."
                    "    --release: Builds a package ready for release. By default, the\n"
                    "       package will be signed with a debug key.\n"
                    "    --sign <url/to/keystore> <alias>: Signs the package with the\n"
                    "       specified keystore, alias and store password. Also implies the\n"
                    "       --release option.\n"
                    "       Optional arguments for use with signing:\n"
                    "         --storepass <password>: Keystore password.\n"
                    "         --storetype <type>: Keystore type.\n"
                    "         --keypass <password>: Password for private key (if different\n"
                    "           from keystore password.)\n"
                    "         --sigfile <file>: Name of .SF/.DSA file.\n"
                    "         --digestalg <name>: Name of digest algorithm. Default is\n"
                    "           \"SHA1\".\n"
                    "         --sigalg <name>: Name of signature algorithm. Default is\n"
                    "           \"SHA1withRSA\".\n"
                    "         --tsa <url>: Location of the Time Stamping Authority.\n"
                    "         --tsacert <alias>: Public key certificate for TSA.\n"
                    "         --internalsf: Include the .SF file inside the signature block.\n"
                    "         --sectionsonly: Don't compute hash of entire manifest.\n"
                    "         --protected: Keystore has protected authentication path.\n"
                    "    --jdk <path/to/jdk>: Used to find the jarsigner tool when used\n"
                    "       in combination with the --release argument. By default,\n"
                    "       an attempt is made to detect the tool using the JAVA_HOME and\n"
                    "       PATH environment variables, in that order.\n"
                    "    --verbose: Prints out information during processing.\n"
                    "    --help: Displays this information.\n\n",
                    qPrintable(QCoreApplication::arguments().at(0))
            );
}

// Since strings compared will all start with the same letters,
// sorting by length and then alphabetically within each length
// gives the natural order.
bool quasiLexicographicalReverseLessThan(const QFileInfo &fi1, const QFileInfo &fi2)
{
    QString s1 = fi1.baseName();
    QString s2 = fi2.baseName();

    if (s1.length() == s2.length())
        return s1 > s2;
    else
        return s1.length() > s2.length();
}

// Files which contain templates that need to be overwritten by build data should be overwritten every
// time.
bool alwaysOverwritableFile(const QString &fileName)
{
    return (fileName.endsWith(QLatin1String("/res/values/libs.xml"))
            //            || fileName.endsWith(QLatin1String("/AndroidManifest.xml"))
            || fileName.endsWith(QLatin1String("/res/values/strings.xml"))
            || fileName.endsWith(QLatin1String("/src/org/qtproject/qt5/android/bindings/QtActivity.java")));
}

bool copyFileIfNewer(const QString &sourceFileName, const QString &destinationFileName, bool verbose)
{
    if (QFile::exists(destinationFileName)) {
        QFileInfo destinationFileInfo(destinationFileName);
        QFileInfo sourceFileInfo(sourceFileName);

        if (sourceFileInfo.lastModified() <= destinationFileInfo.lastModified() && !alwaysOverwritableFile(destinationFileName)) {
            if (verbose)
                fprintf(stdout, "  -- Skipping file %s. Same or newer file already in place.\n", qPrintable(sourceFileName));
            return true;
        } else {
            if (!QFile(destinationFileName).remove()) {
                fprintf(stderr, "Can't remove old file: %s\n", qPrintable(destinationFileName));
                return false;
            }
        }
    }

    if (!QDir().mkpath(QFileInfo(destinationFileName).path())) {
        fprintf(stderr, "Cannot make output directory for %s.\n", qPrintable(destinationFileName));
        return false;
    }

    if (!QFile::exists(destinationFileName) && !QFile::copy(sourceFileName, destinationFileName)) {
        fprintf(stderr, "Failed to copy %s to %s.\n", qPrintable(sourceFileName), qPrintable(destinationFileName));
        return false;
    } else if (verbose) {
        fprintf(stdout, "  -- Copied %s\n", qPrintable(destinationFileName));
    }

    return true;
}

QString detectLatestAndroidPlatform(const QString &sdkPath)
{
    QDir dir(sdkPath + QLatin1String("/platforms"));
    if (!dir.exists()) {
        fprintf(stderr, "Directory %s does not exist\n", qPrintable(dir.absolutePath()));
        return QString();
    }

    QFileInfoList fileInfos = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);
    if (fileInfos.isEmpty()) {
        fprintf(stderr, "No platforms found in %s", qPrintable(dir.absolutePath()));
        return QString();
    }

    std::sort(fileInfos.begin(), fileInfos.end(), quasiLexicographicalReverseLessThan);

    QFileInfo latestPlatform = fileInfos.first();
    return latestPlatform.baseName();
}

bool readInputFile(Options *options)
{
    QFile file(options->inputFileName);
    if (!file.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot read from input file: %s\n", qPrintable(options->inputFileName));
        return false;
    }

    QJsonDocument jsonDocument = QJsonDocument::fromJson(file.readAll());
    if (jsonDocument.isNull()) {
        fprintf(stderr, "Invalid json file: %s\n", qPrintable(options->inputFileName));
        return false;
    }

    QJsonObject jsonObject = jsonDocument.object();

    {
        QJsonValue sdkPath = jsonObject.value(QLatin1String("sdk"));
        if (sdkPath.isUndefined()) {
            fprintf(stderr, "No SDK path in json file %s\n", qPrintable(options->inputFileName));
            return false;
        }

        options->sdkPath = sdkPath.toString();

        if (options->androidPlatform.isEmpty()) {
            options->androidPlatform = detectLatestAndroidPlatform(options->sdkPath);
            if (options->androidPlatform.isEmpty())
                return false;
        } else {
            if (!QDir(options->sdkPath + QLatin1String("/platforms/") + options->androidPlatform).exists()) {
                fprintf(stderr, "Warning: Android platform '%s' does not exist in NDK.\n",
                        qPrintable(options->androidPlatform));
            }
        }
    }

    {
        QJsonValue qtInstallDirectory = jsonObject.value("qt");
        if (qtInstallDirectory.isUndefined()) {
            fprintf(stderr, "No Qt directory in json file %s\n", qPrintable(options->inputFileName));
            return false;
        }
        options->qtInstallDirectory = qtInstallDirectory.toString();
    }

    {
        QJsonValue androidSourcesDirectory = jsonObject.value("android-package-source-directory");
        if (!androidSourcesDirectory.isUndefined())
            options->androidSourceDirectory = androidSourcesDirectory.toString();
    }

    {
        QJsonValue applicationBinary = jsonObject.value("application-binary");
        if (applicationBinary.isUndefined()) {
            fprintf(stderr, "No application binary defined in json file.\n");
            return false;
        }
        options->applicationBinary = applicationBinary.toString();

        if (!QFile::exists(options->applicationBinary)) {
            fprintf(stderr, "Cannot find application binary %s.\n", qPrintable(options->applicationBinary));
            return false;
        }
    }

    {
        QJsonValue deploymentDependencies = jsonObject.value("deployment-dependencies");
        if (!deploymentDependencies.isUndefined())
            options->qtDependencies = deploymentDependencies.toString().split(QLatin1Char(','));
    }


    {
        QJsonValue targetArchitecture = jsonObject.value("target-architecture");
        if (targetArchitecture.isUndefined()) {
            fprintf(stderr, "No target architecture defined in json file.\n");
            return false;
        }
        options->architecture = targetArchitecture.toString();
    }

    {
        QJsonValue ndk = jsonObject.value("ndk");
        if (ndk.isUndefined()) {
            fprintf(stderr, "No NDK path defined in json file.\n");
            return false;
        }
        options->ndkPath = ndk.toString();
    }

    {
        QJsonValue toolchainPrefix = jsonObject.value("toolchain-prefix");
        if (toolchainPrefix.isUndefined()) {
            fprintf(stderr, "No toolchain prefix defined in json file.\n");
            return false;
        }
        options->toolchainPrefix = toolchainPrefix.toString();
    }

    {
        QJsonValue toolPrefix = jsonObject.value("tool-prefix");
        if (toolPrefix.isUndefined()) {
            fprintf(stderr, "Warning: No tool prefix defined in json file.\n");
            options->toolPrefix = options->toolchainPrefix;
        } else {
            options->toolPrefix = toolPrefix.toString();
        }
    }

    {
        QJsonValue toolchainVersion = jsonObject.value("toolchain-version");
        if (toolchainVersion.isUndefined()) {
            fprintf(stderr, "No toolchain version defined in json file.\n");
            return false;
        }
        options->toolchainVersion = toolchainVersion.toString();
    }

    {
        QJsonValue ndkHost = jsonObject.value("ndk-host");
        if (ndkHost.isUndefined()) {
            fprintf(stderr, "No NDK host defined in json file.\n");
            //return false;
        }
        options->ndkHost = ndkHost.toString();
    }

    {
        QJsonValue androidMinimumVersion = jsonObject.value("android-minimum-version");
        if (!androidMinimumVersion.isUndefined()) {
            options->minimumAndroidVersion = androidMinimumVersion.toInt();
            if (options->minimumAndroidVersion < 9)
                fprintf(stderr, "Warning: Unsupported minimum version");
        }
    }

    {
        QJsonValue androidTargetVersion = jsonObject.value("android-target-version");
        if (!androidTargetVersion.isUndefined()) {
            options->targetAndroidVersion = androidTargetVersion.toInt();
            if (options->targetAndroidVersion < 9)
                fprintf(stderr, "Warning: Unsupported target version");
        }
    }

    if (options->minimumAndroidVersion < 0) {
        options->minimumAndroidVersion = 9;
        if (options->targetAndroidVersion < 0)
            options->targetAndroidVersion = 14;
    }

    {
        QJsonValue androidAppName = jsonObject.value("android-app-name");
        if (!androidAppName.isUndefined())
            options->appName = androidAppName.toString();
        else
            options->appName = QFileInfo(options->applicationBinary).baseName().mid(sizeof("lib") - 1);
    }


    {
        QJsonValue androidPackage = jsonObject.value("android-package");
        if (!androidPackage.isUndefined())
            options->packageName = androidPackage.toString();
        else
            options->packageName = QString::fromLatin1("org.qtproject.example.%1").arg(options->appName);
    }

    {
        QJsonValue supportedOrientations = jsonObject.value("supported-orientations");
        if (!supportedOrientations.isUndefined())
            options->supportedOrientations = supportedOrientations.toString().split(QLatin1Char(','));
    }

    {
        QJsonValue extraLibs = jsonObject.value("android-extra-libs");
        if (!extraLibs.isUndefined())
            options->extraLibs = extraLibs.toString().split(QLatin1Char(','));
    }

    return true;
}

bool copyFiles(const QDir &sourceDirectory, const QDir &destinationDirectory, bool verbose)
{
    QFileInfoList entries = sourceDirectory.entryInfoList(QDir::NoDotAndDotDot | QDir::Files | QDir::Dirs);
    foreach (QFileInfo entry, entries) {
        if (entry.isDir()) {
            QDir dir(entry.absoluteFilePath());
            if (!destinationDirectory.mkpath(dir.dirName())) {
                fprintf(stderr, "Cannot make directory %s in %s\n", qPrintable(dir.dirName()), qPrintable(destinationDirectory.path()));
                return false;
            }

            if (!copyFiles(dir, QDir(destinationDirectory.path() + QLatin1String("/") + dir.dirName()), verbose))
                return false;
        } else {
            QString destination = destinationDirectory.absoluteFilePath(entry.fileName());
            if (!copyFileIfNewer(entry.absoluteFilePath(), destination, verbose))
                return false;
        }
    }

    return true;
}

bool copyAndroidTemplate(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Copying Android package template.\n");

    QDir sourceDirectory(options.qtInstallDirectory + QLatin1String("/src/android/java"));
    if (!sourceDirectory.exists()) {
        fprintf(stderr, "Cannot find template directory %s\n", qPrintable(sourceDirectory.absolutePath()));
        return false;
    }

    if (!QDir::current().mkpath(options.outputDirectory)) {
        fprintf(stderr, "Cannot create output directory %s\n", qPrintable(options.outputDirectory));
        return false;
    }

    return copyFiles(sourceDirectory, QDir(options.outputDirectory), options.verbose);
}

bool copyAndroidSources(const Options &options)
{
    if (options.androidSourceDirectory.isEmpty())
        return true;

    if (options.verbose)
        fprintf(stdout, "Copying Android sources from project.\n");

    QDir sourceDirectory(options.androidSourceDirectory);
    if (!sourceDirectory.exists()) {
        fprintf(stderr, "Cannot find android sources in %s", qPrintable(options.androidSourceDirectory));
        return false;
    }

    return copyFiles(sourceDirectory, QDir(options.outputDirectory), options.verbose);
}

bool copyAndroidExtraLibs(const Options &options)
{
    if (options.extraLibs.isEmpty())
        return true;

    if (options.verbose)
        fprintf(stdout, "Copying %d external libraries to package.\n", options.extraLibs.size());

    foreach (QString extraLib, options.extraLibs) {
        QFileInfo extraLibInfo(extraLib);
        if (!extraLibInfo.exists()) {
            fprintf(stderr, "External library %s does not exist!\n", qPrintable(extraLib));
            return false;
        }

        if (!extraLibInfo.fileName().startsWith(QLatin1String("lib")) || extraLibInfo.suffix() != QLatin1String("so")) {
            fprintf(stderr, "The file name of external library %s must begin with \"lib\" and end with the suffix \".so\".\n",
                    qPrintable(extraLib));
            return false;
        }

        QString destinationFile(options.outputDirectory
                                + QLatin1String("/libs/")
                                + options.architecture
                                + QLatin1Char('/')
                                + extraLibInfo.fileName());

        if (!copyFileIfNewer(extraLib, destinationFile, options.verbose))
            return false;
    }

    return true;
}

bool updateFile(const QString &fileName, const QHash<QString, QString> &replacements)
{
    QFile inputFile(fileName);
    if (!inputFile.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot open %s for reading.\n", qPrintable(fileName));
        return false;
    }

    // All the files we are doing substitutes in are quite small. If this
    // ever changes, this code should be updated to be more conservative.
    QByteArray contents = inputFile.readAll();

    bool hasReplacements = false;
    QHash<QString, QString>::const_iterator it;
    for (it = replacements.constBegin(); it != replacements.constEnd(); ++it) {
        int index = contents.indexOf(it.key().toUtf8());
        if (index >= 0) {
            contents.replace(index, it.key().length(), it.value().toUtf8());
            hasReplacements = true;
        }
    }

    if (hasReplacements) {
        inputFile.close();

        if (!inputFile.open(QIODevice::WriteOnly)) {
            fprintf(stderr, "Cannot open %s for writing.\n", qPrintable(fileName));
            return false;
        }

        inputFile.write(contents);
    }

    return true;

}

bool updateLibsXml(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "  -- res/values/libs.xml\n");

    QString fileName = options.outputDirectory + QLatin1String("/res/values/libs.xml");
    if (!QFile::exists(fileName)) {
        fprintf(stderr, "Cannot find %s in prepared packaged. This file is required.\n", qPrintable(fileName));
        return false;
    }

    QString libsPath = QLatin1String("libs/") + options.architecture + QLatin1Char('/');

    QString qtLibs = QLatin1String("<item>gnustl_shared</item>\n");
    QString bundledInLibs;
    QString bundledInAssets;
    foreach (Options::BundledFile bundledFile, options.bundledFiles) {
        if (bundledFile.second.startsWith(QLatin1String("lib/"))) {
            QString s = bundledFile.second.mid(sizeof("lib/lib") - 1);
            s.chop(sizeof(".so") - 1);
            qtLibs += QString::fromLatin1("<item>%1</item>\n").arg(s);
        } else if (bundledFile.first.startsWith(libsPath)) {
            QString s = bundledFile.first.mid(libsPath.length());
            bundledInLibs += QString::fromLatin1("<item>%1:%2</item>\n")
                    .arg(s).arg(bundledFile.second);
        } else if (bundledFile.first.startsWith(QLatin1String("assets/"))) {
            QString s = bundledFile.first.mid(sizeof("assets/") - 1);
            bundledInAssets += QString::fromLatin1("<item>%1:%2</item>\n")
                    .arg(s).arg(bundledFile.second);
        }
    }

    QHash<QString, QString> replacements;
    replacements[QLatin1String("<!-- %%INSERT_QT_LIBS%% -->")] = qtLibs;
    if (options.deploymentMechanism == Options::Bundled) {
        replacements[QLatin1String("<!-- %%INSERT_BUNDLED_IN_LIB%% -->")] = bundledInLibs;
        replacements[QLatin1String("<!-- %%INSERT_BUNDLED_IN_ASSETS%% -->")] = bundledInAssets;
    }

    QString extraLibs;
    if (!options.extraLibs.isEmpty()) {
        foreach (QString extraLib, options.extraLibs) {
            QFileInfo extraLibInfo(extraLib);
            QString name = extraLibInfo.fileName().mid(sizeof("lib") - 1);
            name.chop(sizeof(".so") - 1);

            extraLibs += QLatin1String("<item>") + name + QLatin1String("</item>\n");
        }
    }
    replacements[QLatin1String("<!-- %%INSERT_EXTRA_LIBS%% -->")] = extraLibs;

    if (!updateFile(fileName, replacements))
        return false;

    return true;
}

bool updateAndroidManifest(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "  -- AndroidManifest.xml\n");

    QString usesSdk = QString("<uses-sdk android:minSdkVersion=\"%1\" %2 />").arg(options.minimumAndroidVersion);
    if (options.targetAndroidVersion >= 0)
        usesSdk = usesSdk.arg(QString::fromLatin1("android:targetSdkVersion=\"%1\"").arg(options.targetAndroidVersion));

    QString androidOrientation;
    if (options.supportedOrientations.size() == 1) {
        const QString &orientation = options.supportedOrientations.at(0);
        if (orientation == QLatin1String("Portrait"))
            androidOrientation = QLatin1String("portrait");
        else if (orientation == QLatin1String("Landscape"))
            androidOrientation = QLatin1String("landscape");
        else if (orientation == QLatin1String("InvertedLandscape"))
            androidOrientation = QLatin1String("reverseLandscape");
        else if (orientation == QLatin1String("InvertedPortrait"))
            androidOrientation = QLatin1String("reversePortrait");
    } else if (options.supportedOrientations.size() > 1) {
        fprintf(stderr, "Warning: Multiple supported orientations specified. Orientation of Android app will be unspecified.");
    }

    QHash<QString, QString> replacements;
    replacements[QLatin1String("-- %%INSERT_USES_SDK%% --")] = usesSdk;
    replacements[QLatin1String("package=\"org.qtproject.example\"")] = QString::fromLatin1("package=\"%1\"").arg(options.packageName);

    replacements[QLatin1String("-- %%USE_LOCAL_QT_LIBS%% --")] = "1";
    if (options.deploymentMechanism == Options::Ministro) {
        replacements[QLatin1String("-- %%USE_LOCAL_QT_LIBS%% --")] = "0";
        // replacements[QLatin1String("<meta-data android:value=\"1\" android:name=\"android.app.use_local_qt_libs\"/>")]
        //         = QString::fromLatin1("<meta-data android:value=\"0\" android:name=\"android.app.use_local_qt_libs\"/>");
    }

    replacements[QLatin1String("-- %%BUNDLE_LOCAL_QT_LIBS%% --")] = "1";
    if (options.deploymentMechanism != Options::Bundled) {
        replacements[QLatin1String("-- %%BUNDLE_LOCAL_QT_LIBS%% --")] = "0";
        //replacements[QLatin1String("<meta-data android:value=\"1\" android:name=\"android.app.bundle_local_qt_libs\"/>")]
        //= QString::fromLatin1("<meta-data android:value=\"0\" android:name=\"android.app.bundle_local_qt_libs\"/>");
    }

    QStringList localLibs = options.localLibs;

    // If .pro file overrides dependency detection, we need to see which platform plugin they picked
    if (localLibs.isEmpty()) {
        QString plugin;
        foreach (QString qtDependency, options.qtDependencies) {
            if (qtDependency.endsWith(QLatin1String("libqtforandroid.so"))
                    || qtDependency.endsWith(QLatin1String("libqtforandroidGL.so"))) {
                if (!plugin.isEmpty() && plugin != qtDependency) {
                    fprintf(stderr, "Both platform plugins libqtforandroid.so and libqtforandroidGL.so included in package. Please include only one.\n");
                    return false;
                }

                plugin = qtDependency;
            }
        }

        if (plugin.isEmpty()) {
            fprintf(stderr, "No platform plugin, neither libqtforandroid.so or libqtforandroidGL.so, included in package. Please include one.\n");
            return false;
        }

        localLibs.append(plugin);
        if (options.verbose)
            fprintf(stdout, "  -- Using platform plugin %s\n", qPrintable(plugin));
    }
    replacements[QLatin1String("-- %%INSERT_APP_LIB_NAME%% --")] = QFileInfo(options.applicationBinary).baseName().mid(sizeof("lib") - 1);
    replacements[QLatin1String("-- %%INSERT_LOCAL_LIBS%% --")] = localLibs.join(QLatin1Char(':'));
    replacements[QLatin1String("-- %%INSERT_LOCAL_JARS%% --")] = options.localJars.join(QLatin1Char(':'));
    replacements[QLatin1String("-- %%INSERT_INIT_CLASSES%% --")] = options.initClasses.join(QLatin1Char(':'));

    if (!androidOrientation.isEmpty())
        replacements[QLatin1String("android:screenOrientation=\"unspecified\"")] = QString::fromLatin1("android:screenOrientation=\"%1\"").arg(androidOrientation);
    if (!updateFile(options.outputDirectory + QLatin1String("/AndroidManifest.xml"), replacements))
        return false;

    return true;
}

bool updateStringsXml(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "  -- res/values/strings.xml\n");

    QHash<QString, QString> replacements;
    replacements[QLatin1String("<!-- %%INSERT_APP_NAME%% -->")] = options.appName;

    QString fileName = options.outputDirectory + QLatin1String("/res/values/strings.xml");
    if (!QFile::exists(fileName)) {
        if (options.verbose)
            fprintf(stdout, "  -- Skipping update of strings.xml since it's missing.\n");
        return true;
    }

    if (!updateFile(fileName, replacements))
        return false;

    return true;
}

bool updateJavaFiles(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "  -- /src/org/qtproject/qt5/android/bindings/QtActivity.java\n");

    QString fileName(options.outputDirectory + QLatin1String("/src/org/qtproject/qt5/android/bindings/QtActivity.java"));
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot open %s.\n", qPrintable(fileName));
        return false;
    }

    QByteArray contents;

    while (!file.atEnd()) {
        QByteArray line = file.readLine();
        if (line.startsWith("//@ANDROID-")) {
            bool ok;
            int requiredSdkVersion = line.mid(sizeof("//@ANDROID-") - 1).trimmed().toInt(&ok);
            if (requiredSdkVersion <= options.minimumAndroidVersion)
                contents += line;

            if (ok) {
                while (!file.atEnd()) {
                    line = file.readLine();
                    if (requiredSdkVersion <= options.minimumAndroidVersion)
                        contents += line;

                    if (line.startsWith(QByteArray("//@ANDROID-") + QByteArray::number(requiredSdkVersion)))
                        break;
                }

                if (!line.startsWith(QByteArray("//@ANDROID-") + QByteArray::number(requiredSdkVersion))) {
                    fprintf(stderr, "Mismatched tag ANDROID-%d in %s\n", requiredSdkVersion, qPrintable(fileName));
                    return false;
                }
            } else {
                fprintf(stderr, "Warning: Misformatted tag in %s: %s\n", qPrintable(fileName), line.constData());
            }
        } else {
            contents += line;
        }
    }

    file.close();

    if (!file.open(QIODevice::WriteOnly)) {
        fprintf(stderr, "Can't open %s for writing.\n", qPrintable(fileName));
        return false;
    }

    if (file.write(contents) < contents.size()) {
        fprintf(stderr, "Failed to write contents to %s.\n", qPrintable(fileName));
        return false;
    }

    return true;
}

bool updateAndroidFiles(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Updating Android package files with project settings.\n");

    if (!updateLibsXml(options))
        return false;

    if (!updateAndroidManifest(options))
        return false;

    if (!updateStringsXml(options))
        return false;

    if (!updateJavaFiles(options))
        return false;

    return true;
}

QStringList findFilesRecursively(const Options &options, const QString &fileName)
{
    QFileInfo info(options.qtInstallDirectory + QLatin1Char('/') + fileName);
    if (!info.exists()) {
        fprintf(stderr, "Warning: Dependency not found: %s\n", qPrintable(info.filePath()));
        return QStringList();
    }

    if (info.isDir()) {
        QStringList ret;

        QDir dir(info.filePath());
        QStringList entries = dir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

        foreach (QString entry, entries) {
            QString s = fileName + QLatin1Char('/') + entry;
            ret += findFilesRecursively(options, s);
        }

        return ret;
    } else {
        return QStringList() << fileName;
    }
}

bool readAndroidDependencyXml(Options *options,
                              const QString &moduleName,
                              QSet<QString> *usedDependencies,
                              QSet<QString> *remainingDependencies)
{
    QString androidDependencyName = options->qtInstallDirectory + QString::fromLatin1("/lib/%1-android-dependencies.xml").arg(moduleName);

    QFile androidDependencyFile(androidDependencyName);
    if (androidDependencyFile.exists()) {
        if (options->verbose)
            fprintf(stdout, "Reading Android dependencies for %s\n", qPrintable(moduleName));

        if (!androidDependencyFile.open(QIODevice::ReadOnly)) {
            fprintf(stderr, "Cannot open %s for reading.\n", qPrintable(androidDependencyName));
            return false;
        }

        QXmlStreamReader reader(&androidDependencyFile);
        while (!reader.atEnd()) {
            reader.readNext();

            if (reader.isStartElement()) {
                if (reader.name() == QLatin1String("bundled")) {
                    if (!reader.attributes().hasAttribute(QLatin1String("file"))) {
                        fprintf(stderr, "Invalid android dependency file: %s\n", qPrintable(androidDependencyName));
                        return false;
                    }

                    QString file = reader.attributes().value(QLatin1String("file")).toString();
                    QStringList fileNames = findFilesRecursively(*options, file);
                    foreach (QString fileName, fileNames) {
                        if (usedDependencies->contains(fileName))
                            continue;

                        usedDependencies->insert(fileName);
                        options->qtDependencies.append(fileName);
                    }
                } else if (reader.name() == QLatin1String("jar")) {
                    int bundling = reader.attributes().value(QLatin1String("bundling")).toInt();
                    QString fileName = reader.attributes().value(QLatin1String("file")).toString();
                    if (bundling == (options->deploymentMechanism == Options::Bundled)) {
                        if (!usedDependencies->contains(fileName)) {
                            options->qtDependencies.append(fileName);
                            usedDependencies->insert(fileName);
                        }
                    }

                    if (!fileName.isEmpty())
                        options->localJars.append(fileName);

                    if (reader.attributes().hasAttribute(QLatin1String("initClass"))) {
                        options->initClasses.append(reader.attributes().value(QLatin1String("initClass")).toString());
                    }
                } else if (reader.name() == QLatin1String("lib")) {
                    QString fileName = reader.attributes().value(QLatin1String("file")).toString();
                    if (reader.attributes().hasAttribute(QLatin1String("replaces"))) {
                        QString replaces = reader.attributes().value(QLatin1String("replaces")).toString();
                        for (int i=0; i<options->localLibs.size(); ++i) {
                            if (options->localLibs.at(i) == replaces) {
                                options->localLibs[i] = fileName;
                                break;
                            }
                        }
                    } else if (!fileName.isEmpty()) {
                        options->localLibs.append(fileName);
                    }
                    if (fileName.endsWith(QLatin1String(".so"))) {
                        remainingDependencies->insert(fileName);
                    }
                }
            }
        }

        if (reader.hasError()) {
            fprintf(stderr, "Error in %s: %s\n", qPrintable(androidDependencyName), qPrintable(reader.errorString()));
            return false;
        }
    } else if (options->verbose) {
        fprintf(stdout, "No android dependencies for %s\n", qPrintable(moduleName));
    }

    return true;
}

QStringList getQtLibsFromElf(const Options &options, const QString &fileName)
{
    QString readElf = options.ndkPath
            + QLatin1String("/toolchains/")
            + options.toolchainPrefix
            + QLatin1Char('-')
            + options.toolchainVersion
            + QLatin1String("/prebuilt/")
            + options.ndkHost
            + QLatin1String("/bin/")
            + options.toolPrefix
            + QLatin1String("-readelf");
#if defined(Q_OS_WIN32)
    readElf += QLatin1String(".exe");
#endif

    if (!QFile::exists(readElf)) {
        fprintf(stderr, "Command does not exist: %s\n", qPrintable(readElf));
        return QStringList();
    }

    readElf = QString::fromLatin1("\"%1\" -d -W %2").arg(readElf).arg(fileName);

    FILE *readElfCommand = popen(readElf.toLocal8Bit().constData(), "r");
    if (readElfCommand == 0) {
        fprintf(stderr, "Cannot execute command %s", qPrintable(readElf));
        return QStringList();
    }

    QStringList ret;

    char buffer[512];
    while (fgets(buffer, sizeof(buffer), readElfCommand) != 0) {
        QByteArray line = QByteArray::fromRawData(buffer, qstrlen(buffer));
        if (line.contains("(NEEDED)") && line.contains("Shared library:") ) {
            const int pos = line.lastIndexOf('[') + 1;
            QString libraryName = QLatin1String("lib/") + QString::fromLatin1(line.mid(pos, line.length() - pos - 2));
            if (QFile::exists(options.qtInstallDirectory + QLatin1Char('/') + libraryName)) {
                ret += libraryName;
            }

        }
    }

    pclose(readElfCommand);

    return ret;
}

bool readDependenciesFromElf(Options *options,
                             const QString &fileName,
                             QSet<QString> *usedDependencies,
                             QSet<QString> *remainingDependencies)
{
    // Get dependencies on libraries in $QTDIR/lib
    QStringList dependencies = getQtLibsFromElf(*options, fileName);

    if (options->verbose) {
        fprintf(stdout, "Reading dependencies from %s\n", qPrintable(fileName));
        foreach (QString dep, dependencies)
            fprintf(stdout, "      %s\n", qPrintable(dep));
    }
    // Recursively add dependencies from ELF and supplementary XML information
    foreach (QString dependency, dependencies) {
        if (usedDependencies->contains(dependency))
            continue;

        usedDependencies->insert(dependency);
        if (!readDependenciesFromElf(options,
                              options->qtInstallDirectory + QLatin1Char('/') + dependency,
                              usedDependencies,
                              remainingDependencies)) {
            return false;
        }

        options->qtDependencies.append(dependency);
        if (options->verbose)
            fprintf(stderr, "Appending dependency: %s\n", qPrintable(dependency));
        QString qtBaseName = dependency.mid(sizeof("lib/lib") - 1);
        qtBaseName = qtBaseName.left(qtBaseName.size() - (sizeof(".so") - 1));
        if (!readAndroidDependencyXml(options, qtBaseName, usedDependencies, remainingDependencies)) {
            return false;
        }
    }
    return true;
}

bool readDependencies(Options *options)
{
    if (options->verbose)
        fprintf(stdout, "Detecting dependencies of application.\n");

    // Override set in .pro file
    if (!options->qtDependencies.isEmpty()) {
        if (options->verbose)
            fprintf(stdout, "\tDependencies explicitly overridden in .pro file. No detection needed.\n");
        return true;
    }

    // Add dependencies of application binary first
    QSet<QString> usedDependencies;
    QSet<QString> remainingDependencies;

    QString fileName = options->applicationBinary;
    QString qtDir = options->qtInstallDirectory + QLatin1Char('/');
    for (;;) {
        if (!readDependenciesFromElf(options, fileName, &usedDependencies, &remainingDependencies))
            return false;
        if (remainingDependencies.isEmpty())
            break;
        QSet<QString>::iterator start = remainingDependencies.begin();
        fileName = qtDir+*start;
        remainingDependencies.erase(start);
    };
    return true;
}

bool stripFile(const Options &options, const QString &fileName)
{
    QString strip = options.ndkPath
            + QLatin1String("/toolchains/")
            + options.toolchainPrefix
            + QLatin1Char('-')
            + options.toolchainVersion
            + QLatin1String("/prebuilt/")
            + options.ndkHost
            + QLatin1String("/bin/")
            + options.toolPrefix
            + QLatin1String("-strip");
#if defined(Q_OS_WIN32)
    strip += QLatin1String(".exe");
#endif

    if (!QFile::exists(strip)) {
        fprintf(stderr, "Command does not exist: %s\n", qPrintable(strip));
        return false;
    }

    strip = QString::fromLatin1("\"%1\" %2").arg(strip).arg(fileName);

    FILE *stripCommand = popen(strip.toLocal8Bit().constData(), "r");
    if (stripCommand == 0) {
        fprintf(stderr, "Cannot execute command %s", qPrintable(strip));
        return false;
    }

    pclose(stripCommand);

    return true;
}

bool stripLibraries(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Stripping libraries to minimize size.\n");


    QString libraryPath = options.outputDirectory
            + QLatin1String("/libs/")
            + options.architecture;
    QStringList libraries = QDir(libraryPath).entryList(QDir::Files);
    foreach (QString library, libraries) {
        if (library.endsWith(".so")) {
            if (!stripFile(options, libraryPath + QLatin1Char('/') + library))
                return false;
        }
    }


    return true;
}

bool containsApplicationBinary(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Checking if application binary is in package.\n");

    QFileInfo applicationBinary(options.applicationBinary);
    QString destinationFileName = options.outputDirectory
            + QLatin1String("/libs/")
            + options.architecture
            + QLatin1Char('/')
            + applicationBinary.fileName();

    if (!QFile::exists(destinationFileName)) {
#if defined(Q_OS_WIN32)
        QLatin1String makeTool("mingw32-make"); // Only Mingw host builds supported on Windows currently
#else
        QLatin1String makeTool("make");
#endif

        fprintf(stderr, "Application binary is not in output directory: %s. Please run '%s install INSTALL_ROOT=%s' first.\n",
                qPrintable(destinationFileName),
                qPrintable(makeTool),
                qPrintable(options.outputDirectory));
        return false;
    }

    return true;
}

FILE *runAdb(const Options &options, const QString &arguments)
{
    QString adb = options.sdkPath + QLatin1String("/platform-tools/adb");
#if defined(Q_OS_WIN32)
    adb += QLatin1String(".exe");
#endif

    if (!QFile::exists(adb)) {
        fprintf(stderr, "Cannot find adb tool: %s\n", qPrintable(adb));
        return 0;
    }
    QString installOption;
    if (!options.installLocation.isEmpty())
        installOption = QLatin1String(" -s ") + options.installLocation;

    adb = QString::fromLatin1("\"%1\"%2 %3").arg(adb).arg(installOption).arg(arguments);

    FILE *adbCommand = popen(adb.toLocal8Bit().constData(), "r");
    if (adbCommand == 0) {
        fprintf(stderr, "Cannot start adb: %s\n", qPrintable(adb));
        return 0;
    }

    return adbCommand;
}

bool fetchRemoteModifications(Options *options, const QString &directory)
{
    options->fetchedRemoteModificationDates = true;

    FILE *adbCommand = runAdb(*options, QLatin1String(" ls ") + directory);
    QHash<QString, QDateTime> ret;
    if (adbCommand == 0)
        return false;

    QStringList possibleDirectoriesToTry;
    char buffer[512];
    while (fgets(buffer, sizeof(buffer), adbCommand) != 0) {
        QByteArray line = QByteArray::fromRawData(buffer, qstrlen(buffer));

        if (line.count() < (3 * 8 + 3))
            continue;
        if (line.at(8) != ' '
                || line.at(17) != ' '
                || line.at(26) != ' ') {
            continue;
        }
        bool ok;
        int time = line.mid(18, 8).toUInt(&ok, 16);
        if (!ok)
            continue;

        QString fileName = QString::fromLocal8Bit(line.mid(27)).trimmed();

        ret[directory + QLatin1Char('/') + fileName] = QDateTime::fromTime_t(time);

        if (fileName != QLatin1String("..") && fileName != QLatin1String(".") && !fileName.isEmpty())
            possibleDirectoriesToTry.append(directory + QLatin1Char('/') + fileName);
    }

    foreach (QString possibleDirectoryToTry, possibleDirectoriesToTry)
        fetchRemoteModifications(options, possibleDirectoryToTry);

    pclose(adbCommand);
    options->remoteModificationDates.unite(ret);

    return true;
}

bool goodToCopy(const Options *options, const QString &file)
{
    if (!file.endsWith(QLatin1String(".so")))
        return true;

    foreach (const QString &lib, getQtLibsFromElf(*options, file))
        if (!options->qtDependencies.contains(lib))
            return false;

    return true;
}

bool deployToLocalTmp(Options *options,
                      const QString &qtDependency)
{
    if (!options->fetchedRemoteModificationDates)
        fetchRemoteModifications(options, QLatin1String("/data/local/tmp/qt"));

    QFileInfo fileInfo(options->qtInstallDirectory + QLatin1Char('/') + qtDependency);

    if (!goodToCopy(options, fileInfo.absoluteFilePath())) {
        if (options->verbose)
            fprintf(stderr, "  -- Skipping %s. It has unmet dependencies.\n", qPrintable(fileInfo.absoluteFilePath()));
        return true;
    }

    // Make sure precision is the same as what we get from Android
    QDateTime sourceModified = QDateTime::fromTime_t(fileInfo.lastModified().toTime_t());

    QDateTime destinationModified = options->remoteModificationDates.value(QLatin1String("/data/local/tmp/qt/") + qtDependency);
    if (destinationModified.isNull() || destinationModified < sourceModified) {
        if (!copyFileIfNewer(options->qtInstallDirectory + QLatin1Char('/') + qtDependency,
                             options->temporaryDirectoryName + QLatin1Char('/') + qtDependency,
                             options->verbose)) {
            return false;
        }

        if (qtDependency.endsWith(QLatin1String(".so"))
                && !stripFile(*options, options->temporaryDirectoryName + QLatin1Char('/') + qtDependency)) {
            return false;
        }

        FILE *adbCommand = runAdb(*options,
                                  QString::fromLatin1(" push %1 %2")
                                  .arg(options->temporaryDirectoryName + QLatin1Char('/') + qtDependency)
                                  .arg(QLatin1String("/data/local/tmp/qt/") + qtDependency));
        if (adbCommand == 0)
            return false;

        if (options->verbose) {
            fprintf(stdout, "  -- Deploying %s to device.\n", qPrintable(qtDependency));
            char buffer[512];
            while (fgets(buffer, sizeof(buffer), adbCommand) != 0)
                fprintf(stdout, "%s", buffer);
        }

        int errorCode = pclose(adbCommand);
        if (errorCode != 0) {
            fprintf(stderr, "Copying file to device failed!\n");
            return false;
        }
    }

    return true;
}

bool copyQtFiles(Options *options)
{
    if (options->verbose) {
        switch (options->deploymentMechanism) {
        case Options::Bundled:
            fprintf(stdout, "Copying %d dependencies from Qt into package.\n", options->qtDependencies.size());
            break;
        case Options::Ministro:
            fprintf(stdout, "Setting %d dependencies from Qt in package.\n", options->qtDependencies.size());
            break;
        case Options::Debug:
            fprintf(stdout, "Copying %d dependencies from Qt to device.\n", options->qtDependencies.size());
            break;
        };
    }

    if (options->deploymentMechanism == Options::Debug) {
        foreach (QString qtDependency, options->qtDependencies) {
            if (!deployToLocalTmp(options, qtDependency))
                return false;

            options->bundledFiles += qMakePair(qtDependency, qtDependency);
        }
    } else {
        QString libsDirectory = QLatin1String("libs/");

        // Copy other Qt dependencies
        QString libDestinationDirectory = libsDirectory + options->architecture + QLatin1Char('/');
        QString assetsDestinationDirectory = QLatin1String("assets/--Added-by-androiddeployqt--/");
        foreach (QString qtDependency, options->qtDependencies) {
            QString sourceFileName = options->qtInstallDirectory + QLatin1Char('/') + qtDependency;
            QString destinationFileName;

            if (qtDependency.endsWith(QLatin1String(".so"))) {
                QString garbledFileName;
                if (qtDependency.startsWith(QLatin1String("lib/"))) {
                    garbledFileName = qtDependency.mid(sizeof("lib/") - 1);
                } else {
                    garbledFileName = QLatin1String("lib")
                                    + QString(qtDependency).replace(QLatin1Char('/'), QLatin1Char('_'));

                }
                destinationFileName = libDestinationDirectory + garbledFileName;

            } else if (qtDependency.startsWith(QLatin1String("jar/"))) {
                destinationFileName = libsDirectory + qtDependency.mid(sizeof("jar/") - 1);
            } else {
                destinationFileName = assetsDestinationDirectory + qtDependency;
            }

            if (!QFile::exists(sourceFileName)) {
                fprintf(stderr, "Source Qt file does not exist: %s.\n", qPrintable(sourceFileName));
                return false;
            }

            if (!goodToCopy(options, sourceFileName)) {
                if (options->verbose)
                    fprintf(stderr, "  -- Skipping %s. It has unmet dependencies.\n", qPrintable(sourceFileName));
                continue;
            }

            if (options->deploymentMechanism == Options::Bundled
                    && !copyFileIfNewer(sourceFileName,
                                        options->outputDirectory + QLatin1Char('/') + destinationFileName,
                                        options->verbose)) {
                return false;
            }

            options->bundledFiles += qMakePair(destinationFileName, qtDependency);
        }
    }

    return true;
}

bool createAndroidProject(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Running Android tool to create package definition.\n");

    QString androidTool = options.sdkPath + QLatin1String("/tools/android");
#if defined(Q_OS_WIN32)
    androidTool += QLatin1String(".bat");
#endif

    if (!QFile::exists(androidTool)) {
        fprintf(stderr, "Cannot find Android tool: %s\n", qPrintable(androidTool));
        return false;
    }

    androidTool = QString::fromLatin1("\"%1\" update project --path %2 --target %3 --name %4")
            .arg(androidTool)
            .arg(options.outputDirectory)
            .arg(options.androidPlatform)
            .arg(options.appName);

    if (options.verbose)
        fprintf(stdout, "  -- Command: %s\n", qPrintable(androidTool));

    FILE *androidToolCommand = popen(androidTool.toLocal8Bit().constData(), "r");
    if (androidToolCommand == 0) {
        fprintf(stderr, "Cannot run command '%s'\n", qPrintable(androidTool));
        return false;
    }

    pclose(androidToolCommand);

    return true;
}

QString findInPath(const QString &fileName)
{
    QString path = qgetenv("PATH");
#if defined(Q_OS_WIN32)
    QLatin1Char separator(';');
#else
    QLatin1Char separator(':');
#endif

    QStringList paths = path.split(separator);
    foreach (QString path, paths) {
        QFileInfo fileInfo(path + QLatin1Char('/') + fileName);
        if (fileInfo.exists() && fileInfo.isFile() && fileInfo.isExecutable())
            return path + QLatin1Char('/') + fileName;
    }

    return QString();
}

bool buildAndroidProject(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Building Android package.\n");

    QString antTool = options.antTool;
    if (antTool.isEmpty()) {
#if defined(Q_OS_WIN32)
        antTool = findInPath(QLatin1String("ant.bat"));
#else
        antTool = findInPath(QLatin1String("ant"));
#endif
    }

    if (antTool.isEmpty()) {
        fprintf(stderr, "Cannot find ant in PATH. Please use --ant option to pass in the correct path.\n");
        return false;
    }

    if (options.verbose)
        fprintf(stdout, "Using ant: %s\n", qPrintable(antTool));

    QString oldPath = QDir::currentPath();
    if (!QDir::setCurrent(options.outputDirectory)) {
        fprintf(stderr, "Cannot current path to %s\n", qPrintable(options.outputDirectory));
        return false;
    }

    QString ant = QString::fromLatin1("\"%1\" %2").arg(antTool).arg(options.releasePackage ? QLatin1String(" release") : QLatin1String(" debug"));
    if (!options.verbose)
        ant += QLatin1String(" -quiet");

    FILE *antCommand = popen(ant.toLocal8Bit().constData(), "r");
    if (antCommand == 0) {
        fprintf(stderr, "Cannot run ant command: %s\n.", qPrintable(ant));
        return false;
    }

    char buffer[512];
    while (fgets(buffer, sizeof(buffer), antCommand) != 0)
        fprintf(stdout, "%s", buffer);

    int errorCode = pclose(antCommand);
    if (errorCode != 0) {
        fprintf(stderr, "Building the android package failed!\n");
        if (!options.verbose)
            fprintf(stderr, "  -- For more information, run this command with --verbose.\n");
        return false;
    }

    if (!QDir::setCurrent(oldPath)) {
        fprintf(stderr, "Cannot change back to old path: %s\n", qPrintable(oldPath));
        return false;
    }

    return true;
}

bool uninstallApk(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Uninstalling old Android package %s if present.\n", qPrintable(options.packageName));


    FILE *adbCommand = runAdb(options, QLatin1String(" uninstall ") + options.packageName);
    if (adbCommand == 0)
        return false;

    if (options.verbose || mustReadOutputAnyway) {
        char buffer[512];
        while (fgets(buffer, sizeof(buffer), adbCommand) != 0)
            if (options.verbose)
                fprintf(stdout, "%s", buffer);
    }

    int returnCode = pclose(adbCommand);
    if (returnCode != 0) {
        fprintf(stderr, "Warning: Uninstall failed!\n");
        if (!options.verbose)
            fprintf(stderr, "  -- Run with --verbose for more information.\n");
        return false;
    }

    return true;
}

QString apkName(const Options &options)
{
    if (options.releasePackage && options.keyStore.isEmpty())
        return QLatin1String((options.appName + "-release-unsigned").toLatin1());
    else if (options.releasePackage)
        return QLatin1String((options.appName + "-release").toLatin1());
    else
        return QLatin1String((options.appName + "-debug").toLatin1());
}

bool installApk(const Options &options)
{
    // Uninstall if necessary
    uninstallApk(options);

    if (options.verbose)
        fprintf(stdout, "Installing Android package to device.\n");

    FILE *adbCommand = runAdb(options,
                              QLatin1String(" install -r ")
                              + options.outputDirectory
                              + QLatin1String("/bin/")
                              + apkName(options)
                              + QLatin1String(".apk"));
    if (adbCommand == 0)
        return false;

    if (options.verbose || mustReadOutputAnyway) {
        char buffer[512];
        while (fgets(buffer, sizeof(buffer), adbCommand) != 0)
            if (options.verbose)
                fprintf(stdout, "%s", buffer);
    }

    int returnCode = pclose(adbCommand);
    if (returnCode != 0) {
        fprintf(stderr, "Installing to device failed!\n");
        if (!options.verbose)
            fprintf(stderr, "  -- Run with --verbose for more information.\n");
        return false;
    }

    return true;
}

bool copyGnuStl(Options *options)
{
    if (options->verbose)
        fprintf(stdout, "Copying GNU STL library\n");

    QString filePath = options->ndkPath
            + QLatin1String("/sources/cxx-stl/gnu-libstdc++/")
            + options->toolchainVersion
            + QLatin1String("/libs/")
            + options->architecture
            + QLatin1String("/libgnustl_shared.so");
    if (!QFile::exists(filePath)) {
        fprintf(stderr, "GNU STL library does not exist at %s\n", qPrintable(filePath));
        return false;
    }

    QString destinationDirectory =
            options->deploymentMechanism == Options::Debug
            ? options->temporaryDirectoryName + QLatin1String("/lib")
            : options->outputDirectory + QLatin1String("/libs/") + options->architecture;

    if (!copyFileIfNewer(filePath, destinationDirectory
                                   + QLatin1String("/libgnustl_shared.so"), options->verbose)) {
        return false;
    }

    if (options->deploymentMechanism == Options::Debug && !deployToLocalTmp(options, QLatin1String("/lib/libgnustl_shared.so")))
        return false;

    return true;
}

bool signPackage(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Signing Android package.\n");

    QString jdkPath = options.jdkPath;

    if (jdkPath.isEmpty())
        jdkPath = qgetenv("JAVA_HOME");

#if defined(Q_OS_WIN32)
    QString jarSignerTool = QString::fromLatin1("jarsigner.exe");
#else
    QString jarSignerTool = QString::fromLatin1("jarsigner");
#endif

    if (jdkPath.isEmpty() || !QFile::exists(jdkPath + QLatin1String("/bin/") + jarSignerTool))
        jarSignerTool = findInPath(jarSignerTool);
    else
        jarSignerTool = jdkPath + QLatin1String("/bin/") + jarSignerTool;

    if (!QFile::exists(jarSignerTool)) {
        fprintf(stderr, "Cannot find jarsigner in JAVA_HOME or PATH. Please use --jdk option to pass in the correct path to JDK.\n");
        return false;
    }

    jarSignerTool = QString::fromLatin1("\"%1\" -sigalg %2 -digestalg %3 -keystore %4")
            .arg(jarSignerTool).arg(options.sigAlg).arg(options.digestAlg).arg(options.keyStore);

    if (!options.keyStorePassword.isEmpty())
        jarSignerTool += QString::fromLatin1(" -storepass %1").arg(options.keyStorePassword);

    if (!options.storeType.isEmpty())
        jarSignerTool += QString::fromLatin1(" -storetype %1").arg(options.storeType);

    if (!options.keyPass.isEmpty())
        jarSignerTool += QString::fromLatin1(" -keypass %1").arg(options.keyPass);

    if (!options.sigFile.isEmpty())
        jarSignerTool += QString::fromLatin1(" -sigfile %1").arg(options.sigFile);

    if (!options.signedJar.isEmpty())
        jarSignerTool += QString::fromLatin1(" -signedjar %1").arg(options.signedJar);

    if (!options.tsaUrl.isEmpty())
        jarSignerTool += QString::fromLatin1(" -tsa %1").arg(options.tsaUrl);

    if (!options.tsaCert.isEmpty())
        jarSignerTool += QString::fromLatin1(" -tsacert %1").arg(options.tsaCert);

    if (options.internalSf)
        jarSignerTool += QLatin1String(" -internalsf");

    if (options.sectionsOnly)
        jarSignerTool += QLatin1String(" -sectionsonly");

    if (options.protectedAuthenticationPath)
        jarSignerTool += QLatin1String(" -protected");

    jarSignerTool += QString::fromLatin1(" %1 %2")
            .arg(options.outputDirectory
                 + QLatin1String("/bin/")
                 + apkName(options)
                 + QLatin1String("-unsigned.apk"))
            .arg(options.keyStoreAlias);

    FILE *jarSignerCommand = popen(jarSignerTool.toLocal8Bit().constData(), "r");
    if (jarSignerCommand == 0) {
        fprintf(stderr, "Couldn't run jarsigner.\n");
        return false;
    }

    if (options.verbose) {
        char buffer[512];
        while (fgets(buffer, sizeof(buffer), jarSignerCommand) != 0)
            fprintf(stdout, "%s", buffer);
    }

    int errorCode = pclose(jarSignerCommand);
    if (errorCode != 0) {
        fprintf(stderr, "jarsigner command failed.\n");
        if (!options.verbose)
            fprintf(stderr, "  -- Run with --verbose for more information.\n");
        return false;
    }

    QString zipAlignTool = options.sdkPath + QLatin1String("/tools/zipalign");
#if defined(Q_OS_WIN32)
    zipAlignTool += QLatin1String(".exe");
#endif

    if (!QFile::exists(zipAlignTool)) {
        fprintf(stderr, "zipalign tool not found: %s\n", qPrintable(zipAlignTool));
        return false;
    }

    if (options.verbose)
        zipAlignTool += QLatin1String(" -v");

    zipAlignTool = QString::fromLatin1("\"%1\" -f 4 %2 %3")
            .arg(zipAlignTool)
            .arg(options.outputDirectory
                 + QLatin1String("/bin/")
                 + apkName(options)
                 + QLatin1String("-unsigned.apk "))
            .arg(options.outputDirectory
                 + QLatin1String("/bin/")
                 + apkName(options)
                 + QLatin1String(".apk"));

    FILE *zipAlignCommand = popen(zipAlignTool.toLocal8Bit(), "r");
    if (zipAlignCommand == 0) {
        fprintf(stderr, "Couldn't run zipalign.\n");
        return false;
    }

    char buffer[512];
    while (fgets(buffer, sizeof(buffer), zipAlignCommand) != 0)
        fprintf(stdout, "%s", buffer);

    errorCode = pclose(zipAlignCommand);
    if (errorCode != 0) {
        fprintf(stderr, "zipalign command failed.\n");
        if (!options.verbose)
            fprintf(stderr, "  -- Run with --verbose for more information.\n");
        return false;
    }

    return true;
}

bool copyGdbServer(const Options &options)
{
    if (options.verbose)
        fprintf(stdout, "Copying gdbserver into package.\n");

    QString architectureSubDirectory;
    if (options.architecture.startsWith(QLatin1String("arm")))
        architectureSubDirectory = QLatin1String("android-arm");
    else
        architectureSubDirectory = QLatin1String("android-") + options.architecture;

    QString gdbServerBinary = options.ndkPath
            + QLatin1String("/prebuilt/")
            + architectureSubDirectory
            + QLatin1String("/gdbserver/gdbserver");
    if (!QFile::exists(gdbServerBinary)) {
        fprintf(stderr, "Cannot find gdbserver at %s.\n", qPrintable(gdbServerBinary));
        return false;
    }

    if (!copyFileIfNewer(gdbServerBinary,
                         options.outputDirectory
                            + QLatin1String("/libs/")
                            + options.architecture
                            + QLatin1String("/gdbserver"),
                         options.verbose)) {
        return false;
    }

    return true;
}

enum ErrorCode
{
    Success,
    SyntaxErrorOrHelpRequested = 1,
    CannotReadInputFile = 2,
    CannotCopyAndroidTemplate = 3,
    CannotReadDependencies = 4,
    CannotCopyGnuStl = 5,
    CannotCopyQtFiles = 6,
    CannotFindApplicationBinary = 7,
    CannotCopyGdbServer = 8,
    CannotStripLibraries = 9,
    CannotCopyAndroidExtraLibs = 10,
    CannotCopyAndroidSources = 11,
    CannotUpdateAndroidFiles = 12,
    CannotCreateAndroidProject = 13,
    CannotBuildAndroidProject = 14,
    CannotSignPackage = 15,
    CannotInstallApk = 16
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    Options options = parseOptions();
    if (options.helpRequested || options.outputDirectory.isEmpty()) {
        printHelp();
        return SyntaxErrorOrHelpRequested;
    }

    if (!readInputFile(&options))
        return CannotReadInputFile;

    fprintf(stdout,
//          "012345678901234567890123456789012345678901234567890123456789012345678901"
            "Generating Android Package\n"
            "  Input file: %s\n"
            "  Output directory: %s\n"
            "  Application binary: %s\n"
            "  Android build platform: %s\n"
            "  Install to device: %s\n",
            qPrintable(options.inputFileName),
            qPrintable(options.outputDirectory),
            qPrintable(options.applicationBinary),
            qPrintable(options.androidPlatform),
            options.installApk
                ? (options.installLocation.isEmpty() ? "Default device" : qPrintable(options.installLocation))
                : "No"
            );

    if (!copyAndroidTemplate(options))
        return CannotCopyAndroidTemplate;

    if (!readDependencies(&options))
        return CannotReadDependencies;

    if (options.deploymentMechanism != Options::Ministro && !copyGnuStl(&options))
        return CannotCopyGnuStl;

    if (!copyQtFiles(&options))
        return CannotCopyQtFiles;

    if (!containsApplicationBinary(options))
        return CannotFindApplicationBinary;

    // if (!options.releasePackage && !copyGdbServer(options))
    //     return CannotCopyGdbServer;

    // if (!stripLibraries(options))
    //     return CannotStripLibraries;

    if (!copyAndroidExtraLibs(options))
        return CannotCopyAndroidExtraLibs;

    if (!copyAndroidSources(options))
        return CannotCopyAndroidSources;

    if (!updateAndroidFiles(options))
        return CannotUpdateAndroidFiles;

    if (!createAndroidProject(options))
        return CannotCreateAndroidProject;

    if (!buildAndroidProject(options))
        return CannotBuildAndroidProject;

    if (!options.keyStore.isEmpty() && !signPackage(options))
        return CannotSignPackage;

    if (options.installApk && !installApk(options))
        return CannotInstallApk;

    fprintf(stdout, "Android package built successfully.\n");

    if (options.installApk)
        fprintf(stdout, "  -- It can now be run from the selected device/emulator.\n");

    QString outputFile = options.outputDirectory + QLatin1String("/bin/") + apkName(options);
    fprintf(stdout, "  -- File: %s\n", qPrintable(outputFile));

    return 0;
}
