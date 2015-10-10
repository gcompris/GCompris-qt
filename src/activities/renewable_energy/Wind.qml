/* GCompris - wind.qml
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
import "renewable_energy.js" as Activity
import "../../core"

Item {
    id: wind
    property bool active: false
    Image {
        id: cloud_quiet
        opacity: 1
        source: activity.url + "wind/cloud_quiet.svg"
        sourceSize.width: parent.width * 0.20
        sourceSize.height: parent.height*0.10
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 0.05*parent.width
        }
        MouseArea {
            anchors.fill: cloud_quiet
            onClicked: {
                cloud_quiet.source = activity.url+ "wind/cloud_fury.svg"
                turbine_area.visible = true
                wind.state = "move"
                wind_timer.restart()
            }
        }
    }

    Image {
        id: wind_transformer
        source: activity.url + "transformer.svg"
        sourceSize.width: parent.width*0.035
        height: parent.height*0.06
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height*0.2
            rightMargin: parent.width*0.18
        }
        MouseArea {
            id: wind_transformer_area
            anchors.fill: wind_transformer
            visible: false
            onClicked: {
                if(active == false) {
                    wind_power.source = activity.url + "wind/windpoweron.svg"
                    active = true
                }
                else {
                    active = false
                    wind_power.source = activity.url + "wind/windpoweroff.svg"
                }
            }
        }
    }

    Image{
        sourceSize.width: wind_transformer.width/2
        sourceSize.height: wind_transformer.height/2
        source: activity.url + "down.svg"
        anchors {
            bottom: wind_transformer.top
            right: parent.right
            rightMargin: parent.width*0.20
        }

        Rectangle{
            width: windvoltage.width*1.1
            height: windvoltage.height*1.1
            border.color: "black"
            radius :5
            color:"yellow"
            anchors {
                bottom: parent.top
                right: parent.right
            }
            GCText {
                id: windvoltage
                anchors.centerIn: parent
                text: "0 W"
                fontSize: smallSize * 0.5
            }
        }
    }


    Image {
        id: wind_power
        source: activity.url + "wind/windpoweroff.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        opacity: 1
    }

    Image {
        id: wind_turbine
        source: activity.url + "wind/windturbineoff.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        opacity: 1
    }

    //wind turbines animations

    Image {
        id:turbine1
        source: activity.url + "wind/turbine1.svg"
        visible: true
        sourceSize.width: parent.width*0.15
        height: parent.height*0.15
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height*0.13
            rightMargin: parent.width*0.03
        }

    }

    MouseArea {
        anchors.fill: turbine1
        id: turbine_area
        visible: false
        onClicked: {
            wind_turbine.source= activity.url + "wind/windturbineon.svg"
            wind_transformer_area.visible = true
        }
    }

    Image {
        id:turbine2
        visible: false
        source: activity.url + "wind/turbine2.svg"
        sourceSize.width: parent.width*0.15
        height: parent.height*0.15
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height*0.13
            rightMargin: parent.width*0.03
        }
    }

    states: [
        State {
            name: "move"
            PropertyChanges {
                target: turbine1
                visible: false
            }
            PropertyChanges {
                target: turbine2
                visible: true
            }
        },
        State {
            name: "off"
            PropertyChanges {
                target: turbine2
                visible: false
            }
            PropertyChanges {
                target: turbine1
                visible: true
            }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            loops: Animation.Infinite
            NumberAnimation {
                easing.type: Easing.InQuad
                properties: "visible"
                duration: 2000
            }
        }
    }


    Timer {
        id: wind_timer
        interval: 30000
        running: false
        repeat: false
        onTriggered: active == false ? wind_reset() : wind_power_reset()
    }


    function wind_reset() {
        cloud_quiet.source = activity.url+ "wind/cloud_quiet.svg"
        wind_power.source=  activity.url + "wind/windpoweroff.svg"
        wind_turbine.source = activity.url + "wind/windturbineoff.svg"
        turbine_area.visible = false
        state = "off"
        windvoltage.text = "0 W"
        wind_transformer_area.visible = false
        wind_timer.stop()
    }

    function wind_power_reset() {
        cloud_quiet.source = activity.url+ "wind/cloud_quiet.svg"
        wind_turbine.source = activity.url + "wind/windturbineoff.svg"
        state = "off"
        wind_power.source= activity.url + "wind/windpoweroff.svg"
        wind_transformer_area.visible = false
        turbine_area.visible= false
        active = false
        Activity.add(-100)
        Activity.volt(-100)
        windvoltage.text = "0 W"
        Activity.update()
        Activity.verify()
        wind_timer.stop()
    }
}
