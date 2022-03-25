/* GCompris - Score.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
 * A QML component to visualize sub-level progress.
 * @ingroup components
 *
 * Score usually consists of current-level (@ref currentSubLevel)
 * and the max number of levels (@ref numberOfSubLevels).
 *
 * For other cases an activity can also directly define the whole message
 * it wants to be shown (@ref message).
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle {
    id: score

    /**
     * type:int
     * Size of the font used in pt.
     *
     * @sa GCFont.fontSize.
     */
    property alias fontSize: subLevelText.fontSize

    /**
     * type:string
     * Define how text size is determined
     *
     * @sa GCFont.fontSizeMode.
     */
    property alias fontSizeMode: subLevelText.fontSizeMode
    
    /**
     * type:real
     * Define margins
     */
    property real margins: 30
    
    /**
     * type:int
     * Total number of sub-levels to show.
     *
     * @sa currentSubLevel
     */
    property int numberOfSubLevels

    /**
     * type:int
     * Current sub-level to show.
     *
     * @sa numberOfSubLevels
     */
    property int currentSubLevel

    /**
     * type:string
     * Complete message string to show.
     *
     * Mutually exclusive with currentSubLevel and numberOfSubLevels
     */
    property string message

    /**
     * Alias for external reference of subLevelText.
     */
    readonly property alias internalTextComponent: subLevelText

    /**
     * Emitted when the win animation should be started.
     *
     * Triggers scale and rotation animation.
     */
    signal playWinAnimation
    signal stop

    color: "#AAFFFFFF"
    width: subLevelText.width * 2
    height: subLevelText.height * 1.4
    radius: 10
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: margins

    border.color: "black"
    border.width: 0

    z: 1000

    onCurrentSubLevelChanged: message = currentSubLevel + "/" + numberOfSubLevels
    onNumberOfSubLevelsChanged: message = currentSubLevel + "/" + numberOfSubLevels
    onPlayWinAnimation: winAnimation.start()

    readonly property bool isWinAnimationPlaying: winAnimation.running

    GCText {
        id: subLevelText
        anchors.centerIn: parent
        fontSizeMode: Text.Fit
        font.bold: true
        color: "#373737"
        text: message
    }

    SequentialAnimation {
        id: winAnimation
        ParallelAnimation {
            PropertyAnimation {
                target: score
                properties: "scale"
                from: 1.0
                to: 1.4
                duration: 500
            }
            NumberAnimation {
                target: score
                property: "rotation"
                from: -10; to: 10
                duration: 750
                easing.type: Easing.InOutQuad
            }
        }
        ParallelAnimation {
            PropertyAnimation {
                target: score
                properties: "scale"
                from: 1.4
                to: 1.0
                duration: 500
            }
            NumberAnimation {
                target: score
                property: "rotation"
                from: 10; to: 0
                duration: 750
                easing.type: Easing.InOutQuad
            }
        }
        onStopped: score.stop()
    }
}
