/* GCompris - drawnumbers_dataset.js
* SPDX-FileCopyrightText: 2016 Nitish Chauhan <nitish.nc18@gmail.com>

* SPDX-License-Identifier: GPL-3.0-or-later
*/

.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

function get() {
    return [
    {
        "imageName1": "paper.svg",
        "imageName2": "zero.svg",
        "coordinates": [[341,62],[300,50],[279,52],[251,59],[207,88],[181,121],[164,169],[159,209],[157,259],[168,307],[186,355],[222,388],[266,406],[316,408],[357,402],[402,375],[432,331],[446,289],[450,246],[444,205],[435,160],[414,111],[385,80]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("0"))
    },
    
    {
        "imageName1": "paper.svg",
        "imageName2": "one.svg",
        "coordinates": [[156,175],[189,157],[224,144],[261,124],[293,103],[320,80],[320,115],[320,151],[320,200],[320,246],[320,295],[320,337],[320,376],[320,412],[320,446]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("1"))
    },
    
    {
        "imageName1": "paper.svg",
        "imageName2": "two.svg",
        "coordinates": [[177,132],[189,96],[214,70],[254,49],[304,44],[352,49],[395,70],[425,108],[433,153],[403,198],[359,231],[320,264],[275,295],[237,315],[204,340],[168,372],[210,372],[239,372],[272,372],[301,372],[338,372],[373,372],[408,372],[446,372]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("2"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "three.svg",
        "coordinates": [[166,128],[185,96],[217,70],[254,59],[295,53],[342,57],[380,75],[410,111],[407,157],[380,183],[344,194],[312,197],[269,212],[313,216],[348,220],[384,231],[414,256],[437,291],[433,329],[414,355],[382,373],[348,384],[305,383],[253,377],[208,357],[177,329],[155,295]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("3"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "four.svg",
        "coordinates":[[340,31], [312,66],[287,97],[255,132],[231,166],[200,201],[168,240],[122,288],[173,288],[225,288],[262,288],[306,288],[345,288],[386,288],[417,288],
        [340,31],[340,86],[340,151],[340,212],[340,262],[340,310],[340,364],[340,401]],
        "coordinates2":[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("4"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "five.svg",
        "coordinates": [[428,55],[380,55],[328,55],[283,55],[251,55],[215,55],[208,93],[202,122],[193,160],[185,188],[178,223],[202,226],[225,202],[258,184],[294,179],[335,190],[377,208],[411,234],[428,268],[425,313],[410,347],[381,377],[341,394],[301,402],[254,394],[211,372],[184,347],[167,308]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("5"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "six.svg",
        "coordinates": [[422,125],[406,86],[380,66],[331,52],[288,51],[253,63],[218,88],[191,129],[177,172],[173,208],[175,251],[181,292],[195,333],[217,368],[251,387],[298,401],[346,395],[393,369],[418,315],[411,255],[382,215],[342,197],[300,193],[266,201],[237,219],[208,246]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("6"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "seven.svg",
        "coordinates": [[164,57],[207,57],[258,57],[306,57],[344,57],[391,57],[426,57],[461,57],[426,93],[397,125],[370,160],[348,188],[324,222],[297,273],[282,304],[266,346],[254,390]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("7"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "eight.svg",
        "coordinates": [[279,200],[231,172],[206,135],[210,91],[242,59],[277,42],[319,41],[363,52],[395,78],[413,121],[399,168],[371,198],[317,216],[271,223],[225,246],[197,281],[195,336],[203,364],[224,386],[253,400],[295,411],[345,408],[388,390],[421,354],[432,310],[426,267],[402,240],[374,226],[311,219]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("8"))
    },
    {
        "imageName1": "paper.svg",
        "imageName2": "nine.svg",
        "coordinates": [[413,157],[389,106],[351,74],[305,62],[254,67],[218,89],[193,120],[175,172],[193,222],[226,252],[279,266],[331,259],[371,237],[388,205],[413,157],[421,198],[420,262],[411,304],[395,342],[362,375],[313,388],[262,386],[222,369],[202,348],[191,321]],
        "sound": GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/"+ Core.getSoundFilenamForChar("9"))
    }
    
    ]
}
