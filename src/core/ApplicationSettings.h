
#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <qqml.h>
#include <QtCore/QObject>
#include <QQmlEngine>

#include <QSettings>

class ApplicationSettings : public QObject
{
	Q_OBJECT

    Q_PROPERTY(bool isAudioEnabled READ isAudioEnabled WRITE setIsAudioEnabled NOTIFY audioEnabledChanged)
    Q_PROPERTY(bool isEffectEnabled READ isEffectEnabled WRITE setIsEffectEnabled NOTIFY effectEnabledChanged)
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)
    Q_PROPERTY(bool isVirtualKeyboard READ isVirtualKeyboard WRITE setVirtualKeyboard NOTIFY virtualKeyboardChanged)
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)

public:

    ApplicationSettings(QObject *parent = 0);

    bool isAudioEnabled() const { return m_isAudioEnabled; }
    void setIsAudioEnabled(const bool newMode) {m_isAudioEnabled = newMode; emit audioEnabledChanged();}

    bool isEffectEnabled() const { return m_isEffectEnabled; }
    void setIsEffectEnabled(const bool newMode) {m_isEffectEnabled = newMode; emit effectEnabledChanged();}

    bool isFullscreen() const { return m_isFullscreen; }
    void setFullscreen(const bool newMode) {m_isFullscreen = newMode; emit fullscreenChanged();}

    bool isVirtualKeyboard() const { return m_isVirtualKeyboard; }
    void setVirtualKeyboard(const bool newMode) {m_isVirtualKeyboard = newMode; emit virtualKeyboardChanged();}

    QString locale() const { return m_locale; }
    void setLocale(const QString newLocale) {m_locale = newLocale; emit localeChanged();}

protected slots:
    Q_INVOKABLE void notifyAudioEnabledChanged();
    Q_INVOKABLE void notifyEffectEnabledChanged() {}
    Q_INVOKABLE void notifyFullscreenChanged();
    Q_INVOKABLE void notifyVirtualKeyboardChanged();
    Q_INVOKABLE void notifyLocaleChanged();

protected:

signals:
    void audioEnabledChanged();
    void effectEnabledChanged();
    void fullscreenChanged();
    void virtualKeyboardChanged();
    void localeChanged();

private:
    bool m_isAudioEnabled;
    bool m_isEffectEnabled;
    bool m_isFullscreen;
    bool m_isVirtualKeyboard;

    QString m_locale;

    QSettings m_config;
};

#endif // APPLICATIONSETTINGS_H
