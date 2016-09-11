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
        "imageName1": "A2.svg",
        "imageName2": "A1.svg",
        "coordinates": [[141,418],[154,387],[175,350],[185,323],[202,288],[219,254],[238,212],[259,173],[275,139],[290,106],[304,81],[322,51],[343,87],[361,117],[371,141],[382,167],[394,190],[409,219],[422,243],[438,278],[452,304],[464,325],[475,346],[491,375],[506,399],[521,417], [221,285],[246,285],[272,285],[304,285],[334,285],[364,285],[389,285],[411,285],[434,285]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("a"))
    },
    {
        "imageName1": "B2.svg",
        "imageName2": "B1.svg",
        "coordinates": [[190,59],[190,93],[190,126],[190,165],[190,212],[190,263],[190,308],[190,342],[190,375],[190,409],[223,77],[262,77],[300,78],[340,80],[384,91],[417,114],[433,154],[427,194],[388,226],[360,235],[328,242],[291,240],[262,235],[234,234],[223,234],[251,246],[288,248],[322,248],[358,249],[394,263],[427,291],[440,322],[441,357],[417,390],[375,406],[346,411],[307,413],[267,413],[244,413],[215,409]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("b"))
    },
    {
        "imageName1": "C2.svg",
        "imageName2": "C1.svg",
        "coordinates": [[475,160],[460,135],[431,110],[393,91],[358,86],[329,86],[295,93],[260,108],[224,136],[202,166],[187,211],[188,249],[197,282],[215,314],[238,340],[273,360],[318,372],[358,372],[401,362],[446,342],[467,315],[482,284]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("c"))
    },
    {
        "imageName1": "D2.svg",
        "imageName2": "D1.svg",
        "coordinates": [[150,37],[150,68],[150,102],[150,143],[150,190],[150,237],[150,275],[150,317],[150,353],[150,380],[186,43],[224,48],[259,50],[295,51],[332,55],[368,60],[413,70],[448,88],[474,114],[496,144],[511,190],[515,238],[507,285],[477,326],[438,355],[386,371],[347,376],[300,379],[259,379],[230,379],[197,377]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("d"))
    },
    {
        "imageName1": "E2.svg",
        "imageName2": "E1.svg",
        "coordinates": [[161,62],[161,95],[161,133],[161,175],[161,216],[161,256],[161,296],[161,336],[161,377],[186,78],[212,78],[242,78],[274,78],[304,78],[335,78],[368,78],[405,78],[186,220],[217,220],[253,220],[289,220],[322,220],[353,220],[390,220],[193,366],[222,366],[252,366],[285,366],[313,366],[346,366],[377,366],[408,366]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("e"))
    },
    {
        "imageName1": "F2.svg",
        "imageName2": "F1.svg",
        "coordinates": [[176,81],[176,107],[176,140],[176,180],[176,215],[176,256],[176,304],[176,339],[176,379],[176,415],[201,96],[230,96],[257,96],[291,96],[318,96],[343,96],[373,96],[411,96],[204,249],[227,249],[256,249],[292,249],[324,249],[357,249],[391,249]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("f"))
    },
    {
        "imageName1": "G2.svg",
        "imageName2": "G1.svg",
        "coordinates": [[446,147],[434,124],[411,97],[383,82],[347,70],[317,66],[275,73],[242,86],[208,107],[183,136],[164,172],[161,206],[165,256],[179,297],[206,328],[238,350],[282,366],[320,369],[362,366],[397,355],[428,344],[456,315],[455,288],[455,262],[455,234],[423,235],[395,235],[369,235],[339,235]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("g"))
    },
    {
        "imageName1": "H2.svg",
        "imageName2": "H1.svg",
        "coordinates": [[165,71],[165,107],[165,160],[165,194],[165,235],[165,267],[165,310],[165,344],[165,379],[165,400],[182,228],[206,230],[240,230],[268,230],[296,230],[325,230],[350,230],[379,230],[404,230],[416,75],[416,104],[416,136],[416,169],[416,213],[416,262],[416,299],[416,340],[416,368],[416,393]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("h"))
    },
    {
        "imageName1": "I2.svg",
        "imageName2": "I1.svg",
        "coordinates": [[248,78],[248,106],[248,148],[248,184],[248,220],[248,251],[248,282],[248,320],[248,357],[248,391],[248,409]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("i"))
    },
    {
        "imageName1": "J2.svg",
        "imageName2": "J1.svg",
        "coordinates": [[369,71],[369,102],[369,136],[369,179],[369,224],[369,270],[369,306],[368,346],[348,375],[311,391],[277,394],[241,384],[213,348],[205,321]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("j"))
    },
    {
        "imageName1": "K2.svg",
        "imageName2": "K1.svg",
        "coordinates": [[160,64],[160,102],[160,146],[160,190],[160,240],[160,281],[160,325],[160,366],[160,402],[160,402],[160,437],[186,273],[224,246],[257,219],[285,195],[315,169],[346,144],[375,124],[411,95],[444,68],[286,224],[310,257],[333,289],[366,318],[387,348],[411,373],[434,406],[459,434]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("k"))
    },
    {
        "imageName1": "L2.svg",
        "imageName2": "L1.svg",
        "coordinates": [[177,64],[177,110],[177,158],[177,206],[177,264],[177,315],[177,365],[177,406],[177,420],[211,420],[245,420],[286,420],[326,420],[361,420],[404,420],[455,420],[488,420],[522,420]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("l"))
    },
    {
        "imageName1": "M2.svg",
        "imageName2": "M1.svg",
        "coordinates": [[144,413],[144,377],[144,337],[144,297],[144,263],[144,227],[144,194],[144,148],[144,106],[144,73],[186,103],[198,137],[211,175],[222,204],[234,234],[249,263],[259,291],[274,325],[286,360],[302,393],[311,413],[325,379],[339,344],[354,311],[364,280],[376,246],[387,217],[401,184],[413,150],[426,115],[446,82],[462,114],[462,142],[462,171],[462,201],[462,233],[462,266],[462,306],[462,340],[462,372],[462,405]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("m"))
    },
    {
        "imageName1": "N2.svg",
        "imageName2": "N1.svg",
        "coordinates": [[216,351],[216,324],[216,299],[216,277],[216,254],[216,230],[216,201],[216,170],[216,147],[216,121],[216,102],[216,71],[236,93],[249,105],[264,125],[280,143],[293,160],[310,176],[325,198],[343,218],[357,235],[375,262],[398,287],[420,309],[440,324],[461,343],[461,318],[461,293],[461,271],[461,242],[461,220],[461,195],[461,169],[461,138],[461,112],[461,90],[461,65]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("n"))
    },
    {
        "imageName1": "O2.svg",
        "imageName2": "O1.svg",
        "coordinates":  [[291,71],[326,77],[360,89],[393,108],[417,132],[440,168],[452,209],[457,251],[453,302],[441,335],[426,369],[394,394],[357,415],[322,430],[284,430],[246,424],[215,411],[184,394],[160,364],[140,331],[125,292],[118,246],[131,195],[144,155],[165,122],[193,96],[228,78],[270,66]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("o"))
    },
    {
        "imageName1": "P2.svg",
        "imageName2": "P1.svg",
        "coordinates":  [[154,56],[154,99],[154,132],[154,172],[154,212],[154,273],[154,324],[154,361],[154,400],[154,435],[169,73],[212,73],[248,74],[286,74],[324,78],[371,81],[420,96],[457,121],[477,161],[480,209],[455,249],[412,267],[380,273],[344,277],[308,277],[271,278],[235,275],[208,277],[184,277]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("p"))
    },
    {
        "imageName1": "Q2.svg",
        "imageName2": "Q1.svg",
        "coordinates": [[321,107],[358,108],[393,122],[430,153],[456,193],[464,233],[466,270],[455,308],[423,347],[390,368],[346,382],[297,382],[260,376],[222,360],[193,332],[175,303],[161,270],[160,226],[172,188],[195,148],[233,120],[271,107],[299,99],[329,324],[360,337],[390,350],[413,366],[444,383],[473,397],[492,406]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("q"))
    },
    {
        "imageName1": "R2.svg",
        "imageName2": "R1.svg",
        "coordinates": [[143,86],[146,120],[146,160],[146,202],[146,246],[146,300],[146,344],[146,391],[146,428],[177,99],[212,100],[246,100],[286,100],[329,100],[377,118],[415,147],[428,191],[412,238],[364,256],[311,266],[268,266],[228,263],[202,259],[177,260],[202,277],[234,275],[273,280],[308,292],[339,322],[368,351],[387,379],[415,405],[437,428]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("r"))
    },
    {
        "imageName1": "S2.svg",
        "imageName2": "S1.svg",
        "coordinates": [[448,175],[434,148],[404,125],[366,110],[320,103],[277,104],[245,117],[202,132],[179,162],[176,200],[204,223],[248,237],[281,246],[325,253],[382,264],[423,277],[452,304],[456,343],[423,371],[382,388],[329,394],[284,390],[240,383],[205,368],[171,346],[148,307]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("s"))
    },
    {
        "imageName1": "T2.svg",
        "imageName2": "T1.svg",
        "coordinates": [[81,85],[113,85],[150,85],[194,85],[233,85],[271,85],[313,85],[350,85],[394,85],[434,85],[474,85],[514,85],[304,111],[304,153],[304,186],[304,222],[304,262],[304,303],[304,344],[304,384],[304,424]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("t"))
    },
    {
        "imageName1": "U2.svg",
        "imageName2": "U1.svg",
        "coordinates": [[151,77],[151,118],[151,160],[151,195],[151,234],[151,275],[151,311],[171,351],[198,380],[242,400],[278,404],[320,402],[360,388],[395,369],[423,329],[430,284],[430,237],[430,201],[430,168],[430,136],[430,104],[430,78]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("u"))
    },
    {
        "imageName1": "V2.svg",
        "imageName2": "V1.svg",
        "coordinates": [[188,110],[198,134],[205,156],[214,183],[224,207],[230,228],[239,254],[249,277],[260,303],[272,335],[284,359],[298,387],[315,352],[325,321],[341,280],[356,242],[367,212],[382,173],[395,143],[405,111]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("v"))
    },
    {
        "imageName1": "W2.svg",
        "imageName2": "W1.svg",
        "coordinates": [[154,69],[159,92],[168,113],[175,143],[182,165],[187,187],[190,208],[197,231],[203,252],[210,278],[215,303],[220,329],[231,350],[243,320],[254,290],[261,266],[266,245],[273,222],[278,201],[283,178],[292,155],[297,133],[304,106],[318,75],[329,99],[336,122],[343,143],[348,165],[357,187],[362,210],[371,240],[380,269],[388,292],[397,318],[408,348],[418,318],[425,294],[434,264],[439,236],[450,201],[457,173],[465,138],[474,106],[480,82],[486,60]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("w"))
    },
    {
        "imageName1": "X2.svg",
        "imageName2": "X1.svg",
        "coordinates": [[173,93],[191,115],[206,140],[224,161],[244,184],[267,212],[295,240],[313,267],[333,295],[355,321],[379,348],[400,373],[423,400],[424,92],[404,125],[380,153],[357,180],[332,211],[311,235],[277,275],[252,303],[226,333],[204,358],[186,379],[161,408]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("x"))
    },
    {
        "imageName1": "Y2.svg",
        "imageName2": "Y1.svg",
        "coordinates": [[165,91],[180,122],[200,154],[219,183],[235,213],[260,253],[285,292],[308,267],[331,234],[343,211],[360,186],[375,158],[388,136],[411,99],[289,303],[289,339],[289,371],[289,395],[289,420],[289,446]],
        "coordinates2": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("y"))
    },
    {
        "imageName1": "Z2.svg",
        "imageName2": "Z1.svg",
        "coordinates": [[180,106],[219,106],[252,106],[289,106],[328,106],[368,106],[413,106],[455,106],[427,139],[398,166],[375,188],[350,211],[321,234],[286,263],[256,292],[217,318],[177,344],[217,342],[253,344],[289,344],[320,344],[357,344],[394,344],[431,344],[475,344]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("z"))
    }
    ]
}
