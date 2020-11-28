/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "preset.h"

Preset::Preset() : timbreAmplitudes(8, 0), timbrePhases(8, 0) {
//hardcode custom church pad preset
    waveformMode = Waveform::MODE_SIN;
    env.attackTime = 50;
    env.decayTime = 400;
    env.releaseTime = 100;

    env.initialAmpl = 0;
    env.peakAmpl = 1;
    env.sustainAmpl = 0.8;

    timbreAmplitudes[0] = 50;
    timbreAmplitudes[1] = 15;
    timbreAmplitudes[3] = 15;
    timbreAmplitudes[7] = 50;
    timbrePhases[0] = 0;
}
