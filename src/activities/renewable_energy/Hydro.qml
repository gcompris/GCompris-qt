/* GCompris - hydro.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Big refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"

Item {
    id: hydro
    property alias power: stepup.power
    property alias cloudOpacity: cloud.opacity
    property alias vaporAnimLoop: vapor.animLoop
    property alias vaporIsUp: vapor.isUp
    property alias cloudIsUp: cloud.isUp

    function start() {
        tuxboat.state = "tuxboatRight"
        items.sunIsUp = false
    }

    function stop() {
        tuxboat.state = "tuxboatRestarted"
        dam.started = false
        river.level = 0
        items.sunIsUp = false
        vapor.animLoop = false
        vapor.isUp = false
        rain.down()
        cloud.isUp = false
        stepup.started = false
    }

    function stopTimer() {
        timer.stop();
    }

    Image {
        id: tuxboat
        source: activity.url2 + "boat.svg"
        width: parent.width * 0.12
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        anchors{
            bottom: parent.bottom
            bottomMargin: parent.width * 0.02
            left: parent.left
            leftMargin: 0
        }
        z: 51
        state: "tuxboatLeft"
        states: [
            State {
                name: "tuxboatLeft"
                PropertyChanges {
                    target: tuxboat
                    anchors.leftMargin: 0
                    opacity: 1
                }
            },
            State {
                name: "tuxboatRight"
                PropertyChanges {
                    target: tuxboat
                    anchors.leftMargin: layoutArea.width - tuxboat.width
                    opacity: 0
                }
            },
            State {
                name: "tuxboatRestarted"
                PropertyChanges {
                    target: tuxboat
                    anchors.leftMargin: layoutArea.width - tuxboat.width
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                from: "tuxboatLeft"; to: "tuxboatRight";
                SequentialAnimation {
                    ScriptAction { script: items.audioEffects.play("qrc:/gcompris/src/activities/watercycle/resource/harbor1.wav") }
                    NumberAnimation { property: "anchors.leftMargin"; easing.type: Easing.InOutSine; duration: 15000 }
                    ScriptAction { script: items.audioEffects.play("qrc:/gcompris/src/activities/watercycle/resource/harbor2.wav") }
                    NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 200 }
                    ScriptAction { script: {
                            boatparked.opacity = 1;
                            tux.visible = true;
                        }
                    }
                }
            },
            Transition {
                from: "tuxboatRight"; to: "tuxboatLeft";
                PropertyAction { properties: "anchors.leftMargin, opacity" }
                ScriptAction { script: boatparked.opacity = 0 }
            },
            Transition {
                from: "tuxboatRight, tuxboatLeft"; to: "tuxboatRestarted"
                PropertyAction { properties: "anchors.leftMargin, opacity" }
                ScriptAction { script: {
                        boatparked.opacity = 1;
                        tux.visible = true;
                    }
                }
            }
        ]
    }

    Image {
        id: boatparked
        source: activity.url2 + "boat_parked.svg"
        width: parent.width * 0.12
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        opacity: 0
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: tuxboat.anchors.bottomMargin
        }
        z: 51
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    }

    Image {
        id: vapor
        opacity: 0
        source: activity.url2 + "vapor.svg"
        width: parent.width * 0.1
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        property bool isUp: false
        property bool animLoop: false
        anchors {
            left: parent.left
            top: parent.top
            topMargin: parent.width * 0.28
            leftMargin: parent.width * 0.056
        }
        z: 31

        onIsUpChanged: {
            if(isUp)
                state = "vaporUp"
            else
                state = "vaporDown"
        }

        state: "vaporDown"
        states: [
            State {
                name: "vaporDown"
                PropertyChanges {
                    target: vapor
                    opacity: 0
                    anchors.topMargin: parent.width * 0.28
                }
            },
            State {
                name: "vaporUp"
                PropertyChanges {
                    target: vapor
                    opacity: 1
                    anchors.topMargin: parent.width * 0.1
                }
            }
        ]

        transitions: [
            Transition {
                from: "vaporDown"; to: "vaporUp";
                SequentialAnimation {
                    NumberAnimation { property: "opacity"; duration: 200 }
                    NumberAnimation { property: "anchors.topMargin"; duration: 5000 }
                    ScriptAction { script: vapor.isUp = false }
                }
            },
            Transition {
                from: "vaporUp"; to: "vaporDown";
                SequentialAnimation {
                    NumberAnimation { property: "opacity"; duration: 200 }
                    PropertyAction { property: "anchors.topMargin" }
                    ScriptAction { script: {
                            if(vapor.animLoop === true) {
                                vapor.animLoop = false;
                                vapor.isUp = true;
                            }
                        }
                    }
                }
            }
        ]
    }

    Image {
        id: cloud
        opacity: 0
        source: activity.url2 + "cloud.svg"
        sourceSize.width: parent.width * 0.256
        fillMode: Image.PreserveAspectFit
        width: 0
        property bool isUp: false
        property double originMargin: parent.width * 0.05
        property double upMargin: parent.width * 0.38
        anchors {
            top: parent.top
            topMargin: originMargin
            left: parent.left
            leftMargin: originMargin
        }
        z: 32
        MouseArea {
            id: cloud_area
            anchors.fill: cloud
            enabled: cloud.width > cloud.sourceSize.width * 0.8 && !rain.isRaining
            onClicked: {
                items.sunIsUp = false
                rain.up()
            }
        }

        onIsUpChanged: {
            if(isUp)
                state = "cloudIsUp"
            else
                state = "cloudIsDown"
        }
        state: "cloudIsDown"
        states: [
            State {
                name: "cloudIsDown"
                PropertyChanges {
                    target: cloud
                    opacity: 0
                    width: 0
                    anchors.leftMargin: cloud.originMargin
                }
            },
            State {
                name: "cloudIsUp"
                PropertyChanges {
                    target: cloud
                    opacity: 1
                    width: cloud.sourceSize.width
                    anchors.leftMargin: cloud.upMargin
                }
            }
        ]

        transitions: [
            Transition {
                from: "cloudIsDown"; to: "cloudIsUp";
                NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 5000 }
                NumberAnimation { properties: "width, anchors.leftMargin"; easing.type: Easing.InOutQuad; duration: 15000 }
            },
            Transition {
                from: "cloudIsUp"; to: "cloudIsDown";
                PropertyAction { properties: "opacity, width, anchors.leftMargin" }
            }
        ]
    }

    Image {
        id: rain
        source: activity.url2 + "rain.svg"
        width: parent.width * 0.146
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        opacity: 0
        property bool isRaining: false
        anchors {
            top: parent.top
            topMargin: parent.width * 0.123
            left: cloud.left
            leftMargin: cloud.width * 0.25
        }
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
                    cloud.isUp = false
                }
            }
        }
        function up() {
            isRaining = true;
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/water.wav');
            opacity = 1;
            rainAnim.start();
        }
        function down() {
            isRaining = false;
            scale = 0;
            opacity = 0
        }
    }

    Image {
        id: river
        source: activity.url2 + "river.svg"
        width: parent.width * 0.431
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        opacity: level > 0 ? 1 : 0
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.3309
            leftMargin: parent.width * 0.292
        }
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        property double level: 0
    }

    Image {
        id: reservoir1
        source: activity.url2 + "reservoir1.svg"
        width: layoutArea.width * 0.112
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.3309
            leftMargin: parent.width * 0.2948
        }
        opacity: river.level > 0.2 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }

    Image {
        id: reservoir2
        source: activity.url2 + "reservoir2.svg"
        width: layoutArea.width * 0.1604
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.3309
            leftMargin: parent.width * 0.2691
        }
        opacity: river.level > 0.5 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }

    Image {
        id: reservoir3
        source: activity.url2 + "reservoir3.svg"
        width: layoutArea.width * 0.1965
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.3309
            leftMargin: parent.width * 0.2532
        }
        opacity: river.level > 0.8 ? 1 : 0
        z: 40
        Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
    }


    Rectangle {
        z: 100
        width: stepup_power.width * 1.1
        height: stepup_power.height * 1.1
        border.color: items.produceColorBorder
        radius: 5
        color: items.produceColor
        anchors {
            bottom: stepup.top
            right: stepup.horizontalCenter
        }
        GCText {
            fontSize: smallSize * 0.5
            id: stepup_power
            anchors.centerIn: parent
            text: stepup.power.toString() + "W"
        }
    }

    Image {
        id: dam
        source: activity.url + "hydroelectric/dam_off.svg"
        width: parent.width * 0.102
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        z: 45
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width * 0.299
            topMargin: parent.width * 0.383
        }
        MouseArea {
            id: dam_area
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: parent.width * 1.2
            height: parent.width * 1.2
            enabled: river.opacity > 0
            onClicked: parent.started = !parent.started
        }
        property bool started: false
        property int power: started && river.level > 0.1 ? 1000 : 0
    }

    Image {
        id: damOn
        source:  activity.url + "hydroelectric/dam_on.svg"
        anchors.fill: dam
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        visible: dam.started
        z: 45
    }

    Image {
        id: damWire
        source: activity.url + "hydroelectric/damwire_off.svg"
        width: parent.width * 0.095
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width * 0.372
            topMargin: parent.width * 0.45
        }
        z: 44
    }

    Image {
        id: damWireOn
        source: activity.url + "hydroelectric/damwire_on.svg"
        anchors.fill: damWire
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        z: 44
        visible: dam.power > 0
    }

    Image {
        id: stepup
        source: activity.url + "transformer_off.svg"
        width: parent.width * 0.07
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        z: 46
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.399
            leftMargin: parent.width * 0.445
        }
        property bool started: false
        property int power: started && dam.power ? dam.power : 0
        MouseArea {
            id: stepup_area
            anchors.centerIn: parent
            // Size the area for a touch screen
            width: parent.width * 1.2
            height: parent.width * 1.2
            onClicked: {
                parent.started = !parent.started
            }
        }
    }

    Image {
        id: stepupOn
        source: activity.url + "transformer_on.svg"
        anchors.fill: stepup
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        visible: stepup.started
        z: 46
    }

    Image {
        id: stepupWire
        source: activity.url + "hydroelectric/stepupwire_off.svg"
        width: parent.width * 0.265
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.width * 0.387
            leftMargin: parent.width * 0.478
        }
        z: 44
    }

    Image {
        id: stepupWireOn
        source: activity.url + "hydroelectric/stepupwire_on.svg"
        anchors.fill: stepupWire
        sourceSize.width: width
        fillMode:Image.PreserveAspectFit
        visible: stepup.power > 0
        z: 44
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
