/* GCompris - ApplicationSettingsDefault.cpp
 *
 * Copyright (C) 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This file was originally created from Digia example code under BSD license
 * and heavily modified since then.
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
#ifndef APPLICATIONINFO_H
#define APPLICATIONINFO_H

#include <config.h>
#include "ApplicationSettings.h"

#include <QObject>
#include <QQmlPropertyMap>
#include <QQmlEngine>
#include <QtGlobal>

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
     * http://doc.qt.io/qt-5/scalability.html#calculating-scaling-ratio
     *
     * GCText applies this factor automatically on its new fontSize property.
     */
	Q_PROPERTY(qreal fontRatio READ fontRatio NOTIFY fontRatioChanged)

	/**
	 * Short (2-letter) locale string of the currently active language.
	 */
	Q_PROPERTY(QString localeShort READ localeShort)

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
	Q_PROPERTY(bool useOpenGL READ useOpenGL CONSTANT)
        
public:

	/**
	 * Known host platforms.
	 */
    enum Platform {
        Linux,      /**< Linux (except Android) */
        Windows,    /**< Windows */
        MacOSX,     /**< MacOSX */
        Android,    /**< Android */
        Ios,        /**< IOS (not supported) */
        Blackberry, /**< Blackberry (not supported) */
        SailfishOS  /**< SailfishOS */
    };

    Q_ENUM(Platform)

    /**
     * Registers singleton in the QML engine.
     *
     * It is not recommended to create a singleton of Qml Singleton registered
     * object but we could not found a better way to let us access ApplicationInfo
     * on the C++ side. All our test shows that it works.
     */
    static void init();

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
    static QString localeShort(const QString &locale) {
        QString _locale = locale;
        if(_locale == GC_DEFAULT_LOCALE) {
            _locale = QLocale::system().name();
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
     * Return the platform specific path for storing data shared between apps
     *
     * On Android: /storage/emulated/0/GCompris (>= Android 4.2),
     *             /storage/sdcard0/GCompris (< Android 4.2)
     * On Linux: $HOME/local/share/GCompris
     */
    Q_INVOKABLE QString getSharedWritablePath() const;

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
    Q_INVOKABLE int localeCompare(const QString& a, const QString& b, const QString& locale = "") const;

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
    Q_INVOKABLE QVariantList localeSort(QVariantList list, const QString& locale = "") const;

    /// @cond INTERNAL_DOCS

    static ApplicationInfo *getInstance() {
        if(!m_instance) {
            m_instance = new ApplicationInfo();
        }
        return m_instance;
    }
    static QObject *systeminfoProvider(QQmlEngine *engine,
									   QJSEngine *scriptEngine);
    static void setWindow(QQuickWindow *window);
    explicit ApplicationInfo(QObject *parent = 0);
    ~ApplicationInfo();
	int applicationWidth() const { return m_applicationWidth; }
	void setApplicationWidth(const int newWidth);
    Platform platform() const { return m_platform; }
	bool isPortraitMode() const { return m_isPortraitMode; }
	void setIsPortraitMode(const bool newMode);
    bool isMobile() const { return m_isMobile; }
    bool hasShader() const {
#if defined(Q_OS_ANDROID)
        return false;
#else
        return true;
#endif
    }
	qreal ratio() const { return m_ratio; }
    qreal fontRatio() const { return m_fontRatio; }
    QString localeShort() const {
        return localeShort( ApplicationSettings::getInstance()->locale() );
    }
    static QString GCVersion() { return VERSION; }
    static int GCVersionCode() { return VERSION_CODE; }
    static QString QTVersion() { return qVersion(); }
    static QString CompressedAudio() { return COMPRESSED_AUDIO; }
    static bool isDownloadAllowed() { return QString(DOWNLOAD_ALLOWED) == "ON"; }
    static bool useOpenGL() { 
#if QT_VERSION >= QT_VERSION_CHECK(5, 8, 0)
        return QString(GRAPHICAL_RENDERER) != "software"; 
#else
        return true;
#endif
    }

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
     * Android specific function, cf. http://developer.android.com/reference/android/app/Activity.html#setRequestedOrientation(int)
     *
     * @param orientation Desired orientation of the application. For possible
     *                    values cf. http://developer.android.com/reference/android/content/pm/ActivityInfo.html#screenOrientation .
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
    Q_INVOKABLE bool sensorIsSupported(const QString& sensorType);

    /**
     * Toggles activation of screensaver on android
     *
     * @param value Whether screensaver should be disabled (true) or
     *              enabled (false).
     */
    Q_INVOKABLE void setKeepScreenOn(bool value);

    /// @endcond

protected slots:
	/**
	 * Returns the resource root-path used for GCompris resources.
	 */
	QString getResourceDataPath();

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
     * @param locale the locale for which to get this audio file
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
     * Stores a screenshot in the passed @p file.
     *
     * @param file Absolute destination filename.
     */
    Q_INVOKABLE void screenshot(const QString &file);

    void notifyPortraitMode();
    Q_INVOKABLE void notifyFullscreenChanged();

protected:
	qreal getSizeWithRatio(const qreal height) { return ratio() * height; }

signals:
	void applicationWidthChanged();
	void portraitModeChanged();
	void ratioChanged();
    void fontRatioChanged();
    void applicationSettingsChanged();
    void fullscreenChanged();

private:
    static ApplicationInfo *m_instance;
    int m_applicationWidth;
    Platform m_platform;
	QQmlPropertyMap *m_constants;
	bool m_isPortraitMode;
	bool m_isMobile;
	qreal m_ratio;
    qreal m_fontRatio;

    // Symbols fonts that user can't see
    QStringList m_excludedFonts;
    QStringList m_fontsFromRcc;

    static QQuickWindow *m_window;
};

#endif // APPLICATIONINFO_H
