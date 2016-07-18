
/* GCompris - drawletters_dataset.js
* Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>

* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

function get() {
    return [
    {
        "imageName1": "D2.svg",
        "imageName2": "D1.svg",
        "coordinates": [[134,43],[178,43],[217,42],[271,43],[322,43],[372,51],[411,67],[451,100],[468,135],[478,169],[484,214],[477,262],[458,302],[426,334],[379,351],[328,366],[262,369],[211,369],[169,363],[134,362],[134,310],[138,258],[138,220],[137,172],[138,119],[135,80],[134,43]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("d"))
    },
    {
        "imageName1": "C2.svg",
        "imageName2": "C1.svg",
        "coordinates":   [[413,127],[381,83],[335,61],[284,54],[240,58],[194,74],[160,97],[138,128],[128,170],[125,202],[137,254],[156,293],[199,318],[245,332],[287,334],[327,329],[372,310],[399,278],[421,245]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("c"))
    },
    {
        "imageName1": "L2.svg",
        "imageName2": "L1.svg",
        "coordinates": [[176,35],[176,67],[176,105],[176,153],[176,199],[173,236],[176,272],[176,312],[176,345],[176,379],[198,394],[237,394],[275,394],[310,394],[341,394],[382,394],[421,394],[462,394],[502,394]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("l"))
    },
    {
        "imageName1": "A2.svg",
        "imageName2": "A1.svg",
        "coordinates": [[147,394],[172,350],[197,299],[221,245],[259,169],[296,94],[337,39],[367,91],[397,151],[429,214],[462,278],[496,338],[521,394],[430,271],[362,270],[305,265],[246,264],[216,312],[194,351],[153,394]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("a"))
    },
    {
        "imageName1": "O2.svg",
        "imageName2": "O1.svg",
        "coordinates":  [[294,51],[316,54],[345,58],[378,72],[416,96],[430,119],[445,145],[451,178],[458,205],[458,237],[452,281],[443,313],[417,350],[386,375],[356,389],[316,398],[289,402],[251,391],[211,376],[178,353],[156,322],[138,291],[132,233],[135,179],[150,135],[175,99],[205,78],[242,59],[294,51]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("o"))
    },
    {
        "imageName1": "P2.svg",
        "imageName2": "P1.svg",
        "coordinates":  [[129,414],[129,379],[129,335],[129,283],[129,227],[129,176],[129,125],[129,83],[129,48],[159,39],[197,42],[239,42],[284,42],[335,42],[385,58],[427,81],[452,110],[464,141],[462,183],[435,224],[392,240],[340,252],[296,255],[248,254],[211,254],[173,249],[150,249]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("p"))
    },
    {
        "imageName1": "M2.svg",
        "imageName2": "M1.svg",
        "coordinates": [[129,392],[128,357],[129,328],[129,297],[129,259],[129,220],[129,182],[129,145],[129,115],[132,84],[147,64],[172,96],[186,125],[195,151],[205,176],[217,208],[229,236],[242,270],[255,305],[268,343],[290,375],[313,341],[325,313],[337,278],[348,249],[362,214],[378,178],[394,137],[411,102],[437,70],[442,103],[445,154],[445,195],[445,226],[443,262],[443,300],[443,332],[445,366],[445,392]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("m"))
    },
    {
        "imageName1": "N2.svg",
        "imageName2": "N1.svg",
        "coordinates": [[216,351],[216,324],[216,299],[216,277],[216,254],[216,230],[216,201],[216,170],[216,147],[216,121],[216,102],[216,71],[236,93],[249,105],[264,125],[280,143],[293,160],[310,176],[325,198],[343,218],[357,235],[375,262],[398,287],[420,309],[440,324],[461,343],[461,318],[461,293],[461,271],[461,242],[461,220],[461,195],[461,169],[461,138],[461,112],[461,90],[461,65]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("n"))
    },
    {
        "imageName1": "R2.svg",
        "imageName2": "R1.svg",
        "coordinates": [[169,392],[169,366],[169,331],[169,287],[169,254],[169,217],[169,183],[169,154],[169,115],[169,82],[169,52],[201,49],[241,47],[276,47],[308,49],[341,49],[380,52],[404,64],[432,78],[451,112],[455,159],[439,189],[399,208],[357,222],[318,225],[283,224],[250,224],[229,224],[206,222],[225,245],[259,245],[285,247],[325,254],[353,276],[376,304],[394,324],[413,345],[427,362],[441,378],[455,394]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("r"))
    },
    {
        "imageName1": "W2.svg",
        "imageName2": "W1.svg",
        "coordinates": [[154,69],[159,92],[168,113],[175,143],[182,165],[187,187],[190,208],[197,231],[203,252],[210,278],[215,303],[220,329],[231,350],[243,320],[254,290],[261,266],[266,245],[273,222],[278,201],[283,178],[292,155],[297,133],[304,106],[318,75],[329,99],[336,122],[343,143],[348,165],[357,187],[362,210],[371,240],[380,269],[388,292],[397,318],[408,348],[418,318],[425,294],[434,264],[439,236],[450,201],[457,173],[465,138],[474,106],[480,82],[486,60]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("w"))
    },
    {
        "imageName1": "S2.svg",
        "imageName2": "S1.svg",
        "coordinates": [[442,138],[424,100],[379,71],[334,65],[293,61],[252,65],[214,78],[173,106],[167,144],[201,173],[258,194],[309,205],[372,216],[427,236],[456,275],[442,313],[399,340],[354,348],[294,353],[246,340],[195,324],[166,300],[143,264]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("s"))
    },
    {
        "imageName1": "Z2.svg",
        "imageName2": "Z1.svg",
        "coordinates": [[182,77],[206,77],[231,77],[255,77],[280,77],[304,77],[332,77],[359,77],[387,77],[418,77],[443,77],[480,77],[508,77],[487,101],[464,124],[436,141],[420,159],[395,173],[374,187],[346,215],[320,231],[296,254],[266,275],[243,290],[213,309],[196,324],[167,352],[190,350],[210,350],[232,350],[254,350],[282,350],[310,350],[331,350],[357,350],[376,350],[397,350],[420,350],[444,350],[474,350],[497,350],[530,350]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("z"))
    },
    {
        "imageName1": "U2.svg",
        "imageName2": "U1.svg",
        "coordinates":[[172,54],[172,90],[169,121],[169,156],[170,188],[169,224],[172,256],[175,287],[186,319],[211,345],[240,363],[271,373],[300,376],[327,375],[356,367],[389,363],[416,347],[435,325],[445,294],[449,267],[449,221],[449,186],[448,157],[448,131],[448,99],[448,74],[448,47]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("u"))
    }
    ]
}
