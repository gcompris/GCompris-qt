/* GCompris - mirror.qml
 *
 * Copyright (C) 2016 Shubham Nagaria shubhamrnagaria@gmail.com
 *
 * Authors:
 *   Shubham Nagaria shubhamrnagaria@gmail.com
 *
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
import QtGraphicalEffects 1.0
import "../../core"
import "mirrorgame.js" as Activity

Image {
    id:mirror
    property int currangle:0
    property int  nxtangle:90
    property int pos:1
    property bool placed:false
    source:"resource/mirror.svg"
    fillMode: Image.PreserveAspectFit

    RotationAnimation {
        id: rotate
        target:mirror
        property: "rotation"
        from: mirror.currangle
        to: mirror.nxtangle
        duration: 350
        direction: RotationAnimation.Clockwise
    }

    MouseArea {
       anchors.fill: parent
       onClicked: {
           rotate.start();
           mirror.currangle+=90;
           mirror.nxtangle+=90;
           mirror.pos=mirror.pos+1;
           if(mirror.pos%4==1)mirror.pos=1;
           Activity.checkLightPath();

       }       
   }
}

