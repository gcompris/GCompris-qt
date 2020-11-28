/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#ifndef LINEARSYNTHESIS_H
#define LINEARSYNTHESIS_H

#include "waveform.h"
#include <QVector>

class LinearSynthesis : public Waveform {
public:
    explicit LinearSynthesis(unsigned int mode, unsigned int size=4096);
    ~LinearSynthesis();

    qreal evalTimbre(qreal t);
    void setTimbre(QVector<int> &amplitudes, QVector<int> &phases);

private:
    int *timbreAmplitudes;
    int *timbrePhases;
    int numHarmonics;
};

#endif // LINEARSYNTHESIS_H
