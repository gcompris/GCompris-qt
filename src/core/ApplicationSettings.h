
#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <qqml.h>
#include <QtCore/QObject>
#include <QQmlEngine>
#include <QUrl>

#include <QSettings>

class ApplicationSettings : public QObject
{
	Q_OBJECT

	// general group
    Q_PROPERTY(bool isAudioEnabled READ isAudioEnabled WRITE setIsAudioEnabled NOTIFY audioEnabledChanged)
    Q_PROPERTY(bool isEffectEnabled READ isEffectEnabled WRITE setIsEffectEnabled NOTIFY effectEnabledChanged)
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)
    Q_PROPERTY(bool isVirtualKeyboard READ isVirtualKeyboard WRITE setVirtualKeyboard NOTIFY virtualKeyboardChanged)
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)
    Q_PROPERTY(bool isAutomaticDownloadsEnabled READ isAutomaticDownloadsEnabled WRITE setIsAutomaticDownloadsEnabled NOTIFY automaticDownloadsEnabledChanged)

    // admin group
    Q_PROPERTY(QString downloadServerUrl READ downloadServerUrl WRITE setDownloadServerUrl NOTIFY downloadServerUrlChanged)

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

    bool isAudioEnabled() const { return m_isAudioEnabled; }
    void setIsAudioEnabled(const bool newMode) {
        m_isAudioEnabled = newMode;
        emit audioEnabledChanged();
    }

    bool isEffectEnabled() const { return m_isEffectEnabled; }
    void setIsEffectEnabled(const bool newMode) {
        m_isEffectEnabled = newMode;
        emit effectEnabledChanged();
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

    bool isAutomaticDownloadsEnabled() const { return m_isAutomaticDownloadsEnabled; }
    void setIsAutomaticDownloadsEnabled(const bool newIsAutomaticDownloadsEnabled) {
        m_isAutomaticDownloadsEnabled = newIsAutomaticDownloadsEnabled;
        emit automaticDownloadsEnabledChanged();
    }

    QString downloadServerUrl() const { return m_downloadServerUrl; }
    void setDownloadServerUrl(const QString newDownloadServerUrl) {
        m_downloadServerUrl = newDownloadServerUrl;
        emit downloadServerUrlChanged();
    }

protected slots:
    Q_INVOKABLE void notifyAudioEnabledChanged();
    Q_INVOKABLE void notifyEffectEnabledChanged() {}
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void notifyVirtualKeyboardChanged();
    Q_INVOKABLE void notifyLocaleChanged();
    Q_INVOKABLE void notifyAutomaticDownloadsEnabledChanged();

    Q_INVOKABLE void notifyDownloadServerUrlChanged();

protected:

signals:
    void audioEnabledChanged();
    void effectEnabledChanged();
    void fullscreenChanged();
    void virtualKeyboardChanged();
    void localeChanged();
    void automaticDownloadsEnabledChanged();

    void downloadServerUrlChanged();

private:
    static ApplicationSettings *m_instance;
    bool m_isAudioEnabled;
    bool m_isEffectEnabled;
    bool m_isFullscreen;
    bool m_isVirtualKeyboard;
    bool m_isAutomaticDownloadsEnabled;
    QString m_locale;

    QString m_downloadServerUrl;

    QSettings m_config;
};

#endif // APPLICATIONSETTINGS_H
