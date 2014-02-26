/* gcompris - Plane.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.1
import QtMultimedia 5.0
import "planegame.js" as Activity
import GCompris 1.0

Image {
    id: plane

    property Item score
    property Item background

    source: "qrc:/gcompris/src/activities/planegame/resource/tuxhelico.svgz"
    fillMode: Image.PreserveAspectFit

    sourceSize.height: 200 * ApplicationInfo.ratio

    height: sourceSize.height-50*(activity.currentLevel)

    z: 10

    property int speedX: 0
    property int speedY: 0

    onSpeedXChanged: {
        plane.state = "rotated"
    }

    // Mirror the plan if it goes to right
    transform: Rotation {
        id: rotate; origin.x: width / 2; origin.y: 0;
        axis { x: 0; y: 1; z: 0 } angle: plane.speedX >= 0 ? 0 : 180

        Behavior on angle { PropertyAnimation { duration: 400 } }
    }

    states: State {
        name: "rotated"
        PropertyChanges {
            target: plane;
            rotation: Math.abs(plane.speedX) * 45 / activity.max_speed;
        }
    }

    transitions: Transition {
        RotationAnimation {
            duration: 200;
            direction: RotationAnimation.Shortest
        }
    }

    Audio {
        id: bonusSound
        source: "qrc:/gcompris/src/activities/planegame/resource/sounds/bonus.wav"
        onError: console.log("Plane.qml, bonus play error: " + errorString)
    }

    function computeSpeed() {
        if(activity.rightPressed) {
            Activity.increaseSpeedX()
        }
        if(activity.leftPressed) {
            Activity.decreaseSpeedX()
        }
        if(activity.upPressed) {
            Activity.decreaseSpeedY()
        }
        if(activity.downPressed) {
            Activity.increaseSpeedY()
        }
    }

    function move() {
        if(x+width > background.width && speedX > 0) {
            speedX = 0;
        }
        if(x < 0 && speedX < 0) {
            speedX = 0;
        }
        x+=speedX;

        if(y < 0 && speedY < 0) {
            speedY = 0;
        }
        if(y+height > background.height && speedY > 0) {
            speedY = 0;
        }
        y+=speedY;
    }

    function isIn(x1, y1, px1, py1, px2, py2) {
        return (x1>px1 && x1<px2 && y1>py1 && y1<py2)
    }

    function handleCollisionsWithCloud() {
        var planeX1 = x; var planeX2 = x+width
        var planeY1 = y; var planeY2 = y+height
        for(var i = cloudList.length - 1; i >= 0 ; --i) {
            var cloud = cloudList[i];
            var x1 = cloud.x; var x2 = cloud.x+cloud.width;
            var y1 = cloud.y; var y2 = cloud.y+cloud.height;

            if(x2 < 0) {
                // Remove the cloud
                cloud.destroy()
                cloudList.splice(i, 1)
            }
            else if(isIn(x1, y1, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x2, y1, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x1, y2, planeX1, planeY1, planeX2, planeY2) ||
                    isIn(x2, y2, planeX1, planeY1, planeX2, planeY2)) {

                // Collision, look for id
                if(cloud.number == score.currentSubLevel) {
                    cloud.playSound()
                    // Remove the cloud
                    cloud.destroy()
                    cloudList.splice(i, 1)

                    score.currentSubLevel++

                    if(score.currentSubLevel == score.numberOfSublevels
                            && activity.currentLevel == 0) {
                        /* Try the next level */
                        Activity.nextLevel()

                        bonusSound.play();

                        break;
                    }
                }
            }
        }
    }
}
