/* miniSynth - A Simple Software Synthesizer
   Copyright (C) 2015 Ville Räisänen <vsr at vsr.name>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include "generator.h"
#include "filter.h"
#include <qendian.h>
#include <QDebug>
#include <QFile>

Generator::Generator(const QAudioFormat &_format, QObject *parent) : QIODevice(parent) {
    format = _format;
    linSyn = new LinearSynthesis(Waveform::MODE_SIN);
    curtime = 0;

    defaultEnv.attackTime = 100;
    defaultEnv.decayTime = 400;
    defaultEnv.releaseTime = 100;

    defaultEnv.initialAmpl = 0;
    defaultEnv.peakAmpl = 1;
    defaultEnv.sustainAmpl = 0.8;

    fftTimer = 0;

    rev.delay = 8000;
    rev.active= false;
    rev.attenuation = 1;
    rev.samplingRate = 44100;

    mod_waveform = new Waveform(Waveform::MODE_SIN);

    delayBuffer_size = 44100*2;
    convBuffer_size = 8192;
    convBuffer      = new qreal[convBuffer_size];
    filtBuffer      = new qreal[convBuffer_size];
    delayBuffer     = new qreal[delayBuffer_size];

    delayBuffer_ind = 0;
    convBuffer_ind  = 0;

    for (unsigned int indconv = 0; indconv < convBuffer_size; indconv++) {
        convBuffer[indconv]  = 0;
        filtBuffer[indconv]  = 0;
    }
    for (unsigned int indconv = 0; indconv < delayBuffer_size; indconv++) {
        delayBuffer[indconv]  = 0;
    }

    filter      = 0;
    convImpulse = 0;

#ifdef USE_FFTW
    fftwIn  = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*convBuffer_size);
    fftwOut = (fftw_complex*) fftw_malloc(sizeof(fftw_complex)*convBuffer_size);
    fftwPlan= fftw_plan_dft_1d(convBuffer_size, fftwIn, fftwOut,
                                FFTW_FORWARD, FFTW_ESTIMATE);
#else
    fftLength = convBuffer_size;
    fftData = new std::complex<qreal>[fftLength];
#endif

    FilterParameters param;
    param.freq1 = param.freq2 = 0;
    param.samplingRate = 44100;
    param.size         = 128;
    param.type         = Filter::FILTER_OFF;
    param.window_type  = Filter::WINDOW_RECT;
    param.fftTimer     = 100;
    setFilter(param);
/*
    param.size         = 1000;
    setFilter(param);
    QFile file("rtest2.txt");
    if (!file.open(QIODevice::ReadOnly)) {
        exit(0);
    }
    QTextStream in(&file);

    int ind = 0;
    while (!in.atEnd()) {
        QString line = in.readLine();
        qDebug() << line.toDouble();
        convImpulse[ind++] = 20*line.toDouble();
        if (ind == convImpulse_size) break;
    }
*/
}

Generator::~Generator() {
    delete linSyn;
    delete [] convBuffer;
    delete [] convImpulse;

#ifdef USE_FFTW
    fftw_destroy_plan(fftwPlan);
    fftw_free(fftwIn);
    fftw_free(fftwOut);
#endif
}

void
Generator::start() {
    open(QIODevice::ReadOnly);
}

void
Generator::stop() {
    close();
}

void
Generator::addWave(unsigned char note, unsigned char vel) {
    Wave wav;
    wav.state = wav.STATE_ATTACK;
    wav.note  = note;
    wav.vel   = vel;
    wav.state_age = 0;
    wav.age      = 0;
    wav.env = defaultEnv;

    waveList.push_back(wav);
}

qint64
Generator::readData(char *data, qint64 len) {
    // QAudioOutput tends to ask large packets of data, which can lead to a
    // large delay between noteOn requests and the generation of audio. Thus,
    // in order to provide more responsive interface, the packet size is
    // limited to 2048 bytes ~ 1024 samples.
    //qDebug() << "generator readData";
    if (len > 2048) len = 2048;

    generateData(len);
    memcpy(data, m_buffer.constData(), len);
    curtime += (qreal)len/(44100*2);
    return len;
}

// Not used.
qint64
Generator::writeData(const char *data, qint64 len) {
    Q_UNUSED(data);
    Q_UNUSED(len);
    return 0;
}

// Doesn't seem to be called by QAudioOutput.
qint64
Generator::bytesAvailable() const {
    qDebug() << "bytesAvailable()";
    return m_buffer.size() + QIODevice::bytesAvailable();
}

void
Generator::noteOn(unsigned char chan, unsigned char note, unsigned char vel) {
    // Velocity of 255 is assumed since a "pleasant" relationship between the
    // velocity in the MIDI event and the parameters of the corresponding Wave
    // cannot be currently selected by the user.

    if (vel > 0) vel = 255;
    addWave(note, vel);
    Q_UNUSED(chan);
}

void
Generator::noteOff(unsigned char chan, unsigned char note) {
    QMutableListIterator<Wave> i(waveList);

    while (i.hasNext()) {
        Wave wav = i.next();
        if (wav.note == note && wav.state != Wave::STATE_RELEASE) {
            // To avoid discontinuity in the envelope, the initial value for
            // the release part of the envelope should be equal to current
            // value.

            wav.env.sustainAmpl = wav.env.eval(wav.state_age, wav.state);

            wav.state = Wave::STATE_RELEASE;
            wav.state_age = 0;
        }
        i.setValue(wav);
    }
    Q_UNUSED(chan);
}

void
Generator::setMode(int _mode) {
    delete linSyn;
    linSyn = new LinearSynthesis(_mode);
    curtime = 0;
}

void
Generator::setTimbre(QVector<int> &amplitudes, QVector<int> &phases) {
    linSyn->setTimbre(amplitudes, phases);
}

void
Generator::generateData(qint64 len) {
    //qDebug() << "generate data";
    unsigned int numSamples = len/2;
    m_buffer.resize(len);

    // Raw synthesized data is assembled into synthData. This data is then
    // filtered and assembled into filteredData.
    QVector<qreal> synthData    = QVector<qreal>(numSamples, 0),
                   filteredData = QVector<qreal>(numSamples, 0);

    // All samples for each active note in waveList are synthesized separately.
    QMutableListIterator<Wave> i(waveList);

    while (i.hasNext()) {
        Wave wav = i.next();
        qreal attackTime  = 0.001*(qreal)wav.env.attackTime,
//              decayTime   = 0.001*(qreal)wav.env.decayTime,
              releaseTime = 0.001*(qreal)wav.env.releaseTime;


        qreal freq = 8.175 * 0.5 * qPow(2, ((qreal)wav.note)/12);
        qreal ampl = 0.5*((qreal)wav.vel)/256;

        qreal stateAge = wav.state_age,
              wavAge   = wav.age;

        for (unsigned int sample = 0; sample < numSamples; sample++) {
            qreal t    = curtime   + (qreal)sample / 44100;
            qreal envt = stateAge  + (qreal)sample / 44100;
            qreal modt = wavAge    + (qreal)sample / 44100;

            // Handle timed change of state in the ADSR-envelopes ATTACK->DECAY
            // and RELEASE->OFF.
            switch(wav.state) {
            case ADSREnvelope::STATE_ATTACK:
                if (envt > attackTime) {
                    stateAge -= attackTime;
                    wav.state = ADSREnvelope::STATE_DECAY;
                    wav.state_age -= attackTime;
                    envt = stateAge  + (qreal)sample / 44100;
                }
                break;
            case ADSREnvelope::STATE_RELEASE:
                if (envt > releaseTime) {
                    stateAge = 0;
                    wav.state = ADSREnvelope::STATE_OFF;
                }
                break;
            }

            if (wav.state == ADSREnvelope::STATE_OFF) {
                i.remove();
            } else {
                qreal freqmod = 0, amod = 0;

                // Compute modulation waves.

                if (mod.FM_freq > 0) {
                    qreal envVal = mod.useEnvelope ? wav.env.eval(envt, wav.state) : 1;
                    if (mod.propFreq) {
                        freqmod = mod.FM_ampl
                                * envVal* mod_waveform->eval(2*M_PI*mod.FM_freq*freq*modt);
                    } else {
                        freqmod = mod.FM_ampl
                                * mod_waveform->eval(2*M_PI*mod.FM_freq*modt);
                    }
                }
                if (mod.AM_freq > 0) {
                    amod = (1 - qExp(-modt/mod.AM_time))*mod.AM_ampl * mod_waveform->eval(2*M_PI*mod.AM_freq*t);
                }

                // Evaluate the output wave for the current note and add to the
                // output obtained with other notes.

                qreal envVal = wav.env.eval(envt, wav.state);
                qreal newVal = envVal * (ampl + amod)
                             * 0.5 * linSyn->evalTimbre(2*M_PI*(freq+freqmod)*(modt+100));
                qreal oldVal = synthData[sample];

                synthData[sample] = newVal + oldVal;
            }
        }
        wav.age += (qreal)numSamples/44100;
        if (wav.state != ADSREnvelope::STATE_OFF) {
            wav.state_age += (qreal)numSamples/44100;
            i.setValue(wav);
        }
    }

    for (unsigned int sample = 0; sample < numSamples; sample++) {
        convBuffer[convBuffer_ind] = synthData[sample];
        filteredData[sample] = 0;

        for (unsigned int convind = 0; convind < convImpulse_size; convind ++) {            
            if (convImpulse[convind] != 0) {
                // The term convBuffer_size keeps the left side non-negative and avoids
                // negative results from the modulo operator.

                int bufind = (convBuffer_ind + convBuffer_size - convind) % convBuffer_size;

                filteredData[sample] += convImpulse[convind] * convBuffer[bufind];
            }
        }
        delayBuffer[delayBuffer_ind] = filteredData[sample];
        delayBuffer_ind = (delayBuffer_ind + 1) % delayBuffer_size;

        // Primitive Reverb algorith.
        if (rev.active) {
            qreal reverb = 0;
            unsigned int ind;
            unsigned int nsteps = delayBuffer_size / rev.delay;

            for (int delayInd = 0; delayInd < nsteps; delayInd ++) {
                ind = (delayBuffer_ind + delayBuffer_size - 1 - delayInd * 8000) % delayBuffer_size;
                reverb += delayBuffer[ind] * qExp(-delayInd*rev.attenuation);
            }
            convBuffer_ind = (convBuffer_ind + 1) % convBuffer_size;
            filtBuffer[convBuffer_ind] = reverb;//filteredData[sample];
            filteredData[sample] = reverb;
        } else {
            filtBuffer[convBuffer_ind] = filteredData[sample];
            convBuffer_ind = (convBuffer_ind + 1) % convBuffer_size;
        }
    }
//    qDebug() << numSamples;
#ifdef USE_FFTW
    fftTimer += (qreal)numSamples / 44100;
//    qDebug() << fftTimer;
   // if (numSamples > 1023) {
    if (fftTimer > 0.001*filter->fftTimer) {
      //  qDebug () << filter->fftTimer;
        fftTimer = 0;
        for (unsigned int convind = 0; convind < convBuffer_size; convind++) {
            fftwIn[convind][0] = convBuffer[convind];
            fftwIn[convind][1] = 0;
        }
        fftw_execute(fftwPlan);
        emit fftUpdate(fftwOut, convBuffer_size, 0);
        for (unsigned int convind = 0; convind < convBuffer_size; convind++) {
            fftwIn[convind][0] = filtBuffer[convind];
            fftwIn[convind][1] = 0;
        }
        fftw_execute(fftwPlan);
        emit fftUpdate(fftwOut, convBuffer_size, 1);
        for (unsigned int convind = 0; convind < convBuffer_size; convind++) {
            fftwIn[convind][0] = 0;
            fftwIn[convind][1] = 0;
        }
    }
#else
    fftTimer += (qreal)numSamples / 44100;
    if (fftTimer > 0.001*filter->fftTimer) {
        fftTimer = 0;
        for (unsigned int convind = 0; convind < convBuffer_size; convind++) {
            std::complex <qreal> v(convBuffer[convind], 0);
            fftData[convind] = v;
        }
        FFTCompute(fftData, fftLength);
        emit fftUpdate(fftData, convBuffer_size, 0);
        for (unsigned int convind = 0; convind < convBuffer_size; convind++) {
            std::complex <qreal> v(filtBuffer[convind], 0);
            fftData[convind] = v;
        }
        FFTCompute(fftData, fftLength);
        emit fftUpdate(fftData, convBuffer_size, 1);
    }
#endif

    // Convert data from qreal to qint16.

    const int channelBytes = format.sampleSize() / 8;
    unsigned char *ptr = reinterpret_cast<unsigned char *>(m_buffer.data());

    for (unsigned int sample = 0; sample < numSamples; sample++) {
        if (filteredData[sample] > 1)  filteredData[sample] = 1;
        if (filteredData[sample] < -1) filteredData[sample] = -1;
        qint16 value = static_cast<qint16>(filteredData[sample] * 32767);
        qToLittleEndian<qint16>(value, ptr);
        ptr += channelBytes;
    }
}

void
Generator::setEnvelope(ADSREnvelope &_env) {
    defaultEnv = _env;
}

void
Generator::setModulation(Modulation &modulation) {
    if (modulation.mode != mod_waveform->mode) {
        delete mod_waveform;
        mod_waveform = new Waveform(modulation.mode);
    }
    mod = modulation;
}

void
Generator::setFilter(FilterParameters &filtParam) {
    if (filter)      delete filter;
    if (convImpulse) delete [] convImpulse;

    filter = new Filter(filtParam.type, filtParam.window_type, filtParam.size,
                        44100, filtParam.freq1, filtParam.freq2);
    filter->fftTimer = filtParam.fftTimer;
    convImpulse_size = filter->size;
    convImpulse      = new qreal[convImpulse_size];
    for (unsigned int ind = 0; ind < convImpulse_size; ind++) {
        convImpulse[ind] = filter->IR[ind];
    }
#ifdef USE_FFTW
    for (unsigned int convind = 0; convind < convImpulse_size; convind++) {
        fftwIn[convind][0] = 2*(convBuffer_size/(M_PI*M_PI))*convImpulse[convind];
        fftwIn[convind][1] = 0;
    }
    fftw_execute(fftwPlan);
    emit fftUpdate(fftwOut, convBuffer_size, 2);
#else
    for (unsigned int convind = 0; convind < convImpulse_size; convind++) {
        std::complex <qreal> v(2*(convBuffer_size/(M_PI*M_PI))*convImpulse[convind], 0);
        fftData[convind] = v;
    }
    for (unsigned int convind = convImpulse_size; convind < fftLength; convind++) {
        fftData[convind] = 0;
    }
    FFTCompute(fftData, fftLength);
    emit fftUpdate(fftData, convBuffer_size, 2);
#endif
    qDebug() << filtParam.fftTimer;
}

void
Generator::setReverb(Reverb &_rev) {
    qDebug() << "setReverb";
    rev = _rev;
}
