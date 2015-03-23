/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). <qt@digia.org>
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
***************************************************************************/
#ifndef APPLICATIONINFO_H
#define APPLICATIONINFO_H

#include <config.h>
#include "ApplicationSettings.h"

#include <qqml.h>
#include <QtCore/QObject>
#include <QtQml/QQmlPropertyMap>
#include <QQmlEngine>

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

    Q_ENUMS(Platform)

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
        Blackberry  /**< Blackberry (not supported) */
    };

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
    bool hasShader() const { return false; }
	qreal ratio() const { return m_ratio; }
    qreal fontRatio() const { return m_fontRatio; }
    QString localeShort() const {
        return localeShort( ApplicationSettings::getInstance()->locale() );
    }
    static QString GCVersion() { return VERSION; }
    static QString QTVersion() { return qVersion(); }
    static QString CompressedAudio() { return COMPRESSED_AUDIO; }

    /// @endcond

protected slots:
	/**
	 * Returns the resource root-path used for GCompris resources.
	 */
	QString getResourceDataPath();

	/**
	 * Returns an absolute path to a langauge specific sound/voices file.
	 *
	 * @param file A templated relative path to a language specific file. Any
	 *             occurence of the '$LOCALE' placeholder will be replaced by
	 *             the currently active locale string.
	 *             Example: 'voices/$LOCALE/misc/click_on_letter.ogg'
	 * @returns An absolute path to the corresponding resource file.
	 */
    Q_INVOKABLE QString getAudioFilePath(const QString &file);

    /**
     * Returns an absolute path to a langauge specific resource file.
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
