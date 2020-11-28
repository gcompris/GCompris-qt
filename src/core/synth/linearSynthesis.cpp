/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
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
    for (int harm = 0; harm < numHarmonics; harm++) {
        int qa_int = timbreAmplitudes[harm];
        int qp_int = timbrePhases[harm];

        if (qa_int > 0) {
            qreal qa = (qreal)qa_int/100;
            qreal qp = (2*M_PI*(qreal)qp_int)/360;

            val += qa * eval(((qreal)harm + 1) * t - qp);
        }
    }
    return val;
}
