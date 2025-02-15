/* GCompris - ErrorRectangle.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

/**
 * A QML component to give wrong answer visual feedback
 * 
 * When using it, think about setting its position, size and radius depending on the context.
 * Also set the errorImage size if needed.
 * 
 * Always add it after the components it should overlay in the qml file.
 * 
 * Use startAnimation() to display it on wrong answer.
 * 
 * Redefine locally releaseControls() depending on the variable used to lock controls in the activity.
 * 
 * Redefine locally startAnimation() if you need more actions.
 * 
 * Always call resetState() on level init to avoid issues.
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle {
    id: errorRectangle
    width: 0
    height: 0
    radius: 0
    color: GCStyle.grayedBg
    opacity: 0
    
    property alias errorAnimation: errorAnimation
    property alias imageSize: errorImage.width
    
    Image {
        id: errorImage
        anchors.centerIn: parent
        source: "qrc:/gcompris/src/core/resource/cross.svg"
        width: 30 * ApplicationInfo.ratio
        height: width
        sourceSize.width: width
        sourceSize.height: width
    }
    SequentialAnimation {
        id: errorAnimation
        running: false
        NumberAnimation { target: errorRectangle; property: "opacity"; to: 1; duration: 200 }
        PauseAnimation { duration: 1000 }
        NumberAnimation { target: errorRectangle; property: "opacity"; to: 0; duration: 200 }
        ScriptAction { script: releaseControls() }
    }
    function releaseControls() {
        return;
    }
    function startAnimation() {
        errorAnimation.restart();
    }
    function resetState() {
        errorAnimation.stop();
        errorRectangle.opacity = 0;
    }
}
