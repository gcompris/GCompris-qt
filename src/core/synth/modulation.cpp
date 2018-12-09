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
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "modulation.h"
#include "waveform.h"

Modulation::Modulation() : FM_freq(0.f), FM_ampl(0.f),
                           AM_freq(0.f), AM_ampl(0.f), AM_time(0.2f),
                           mode(Waveform::MODE_SIN),
                           propFreq(false), useEnvelope(false) {
}
