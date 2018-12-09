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
