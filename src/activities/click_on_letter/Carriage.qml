/* GCompris - Carriage.qml
 *
 * Copyright (C) 2014 Holger Kaelberer  <holger.k@elberer.de>
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

import QtQuick 2.6
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "click_on_letter.js" as Activity

Item {
    id: carriageItem
    property int nbCarriage
    property bool isCarriage: index <= nbCarriage

    Image {
        id: carriageImage
        sourceSize.width: carriageItem.width
        fillMode: Image.PreserveAspectFit
        source: isCarriage ?
                    Activity.url + "carriage.svg":
                    Activity.url + "cloud.svg"
        z: (state == 'scaled') ? 1 : -1

        Rectangle {
            id: carriageBg
            visible: isCarriage
            width: parent.width - 8
            height: parent.height / 1.8
            anchors.bottom: parent.top
            anchors.bottomMargin: - parent.height / 1.5
            radius: height / 10
            color: "#f0d578"
            border.color: "#b98a1c"
            border.width: 3
        }

        GCText {
            id: text
            anchors.horizontalCenter: isCarriage ?
                                          carriageBg.horizontalCenter :
                                          parent.horizontalCenter
            anchors.verticalCenter: isCarriage ?
                                        carriageBg.verticalCenter :
                                        parent.verticalCenter
            z: 11

            text: letter
            font.pointSize: NaN  // need to clear font.pointSize explicitly
            font.pixelSize: parent.width * 0.65
            font.bold: true
            style: Text.Outline
            styleColor: "#2a2a2a"
            color: "white"
        }

        DropShadow {
            anchors.fill: text
            cached: false
            horizontalOffset: 1
            verticalOffset: 1
            radius: 3
            samples: 16
            color: "#422a2a2a"
            source: text
        }

        Image {
            id:softFailure
            z: 12
            source: "qrc:/gcompris/src/activities/tic_tac_toe/resource/cross.svg"
            width: parent.width
            height: width
            anchors.centerIn: text
            opacity:0
            visible: ApplicationInfo.useOpenGL ? false : true
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: ApplicationInfo.isMobile ? false : true

            onClicked: {
                if (Activity.checkAnswer(index)) {
                    successAnimation.restart();
                    particle.burst(30)
                } else {
                    failureAnimation.restart()
                }
            }
        }

        ParticleSystemStarLoader {
            id: particle
            clip: false
        }

        states: State {
            name: "scaled"; when: mouseArea.containsMouse
            PropertyChanges {
                target: carriageItem
                scale: /*carriageImage.scale * */ 1.2
                z: 2}
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
        }

        SequentialAnimation {
            id: successAnimation
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 20; duration: 100
            }
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"; to: -20
                duration: 100 }
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 0
                duration: 50 }
        }

        SequentialAnimation {
            id: failureAnimation
            NumberAnimation {
                target: ApplicationInfo.useOpenGL ? color : softFailure
                property: "opacity"
                to: 1; duration: 400
            }
            NumberAnimation {
                target: ApplicationInfo.useOpenGL ? color : softFailure
                property: "opacity"
                to: 0; duration: 200
            }
        }
    }
    
    Colorize {
        id: color
        z: 5
        anchors.fill: carriageImage
        source: carriageImage
        hue: 0.0
        saturation: 1
        opacity: 0
    }
}
