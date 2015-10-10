/* GCompris - renewable_energy.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0
import "../../core"
import "renewable_energy.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/renewable_energy/resource/"

    property int oldWidth: width
    onWidthChanged: {
        oldWidth: width
    }

    property int oldHeight: height
    onHeightChanged: {
        oldHeight: height
    }

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property GCAudio audioEffects: activity.audioEffects
            property int currentLevel
        }

        onStart: { Activity.start(items) }
        onStop: {
            hydro.item.stop()
        }

        Loader {
            id: hydro
            anchors.fill: parent
            source: "Hydro.qml"
        }

        Loader {
            id: wind
            anchors.fill: parent
            source: items.currentLevel > 0 ? "Wind.qml" : ""
        }

        Loader {
            id: solar
            anchors.fill: parent
            source: items.currentLevel > 1 ? "Solar.qml" : ""
        }

        IntroMessage {
            id: message
            opacity: items.currentLevel == 0 ? 1 : start()
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            onIntroDone: {
                hydro.item.start()
                message.opacity = 0
            }
            intro: [
                qsTr("Tux has come back from a long fishing party on his boat. " +
                     "Bring the electrical system back up so he can have light in his home."),
                qsTr("Click on different active elements : sun, cloud, dam, solar array, " +
                     "wind farm and transformers, in order to reactivate the entire electrical system."),
                qsTr("When the system is back up and Tux is in his home, push the light button for him. " +
                     "To win you must switch on all the consumers while all the producers are up."),
                qsTr("Learn about an electrical system based on renewable energy. Enjoy.")
            ]
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Rectangle {
            id: check
            opacity: 0
            width: 400 * ApplicationInfo.ratio
            height: 200 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            z: 3
            border.width: 2
            radius: 5
            color: "#00d635"

            GCText {
                id: warning
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr( "It is not possible to consume more electricity " +
                           "than what is produced. This is a key limitation in the " +
                           "distribution of electricity, with minor exceptions, " +
                           "electrical energy cannot be stored, and therefore it " +
                           "must be generated as it is needed. A sophisticated " +
                           "system of control is therefore required to ensure electric " +
                           "generation very closely matches the demand. If supply and demand " +
                           "are not in balance, generation plants and transmission equipment " +
                           "can shut down which, in the worst cases, can lead to a major " +
                           "regional blackout.")
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                wrapMode: Text.WordWrap
                fontSize: smallSize
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: check.opacity > 0
                onClicked: check.opacity = 0
            }
        }

        Image {
            id: stepdown
            source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
            sourceSize.width: parent.width * 0.06
            height: parent.height * 0.09
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height * 0.41
                leftMargin: parent.width * 0.72
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    onClicked: parent.started = !parent.started
                }
            }
            property bool started: false
            property double power: started ? (hydro.item.power + wind.item.power) : 0
        }

        Image {
            source:  activity.url + "right.svg"
            sourceSize.width: stepdown.width/2
            sourceSize.height: stepdown.height/2
            anchors {
                right: stepdown.left
                bottom: stepdown.bottom
                bottomMargin: parent.height*0.03
            }

            Rectangle {
                width: pow.width*1.1
                height: pow.height*1.1
                border.color: "black"
                radius :5
                color:"yellow"
                anchors {
                    top: parent.top
                    right: parent.left

                }
                GCText {
                    id: pow
                    anchors.centerIn: parent
                    fontSize: smallSize * 0.5
                    text: stepdown.power.toString() + "W"
                }
            }
        }

        Image {
            source: activity.url + "down.svg"
            sourceSize.width: stepdown.width/2
            sourceSize.height: stepdown.height/2
            anchors {
                left: stepdown.left
                top: stepdown.top
                topMargin: stepdown.height*0.8
                leftMargin: parent.width*0.05
            }


            Rectangle {
                width: stepdown_info.width*1.1
                height: stepdown_info.height*1.1
                border.color: "black"
                radius :5
                color:"red"
                anchors {
                    top: parent.bottom
                    left: parent.right
                }
                GCText {
                    id: stepdown_info
                    anchors.centerIn: parent
                    fontSize: smallSize * 0.5
                }
            }
        }

        Image {
            id: stepdownwire
            source: activity.url + "hydroelectric/stepdown.svg"
            sourceSize.width: parent.width
            anchors.fill: parent
            visible: power > 0
            property double power: stepdown.power
        }

        Image {
            id: residentsmalloff
            visible: false
            source: activity.url + "off.svg"
            sourceSize.height: parent.height * 0.03
            sourceSize.width: parent.height * 0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width * 0.55
                topMargin: parent.height * 0.65
            }
            MouseArea {
                id: small_area
                visible: false
                anchors.fill: parent
                onClicked: {
                    console.log('residentsmalloff')
                }
            }
        }

        Image {
            id: residentsmallon
            visible: false
            source: activity.url + "on.svg"
            sourceSize.height: parent.height*0.03
            sourceSize.width: parent.height*0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.55
                topMargin: parent.height*0.65
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("residentsmallon")
                }
            }
        }

        Image {
            id: residentbigoff
            visible: false
            source: activity.url + "off.svg"
            sourceSize.height: parent.height*0.03
            sourceSize.width: parent.height*0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.60
                topMargin: parent.height*0.65
            }
            MouseArea {
                id: big_area
                visible: false
                anchors.fill: parent
                onClicked: {
                    console.log('residentbigoff')
                }
            }
        }

        Image {
            id: residentbigon
            visible: false
            source: activity.url + "on.svg"
            sourceSize.height: parent.height*0.03
            sourceSize.width: parent.height*0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.60
                topMargin: parent.height*0.65
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log('residentbigon')
                }
            }
        }

        Image {
            id: resident_smalllights
            source: activity.url+ "resident_smallon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.fill: parent
            visible: false
        }

        Rectangle{
            id: small_consume_rect
            width: small_consume.width*1.1
            height: small_consume.height*1.1
            border.color: "black"
            radius: 5
            color:"yellow"
            anchors {
                top: residentsmallon.bottom
                left:residentsmallon.left
            }
            GCText {
                id: small_consume
                anchors.centerIn: parent
                text: "0 W"
                fontSize: smallSize * 0.5
            }
            visible: false
        }


        Image {
            id: resident_biglights
            source: activity.url+ "resident_bigon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.fill: parent
            visible: false
        }

        Rectangle {
            id: big_consume_rect
            width: big_consume.width * 1.1
            height: big_consume.height * 1.1
            border.color: "black"
            radius : 5
            color: "yellow"
            anchors {
                top: residentbigon.bottom
                left: small_consume_rect.right
                leftMargin: parent.width * 0.05
            }
            GCText {
                id: big_consume
                anchors.centerIn: parent
                text: "0 W"
                fontSize: smallSize * 0.5
            }
            visible: false
        }

        // Tux is visible when tuxboat animation stops
        // It's light can be activated after stepdown is on

        Image {
            id: tux
            source: activity.url + (on ? "lightson.svg" : "lightsoff.svg")
            sourceSize.height: parent.height * 0.2
            sourceSize.width: parent.width * 0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height * 0.3
                rightMargin: parent.width * 0.02
            }
            visible: false
            property double power_consumed: on ? 50 : 0
            property bool on: stepdown.power > 50 && tux_switch.on

            Image {
                id: tux_switch
                source: activity.url + (on ? "on.svg" : "off.svg")
                sourceSize.height: parent.height*0.20
                sourceSize.width: parent.height*0.20
                property bool on: false
                anchors {
                    right: tux.right
                    top: tux.top
                    rightMargin: tux.width * 0.20
                    topMargin: tux.height * 0.30
                }
                MouseArea {
                    id: off_area
                    anchors.fill: parent
                    onClicked: {
                        tux_switch.on = !tux_switch.on
                    }
                }
            }
        }

        Rectangle {
            id: tux_meter
            width: tux_consume.width * 1.1
            height: tux_consume.height * 1.1
            border.color: "black"
            radius : 5
            color: "yellow"
            anchors {
                top: tux.top
                left: tux.left
                leftMargin: tux.width * 0.2
            }
            GCText {
                id: tux_consume
                anchors.centerIn: parent
                fontSize: smallSize * 0.5
                text: tux.power_consumed.toString() + "W"
            }
            visible: tux.visible
        }

        function win() {
            items.bonus.good("flower")
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
            level: items.currentLevel + 1
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
