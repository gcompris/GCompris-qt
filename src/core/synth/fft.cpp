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

#include "fft.h"

void
FFTCompute(std::complex<qreal> *data, unsigned int dataLength) {
    for (unsigned int pos= 0; pos < dataLength; pos++) {
        unsigned int mask = dataLength;
        unsigned int mirrormask = 1;
        unsigned int target = 0;

        while (mask != 1) {
            mask >>= 1;
            if (pos & mirrormask)
            target |= mask;
            mirrormask <<= 1;
        }
        if (target > pos) {
            std::complex<qreal> tmp = data[pos];
            data[pos] = data[target];
            data[target] = tmp;
        }
    }

    for (unsigned int step = 1; step < dataLength; step <<= 1) {
        const unsigned int jump = step << 1;
        const qreal delta = M_PI / qreal(step);
        const qreal sine = sin(delta * 0.5);
        const std::complex<qreal> mult (-2.*sine*sine, sin(delta));
        std::complex<qreal> factor(1.0, 0.0);

        for (unsigned int group = 0; group < step; ++group) {
            for (unsigned int pair = group; pair < dataLength; pair += jump) {
                const unsigned int match = pair + step;
                const std::complex<qreal> prod(factor * data[match]);
                data[match] = data[pair] - prod;
                data[pair] += prod;
            }
            factor = mult * factor + factor;
        }
    }
}
