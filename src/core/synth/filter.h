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
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef FILTER_H
#define FILTER_H

#include <qmath.h>
#include <QVector>

class FilterParameters {
public:
    unsigned int type, window_type, size, samplingRate, fftTimer;
    qreal freq1, freq2;
};

class Filter : public FilterParameters {
public:
    enum {FILTER_OFF, FILTER_LOWPASS, FILTER_HIGHPASS, FILTER_BANDSTOP,
          FILTER_BANDPASS};
    enum {WINDOW_RECT, WINDOW_HANNING, WINDOW_HAMMING, WINDOW_BLACKMAN};

    Filter(unsigned int _type, unsigned int _window_type, unsigned int _size,
           unsigned int _samplingRate, qreal _freq1, qreal _freq2 = 0);
    Filter(unsigned int _samplingRate, FilterParameters &filt);
    ~Filter();
    qreal * IR;
//    unsigned int type, window_type, size, samplingRate;
//    qreal freq1, freq2;

private:

};

#endif // FILTER_H
