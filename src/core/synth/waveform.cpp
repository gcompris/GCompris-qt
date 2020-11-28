/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "waveform.h"
#include <QCoreApplication>
#include <QDebug>

Waveform::Waveform(unsigned int mode, unsigned int size) {
    waveTable = new qreal[size];
    tableSize = size;
    this->mode = mode;

    for (unsigned int sample = 0; sample < tableSize; sample++) {
        qreal u = (2*M_PI * (qreal)sample) / ((qreal)tableSize);

        switch(mode) {
        case MODE_SIN:
            waveTable[sample] = waveSin(u);
            break;
        case MODE_SAW:
            waveTable[sample] = waveSaw(u);
            break;
        case MODE_SAW2:
            waveTable[sample] = waveSaw2(u);
            break;
        case MODE_SQU:
            waveTable[sample] = waveSqu(u);
            break;
        }
    }
}

Waveform::~Waveform() {
    delete [] waveTable;
    waveTable = nullptr;
}

qreal
Waveform::waveSin(qreal t) {
    return qSin(t);
}

qreal
Waveform::waveSaw(qreal t) {
    qreal tmod = (qreal)(fmod((double)t, 2*M_PI) - M_PI);
    return tmod / M_PI;
}

qreal
Waveform::waveSaw2(qreal t) {
    qreal tmod = (qreal)(fmod((double)t, 2*M_PI) - M_PI);
    return 1 - 2 * qAbs(tmod) / M_PI;
}

qreal
Waveform::waveSqu(qreal t) {
    qreal tmod = (qreal)fmod((double)t, 2*M_PI);
    if (tmod < M_PI) {
        return 1;
    }
    return -1;
}


qreal
Waveform::eval(qreal t) {
    qreal tmod = fmod((double)t, 2*M_PI);
    if (tmod < 0) tmod += 2*M_PI;

    // Position indexed by a continuous variable does not generally fall on
    // integer-valued points. Here indF is the "continuous-valued position"
    // of the argument and is somewhere between the integers qFloor(indF) and
    // qCeil(indF). When indF is not an integer, we use linear interpolation
    // to obtain the appropriate value.

    qreal indF = ((qreal)tableSize) * tmod / (2*(qreal)M_PI);
    if (indF == (qreal)tableSize) indF = 0;

    Q_ASSERT(indF >= 0);
    Q_ASSERT(indF < (qreal)tableSize);

    unsigned int ind_min = (unsigned int) qFloor(indF);
    unsigned int ind_max = (unsigned int) qCeil(indF);

    Q_ASSERT(ind_min <= ind_max);
    Q_ASSERT(ind_max <= tableSize);
    Q_ASSERT(ind_min < tableSize);

    qreal indmod = indF - (qreal)ind_min;
    Q_ASSERT(indmod < 1 && indmod >= 0);

    qreal value_next;
    qreal value_prev;

    if (ind_min == ind_max) {
        return waveTable[ind_min];
    }
    if (ind_max == tableSize) {
        value_prev = waveTable[ind_min];
        value_next = waveTable[0];
        return indmod * value_next + (1-indmod) * value_prev;
    }
    if (ind_min < ind_max) {
        Q_ASSERT(ind_max < tableSize);
        value_prev = waveTable[ind_min];
        value_next = waveTable[ind_max];
        return indmod * value_next + (1-indmod) * value_prev;
    }
    // This shouldn't be reached;
    qCritical("Wave Table Interpolation Failed");
    QCoreApplication::exit(-1);
    return 0;
}
