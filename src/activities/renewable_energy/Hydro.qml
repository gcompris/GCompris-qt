/* GCompris - hydro.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"

Item {
    id: hydro
    property alias power: stepupwire1.power

    function start() {
        anim.running = true
    }

    function stop() {
        anim.running = false
        dam.started = false
        river.level = 0
        sun.down()
        rain.down()
        cloud.down()
        stepup1.started = false
    }

    Image {
        id: sky
        anchors.top: parent.top
        sourceSize.width: parent.width
        source: activity.url + "sky.svg"
        height: (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.3
        visible: true
        z: 27
    }

    Image {
        id: landscape
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        source: activity.url + "landscape.svg"
        z: 30
    }

    Image {
        id: tuxboat
        source: activity.url + "boat.svg"
        sourceSize.width: parent.width * 0.15
        sourceSize.height: parent.height * 0.15
        anchors {
            bottom: parent.bottom
            bottomMargin: 15
        }
        x: 0
        z: 51

        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
        NumberAnimation on x {
            id: anim
            running: false
            to: background.width - tuxboat.width
            duration: 15000
            easing.type: Easing.InOutSine
            onRunningChanged: {
                if(!anim.running)
                {
                    items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/harbor2.wav')
                    if(!anim.running)
                    {
                        tuxboat.opacity = 0
                        boatparked.opacity = 1
                        tux.visible = true
                    }
                } else {
                    items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/harbor1.wav')
                }
            }
        }
    }

    Image {
        id: boatparked
        source: activity.url + "boat_parked.svg"
        sourceSize.width: parent.width*0.15
        sourceSize.height: parent.height*0.15
        opacity: 0
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        z: 51
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    }

    Image {
        id: sun
        source: activity.url + "sun.svg"
        sourceSize.width: parent.width * 0.06
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width * 0.05
            topMargin: sun.downPosition
            onTopMarginChanged: items.sunIsUp = (anchors.topMargin != sun.downPosition)
        }
        z: 28
        property double upPosition: parent.height * 0.05
        property double downPosition: parent.height * 0.28
        MouseArea {
            id: sun_area
            anchors.fill: sun
            onClicked: {
                if(cloud.opacity == 0)
                    sun.up()
            }
        }
        Behavior on anchors.topMargin { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        function up() {
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')
            sun.anchors.topMargin = upPosition
            vapor.up()
        }
        function down() {
            sun.anchors.topMargin = downPosition
        }
    }

    Image {
        id: sea
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        sourceSize.width: parent.width
        source: activity.url + "sea.svg"
        height : (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.7
        z: 29
    }

    Image {
        id: vapor
        opacity: 0
        source: activity.url + "vapor.svg"
        sourceSize.width: parent.width*0.05
        anchors {
            left: sun.left
        }
        y: background.height * 0.28
        z: 31

        SequentialAnimation {
            id: vaporAnim
            loops: 2
            NumberAnimation {
                target: vapor
                property: "opacity"
                duration: 200
                from: 0
                to: 1
            }
            NumberAnimation {
                target: vapor
                property: "y"
                duration: 5000
                from: background.height * 0.28
                to: background.height * 0.1
            }
            NumberAnimation {
                target: vapor
                property: "opacity"
                duration: 200
                from: 1
                to: 0
            }
            NumberAnimation {
                target: vapor
                property: "y"
                duration: 0
                to: background.height * 0.28
            }
            onRunningChanged: {
            }
        }
        function up() {
            vaporAnim.start()
            cloud.up()
        }
        function down() {
        }
    }

    Image {
        id: cloud
        opacity: 0
        source: activity.url + "cloud.svg"
        sourceSize.width: parent.width * 0.20
        fillMode: Image.PreserveAspectFit
        width: 0
        anchors {
            top: parent.top
            topMargin: parent.height * 0.05
        }
        x: parent.width * 0.05
        z: 32
        MouseArea {
            id: cloud_area
            anchors.fill: cloud
            onClicked: {
                sun.down()
                rain.up()
            }
        }
        ParallelAnimation {
            id: cloudanimOn
            running: false
            PropertyAnimation {
                target: cloud
                property: 'opacity'
                easing.type: Easing.InOutQuad
                duration: 5000
                from: 0
                to: 1
            }
            PropertyAnimation {
                target: cloud
                property: 'width'
                easing.type: Easing.InOutQuad
                duration: 15000
                from: 0
                to: cloud.sourceSize.width
            }
            PropertyAnimation {
                target: cloud
                property: 'x'
                easing.type: Easing.InOutQuad
                duration: 15000
                from: background.width * 0.05
                to: background.width * 0.4
            }
        }
        function up() {
            cloudanimOn.start()
        }
        function down() {
            opacity = 0
            width = 0
            x = parent.width * 0.05
        }
    }

    Image {
        id: rain
        source: activity.url + "rain.svg"
        sourceSize.height: cloud.height * 2
        opacity: 0
        anchors {
            top: cloud.bottom
        }
        x: cloud.x
        z: 35
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        SequentialAnimation{
            id: rainAnim
            running: false
            loops: 10
            NumberAnimation {
                target: rain
                property: "scale"
                duration: 500
                to: 0.95
            }
            NumberAnimation {
                target: rain
                property: "scale"
                duration: 500
                to: 1
            }
            onRunningChanged: {
                if(!running) {
                    rain.down()
                    cloud.down()
                }
            }
        }
        function up() {
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/water.wav')
            opacity = 1
            rainAnim.start()
        }
        function down() {
            opacity = 0
        }
    }

    Image {
        id: river
        source: activity.url + "river.svg"
        sourceSize.width: parent.width * 0.415
        sourceSize.height: parent.height * 0.74
        width: parent.width * 0.415
        height: parent.height * 0.74
        opacity: level > 0 ? 1 : 0
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.1775
            leftMargin: parent.width * 0.293
        }
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        property double level: 0
    }

    Image {
        id: reservoir1
        source: activity.url + "hydroelectric/reservoir1.svg"
        sourceSize.width: parent.width * 0.06
        width: parent.width * 0.06
        height: parent.height * 0.15
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.2925
            leftMargin: parent.width * 0.3225
        }
        opacity: river.level > 0.2 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }

    Image {
        id: reservoir2
        source: activity.url + "hydroelectric/reservoir2.svg"
        sourceSize.width: parent.width*0.12
        width: parent.width * 0.12
        height: parent.height * 0.155
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.2925
            leftMargin: parent.width * 0.285
        }
        opacity: river.level > 0.5 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }

    Image {
        id: reservoir3
        source: activity.url + "hydroelectric/reservoir3.svg"
        sourceSize.width: parent.width * 0.2
        width: parent.width * 0.2
        height: parent.height * 0.17
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.29
            leftMargin: parent.width * 0.25
        }
        opacity: river.level > 0.8 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }

    Image {
        source: activity.url + "left.svg"
        width: dam.width / 2
        height: dam.height * 0.5
        z: 30
        anchors {
            left: dam.left
            leftMargin: parent.width * 0.05
            top: dam.top
        }
        Rectangle {
            width: dam_power.width * 1.1
            height: dam_power.height * 1.1
            border.color: "black"
            radius: 5
            color: items.produceColor
            anchors {
                left: parent.right
            }
            GCText {
                fontSize: smallSize * 0.5
                id: dam_power
                anchors.centerIn: parent
                text: dam.power.toString() + "W"
            }
        }
    }

    Image {
        id: dam
        source: activity.url + "hydroelectric/" + (started ? "dam.svg" : "dam_off.svg")
        width: river.width * 0.12
        sourceSize.height: parent.height * 0.08
        z: 45
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width * 0.33
            topMargin: parent.height * 0.42
        }
        MouseArea {
            id: dam_area
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: 70 * ApplicationInfo.ratio
            height: width
            onClicked: parent.started = !parent.started
        }
        property bool started: false
        property int power: started && river.level > 0.1 ? 1000 : 0
    }

    Image {
        id: damwire
        source: activity.url + "hydroelectric/damwire.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        z: 44
        visible: power > 0
        property int power: dam.power
    }

    Image {
        id: stepup1
        source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
        sourceSize.width: parent.width * 0.06
        height: parent.height * 0.09
        z: 34
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.435
            leftMargin: parent.width*0.44
        }
        property bool started: false
        property int power: started && damwire.power ? damwire.power : 0
        MouseArea {
            id: stepup1_area
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: 70 * ApplicationInfo.ratio
            height: width
            onClicked: {
                parent.started = !parent.started
            }
        }
    }

    Image {
        id: stepupwire1
        source: activity.url + "hydroelectric/stepupwire.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        z: 34
        visible: power > 0
        property int power: stepup1.power
    }

    // Manage stuff that changes periodically
    Timer {
        id: timer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if(rain.opacity > 0.2 && river.level < 1) {
                river.level += 0.01
            } else if(river.level > 0) {
                // Make the river level dependent on whether the dam runs
                river.level -= (dam.power > 0 ? 0.001 : 0.0005)
            } else {
                dam.started = false
            }
        }
    }
}
