/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#ifndef MODULATION_H
#define MODULATION_H

#include <qmath.h>
#include "waveform.h"

class Modulation {
public:
    Modulation();
    ~Modulation() = default;

    qreal FM_freq, FM_ampl;
    qreal AM_freq, AM_ampl, AM_time;
    unsigned int mode;

    bool propFreq, useEnvelope;
};

#endif // MODULATION_H
