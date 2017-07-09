/* GCompris - ScoreItem.qml
 *
 * Copyright (C) 2017 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com> (main code)
 *   Johnny Jazeix <jazeix@gmail.com> (refactorisation)
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

Item {
    id: scoreItem

    property int player: 1
    property string backgroundImageSource
    property string playerImageSource
    property int playerScore

    property int playerScaleOriginX
    property int playerScaleOriginY

    signal win
    signal beginTurn
    signal endTurn

    onBeginTurn: {
        scaleAnimation.start()
    }

    onEndTurn: {
        scaleAnimation.stop()
        playerImageRotate.stop()
        playerImage.rotation = 0
        shrinkAnimation.start()
        backgroundRectangle.state = "second"
    }

    onWin: {
        scaleAnimation.start()
        backgroundRectangle.state = "win"
        playerScore ++;
    }

    PropertyAnimation {
        id: scaleAnimation
        target: scaleTransform
        properties: "scale"
        from: 1.0
        to: 1.4
        duration: 500
        onStarted: {
            backgroundRectangle.state = "first"
            playerImageRotate.start()
        }
    }

    PropertyAnimation {
        id: shrinkAnimation
        target: scaleTransform
        properties: "scale"
        from: 1.4
        to: 1.0
        duration: 500
    }

    SequentialAnimation {
        id: playerImageRotate
        loops: Animation.Infinite
        NumberAnimation {
            target: playerImage
            property: "rotation"
            from: -30; to: 30
            duration: 750
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: playerImage
            property: "rotation"
            from: 30; to: -30
            duration: 750
            easing.type: Easing.InOutQuad
        }
    }

    Rectangle {
        id: backgroundRectangle
        anchors.fill: parent
        radius: 15
        state: "second"

        Image {
            id: backgroundImage
            source: backgroundImageSource
            sourceSize.height: parent.height*0.93
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 0.5

            Image {
                id: playerImage
                source: playerImageSource
                sourceSize.height: parent.height*0.8
                x: parent.width*0.06
                anchors.verticalCenter: parent.verticalCenter
            }

            GCText {
                id: scoreLabel
                anchors.verticalCenter: parent.verticalCenter
                color: "#2a2a2a"
                x: parent.width*0.65
                fontSizeMode: Text.Fit
                text: playerScore
            }
        }

        states: [
        State {
            name: "first"
            PropertyChanges {
                target: backgroundRectangle
                color: "#80ffffff"
            }
            PropertyChanges {
                target: playerImage
                source: playerImageSource
            }
        },
        State {
            name: "second"
            PropertyChanges {
                target: backgroundRectangle
                color: "transparent"
            }
            PropertyChanges {
                target: playerImage
                source: playerImageSource
            }
        },
        State {
            name: "win"
            PropertyChanges {
                target: playerImage
                source: "qrc:/gcompris/src/core/resource/win.svg"
            }
            PropertyChanges {
                target: backgroundRectangle
                color: "#80ffffff"
            }
        }
        ]

        transform: Scale {
            id: scaleTransform
            property real scale: 1
            origin.x: playerScaleOriginX
            origin.y: playerScaleOriginY
            xScale: scale
            yScale: scale
        }
    }
}
