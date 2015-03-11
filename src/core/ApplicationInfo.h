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
****************************************************************************/
#ifndef APPLICATIONINFO_H
#define APPLICATIONINFO_H

#include <config.h>
#include "ApplicationSettings.h"

#include <qqml.h>
#include <QtCore/QObject>
#include <QtQml/QQmlPropertyMap>
#include <QQmlEngine>

class QQuickWindow;

class ApplicationInfo : public QObject
{
	Q_OBJECT

    Q_ENUMS(Platform)

	Q_PROPERTY(int applicationWidth READ applicationWidth WRITE setApplicationWidth NOTIFY applicationWidthChanged)
    Q_PROPERTY(Platform platform READ platform CONSTANT)
    Q_PROPERTY(bool isMobile READ isMobile CONSTANT)
    Q_PROPERTY(bool hasShader READ hasShader CONSTANT)
    Q_PROPERTY(bool isPortraitMode READ isPortraitMode WRITE setIsPortraitMode NOTIFY portraitModeChanged)
	Q_PROPERTY(qreal ratio READ ratio NOTIFY ratioChanged)
    Q_PROPERTY(qreal fontRatio READ fontRatio NOTIFY fontRatioChanged)
	Q_PROPERTY(qreal hMargin READ hMargin NOTIFY hMarginChanged)
	Q_PROPERTY(qreal sliderHandleWidth READ sliderHandleWidth NOTIFY ratioChanged)
	Q_PROPERTY(qreal sliderHandleHeight READ sliderHandleHeight NOTIFY ratioChanged)
	Q_PROPERTY(qreal sliderGapWidth READ sliderGapWidth NOTIFY ratioChanged)
    Q_PROPERTY(QString localeShort READ localeShort)
    Q_PROPERTY(QString GCVersion READ GCVersion CONSTANT)
    Q_PROPERTY(QString QTVersion READ QTVersion CONSTANT)
    Q_PROPERTY(QString CompressedAudio READ CompressedAudio CONSTANT)

public:

    enum Platform {
        Linux,
        Windows,
		MacOSX,
        Android,
        Ios,
        Blackberry
    };

    explicit ApplicationInfo(QObject *parent = 0);
    ~ApplicationInfo();
    static void init();
    // It is not recommended to create a singleton of Qml Singleton registered
    // object but we could not found a better way to let us access ApplicationInfo
    // on the C++ side. All our test shows that it works.
    static ApplicationInfo *getInstance() {
        if(!m_instance) {
            m_instance = new ApplicationInfo();
        }
        return m_instance;
    }
    static QObject *systeminfoProvider(QQmlEngine *engine,
									   QJSEngine *scriptEngine);

    static void setWindow(QQuickWindow *window);
    static QString getFilePath(const QString &file);

	int applicationWidth() const { return m_applicationWidth; }
	void setApplicationWidth(const int newWidth);

    Platform platform() const { return m_platform; }

	bool isPortraitMode() const { return m_isPortraitMode; }
	void setIsPortraitMode(const bool newMode);

    bool isMobile() const { return m_isMobile; }

    // On some platforms shader crashes, let's put them back when we
    // know how to detect the platforms that support it
    // https://bugreports.qt.io/browse/QTBUG-44194
    bool hasShader() const { return false; }

	qreal hMargin() const { return m_hMargin; }
	qreal ratio() const { return m_ratio; }
    qreal fontRatio() const { return m_fontRatio; }
	qreal sliderHandleHeight()  { return m_sliderHandleHeight; }
	qreal sliderGapWidth()  { return m_sliderGapWidth; }
	qreal sliderHandleWidth()  { return m_sliderHandleWidth; }

    // return the short locale name for the given locale.
    // If 'defaut' is passed then return the short locale for the system locale
    // Can't use left(2) because of Asturian where there are 3 chars
    static QString localeShort(const QString &locale) {
        QString _locale = locale;
        if(_locale == GC_DEFAULT_LOCALE) {
            _locale = QLocale::system().name();
        }
        return _locale.left(_locale.indexOf('_'));
    }
    // return the short locale name for the current config
    QString localeShort() const {
        return localeShort( ApplicationSettings::getInstance()->locale() );
    }
    static QString GCVersion() { return VERSION; }
    static QString QTVersion() { return qVersion(); }
    static QString CompressedAudio() { return COMPRESSED_AUDIO; }

    Q_INVOKABLE QString getVoicesLocale(const QString &locale);

protected slots:
	void notifyPortraitMode();

	QString getResourceDataPath();
    Q_INVOKABLE QString getAudioFilePath(const QString &file);
    Q_INVOKABLE QString getLocaleFilePath(const QString &file);
    Q_INVOKABLE QStringList getSystemExcludedFonts();
    Q_INVOKABLE QStringList getFontsFromRcc();
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void screenshot(const QString &file);


protected:
	qreal getSizeWithRatio(const qreal height) { return ratio() * height; }

signals:
	void applicationWidthChanged();
	void portraitModeChanged();
	void hMarginChanged();
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
	qreal m_hMargin;
	qreal m_sliderHandleHeight, m_sliderHandleWidth, m_sliderGapWidth;

    // Symbols fonts that user can't see
    QStringList m_excludedFonts;
    QStringList m_fontsFromRcc;

    static QQuickWindow *m_window;
};

#endif // APPLICATIONINFO_H
