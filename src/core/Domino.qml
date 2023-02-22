/* GCompris - Domino.qml
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
 * A QML component to display a domino.
 *
 * Domino consists of Flipable sides(front and back)
 * and uses DominoNumber to display numbers.
 * It is divided into two regions containing DominoNumbers.
 *
 * @inherit QtQuick.Flipable
 */
Flipable {
    id: flipable

    /**
     * type:int
     * Integer displayed in first region.
     */
    property alias value1: number1.value

    /**
     * type:int
     * Integer displayed in second region.
     */
    property alias value2: number2.value

    /**
     * type:int
     * Highest integer to display.
     */
    property int valueMax: 9

    // Domino style
    property color color: "#f8f8f8"
    property color borderColor: "#373737"
    property int borderWidth: 2
    property int radius: width * 0.05
    property color backColor: "#f8f8f8"
    property color pointColor: "#373737"

    // Define the mode/representation of domino
    property string mode: "dot"

    // menu modes for setting different types for domino
    readonly property var menuModes : [
        //: "Dots" is for representation of the points in a domino in the form of dots
        { "text": qsTr("Dots"), "value": "dot" },
        //: "Arabic Numbers" is for representation of the points in a domino in the form of integer numbers
        { "text": qsTr("Arabic Numbers"), "value": "number" },
        //: "Roman Numbers" is for representation of the points in a domino  in the form of roman numbers
        { "text": qsTr("Roman Numbers"), "value": "roman" },
        //: "Images" is for representation of the points in a domino in the form of an image (containing a specific count of same elements)
        { "text": qsTr("Images"), "value": "image" }
    ]

    // Set to true when to display on both sides.
    property bool flipEnabled: false

    property bool flipped: true

    // Set to false to prevent user inputs.
    property bool isClickable: true
    property GCSfx audioEffects

    front: Rectangle {
        anchors.fill: parent
        smooth: true;
        color: flipable.color
        border.color: flipable.borderColor
        border.width: flipable.borderWidth
        radius: flipable.radius

        DominoNumber {
            id: number1
            mode: flipable.mode
            width: parent.width / 2
            height: parent.height
            color: flipable.pointColor
            borderColor: flipable.borderColor
            borderWidth: 0
            radius: parent.height * 0.25
            valueMax: flipable.valueMax
            onValueChanged: if(flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
            audioEffects: flipable.audioEffects
        }

        // Separation
        Rectangle {
            x: front.width / 2
            anchors.verticalCenter: front.verticalCenter
            width: 2
            height: front.height * 0.7
            color: flipable.borderColor
        }

        DominoNumber {
            id: number2
            mode: flipable.mode
            x: parent.width / 2
            width: parent.width / 2
            height: parent.height
            color: flipable.pointColor
            borderColor: flipable.borderColor
            borderWidth: 0
            radius: parent.height * 0.25
            valueMax: flipable.valueMax
            onValueChanged: if(flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
            audioEffects: flipable.audioEffects
        }
    }

    back: Rectangle {
        anchors.fill: parent
        smooth: true;
        color: flipable.backColor
        border.width: flipable.borderWidth
        radius: flipable.radius
    }

    transform: Rotation {
        id: rotation
        origin.x: flipable.width/2
        origin.y: flipable.height/2
        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
        angle: 0    // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 }
        when: flipable.flipped
        onCompleted: flipable.flipped = false
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 250 }
    }
}
