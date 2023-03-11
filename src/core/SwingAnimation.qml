/* GCompris - SwingAnimation.qml
 *
 * Copyright (C) 2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

SequentialAnimation {
    id: swing
    property int amplitude: 10
    property int duration: 800
    property var target: undefined
    running: false
    loops: Animation.Infinite
    alwaysRunToEnd: true
    NumberAnimation {
        target: swing.target
        property: "rotation"
        from: 0; to: amplitude
        duration: swing.duration / 4
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        target: swing.target
        property: "rotation"
        from: amplitude; to: -amplitude
        duration: swing.duration / 2
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        target: swing.target
        property: "rotation"
        from: -amplitude; to: 0
        duration: swing.duration / 4
        easing.type: Easing.InQuad
    }
}
