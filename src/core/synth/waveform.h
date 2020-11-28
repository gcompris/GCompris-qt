/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#ifndef WAVEFORM_H
#define WAVEFORM_H

#include <qmath.h>
#include <math.h>

// The Waveform class implements the necessary code for the generation of the
// basic waveforms. The waveform is computed at the constructor stage and
// assembled into a wavetable, which is evaluated with the eval(qreal t)
// function.

class Waveform  {
public:
    explicit Waveform(unsigned int mode, unsigned int size=4096);
    ~Waveform();    

    qreal eval(qreal t);

    enum {MODE_SIN, MODE_SAW, MODE_SQU, MODE_SAW2};
private:
    qreal waveSin (qreal t);
    qreal waveSaw (qreal t);
    qreal waveSqu (qreal t);
    qreal waveSaw2(qreal t);

    qreal *waveTable;
    unsigned int tableSize;
    
public:
    unsigned int mode;
};

#endif // WAVEFORM_H
