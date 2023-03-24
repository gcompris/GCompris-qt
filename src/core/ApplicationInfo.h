/* GCompris - ApplicationInfo.h
 *
 * SPDX-FileCopyrightText: 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This file was originally created from Digia example code under BSD license
 * and heavily modified since then.
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef APPLICATIONINFO_H
#define APPLICATIONINFO_H

#include <config.h>
#include "ApplicationSettings.h"

#include <QObject>
#include <QSslSocket>

class QQmlEngine;
class QQuickWindow;

/**
 * @class ApplicationInfo
 * @short A general purpose singleton that exposes miscellaneous native
 *        functions to the QML layer.
 * @ingroup infrastructure
 */
class ApplicationInfo : public QObject
{
    Q_OBJECT

    /**
     * Width of the application viewport.
     */
    Q_PROPERTY(int applicationWidth READ applicationWidth WRITE setApplicationWidth NOTIFY applicationWidthChanged)

    /**
     * Platform the application is currently running on.
     */
    Q_PROPERTY(Platform platform READ platform CONSTANT)

    /**
     * Whether the application is currently running on a mobile platform.
     *
     * Mobile platforms are Android, Ios (not supported yet),
     * Blackberry (not supported)
     */
    Q_PROPERTY(bool isMobile READ isMobile CONSTANT)

    /**
     * Whether the current platform supports fragment shaders.
     *
     * This flag is used in some core modules to selectively deactivate
     * particle effects which cause crashes on some Android devices.
     *
     * cf. https://bugreports.qt.io/browse/QTBUG-44194
     *
     * For now always set to false, to prevent crashes.
     */
    Q_PROPERTY(bool hasShader READ hasShader CONSTANT)

    /**
     * Whether currently in portrait mode, on mobile platforms.
     *
     * Based on viewport geometry.
     */
    Q_PROPERTY(bool isPortraitMode READ isPortraitMode WRITE setIsPortraitMode NOTIFY portraitModeChanged)

    /**
     * Ratio factor used for scaling of sizes on high-dpi devices.
     *
     * Must be used by activities as a scaling factor to all pixel values.
     */
    Q_PROPERTY(qreal ratio READ ratio NOTIFY ratioChanged)

    /**
     * Ratio factor used for font scaling.
     *
     * On some low-dpi Android devices with high res (e.g. Galaxy Tab 4) the
     * fonts in Text-like elements appear too small with respect to the other
     * graphics -- also if we are using font.pointSize.
     *
     * For these cases we calculate a fontRatio in ApplicationInfo that takes
     * dpi information into account, as proposed on
     * https://doc.qt.io/qt-5/scalability.html#calculating-scaling-ratio
     *
     * GCText applies this factor automatically on its new fontSize property.
     */
    Q_PROPERTY(qreal fontRatio READ fontRatio NOTIFY fontRatioChanged)

    /**
     * Short (2-letter) locale string of the currently active language.
     */
    Q_PROPERTY(QString localeShort READ localeShort CONSTANT)

    /**
     * GCompris version string (compile time).
     */
    Q_PROPERTY(QString GCVersion READ GCVersion CONSTANT)

    /**
     * GCompris version code (compile time).
     */
    Q_PROPERTY(int GCVersionCode READ GCVersionCode CONSTANT)

    /**
     * Qt version string (runtime).
     */
    Q_PROPERTY(QString QTVersion READ QTVersion CONSTANT)

    /**
     * OpenSSL version string (runtime).
     */
    Q_PROPERTY(QString OpenSSLVersion READ OpenSSLVersion CONSTANT)

    /**
     * Audio codec used for voices resources.
     *
     * This is determined at compile time (ogg for free platforms, aac on
     * MacOSX and IOS).
     */
    Q_PROPERTY(QString CompressedAudio READ CompressedAudio CONSTANT)

    /**
     * Download allowed
     *
     * This is determined at compile time. If set to NO GCompris will
     * never download anything.
     */
    Q_PROPERTY(bool isDownloadAllowed READ isDownloadAllowed CONSTANT)

    /**
     * Whether the application is currently using OpenGL or not.
     *
     * Use to deactivate some effects if OpenGL not used.
     */
    Q_PROPERTY(bool useOpenGL READ useOpenGL WRITE setUseOpenGL NOTIFY useOpenGLChanged)

    /**
     * Whether Box2D is installed or not.
     *
     * Use to disable activities that use Box2D when it's not installed.
     */
    Q_PROPERTY(bool isBox2DInstalled READ isBox2DInstalled NOTIFY isBox2DInstalledChanged)

public:
    /**
     * Known host platforms.
     */
    enum Platform {
        Linux, /**< Linux (except Android) */
        Windows, /**< Windows */
        MacOSX, /**< MacOSX */
        Android, /**< Android */
        Ios, /**< IOS (not supported) */
        Blackberry, /**< Blackberry (not supported) */
        UbuntuTouchOS /**< UbuntuTouch OS */
    };

    Q_ENUM(Platform)

    /**
     * Returns an absolute and platform independent path to the passed @p file
     *
     * @param file A relative filename.
     * @returns Absolute path to the file.
     */
    static QString getFilePath(const QString &file);

    /**
     * Returns the short locale name for the passed @p locale.
     *
     * Handles also 'system' (GC_DEFAULT_LOCALE) correctly which resolves to
     * QLocale::system().name().
     *
     * @param locale A locale string of the form \<language\>_\<country\>
     * @returns A short locale string of the form \<language\>
     */
    static QString localeShort(const QString &locale)
    {
        QString _locale = locale;
        if (_locale == GC_DEFAULT_LOCALE) {
            _locale = QLocale::system().name();
        }
        if (_locale == "C") {
            _locale = "en_US";
        }
        // Can't use left(2) because of Asturian where there are 3 chars
        return _locale.left(_locale.indexOf('_'));
    }

    /**
     * Returns a locale string that can be used in voices filenames.
     *
     * @param locale A locale string of the form \<language\>_\<country\>
     * @returns A locale string as used in voices filenames.
     */
    Q_INVOKABLE QString getVoicesLocale(const QString &locale);

    /**
     * Request GCompris to take the Audio Focus at the system level.
     *
     * On systems that support it, it will mute a running audio player.
     */
    Q_INVOKABLE bool requestAudioFocus() const;

    /**
     * Abandon the Audio Focus.
     *
     * On systems that support it, it will let an audio player start again.
     */
    Q_INVOKABLE void abandonAudioFocus() const;

    /**
     * Compare two strings respecting locale specific sort order.
     *
     * @param a         First string to compare
     * @param b         Second string to compare
     * @param locale    Locale to respect for comparison in any of the forms
     *                  used in GCompris xx[_XX][.codeset]. Defaults to currently
     *                  set language from global configuration.
     * @returns         -1, 0 or 1 if a is less than, equal to or greater than b
     */
    Q_INVOKABLE int localeCompare(const QString &a, const QString &b, const QString &locale = "") const;

    /**
     * Sort a list of strings respecting locale specific sort order.
     *
     * This function is supposed to be called from QML/JS. As there are still
     * problems marshalling QStringList from C++ to QML/JS we use QVariantList
     * both for argument and return value.
     *
     * @param list      List of strings to be sorted.
     * @param locale    Locale to respect for sorting in any of the forms
     *                  used in GCompris xx[_XX][.codeset].
     * @returns         List sorted by the sort order of the passed locale.
     */
    Q_INVOKABLE QVariantList localeSort(QVariantList list, const QString &locale = "") const;

    /// @cond INTERNAL_DOCS

    static ApplicationInfo *getInstance()
    {
        if (!m_instance) {
            m_instance = new ApplicationInfo();
        }
        return m_instance;
    }
    static QObject *applicationInfoProvider(QQmlEngine *engine,
                                            QJSEngine *scriptEngine);
    static void setWindow(QQuickWindow *window);
    explicit ApplicationInfo(QObject *parent = nullptr);
    ~ApplicationInfo();
    int applicationWidth() const { return m_applicationWidth; }
    void setApplicationWidth(const int newWidth);
    Platform platform() const { return m_platform; }
    bool isPortraitMode() const { return m_isPortraitMode; }
    void setIsPortraitMode(const bool newMode);
    bool isMobile() const { return m_isMobile; }
    bool hasShader() const
    {
#if defined(Q_OS_ANDROID)
        return false;
#else
        return true;
#endif
    }
    qreal ratio() const { return m_ratio; }
    qreal fontRatio() const { return m_fontRatio; }
    QString localeShort() const
    {
        return localeShort(ApplicationSettings::getInstance()->locale());
    }
    static QString GCVersion() { return VERSION; }
    static int GCVersionCode() { return VERSION_CODE; }
    static QString QTVersion() { return qVersion(); }
    static QString OpenSSLVersion() { return QSslSocket::sslLibraryVersionString(); }
    static QString CompressedAudio() { return COMPRESSED_AUDIO; }
    static bool isDownloadAllowed() { return QString(DOWNLOAD_ALLOWED) == "ON"; }
    bool useOpenGL() const { return m_useOpenGL; }
    void setUseOpenGL(bool useOpenGL) { m_useOpenGL = useOpenGL; }

    bool isBox2DInstalled() const { return m_isBox2DInstalled; }
    void setBox2DInstalled(const QQmlEngine &engine);

    /**
     * Returns the native screen orientation.
     *
     * Wraps QScreen::nativeOrientation: The native orientation of the screen
     * is the orientation where the logo sticker of the device appears the
     * right way up, or Qt::PrimaryOrientation if the platform does not support
     * this functionality.
     *
     * The native orientation is a property of the hardware, and does not change
     */
    Q_INVOKABLE Qt::ScreenOrientation getNativeOrientation();

    /**
     * Change the desired orientation of the application.
     *
     * Android specific function, cf. https://developer.android.com/reference/android/app/Activity.html#setRequestedOrientation(int)
     *
     * @param orientation Desired orientation of the application. For possible
     *                    values cf. https://developer.android.com/reference/android/content/pm/ActivityInfo.html#screenOrientation .
     *                    Some useful values:
     *                    - -1: SCREEN_ORIENTATION_UNSPECIFIED
     *                    -  0: SCREEN_ORIENTATION_LANDSCAPE: forces landscape
     *                    -  1: SCREEN_ORIENTATION_PORTRAIT: forces portrait
     *                    -  5: SCREEN_ORIENTATION_NOSENSOR: forces native
     *                          orientation mode on each device (portrait on
     *                          smartphones, landscape on tablet)
     *                    - 14: SCREEN_ORIENTATION_LOCKED: lock current orientation
     */
    Q_INVOKABLE void setRequestedOrientation(int orientation);

    /**
     * Query the desired orientation of the application.
     *
     * @sa setRequestedOrientation
     */
    Q_INVOKABLE int getRequestedOrientation();

    /**
     * Checks whether a sensor type from the QtSensor module is supported on
     * the current platform.
     *
     * @param sensorType  Classname of a sensor from the QtSensor module
     *                    to be checked (e.g. "QTiltSensor").
     */
    Q_INVOKABLE bool sensorIsSupported(const QString &sensorType);

    /**
     * Toggles activation of screensaver on android
     *
     * @param value Whether screensaver should be disabled (true) or
     *              enabled (false).
     */
    Q_INVOKABLE void setKeepScreenOn(bool value);

    /**
     * Ask for permissions for reading/writing in storage for android.
     * Do nothing for other platforms.
     *
     * https://developer.android.com/training/permissions/requesting
     * https://doc.qt.io/qt-5/qtandroid.html#requestPermissions
     * Needed for android above 6.0
     */
    bool checkPermissions() const;

    /// @endcond

public Q_SLOTS:
    /**
     * Returns the resource root-paths used for GCompris resources.
     * First look in a local folder if exists, else will look into the rcc files.
     */
    QStringList getResourceDataPaths();

    /**
     * Returns an absolute path to a language specific sound/voices file. If
     * the file is already absolute only the token replacement is applied.
     *
     * @param file A templated relative path to a language specific file. Any
     *             occurrence of the '$LOCALE' placeholder will be replaced by
     *             the currently active locale string.
     *             Any occurrence of '$CA' placeholder will be replaced by
     *             the current compressed audio format ('ogg' or 'aac).
     *             Example: 'voices-$CA/$LOCALE/misc/click_on_letter.$CA'
     * @returns An absolute path to the corresponding resource file.
     */
    Q_INVOKABLE QString getAudioFilePath(const QString &file);

    /**
     * Returns an absolute path to a language specific sound/voices file. If
     * the file is already absolute only the token replacement is applied.
     *
     * @param file A templated relative path to a language specific file. Any
     *             occurrence of the '$LOCALE' placeholder will be replaced by
     *             the currently active locale string.
     *             Any occurrence of '$CA' placeholder will be replaced by
     *             the current compressed audio format ('ogg' or 'aac).
     *             Example: 'voices-$CA/$LOCALE/misc/click_on_letter.$CA'
     * @param localeName the locale for which to get this audio file
     * @returns An absolute path to the corresponding resource file.
     */
    Q_INVOKABLE QString getAudioFilePathForLocale(const QString &file,
                                                  const QString &localeName);

    /**
     * Returns an absolute path to a language specific resource file.
     *
     * Generalization of getAudioFilePath().
     * @sa getAudioFilePath
     */
    Q_INVOKABLE QString getLocaleFilePath(const QString &file);

    /**
     * @returns A list of systems-fonts that should be excluded from font
     *          selection.
     */
    Q_INVOKABLE QStringList getSystemExcludedFonts();

    /**
     * @returns A list of fonts contained in the fonts resources.
     */
    Q_INVOKABLE QStringList getFontsFromRcc();
    /**
     * @returns A list of background music contained in the background music resources.
     */
    Q_INVOKABLE QStringList getBackgroundMusicFromRcc();
    /**
     * Stores a screenshot in the passed @p file.
     *
     * @param file Absolute destination filename.
     */
    Q_INVOKABLE void screenshot(const QString &file);

    void notifyPortraitMode();
    Q_INVOKABLE void notifyFullscreenChanged();

protected:
    qreal getSizeWithRatio(const qreal height) { return ratio() * height; }

Q_SIGNALS:
    void applicationWidthChanged();
    void portraitModeChanged();
    void ratioChanged();
    void fontRatioChanged();
    void applicationSettingsChanged();
    void fullscreenChanged();
    void useOpenGLChanged();
    void isBox2DInstalledChanged();

private:
    static ApplicationInfo *m_instance;
    int m_applicationWidth;
    Platform m_platform;
    bool m_isPortraitMode;
    bool m_isMobile;
    bool m_useOpenGL;
    bool m_isBox2DInstalled;
    qreal m_ratio;
    qreal m_fontRatio;

    // Symbols fonts that user can't see
    QStringList m_excludedFonts;
    QStringList m_fontsFromRcc;
    QStringList m_backgroundMusicFromRcc;

    static QQuickWindow *m_window;
};

#endif // APPLICATIONINFO_H
