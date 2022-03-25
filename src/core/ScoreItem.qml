/* GCompris - ScoreItem.qml
 *
 * SPDX-FileCopyrightText: 2017 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com> (main code)
 *   Johnny Jazeix <jazeix@gmail.com> (refactorisation)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
 * A QML component to visualize number of wins.
 * @ingroup components
 *
 * ScoreItem consists of player score (@ref playerScore)
 * and player image (@ref playerImageSource).
 * Mostly used in multi-player activities.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: scoreItem

    /**
     * type:int
     * Id of the player.
     */
    property int player: 1

    /**
     * type:string
     * Source of background image to display.
     *
     * @sa backgroundImage.source
     */
    property string backgroundImageSource

    /**
     * type:string
     * Source of player image to display.
     *
     * @sa playerImage.source
     */
    property string playerImageSource

    /**
     * type:int
     * Count of score(i.e. number of wins).
     *
     * @sa scoreLabel.text
     */
    property int playerScore

    /**
     * type:int
     * Holds the point from which the player image
     * is scaled on x-axis.
     *
     * @sa scaleTransform.origin.x
     */
    property int playerScaleOriginX

    /**
     * type:int
     * Holds the point from which the player image
     * is scaled on y-axis.
     *
     * @sa scaleTransform.origin.y
     */
    property int playerScaleOriginY

    /**
     * Emitted when the win animation should be started.
     *
     * Triggers scale, rotation animation and increases playerScore count.
     */
    signal win

    /**
     * Emitted when the player turn should be started.
     *
     * Triggers scale and rotation animation.
     */
    signal beginTurn

    /**
     * Emitted when the player turn should be ended.
     *
     * Triggers shrink and rotation animation on player image.
     */
    signal endTurn

    /**
     * type:bool
     * Wether it is player's turn.
     */
    property bool playersTurn: false

    /**
     * type:alias
     * allow to access properties of playerItem
     * Usually you'll need set its source, height, anchors.leftMargin and anchors.bottom.margin
     */
    property alias playerItem: playerItem

    onBeginTurn: {
        scaleAnimation.start()
        playersTurn = true
    }

    onEndTurn: {
        playersTurn = false
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
            sourceSize.height: height * 1.4
            sourceSize.width: width * 1.4
            anchors.fill: parent
            anchors.margins: parent.height * 0.04

            Image {
                id: playerImage
                source: playerImageSource
                fillMode: Image.PreserveAspectFit
                height: parent.height*0.8
                sourceSize.height: height * 1.4
                x: parent.width*0.06
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    id: playerItem
                    source: "qrc:/gcompris/src/core/resource/empty.svg"
                    fillMode: Image.PreserveAspectFit
                    height: 0
                    sourceSize.height: height * 1.4
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                }
            }
            GCText {
                id: scoreLabel
                x: parent.width * 0.65
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.8
                width: parent.width * 0.3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#2a2a2a"
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
            PropertyChanges {
                target: playerItem
                visible: true
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
            PropertyChanges {
                target: playerItem
                visible: true
            }
        },
        State {
            name: "win"
            PropertyChanges {
                target: playerImage
                source: "qrc:/gcompris/src/core/resource/win.svg"
            }
            PropertyChanges {
                target: playerItem
                visible: false
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
