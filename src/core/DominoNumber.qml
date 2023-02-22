/* GCompris - DominoNumber.qml
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
 * A QML component to display integers(0-9) on Domino.
 * Numbers are displayed in the form of specified representation.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: item

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
    property color color

    /**
     * type:color
     * Border color of the dots to display an integer.
     */
    property color borderColor

    /**
     * type:int
     * Border width of the dots to display an integer.
     */
    property int borderWidth

    /**
     * type:int
     * Radius of the dots to display an integer.
     */
    property int radius

    /**
     * type:boolean
     * Set false to disable mouse/touch inputs on domino.
     */
    property bool isClickable: true // Default value

    /**
     * type:GCAudio
     * To play sound and audio effects.
     */
    property GCSfx audioEffects

    readonly property var romans: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    // Source of the images should be in the same format as below with the number associated and svg format
    property string source: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    /**
     * type:var
     * the butterflies model for the image mode
     */
    readonly property var butterfliesModel: [
        [
            [{ "itemX": 0, "itemY": 0, "itemSize": 0, "itemRotation": 0, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.3, "itemY": 0.45, "itemSize": 0.3, "itemRotation": 30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.25, "itemY": 0.1, "itemSize": 0.3, "itemRotation": 50, "itemSource": source},
            { "itemX": 0.4, "itemY": 0.6, "itemSize": 0.3, "itemRotation": -50, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.35, "itemSize": 0.3, "itemRotation": -25, "itemSource": source},
            { "itemX": 0.2, "itemY": 0.55, "itemSize": 0.3, "itemRotation": 30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.5, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.3, "itemSize": 0.3, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.5, "itemSize": 0.3, "itemRotation": -15, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.65, "itemSize": 0.3, "itemRotation": -30, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.55, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -15, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.15, "itemSize": 0.3, "itemRotation": -150, "itemSource": source},
            { "itemX": 0.5, "itemY": 0.35, "itemSize": 0.3, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.55, "itemSize": 0.3, "itemRotation": -45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.75, "itemSize": 0.3, "itemRotation": -10, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -75, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.05, "itemSize": 0.3, "itemRotation": 15, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.35, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.4, "itemSize": 0.3, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.65, "itemSize": 0.3, "itemRotation": 45, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.7, "itemSize": 0.3, "itemRotation": -45, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.02, "itemSize": 0.3, "itemRotation": 60, "itemSource": source},
            { "itemX": 0.6, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.25, "itemY": 0.25, "itemSize": 0.3, "itemRotation": -165, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.3, "itemSize": 0.3, "itemRotation": -135, "itemSource": source},
            { "itemX": 0.1, "itemY": 0.5, "itemSize": 0.3, "itemRotation": 75, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.6, "itemSize": 0.3, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.3, "itemY": 0.75, "itemSize": 0.3, "itemRotation": -10, "itemSource": source}
            ], ''
        ],
        [
            [{ "itemX": 0.05, "itemY": 0.02, "itemSize": 0.3, "itemRotation": -25, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.03, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.15, "itemSize": 0.3, "itemRotation": 5, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.3, "itemSize": 0.3, "itemRotation": 15, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.35, "itemSize": 0.3, "itemRotation": 170, "itemSource": source},
            { "itemX": 0.15, "itemY": 0.55, "itemSize": 0.3, "itemRotation": 50, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.65, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.8, "itemSize": 0.3, "itemRotation": 5, "itemSource": source}], ''
        ],
        [
            [{ "itemX": 0.06, "itemY": 0.01, "itemSize": 0.3, "itemRotation": -10, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.02, "itemSize": 0.3, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.18, "itemSize": 0.3, "itemRotation": 10, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.27, "itemSize": 0.3, "itemRotation": 170, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.35, "itemSize": 0.3, "itemRotation": 20, "itemSource": source},
            { "itemX": 0.32, "itemY": 0.45, "itemSize": 0.3, "itemRotation": -40, "itemSource": source},
            { "itemX": 0.05, "itemY": 0.6, "itemSize": 0.3, "itemRotation": 5, "itemSource": source},
            { "itemX": 0.65, "itemY": 0.65, "itemSize": 0.3, "itemRotation": 175, "itemSource": source},
            { "itemX": 0.35, "itemY": 0.8, "itemSize": 0.3, "itemRotation": -10, "itemSource": source}], ''
        ]
    ]

    GCText {
        id: numberText
        visible: (item.mode == "number" || item.mode == "roman")
        fontSize: ((item.mode == "number") ? 30 : (item.value == 8) ? 20 : (item.value == 7 || item.value == 3) ? 25 : 30)
        anchors.horizontalCenter: item.horizontalCenter
        anchors.verticalCenter: item.verticalCenter
        color: item.color
        anchors.margins: ApplicationInfo.ratio * 5
        text: (mode == "number") ? item.value : romans[item.value]
    }

    Item {
        id: contentImage
        anchors.fill: parent
        visible: (item.mode == "image")
        Repeater {
            model: butterfliesModel[item.value][0]
            Image {
                source: modelData.itemSource
                x: contentImage.width * modelData.itemX
                y: contentImage.height * modelData.itemY
                width: contentImage.width * modelData.itemSize
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
            Rectangle {
                width: radius
                height: radius
                border.width: item.borderWidth
                color: item.color
                border.color: item.borderColor
                radius: item.radius
                opacity: isVisible(index)

                Behavior on opacity { PropertyAnimation { duration: 200 } }
            }
        }
    }

    // Increase the displayed integer value by one.
    function up() {
        audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
        if(item.value == item.valueMax)
            item.value = 0
        else
            item.value++
    }

    // Decrease the displayed integer by one.
    function down() {
        audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
        if(item.value == 0)
            item.value = item.valueMax
        else
            item.value--
    }

    MouseArea {
        enabled: !ApplicationInfo.isMobile && item.isClickable
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.LeftButton)
                up()
            else
                down()
        }
    }

    MultiPointTouchArea {
        enabled: ApplicationInfo.isMobile && item.isClickable
        anchors.fill: parent
        maximumTouchPoints: 1
        onPressed: {
            up()
        }
    }

}
