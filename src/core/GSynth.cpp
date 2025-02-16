/* GCompris - GSynth.cpp
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "GSynth.h"
#include "synth/generator.h"

#include <QDebug>
#include <QQmlEngine>
#include <QMediaDevices>
#include <QAudioDevice>

GSynth *GSynth::m_instance = nullptr;

GSynth::GSynth(QObject *parent) : QObject(parent)
{
    static const int bufferSize = 8192;

    m_format.setSampleRate(22050);
    m_format.setChannelCount(1);
    m_format.setSampleFormat(QAudioFormat::Int16);

    QAudioDevice defaultDevice(QMediaDevices::defaultAudioOutput());
    if (!defaultDevice.isFormatSupported(m_format)) {
        qWarning() << "Default format not supported - sound will probably not play";
    }
    m_audioSink = new QAudioSink(QMediaDevices::defaultAudioOutput(), m_format, this);

    m_audioSink->setBufferSize(bufferSize);
    m_generator   = new Generator(m_format, this);
    // todo Only start generator if musical activity, and stop it on exit (in main.qml, activity.isMusicalActivity)
    m_generator->setPreset(PresetCustom);
    m_generator->start();

    // On Windows, since Qt6, the audio does not work (https://bugreports.qt.io/browse/QTBUG-108672)
    // periodically push to QAudioSink using a timer works, but seems slower,
    // so we keep the previous way of playing audio for all the other systems.
#if defined(Q_OS_WIN)
    m_pushTimer = new QTimer(this);

    auto io = m_audioSink->start();
    connect(m_pushTimer, &QTimer::timeout, [this, io]() {
        int len = m_audioSink->bytesFree();
        QByteArray buffer(len, 0);
        len = m_generator->read(buffer.data(), len);
        if(len) {
            io->write(buffer.data(), len);
        }
    });
    m_pushTimer->start(10);
#else
    m_audioSink->start(m_generator);
#endif
    m_audioSink->setVolume(1);
}

GSynth::~GSynth() {
#if defined(Q_OS_WIN)
    m_pushTimer->stop();
#endif
    m_audioSink->stop();
    m_generator->stop();
    delete m_generator;

    auto i = m_timers.constBegin();
    while (i != m_timers.constEnd()) {
        delete i.value();
        ++i;
    }
}

void GSynth::generate(int note, int duration) {
    //test part...
    m_generator->noteOn(1, note, 255);
    if(!m_timers.contains(note)) {
        m_timers[note] = new QTimer();
        connect(m_timers[note], &QTimer::timeout, this,
                [this, note]() {
                    stopAudio(note);
                });
    }
    m_timers[note]->start(duration);
}

void GSynth::stopAudio(int note) {
    m_generator->noteOff(1, note);
}

GSynth *GSynth::create(QQmlEngine *engine,
                       QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    GSynth* synth = getInstance();
    return synth;
}

#include "moc_GSynth.cpp"
