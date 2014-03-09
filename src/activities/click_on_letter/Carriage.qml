/* GCompris - Carriage.qml
 *
 * Copyright (C) 2014 Holger Kaelberer 
 * 
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
import "qrc:/gcompris/src/core"
import "click_on_letter.js" as Activity

Component {
    Image {
        id: carriageImage
        source: image
        scale: 1 * ApplicationInfo.ratio
        
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: type == "carriage" ? -8 : 0
            anchors.verticalCenter: type == "carriage" ? undefined : parent.verticalCenter
            anchors.top: type == "carriage" ? parent.top : undefined
            anchors.topMargin: type == "carriage" ? 1 : undefined
            z:11
                        
            text: letter
            font.pointSize: 44
            font.bold: true
            style: Text.Outline
            styleColor: "lightblue"
                color: "black"
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: ApplicationInfo.isMobile ? false : true
                
            onClicked: {
                clickAnimation.restart();
                Activity.checkAnswer(index);
                carriageImage.focus = false;
            }
        }
            
        states: State {
            name: "scaled"; when: mouseArea.containsMouse
            PropertyChanges { target: carriageImage; scale: /*carriageImage.scale * */ 1.2 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
        }
            
        SequentialAnimation {
            id: clickAnimation
            NumberAnimation { target: carriageImage; easing.type: Easing.InOutQuad; property: "rotation"; to: 20; duration: 100 }
            NumberAnimation { target: carriageImage; easing.type: Easing.InOutQuad; property: "rotation"; to: -20; duration: 100 }
            NumberAnimation { target: carriageImage; easing.type: Easing.InOutQuad; property: "rotation"; to: 0; duration: 50 }
        }
    }
}
