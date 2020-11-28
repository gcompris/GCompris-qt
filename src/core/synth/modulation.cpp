/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "modulation.h"
#include "waveform.h"

Modulation::Modulation() : FM_freq(0.f), FM_ampl(0.f),
                           AM_freq(0.f), AM_ampl(0.f), AM_time(0.2f),
                           mode(Waveform::MODE_SIN),
                           propFreq(false), useEnvelope(false) {
}
