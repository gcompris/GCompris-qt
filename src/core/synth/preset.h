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

#ifndef PRESET_H
#define PRESET_H

#include "ADSRenvelope.h"
#include "linearSynthesis.h"
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
