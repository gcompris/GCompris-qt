/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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

#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <qqml.h>
#include <QtCore/QObject>
#include <QQmlEngine>
#include <QUrl>
#include <QtGlobal>

#include <QSettings>

class ApplicationSettings : public QObject
{
	Q_OBJECT

	// general group
	Q_PROPERTY(bool isAudioVoicesEnabled READ isAudioVoicesEnabled WRITE setIsAudioVoicesEnabled NOTIFY audioVoicesEnabledChanged)
	Q_PROPERTY(bool isAudioEffectsEnabled READ isAudioEffectsEnabled WRITE setIsAudioEffectsEnabled NOTIFY audioEffectsEnabledChanged)
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)
    Q_PROPERTY(bool isVirtualKeyboard READ isVirtualKeyboard WRITE setVirtualKeyboard NOTIFY virtualKeyboardChanged)
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)
    Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(bool isEmbeddedFont READ isEmbeddedFont WRITE setIsEmbeddedFont NOTIFY embeddedFontChanged)
    Q_PROPERTY(bool isAutomaticDownloadsEnabled READ isAutomaticDownloadsEnabled WRITE setIsAutomaticDownloadsEnabled NOTIFY automaticDownloadsEnabledChanged)
    Q_PROPERTY(quint32 filterLevelMin READ filterLevelMin WRITE setFilterLevelMin NOTIFY filterLevelMinChanged)
    Q_PROPERTY(quint32 filterLevelMax READ filterLevelMax WRITE setFilterLevelMax NOTIFY filterLevelMaxChanged)

    // admin group
    Q_PROPERTY(QString downloadServerUrl READ downloadServerUrl WRITE setDownloadServerUrl NOTIFY downloadServerUrlChanged)

    // internal group
    Q_PROPERTY(quint32 exeCount READ exeCount WRITE setExeCount NOTIFY exeCountChanged)

public:

    ApplicationSettings(QObject *parent = 0);
    ~ApplicationSettings();
    static void init();
    // It is not recommended to create a singleton of Qml Singleton registered
    // object but we could not found a better way to let us access ApplicationInfo
    // on the C++ side. All our test shows that it works.
    static ApplicationSettings *getInstance() {
        if(!m_instance) {
            m_instance = new ApplicationSettings();
        }
        return m_instance;
    }
    static QObject *systeminfoProvider(QQmlEngine *engine,
                                       QJSEngine *scriptEngine);

	bool isAudioVoicesEnabled() const { return m_isAudioVoicesEnabled; }
	void setIsAudioVoicesEnabled(const bool newMode) {
		m_isAudioVoicesEnabled = newMode;
		emit audioVoicesEnabledChanged();
    }

	bool isAudioEffectsEnabled() const { return m_isAudioEffectsEnabled; }
	void setIsAudioEffectsEnabled(const bool newMode) {
		m_isAudioEffectsEnabled = newMode;
		emit audioEffectsEnabledChanged();
    }

    bool isFullscreen() const { return m_isFullscreen; }
    void setFullscreen(const bool newMode) {
        m_isFullscreen = newMode;
        emit fullscreenChanged();
    }

    bool isVirtualKeyboard() const { return m_isVirtualKeyboard; }
    void setVirtualKeyboard(const bool newMode) {
        m_isVirtualKeyboard = newMode;
        emit virtualKeyboardChanged();
    }

    QString locale() const { return m_locale; }
    void setLocale(const QString newLocale) {
        m_locale = newLocale;
        emit localeChanged();
    }

    QString font() const { return m_font; }
    void setFont(const QString newFont) {
        m_font = newFont;
        emit fontChanged();
    }

    bool isEmbeddedFont() const { return m_isEmbeddedFont; }
    void setIsEmbeddedFont(const bool newIsEmbeddedFont) {
        m_isEmbeddedFont = newIsEmbeddedFont;
        emit embeddedFontChanged();
    }

    bool isAutomaticDownloadsEnabled() const { return m_isAutomaticDownloadsEnabled; }
    void setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled) {
        m_isAutomaticDownloadsEnabled = newIsAutomaticDownloadsEnabled;
        emit automaticDownloadsEnabledChanged();
    }

    quint32 filterLevelMin() const { return m_filterLevelMin; }
    void setFilterLevelMin(const quint32 newFilterLevelMin) {
        m_filterLevelMin = newFilterLevelMin;
        emit filterLevelMinChanged();
    }

    quint32 filterLevelMax() const { return m_filterLevelMax; }
    void setFilterLevelMax(const quint32 newFilterLevelMax) {
        m_filterLevelMax = newFilterLevelMax;
        emit filterLevelMaxChanged();
    }

    QString downloadServerUrl() const { return m_downloadServerUrl; }
    void setDownloadServerUrl(const QString newDownloadServerUrl) {
        m_downloadServerUrl = newDownloadServerUrl;
        emit downloadServerUrlChanged();
    }

    quint32 exeCount() const { return m_exeCount; }
    void setExeCount(const quint32 newExeCount) {
        m_exeCount = newExeCount;
        emit exeCountChanged();
    }

protected slots:
	Q_INVOKABLE void notifyAudioVoicesEnabledChanged();
	Q_INVOKABLE void notifyAudioEffectsEnabledChanged();
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void notifyVirtualKeyboardChanged();
    Q_INVOKABLE void notifyLocaleChanged();
    Q_INVOKABLE void notifyFontChanged();
    Q_INVOKABLE void notifyEmbeddedFontChanged();
    Q_INVOKABLE void notifyAutomaticDownloadsEnabledChanged();
    Q_INVOKABLE void notifyFilterLevelMinChanged();
    Q_INVOKABLE void notifyFilterLevelMaxChanged();

    Q_INVOKABLE void notifyDownloadServerUrlChanged();

    Q_INVOKABLE void notifyExeCountChanged();

protected:

signals:
	void audioVoicesEnabledChanged();
	void audioEffectsEnabledChanged();
    void fullscreenChanged();
    void virtualKeyboardChanged();
    void localeChanged();
    void fontChanged();
    void embeddedFontChanged();
    void automaticDownloadsEnabledChanged();
    void filterLevelMinChanged();
    void filterLevelMaxChanged();

    void downloadServerUrlChanged();

    void exeCountChanged();

private:

    // Update in configuration the couple {key, value} in the group.
    template<class T> void updateValueInConfig(const QString& group,
                                         const QString& key, const T& value);

    static ApplicationSettings *m_instance;
	bool m_isAudioVoicesEnabled;
	bool m_isAudioEffectsEnabled;
    bool m_isFullscreen;
    bool m_isVirtualKeyboard;
    bool m_isAutomaticDownloadsEnabled;
    bool m_isEmbeddedFont;
    quint32 m_filterLevelMin;
    quint32 m_filterLevelMax;
    QString m_locale;
    QString m_font;

    QString m_downloadServerUrl;

    quint32 m_exeCount;

    QSettings m_config;
};

#endif // APPLICATIONSETTINGS_H
