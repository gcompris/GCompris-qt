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
#include "generator.h"

#include <QDebug>
#if QT_VERSION > QT_VERSION_CHECK(6, 0, 0)
#include <QMediaDevices>
#include <QAudioDevice>
#else
#include <QAudioDeviceInfo>
#endif

GSynth *GSynth::m_instance = nullptr;

GSynth::GSynth(QObject *parent) : QObject(parent)
{
    static const int bufferSize = 8192;

    m_format.setSampleRate(22050);
    m_format.setChannelCount(1);
#if QT_VERSION > QT_VERSION_CHECK(6, 0, 0)
    m_format.setSampleFormat(QAudioFormat::Int16);
    //? m_format.setCodec("audio/pcm");
    //? m_format.setByteOrder(QAudioFormat::LittleEndian);
#else
    m_format.setSampleSize(16);
    m_format.setCodec("audio/pcm");
    m_format.setByteOrder(QAudioFormat::LittleEndian);
    m_format.setSampleType(QAudioFormat::SignedInt);
#endif

#if QT_VERSION > QT_VERSION_CHECK(6, 0, 0)
    QAudioDevice defaultDevice(QMediaDevices::defaultAudioOutput());
    if (!defaultDevice.isFormatSupported(m_format)) {
        qWarning() << "Default format not supported - trying to use nearest";
        //? m_format = defaultDevice.nearestFormat(m_format);
    }
    m_audioOutput = new QAudioOutput(QMediaDevices::defaultAudioOutput(), this);
    //? set format?? m_audioOutput = new QAudioOutput(QMediaDevices::defaultAudioOutput(), m_format, this);
#else
    QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());
    if (!info.isFormatSupported(m_format)) {
        qWarning() << "Default format not supported - trying to use nearest";
        m_format = info.nearestFormat(m_format);
    }
    m_audioOutput = new QAudioOutput(QAudioDeviceInfo::defaultOutputDevice(), m_format, this);
#endif

    m_buffer = QByteArray(bufferSize, 0);
    //? m_audioOutput->setBufferSize(bufferSize);
    m_generator   = new Generator(m_format, this);
    // todo Only start generator if musical activity, and stop it on exit (in main.qml, activity.isMusicalActivity)
    m_generator->setPreset(PresetCustom);
    m_generator->start();
    //? m_audioOutput->start(m_generator);
    m_audioOutput->setVolume(1);
}

GSynth::~GSynth() {
    //? m_audioOutput->stop();
    m_generator->stop();
    delete m_audioOutput;
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

QObject *GSynth::synthProvider(QQmlEngine *engine,
                               QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    GSynth* synth = getInstance();
    return synth;
}
