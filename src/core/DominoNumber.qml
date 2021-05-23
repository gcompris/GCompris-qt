/* GCompris - DominoNumber.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
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

    /**
     * type:string
     * String to specify the source folder for the image mode
     */
    property string source

    readonly property var romans : ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    GCText {
        id: numberText
        visible: (item.mode == "number" || item.mode == "roman")
        fontSize: ((item.mode == "number") ? 30 : (item.value == 8) ? 20 : (item.value == 7 || item.value == 3) ? 25 : 30)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: item.color
        anchors.margins: ApplicationInfo.ratio * 5
        text: (mode == "number") ? item.value : romans[item.value]
    }

    Image {
        id: imageText
        visible: (item.mode == "image")
        height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: ApplicationInfo.ratio * 5
        source: item.source + item.value + ".svg"
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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
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

    /**
     * type:boolean
     * To check on touch devices to increase or decrease the integer value.
     */
    property bool goUp
    Timer {
        id: timer
        interval: 500
        repeat: true
        onTriggered: goUp ? up() : down()
    }

    MultiPointTouchArea {
        enabled: ApplicationInfo.isMobile && item.isClickable
        anchors.fill: parent
        maximumTouchPoints: 1
        onPressed: {
            goUp = true
            up()
            timer.start()
        }
        onTouchUpdated: {
            if(touchPoints.length) {
                var touch = touchPoints[0]
                if(touch.y < parent.y + parent.height)
                    goUp = true
                else
                    goUp = false
            }
        }
        onReleased: timer.stop()
    }

}
