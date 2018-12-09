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


#include "ADSRenvelope.h"
//#include <QDebug>

ADSREnvelope::ADSREnvelope() : ADSREnvelope(0, 0, 0, 0.f, 0.f, 0.f) {
}

ADSREnvelope::ADSREnvelope(unsigned int _attackTime,
                           unsigned int _decayTime,
                           unsigned int _releaseTime,
                           qreal _initialAmpl,
                           qreal _peakAmpl,
                           qreal _sustainAmpl) : initialAmpl(_initialAmpl),
                                                 peakAmpl(_peakAmpl),
                                                 sustainAmpl(_sustainAmpl),
                                                 attackTime(_attackTime),
                                                 decayTime(_decayTime),
                                                 releaseTime(_releaseTime) {
}

qreal
ADSREnvelope::eval(qreal t, unsigned char state) const {
    qreal attackTimeF  = ((qreal)attackTime)/1000;
    qreal decayTimeF   = ((qreal)decayTime)/1000;
    qreal releaseTimeF = ((qreal)releaseTime)/1000;

    switch (state) {
    case STATE_ATTACK:
        if (t < attackTimeF) {
            return initialAmpl*(attackTimeF - t)/attackTimeF +  peakAmpl*t/attackTimeF;
        } else {
            //qWarning() << "ADSREnvelope::eval - attack outside range";
            return peakAmpl;
        }
        break;
    case STATE_DECAY:
        if (t < decayTimeF) {
            return peakAmpl*(decayTimeF-t)/decayTimeF + sustainAmpl*t/decayTimeF;
        } else {
            return sustainAmpl;
        }
        break;
    case STATE_RELEASE:
        if (t < releaseTimeF) {
            return sustainAmpl*(1 - t/releaseTimeF);
        } else {
            //qWarning() << "ADSREnvelope::eval - release outside range";
            return 0;
        }
        break;
    }

    //qWarning() << "ADSREnvelope::eval - invalid state";
    return 0;
}
