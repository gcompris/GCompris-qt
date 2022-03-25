/* GCompris - BarButton.qml
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
 * Helper QML component for a button shown on the Bar.
 * @ingroup components
 *
 * Used internally by the Bar component.
 *
 * @sa Bar
 */
Image {
    id: button
    state: "notclicked"

    property alias mouseArea: mouseArea

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }

    states: [
        State {
            name: "reset"
            when: !mouseArea.enabled
            PropertyChanges {
                target: button
                scale: 1.0
            }
        },
        State {
            name: "notclicked"
            PropertyChanges {
                target: button
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: button
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: button
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
    Behavior on opacity { PropertyAnimation { duration: 200 } }

}
