/* GCompris - AnimalDescription.qml
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

    id:description
    property int i: i

    Rectangle{
        id:rectangleDesc
        height: Activity.getHeight() ;
        width:Activity.getWidth()  ;
        radius: 30
        border.width: 5
        border.color: "black"
        color:"lightpink"
        x:width * -1
        y: 0
        z:5
        visible: true


      Rectangle{
         id:bouttonBack
         x:500
         y:700
         width:300
         height: 50
         radius: 30
         color:"lightgray"
         border.width: 2



         MultiPointTouchArea {
              id: touchArea2
              anchors.fill: parent
              touchPoints: [ TouchPoint { id: point1 } ]
              mouseEnabled: true

              property bool started


                onStartedChanged: started ? retouch.start() : retouch.stop()
                      onPressed: {description.destroy(100);Activity.comp=0;
                                    if (Activity.isComplete(i) == 1) Activity.nextLevel();
                                 }
                                  }

         GCText {
             id: textB
             text: qsTr("Back to the Homepage")
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: Text.AlignHCenter
             fontSize: mediumSize
             font.weight: Font.Normal
             anchors.centerIn: parent.Center
             color: "#2a2a2a"
             width: parent.width

         }

              }
        Rectangle{
            id:rectText
            y:parent.height * 0.20
            x:parent.width * 0.05
            width:parent.width/3
            height:parent.height/2
            color:"lightpink"


        GCText {
            id: textDesc
            text: Dataset.tab[i].text
            fontSize: largeSize
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.DemiBold
            anchors.centerIn: parent.Center
            color: "#2a2a2a"
            width: parent.width
            wrapMode: Text.WordWrap

        }
}
            Image{
                id:imgDesc
                source: Dataset.tab[i].image2
                x:parent.width * 0.50
                y:100
                fillMode:Image.PreserveAspectFit
                width:600 * ApplicationInfo.ratio
                height:400 * ApplicationInfo.ratio


                  }
            SequentialAnimation {
                   running: true
                   NumberAnimation { target: rectangleDesc; property: "x"; to: 0; duration: 800 }
                   NumberAnimation { target: rectangleDesc; property: "x"; to: 50 ; duration: 100 }
                   NumberAnimation { target: rectangleDesc; property: "x"; to: 0; duration: 400 }

               }




                         }


}





