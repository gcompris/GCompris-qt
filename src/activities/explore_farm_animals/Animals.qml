/* GCompris - Animals.qml
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
import QtQuick 2.2
import GCompris 1.0

import "../../core"
import "explore.js" as Dataset
import "explore_farm_animals.js" as Activity

Item {
    id: animal
    width: animalImg.width
    height: animalImg.height
    property string animalSource
    property real xA :xA
    property real yA:yA
    property string name: name
    property real animalWidth: animalWidth
    property real animalHeight: animalHeight
    property int i: i

    Image {
        id: animalImg
        source: parent.animalSource

        sourceSize.width: parent.width
        sourceSize.height:  parent.height
        width: animalWidth
        height: animalHeight
        x:parent.xA
        y:parent.yA
        SequentialAnimation {
              id: anim
              running: true
              loops: 1

              NumberAnimation {
                  target: animalImg
                  property: "rotation"
                  from: 0; to: 360
                  duration: 400 + Math.floor(Math.random() * 400)
                  easing.type: Easing.InOutQuad }
        }
        Image{
            id:star

            x:animalWidth / 2.5
            y:animalHeight * 0.8
            opacity: 0
            source:"qrc:/gcompris/src/core/resource/star.png"
                 }

        function createDesc(i_){
            var component= Qt.createComponent("AnimalDescription.qml");
            if (component.status == Component.Ready)
                component.createObject(items.background,{"i":i});

        }

            MultiPointTouchArea {
                 id: touchArea
                 anchors.fill: parent
                 touchPoints: [ TouchPoint { id: point1 } ]
                 mouseEnabled: true

                 property bool started


                   onStartedChanged: started ? retouch.start() : retouch.stop()
                         onPressed: {
                                    if (Activity.getLevel() == 0 && Activity.comp == 0){
                                     audioEffects.play(activity.url + name + '.wav');
                                       animalImg.createDesc(animal.i);
                                        Activity.comp=1;
                                     star.opacity=1;}
                                     }
                                       }


}
}


