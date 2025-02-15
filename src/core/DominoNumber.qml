/* GCompris - DominoNumber.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

/**
 * A QML component to display integers(0-9) on Domino.
 * Numbers are displayed in the form of specified representation.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: item
    height: width

    /**
     * type:int
     * Integer to display on the domino
     */
    property int value

    /**
     * type:string
     * String to specify representation of Domino
     */
    property string mode

    /**
     * type:int
     * Highest number visible on domino.
     */
    property int valueMax

    /**
     * type:color
     * color of the dots to display an integer.
     */
    property color numberColor

    /**
     * type:int
     * Radius of the dots to display an integer.
     */
    readonly property int radius: contentImage.width * 0.25

    /**
     * type:double
     * margin around number content
     */
    property double margins

    /**
     * type:boolean
     * Set false to disable mouse/touch inputs on domino.
     */
    property bool isClickable: true // Default value

    /**
     * type:GCSoundEffect
     * To play sound and audio effects.
     */
    property GCSoundEffect soundEffects

    readonly property var romans: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    // Source of the images should be in the same format as below with the number associated and svg format
    property string source: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    /**
     * type:var
     * the butterflies model for the image mode
     */
    readonly property var butterfliesModel: [
        [
        ],
        [
            [{ "itemX": 0.3, "itemY": 0.45, "itemRotation": 30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.25, "itemY": 0.1, "itemRotation": 50, "itemSource": source},
            { "itemX": 0.4, "itemY": 0.6, "itemRotation": -50, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.35, "itemRotation": -25, "itemSource": source},
            { "itemX": 0.2, "itemY": 0.55, "itemRotation": 30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.5, "itemY": 0.05, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.3, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.5, "itemRotation": -15, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.65, "itemRotation": -30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.55, "itemY": 0.05, "itemRotation": -15, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.15, "itemRotation": -150, "itemSource": source},
            { "itemX": 0.5, "itemY": 0.35, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.55, "itemRotation": -45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.75, "itemRotation": -10, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemRotation": -75, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.05, "itemRotation": 15, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.35, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.4, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.65, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.7, "itemRotation": -45, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.02, "itemRotation": 60, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.05, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.25, "itemRotation": -165, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.3, "itemRotation": -135, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.5, "itemRotation": 75, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.6, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.3, "itemY": 0.75, "itemRotation": -10, "itemSource": source}
            ], ''
        ],
        [
            [{ "itemX": 0.05, "itemY": 0.02, "itemRotation": -25, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.03, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.15, "itemRotation": 5, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.3, "itemRotation": 15, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.35, "itemRotation": 170, "itemSource": source},
            { "itemX": 0.15, "itemY": 0.55, "itemRotation": 50, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.65, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.8, "itemRotation": 5, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.06, "itemY": 0.01, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.02, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.18, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.27, "itemRotation": 170, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.35, "itemRotation": 20, "itemSource": source},
            { "itemX": 0.32, "itemY": 0.45, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.6, "itemRotation": 5, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.65, "itemRotation": 175, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.8, "itemRotation": -10, "itemSource": source}], ''
        ]
    ]

    GCText {
        id: numberText
        visible: (item.mode == "number" || item.mode == "roman")
        anchors.fill: parent
        anchors.margins: item.margins
        color: item.numberColor
        fontSize: hugeSize
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: (item.mode == "number") ? item.value : item.romans[item.value]
    }

    Item {
        id: contentImage
        anchors.fill: parent
        anchors.margins: item.margins
        visible: (item.mode == "image")
        Repeater {
            model: item.butterfliesModel[item.value][0]
            Image {
                required property var modelData
                source: modelData.itemSource
                x: contentImage.width * modelData.itemX
                y: contentImage.height * modelData.itemY
                width: item.radius
                height: width
                sourceSize.width: width
                rotation: modelData.itemRotation
            }
        }
    }

    function isVisible(index) {
        var value = item.value
        var visible = false
        switch(index) {
        case 0:
            if(value >= 2) visible = true
            break
        case 1:
            if(value >= 6) visible = true
            break
        case 2:
            if(value >= 4) visible = true
            break
        case 3:
            if(value >= 8) visible = true
            break
        case 4:
            if(value === 1 || value === 3 || value === 5 ||
               value === 7 || value === 9) visible = true
            break
        case 5:
            if(value >= 8) visible = true
            break
        case 6:
            if(value >= 4) visible = true
            break
        case 7:
            if(value >= 6) visible = true
            break
        case 8:
            if(value >= 2) visible = true
            break
        }
        return visible
    }

    Grid {
        columns: 3
        spacing: 3
        visible: (item.mode == "dot")
        anchors.horizontalCenter: item.horizontalCenter
        anchors.verticalCenter: item.verticalCenter
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        Repeater {
            model: 9
            Item {
                required property int index
                width: contentImage.width * 0.32
                height: width
                Rectangle {
                    width: item.radius
                    height: item.radius
                    color: item.numberColor
                    radius: item.radius
                    anchors.centerIn: parent
                }
                opacity: isVisible(index)

                Behavior on opacity { PropertyAnimation { duration: 200 } }
            }
        }
    }

    // Increase the displayed integer value by one.
    function up() {
        soundEffects.play()
        if(item.value == item.valueMax)
            item.value = 0
        else
            item.value++
    }

    // Decrease the displayed integer by one.
    function down() {
        soundEffects.play()
        if(item.value == 0)
            item.value = item.valueMax
        else
            item.value--
    }

    MouseArea {
        enabled: !ApplicationInfo.isMobile && item.isClickable
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button == Qt.LeftButton)
                item.up()
            else
                item.down()
        }
    }

    MultiPointTouchArea {
        enabled: ApplicationInfo.isMobile && item.isClickable
        anchors.fill: parent
        maximumTouchPoints: 1
        onPressed: {
            item.up()
        }
    }

}
