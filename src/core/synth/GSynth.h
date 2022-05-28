/* GCompris - GSynth.h
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef GSYNTH_H
#define GSYNTH_H

#include <QAudioOutput>
#include <QAudioFormat>
#include <QTimer>
#include <QQmlEngine>
#include "preset.h"

class Generator;

class GSynth : public QObject
{
    Q_OBJECT

public:
    explicit GSynth(QObject *parent = 0);
    virtual ~GSynth();

    /**
     * Generate a note and start the corresponding timer
     *  to stop it at "duration" ms.
     *
     * @param note note to play
     * @param duration how much time the note needs to be played
     */
    Q_INVOKABLE void generate(int note, int duration);

    static GSynth *getInstance() {
        if(!m_instance) {
            m_instance = new GSynth();
        }
        return m_instance;
    }
    static QObject *synthProvider(QQmlEngine *engine,
                                  QJSEngine *scriptEngine);

protected:
    static GSynth *m_instance;

private slots:
    void stopAudio(int note);
    
private:
    Generator        *m_generator;
    QAudioFormat      m_format;
    QByteArray        m_buffer;
    QAudioOutput     *m_audioOutput;
    QMap<int, QTimer *> m_timers;
    
    Preset PresetCustom;
};

#endif // GSYNTH_H
 
