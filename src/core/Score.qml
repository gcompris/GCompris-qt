/* GCompris - Score.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

/**
 * A QML component to visualize sub-level progress.
 * @ingroup components
 *
 * Score usually consists of current-level (@ref currentSubLevel)
 * and the max number of levels (@ref numberOfSubLevels).
 *
 * It is mainly used as a score counter, starting at 0 and increasing
 * directly after a good answer.
 *
 * It can in some cases be used as a sub-level counter, starting at 1.
 * But it should be used as sub-level counter only if the sub-level increases
 * regardless of if the answer is good or bad, or if there is no answer to give
 * to reach next sub-level. In this case, don't forget to set the variable
 * "isScoreCounter" to false, so it will look a bit different visually.
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
    property real margins: GCStyle.baseMargins
    
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
     * type:bool
     * Whether the component is used as a score counter (true)
     * or something else, like a subLevel counter (false)
     */
    property bool isScoreCounter: true

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
    /**
     * Emitted when manually stopping the animation
     *
     * Resets scale and rotation.
     */
    signal stopWinAnimation
    /**
     * Emitted when the animation is finished
     */
    signal stop

    /**
     * type:bool
     * Whether the component has a fixed width.
     * If set to true, setting the width is required.
     */
    property bool fixedWidth: false

    Connections {
        target: activity
        function onStop() { stopWinAnimation(); }
    }

    color: GCStyle.lightTransparentBg
    width: fixedWidth ? 1 : subLevelText.width + 2 * GCStyle.baseMargins
    height: subLevelText.height + GCStyle.baseMargins
    radius: GCStyle.halfMargins
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: margins

    border.color: GCStyle.whiteBorder
    border.width: isScoreCounter ? 0 : GCStyle.midBorder

    z: 1000

    onCurrentSubLevelChanged: message = currentSubLevel + "/" + numberOfSubLevels
    onNumberOfSubLevelsChanged: message = currentSubLevel + "/" + numberOfSubLevels
    onPlayWinAnimation: winAnimation.start()
    onStopWinAnimation: {
        winAnimation.stop()
        score.scale = 1.0
        score.rotation = 0
    }

    readonly property bool isWinAnimationPlaying: winAnimation.running

    GCText {
        id: subLevelText
        anchors.centerIn: parent
        width: score.fixedWidth ? parent.width - 2 * GCStyle.baseMargins : implicitWidth
        height: 34 * ApplicationInfo.ratio
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.bold: true
        color: GCStyle.darkText
        text: score.message
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
        onFinished: score.stop()
    }
}
