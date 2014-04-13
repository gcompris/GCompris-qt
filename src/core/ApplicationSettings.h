
#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <qqml.h>
#include <QtCore/QObject>
#include <QQmlEngine>

#include <KConfig>

class ApplicationSettings : public QObject
{
	Q_OBJECT

    Q_PROPERTY(bool isAudioEnabled READ isAudioEnabled WRITE setIsAudioEnabled NOTIFY audioEnabledChanged)
    Q_PROPERTY(bool isEffectEnabled READ isEffectEnabled WRITE setIsEffectEnabled NOTIFY effectEnabledChanged)
    Q_PROPERTY(bool isFullscreen READ isFullscreen WRITE setFullscreen NOTIFY fullscreenChanged)

public:

    ApplicationSettings(QObject *parent = 0);

    bool isAudioEnabled() const { return m_isAudioEnabled; }
    void setIsAudioEnabled(const bool newMode) {m_isAudioEnabled = newMode; emit audioEnabledChanged();}

    bool isEffectEnabled() const { return m_isEffectEnabled; }
    void setIsEffectEnabled(const bool newMode) {m_isEffectEnabled = newMode; emit effectEnabledChanged();}

    bool isFullscreen() const { return m_isFullscreen; }
    void setFullscreen(const bool newMode) {m_isFullscreen = newMode; emit fullscreenChanged();}

protected slots:
    Q_INVOKABLE void notifyAudioEnabledChanged();
    Q_INVOKABLE void notifyEffectEnabledChanged() {}
    Q_INVOKABLE void notifyFullscreenChanged() {}

protected:

signals:
    void audioEnabledChanged();
    void effectEnabledChanged();
    void fullscreenChanged();

private:
    bool m_isAudioEnabled;
    bool m_isEffectEnabled;
    bool m_isFullscreen;

    QString m_locale;

    KConfig m_config;
};

#endif // APPLICATIONSETTINGS_H
