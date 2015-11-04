/* GCompris - explore_farm_animals.qml
 *
 * Copyright (C) 2015 Djalil Mesli <djalilmesli@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Djalil Mesli <djalilmesli@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "explore_farm_animals.js" as Activity
import "explore.js" as Dataset
ActivityBase {
    id: activity

    property string url: "qrc:/gcompris/src/activities/explore_farm_animals/resource/"

    onStart: focus = true
    onStop: {}

    pageComponent: Image{
        id: background
        source : "resource/farm-animals.svg"
        anchors.fill:parent
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        focus: true

        signal start
        signal stop





        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items

            property GCAudio audioEffects: activity.audioEffects
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias horse: horse
            property alias chicken: chicken
            property alias cow: cow
            property alias cat: cat
            property alias pig: pig
            property alias duck: duck
            property alias dog: dog
            property alias rooster: rooster
            property int i: i

        }


      Animals{
          i:0
          id:horse
          name:"horse"
          animalSource:Dataset.tab[i].image
          xA: 447.175 * 1.7075 * ApplicationInfo.ratio
          yA: 120 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 84.516 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 89.969 * 1.7075 * ApplicationInfo.ratio
              }

      Animals{
          i:1
          id:chicken
          name:"chickens"
          animalSource:Dataset.tab[i].image
          xA: 288.831 * 1.7075 * ApplicationInfo.ratio
          yA: 350 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 142.599 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 91.175 * 1.7075 * ApplicationInfo.ratio
              }
      Animals{
          i:2
          id:cow
          name:"cow"
          animalSource:Dataset.tab[i].image
          xA: 365.175 * 1.7075 * ApplicationInfo.ratio
          yA: 235 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 193.853 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 109.575 * 1.7075 * ApplicationInfo.ratio
              }
      Animals{
          i:3
          id:cat
          name:"cat"
          animalSource:Dataset.tab[i].image
          xA: 353.279 * 1.7075 * ApplicationInfo.ratio
          yA: 182 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 50.109 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 48.230 * 1.7075 * ApplicationInfo.ratio
              }
      Animals{
          i:4
          id:pig
          name:"pig"
          animalSource:Dataset.tab[i].image
          xA: 689.135 * 1.7075 * ApplicationInfo.ratio
          yA: 350 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 64.487 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 60.057 * 1.7075 * ApplicationInfo.ratio
              }
      Animals{
          i:5
          id:duck
          name:"duck"
          animalSource:Dataset.tab[i].image
          xA: 129.035 * 1.7075 * ApplicationInfo.ratio
          yA: 300 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 143.751 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 93.146 * 1.7075 * ApplicationInfo.ratio
              }
      Animals{
          i:6
          id:owl
          name:"owl"
          animalSource:Dataset.tab[i].image
          xA: 669.921 * 1.7075 * ApplicationInfo.ratio
          yA: 2 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 40.821 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 55.707 * 1.7075 * ApplicationInfo.ratio
              }

      Animals{
          i:7
        id:dog
        name:"dog"
        animalSource:Dataset.tab[i].image
        xA: 424.53914 * ApplicationInfo.ratio
        yA: 380 * ApplicationInfo.ratio
        animalWidth: 63.331 * 1.7075 * ApplicationInfo.ratio
        animalHeight: 51.007 * 1.7075 * ApplicationInfo.ratio
            }
      Animals{
          i:8
          id:rooster
          name:"rooster"
          animalSource:Dataset.tab[i].image
          xA: 484.093 * 1.7075 * ApplicationInfo.ratio
          yA: 350 * 1.7075 * ApplicationInfo.ratio
          animalWidth: 71.157 * 1.7075 * ApplicationInfo.ratio
          animalHeight: 79.436 * 1.7075 * ApplicationInfo.ratio
              }

      onStart: { Activity.start(items) }
      onStop: { Activity.stop() }






        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
}

    }



