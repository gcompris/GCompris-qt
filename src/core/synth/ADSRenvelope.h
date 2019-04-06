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

#ifndef ADSRENVELOPE_H
#define ADSRENVELOPE_H

#include <qmath.h>

class ADSREnvelope {
public:
    ADSREnvelope();
    ADSREnvelope(unsigned int _attackTime,
                 unsigned int _decayTime,
                 unsigned int _releaseTime,
                 qreal _initialAmpl,
                 qreal _peakAmpl,
                 qreal _sustainAmpl);
    ~ADSREnvelope() = default;
    enum {STATE_OFF, STATE_ATTACK, STATE_DECAY, STATE_RELEASE};

    qreal initialAmpl, peakAmpl, sustainAmpl;
    unsigned int attackTime, decayTime, releaseTime;

    qreal eval(qreal t, unsigned char state) const;
private:
};

#endif // ADSRENVELOPE_H
