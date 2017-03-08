/* GCompris - drawnumbers_dataset.js
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
        "imageName1": "background.svg",
        "imageName2": "zero1.svg",
        "coordinates": [[441,62],[400,50],[379,52],[351,59],[307,88],[281,121],[264,169],[259,209],[257,259],[268,307],[286,355],[322,388],[366,406],[416,408],[457,402],[502,375],[532,331],[546,289],[550,246],[544,205],[535,160],[514,111],[485,80]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("0"))
    },
    
    {
        "imageName1": "background.svg",
        "imageName2": "one1.svg",
        "coordinates": [[256,175],[289,157],[324,144],[361,124],[393,103],[420,80],[420,115],[420,151],[420,200],[420,246],[420,295],[420,337],[420,376],[420,412],[420,446]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("1"))
    },
    
    {
        "imageName1": "background.svg",
        "imageName2": "two1.svg",
        "coordinates": [[277,132],[289,96],[314,70],[354,49],[404,44],[452,49],[495,70],[525,108],[533,153],[503,198],[459,231],[420,264],[375,295],[337,315],[304,340],[268,372],[310,372],[339,372],[372,372],[401,372],[438,372],[473,372],[508,372],[546,372]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("2"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "three1.svg",
        "coordinates": [[266,128],[285,96],[317,70],[354,59],[395,53],[442,57],[480,75],[510,111],[507,157],[480,183],[444,194],[412,197],[369,212],[413,216],[448,220],[484,231],[514,256],[537,291],[533,329],[514,355],[482,373],[448,384],[405,383],[353,377],[308,357],[277,329],[255,295]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("3"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "four1.svg",
        "coordinates":[[440,31], [412,66],[387,97],[355,132],[331,166],[300,201],[268,240],[222,288],[273,288],[325,288],[362,288],[406,288],[445,288],[486,288],[517,288],
        [440,31],[440,86],[440,151],[440,212],[440,262],[440,310],[440,364],[440,401]],
        "coordinates2":[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("4"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "five1.svg",
        "coordinates": [[528,55],[480,55],[428,55],[383,55],[351,55],[315,55],[308,93],[302,122],[293,160],[285,188],[278,223],[302,226],[325,202],[358,184],[394,179],[435,190],[477,208],[511,234],[528,268],[525,313],[510,347],[481,377],[441,394],[401,402],[354,394],[311,372],[284,347],[267,308]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("5"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "six1.svg",
        "coordinates": [[522,125],[506,86],[480,66],[431,52],[388,51],[353,63],[318,88],[291,129],[277,172],[273,208],[275,251],[281,292],[295,333],[317,368],[351,387],[398,401],[446,395],[493,369],[518,315],[511,255],[482,215],[442,197],[400,193],[366,201],[337,219],[308,246]],        
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("6"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "seven1.svg",
        "coordinates": [[264,57],[307,57],[358,57],[406,57],[444,57],[491,57],[526,57],[561,57],[526,93],[497,125],[470,160],[448,188],[424,222],[397,273],[382,304],[366,346],[354,390]],        
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("7"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "eight1.svg",
        "coordinates": [[379,200],[331,172],[306,135],[310,91],[342,59],[377,42],[419,41],[463,52],[495,78],[513,121],[499,168],[471,198],[417,216],[371,223],[325,246],[297,281],[295,336],[303,364],[324,386],[353,400],[395,411],[445,408],[488,390],[521,354],[532,310],[526,267],[502,240],[474,226],[411,219]],        
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("8"))
    },
    {
        "imageName1": "background.svg",
        "imageName2": "nine1.svg",
        "coordinates": [[513,157],[489,106],[451,74],[405,62],[354,67],[318,89],[293,120],[275,172],[293,222],[326,252],[379,266],[431,259],[471,237],[488,205],[513,157],[521,198],[520,262],[511,304],[495,342],[462,375],[413,388],[362,386],[322,369],[302,348],[291,321]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("9"))
    }
    
    ]
}
