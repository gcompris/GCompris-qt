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

#include "linearSynthesis.h"
#include <QDebug>

LinearSynthesis::LinearSynthesis(unsigned int mode, unsigned int size) :
    Waveform(mode, size) {

    numHarmonics = 16;

    timbreAmplitudes = new int[numHarmonics];
    timbrePhases     = new int[numHarmonics];

    timbreAmplitudes[0] = 100;
}

void
LinearSynthesis::setTimbre(QVector<int> &amplitudes, QVector<int> &phases) {
    Q_ASSERT(amplitudes.size() == phases.size());

    delete[] timbreAmplitudes;
    delete[] timbrePhases;

    numHarmonics = amplitudes.size();
    timbreAmplitudes = new int[numHarmonics];
    timbrePhases = new int[numHarmonics];
    for(int i = 0 ; i < numHarmonics ; ++ i) {
        timbreAmplitudes[i] = amplitudes[i];
        timbrePhases[i] = phases[i];
    }
}

LinearSynthesis::~LinearSynthesis() {
    delete[] timbreAmplitudes;
    delete[] timbrePhases;
}

qreal
LinearSynthesis::evalTimbre(qreal t) {
    qreal val = 0;
    for (unsigned int harm = 0; harm < numHarmonics; harm++) {
        int qa_int = timbreAmplitudes[harm],
            qp_int = timbrePhases[harm];

        if (qa_int > 0) {
            qreal qa = (qreal)qa_int/100,
                  qp = (2*M_PI*(qreal)qp_int)/360;

            val += qa * eval(((qreal)harm + 1) * t - qp);
        }
    }
    return val;
}
