/* GCompris - hydro.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick)
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

Item {
    id: hydro
    state: "down"
    property bool check: false
    property bool scenery: false
    IntroMessage {
        id: message
        opacity: Activity.currentLevel == 0 ? 1 : start()
        z: 20
        anchors {
            top: parent.top
            topMargin: 10
            right: parent.right
            rightMargin: 5
            left: parent.left
            leftMargin: 5
        }
        onIntroDone: {
            anim.running = true
            sun_area.visible = true
        }
        intro:[
            qsTr("Tux has come back from a long fishing party on his boat. Bring the electrical system back up so he can have light in his home. "),
            qsTr("Click on different active elements : sun, cloud, dam, solar array, wind farm and transformers, in order to reactivate the entire electrical system."),
            qsTr("When the system is back up and Tux is in his home, push the light button for him. To win you must switch on all the consumers while all the producers are up. "),
            qsTr("Learn about an electrical system based on renewable energy. Enjoy. ")
        ]
    }

    function start() {
        message.opacity = 0
        anim.running = true
        sun_area.visible = true
    }

    Image {
        id: tuxboat
        opacity: 1
        source: activity.url + "boat.svg"
        sourceSize.width: root.width*0.15
        sourceSize.height: root.height*0.15
        anchors{
            bottom: parent.bottom
            bottomMargin: 15
        }
        x: 0
        z: 20

        NumberAnimation on x {
            id: anim
            running: false
            to: root.width - tuxboat.width
            duration: 15000
            onRunningChanged: {
                if(!anim.running)
                {
                    tuxboat.opacity = 0
                    tuxparked.opacity = 1
                    tuxoff.visible = true
                    Activity.tuxreached = true
                    Activity.showtuxmeter()
                }
            }
        }
    }

    Image {
        id: tuxparked
        source: activity.url + "boat_parked.svg"
        sourceSize.width: parent.width*0.15
        sourceSize.height: parent.height*0.15
        opacity: 0
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        z: 20
    }

    Image {
        id: sun
        source: activity.url + "sun.svg"
        sourceSize.width: parent.width*0.05
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.05
            topMargin: parent.height*0.30
        }
        MouseArea {
            id: sun_area
            anchors.fill: sun
            visible: false
            onClicked: {
                sun_area.visible = false
                if(check == false){
                    hydro.state = "up"
                    check = true
                    Activity.panel()
                    cloudarea.start()
                }
                else {
                    if(Activity.currentLevel == 2) {
                        hydro.state = "rise"
                        Activity.panel()
                        sunset.start()
                    }
                }
            }
        }
    }


    Image {
        id: mask
        source: activity.url + "mask.svg"
        sourceSize.width: parent.width*0.05
        anchors{
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.05
            topMargin: parent.height*0.32
        }
    }


    Image {
        id: vapor
        opacity: 0
        state: "vapor"
        source: activity.url + "vapor.svg"
        sourceSize.width: parent.width*0.05
        anchors {
            top: mask.bottom
            left: parent.left
            leftMargin: parent.width*0.05
        }
    }


    Image {
        id: cloud
        opacity: 0
        source: activity.url + "cloud.svg"
        sourceSize.width: parent.width * 0.20
        sourceSize.height: parent.height*0.10
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 0.05*parent.width
        }
        MouseArea {
            id: cloud_area
            visible: false
            anchors.fill: cloud
            onClicked: {
                rain.visible = true
                river.visible = true
                anim2.running = true
            }
        }
        Image {
            id: rain
            source: activity.url + "rain.svg"
            height:cloud.height*2
            width: cloud.width
            anchors {
                top: cloud.bottom
            }
            visible: false
        }
    }

    Image {
        id: river
        source: activity.url + "river.svg"
        width: parent.width*0.415
        height: parent.height*0.74
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.1775
            leftMargin: parent.width*0.293
        }
        visible: false
    }

    Image {
        id: reservoir1
        source: activity.url + "hydroelectric/reservoir1.svg"
        width: parent.width*0.06
        height: parent.height*0.15
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.2925
            leftMargin: parent.width*0.3225
        }
        opacity: 0
    }

    Image {
        id: reservoir2
        source: activity.url + "hydroelectric/reservoir2.svg"
        width: parent.width*0.12
        height: parent.height*0.155
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.2925
            leftMargin: parent.width*0.285
        }
        opacity: 0
    }

    Image {
        id: reservoir3
        source: activity.url + "hydroelectric/reservoir3.svg"
        width: parent.width*0.2
        height: parent.height*0.17
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.29
            leftMargin: parent.width*0.25
        }
        opacity: 0
    }

    SequentialAnimation {
        id: anim2
        running: false

        PropertyAnimation{
            target: reservoir1
            property: "opacity"
            to: 1
        }

        PauseAnimation {
            duration: 1000
        }

        PropertyAnimation{
            target: reservoir2
            property: "opacity"
            to: 1
        }

        PauseAnimation {
            duration: 1000
        }
        PropertyAnimation{
            target: reservoir3
            property: "opacity"
            to: 1
        }
        onRunningChanged: {
            if(!anim2.running)
            {
                hydro.state = "down"
                rain.visible = false
                cloud.opacity = 0
                dam_area.visible = true
                if( Activity.currentLevel == 2) {
                    panel_timer.start()
                }
            }
        }
    }

    Image{
        source: activity.url + "left.svg"
        width: dam.width/2
        height: dam.height*0.5
        anchors {
            left:dam.left
            leftMargin: parent.width*0.05
            top: dam.top
        }
        Rectangle{
            width: dam_voltage.width*1.1
            height: dam_voltage.height*1.1
            border.color: "black"
            radius :5
            color:"yellow"
            anchors {
                left: parent.right
            }
            GCText {
                fontSize: smallSize * 0.5
                id: dam_voltage
                anchors.centerIn: parent
                text: "0 W"
            }
        }
    }

    Image {
        id: dam
        source: activity.url + "hydroelectric/dam.svg"
        width: river.width*0.12
        sourceSize.height: parent.height*0.08
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.33
            topMargin: parent.height*0.42
        }
        MouseArea{
            id: dam_area
            visible: false
            anchors.fill: dam
            onClicked:{
                anim3.running = true
            }
        }
    }


    SequentialAnimation {
        id: anim3
        running: false

        PropertyAnimation{
            target: reservoir3
            property: "opacity"
            to: 0
        }

        PauseAnimation {
            duration: 1000
        }

        PropertyAnimation{
            target: reservoir2
            property: "opacity"
            to: 0
        }

        PauseAnimation {
            duration: 1000
        }

        PropertyAnimation{
            target: reservoir1
            property: "opacity"
            to: 0
        }
        onRunningChanged: {
            if(!anim3.running)
            {
                stepup1_area.visible= true
                dam_area.visible= false
                damwire.visible = true
                dam_voltage.text = "900 W"
            }
        }
    }


    Image {
        id: damwire
        source: activity.url+ "hydroelectric/damwire.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        visible: false
    }

    Image {
        id: stepup1
        source: activity.url + "transformer.svg"
        sourceSize.width: parent.width*0.06
        height: parent.height*0.09
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height*0.435
            leftMargin: parent.width*0.44
        }
        MouseArea {
            id: stepup1_area
            visible: false
            anchors.fill: stepup1
            onClicked: {
                if(stepupwire1.visible == true){
                    stepupwire1.visible = false
                    Activity.add(-900)
                    Activity.volt(-900)
                    Activity.update()
                    Activity.verify()
                }
                else {
                    stepupwire1.visible = true
                    Activity.add(900)
                    Activity.volt(900)
                    Activity.update()
                }
            }
        }
    }

    Image {
        id: stepupwire1
        source: activity.url + "hydroelectric/stepupwire.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
        visible: false
    }


    //transitions,animations and state changes.

    states: [
        State {
            name:"up"
            AnchorChanges {
                target: sun
                anchors {
                    left: parent.left
                    top: parent.top
                }
            }
            PropertyChanges {
                target: sun
                anchors
                {
                    leftMargin: hydro.width*0.05
                    topMargin: hydro.height*0.05
                }
            }

            AnchorChanges {
                target:vapor
                anchors {
                    left: parent.left
                    top: parent.top
                }
            }
            PropertyChanges {
                target: vapor
                opacity: 1
                anchors {
                    leftMargin: hydro.width*0.05
                    topMargin: hydro.height*0.15
                }
            }
            AnchorChanges {
                target: cloud
                anchors {
                    top: parent.top
                    left: parent.left
                }
            }
            PropertyChanges {
                target: cloud
                opacity: 1
                anchors {
                    leftMargin: hydro.width*0.35
                }
            }
        } ,
        State {
            name: "down"
            AnchorChanges {
                target: sun
                anchors {
                    left: parent.left
                    top: parent.top
                }
            }

            PropertyChanges {
                target: sun
                anchors {
                    leftMargin: hydro.width*0.05
                    topMargin: hydro.height*0.30
                }
            }

            AnchorChanges {
                target: vapor
                anchors {
                    top: mask.bottom
                    left: parent.left
                }
            }

            PropertyChanges {
                target: vapor
                opacity: 0
                anchors {
                    leftMargin: hydro.width*0.05
                }
            }
        },
        State {
            name: "rise"
            AnchorChanges {
                target: sun
                anchors {
                    left: parent.left
                    top: parent.top
                }
            }

            PropertyChanges {
                target: sun
                anchors
                {
                    leftMargin: hydro.width*0.05
                    topMargin: hydro.height*0.05
                }
            }
        },

        State {
            name: "set"
            AnchorChanges {
                target: sun
                anchors {
                    left: parent.left
                    top: parent.top
                }
            }

            PropertyChanges {
                target: sun
                anchors {
                    leftMargin: hydro.width*0.05
                    topMargin: hydro.height*0.30
                }
            }
        }
    ]

    transitions: [
        Transition {
            to: "up"
            SequentialAnimation {
                id: rainform
                AnchorAnimation {
                    targets: sun
                    duration: 3000
                }

                NumberAnimation {
                    target: vapor
                    property: "opacity"
                    duration:100
                }

                AnchorAnimation {
                    targets: vapor
                    loops: 5
                    duration: 1000
                }

                NumberAnimation {
                    target: cloud
                    property: "opacity"
                    duration: 50
                }

                AnchorAnimation {
                    targets: cloud
                    duration: 3000
                }

            }
        } ,
        Transition {
            from: "up"
            to: "down"
            SequentialAnimation {
                id: down

                NumberAnimation {
                    target: vapor
                    property: "opacity"
                    duration: 100
                }

                AnchorAnimation {
                    targets: vapor
                    duration: 100
                }

                AnchorAnimation {
                    targets: sun
                    duration: Activity.currentLevel != 2 ? 3000 : 5000
                }
            }
        },
        Transition {
            to: "rise"
            AnchorAnimation {
                targets: sun
                duration: 3000
            }
        },
        Transition {
            from: "rise"
            to: "set"
            AnchorAnimation {
                targets: sun
                duration: 5000
            }
        }
    ]

    Timer {
        id: panel_timer
        interval: 5200
        running: false
        repeat: false
        onTriggered: {
            Activity.paneloff()
            Activity.panel_activate = false
            panel_timer.stop()
        }
    }

    Timer {
        id: cloudarea
        interval: 11150
        running: false
        repeat: false
        onTriggered: {
            cloud_area.visible = true
            cloudarea.stop()
        }
    }

    Timer {
        id: sunset
        interval: 15000
        running: false
        repeat: false
        onTriggered: {
            hydro.state= "set"
            panel_timer.start()
            sunset.stop()
        }
    }

    Timer {
        id: scene
        interval: 60000
        running: Activity.currentLevel == 2 ? true : false
        repeat: true
        onTriggered: {
            if(scenery == false ) {
                console.log("night")
                Activity.sceneload(true)
                sun_area.visible= false
                hydro.state = "down"
                scenery = true
                Activity.paneloff()
                Activity.panel_activate = false
                sun.visible = false
            }
            else {
                if(river.visible == false){
                    check = false
                    console.log("day")
                    Activity.sceneload(false)
                    sun_area.visible = true
                    scenery = false
                    sun.visible = true
                }
                else {
                    console.log("day")
                    Activity.sceneload(false)
                    sun_area.visible = true
                    scenery = false
                    sun.visible = true
                }
            }
        }
    }
}
