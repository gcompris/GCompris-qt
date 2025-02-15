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
import core 1.0

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
    height: width * 0.5

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
    property color color: GCStyle.lighterBg
    property color borderColor: GCStyle.darkBorder
    property int borderWidth: GCStyle.thinnestBorder
    property int radius: width * 0.05
    property color backColor: GCStyle.lighterBg
    property color pointColor: GCStyle.darkText

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
    property GCSoundEffect soundEffects

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
            width: parent.width * 0.5
            margins: flipable.radius
            numberColor: flipable.pointColor
            valueMax: flipable.valueMax
            onValueChanged: if(flipable.flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
            soundEffects: flipable.soundEffects
        }

        // Separation
        Rectangle {
            anchors.centerIn: parent
            width: GCStyle.thinnestBorder
            height: front.height * 0.7
            color: flipable.borderColor
        }

        DominoNumber {
            id: number2
            mode: flipable.mode
            x: parent.width * 0.5
            width: number1.width
            margins: flipable.radius
            numberColor: flipable.pointColor
            valueMax: flipable.valueMax
            onValueChanged: if(flipable.flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
            soundEffects: flipable.soundEffects
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
        origin.x: flipable.width * 0.5
        origin.y: flipable.height * 0.5
        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
        angle: 0    // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges { 
            rotation {
                angle: 180
            }
        }
        when: flipable.flipped
        onCompleted: flipable.flipped = false
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 250 }
    }
}
