/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#ifndef GENERATOR_H
#define GENERATOR_H

#include <QAudioDeviceInfo>
#include <QAudioOutput>
#include <QByteArray>
#include <QIODevice>

#include <QMutex>
#include <QList>

#include "modulation.h"
#include "ADSRenvelope.h"

class Preset;
class LinearSynthesis;

// The state of each active note is described with an Wave object. Wave
// objects are assembled into the QList<Wave> waveList and removed once
// they reach the state STATE_OFF.

class Wave {
public:
    enum {STATE_OFF, STATE_ATTACK, STATE_DECAY, STATE_RELEASE};
    unsigned char note, vel, state;
    qreal state_age, age;
    ADSREnvelope env;
};

// The synthesizer is implemented as a QIODevice and is connected to
// a QAudioOutput in mainWindow.cpp. QAudioOutput reads data from the
// synthersizer using the function readData(data, size). readData
// returns maximum of 2048 samples generated with generateData(len).

class Generator : public QIODevice {
    Q_OBJECT
public:
    explicit Generator(const QAudioFormat &_format, QObject *parent = nullptr);
    ~Generator();

    void start    ();
    void stop     ();
    void setState ();

    void addWave (unsigned char note, unsigned char vel);

    qint64 readData(char *data, qint64 len) override;
    qint64 writeData(const char *data, qint64 len) override;
    qint64 bytesAvailable() const override;

    void generateData(qint64 len);

public Q_SLOTS:
    void noteOn   (unsigned char chan, unsigned char note, unsigned char vel);
    void noteOff  (unsigned char chan, unsigned char note);

    // Slots for manipulation of the current patch.
    void setMode      (unsigned int _mode);
    void setTimbre    (QVector<int> &amplitudes, QVector<int> &phases);
    void setEnvelope  (const ADSREnvelope &env);
    void setModulation(Modulation &modulation);
    void setPreset    (Preset &preset);
    
private:
    QAudioFormat format;
    QByteArray m_buffer;

    // State of the synthesizer
    qreal curtime;
    QList<Wave> waveList;

    // Parameters of the current patch
    LinearSynthesis *linSyn;
    ADSREnvelope     defaultEnv;
    Modulation       mod;
    Waveform        *mod_waveform;

    static const int m_samplingRate = 22050;
    static const int maxUsedBytes = 2048;
    
    qreal *synthData;
    
    QMutex m_lock;
};

#endif // GENERATOR_H
