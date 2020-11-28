/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#ifndef PRESET_H
#define PRESET_H

#include "ADSRenvelope.h"
#include "modulation.h"

#include <QVector>

class Preset {
public:
    Preset ();
    ~Preset() = default;

    QVector<int> timbreAmplitudes;
    QVector<int> timbrePhases;
    unsigned int waveformMode;

    ADSREnvelope     env;
    Modulation       mod;
};

#endif // PRESET_H
