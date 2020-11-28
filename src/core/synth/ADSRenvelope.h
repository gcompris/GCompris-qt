/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
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
