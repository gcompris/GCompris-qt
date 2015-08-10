/* GCompris - watercycle.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>(GTK+ version)
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
import "."
import "watercycle_text.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/watercycle/resource/"
    property bool shower_activate: false
    property bool cycle_done: false

    property int  oldWidth: width
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

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property int count: 0
            property alias bonus: bonus
            property var dataset: Dataset.dataset
            property GCAudio audioEffects: activity.audioEffects
        }

        IntroMessage {
            id: message
            onIntroDone: {
                anim.running = true
                info.visible = true
                sun_area.visible = true

            }
            intro: [
                qsTr("The Water Cycle (also known as the hydrologic cycle) is the journey water takes"
                     +" as it circulates from the land to the sky and back again."
                     +" The Sun's heat provides energy to evaporate water from water bodies like oceans.") ,
                qsTr(" Plants also lose water to the air through transpiration. The water vapor eventually, "
                     +" cools forming tiny droplets in clouds. When the clouds meet cool air over land, "
                     +" precipitation is triggered and fall down as rain.") ,
                qsTr("Some of the water is trapped between rock or clay layers, called groundwater."
                     +" But most of the water flows as runoff, eventually returning to the seas via rivers."),
                qsTr("Your goal is to complete water cycle before Tux reaches home."
                     +" Click on the different components which make up the Water Cycle."
                     +" First click on sun, then cloud, then motor near the river and"
                     +" at last regulate the switch to provide water to Tux's bathroom."),
                qsTr("There is text guide to help you in understanding the course of water cycle. "
                     +"Learn and Enjoy.")
            ]
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }

            z: 20
        }

        Image {
            id: sky
            anchors.top: parent.top
            sourceSize.width: parent.width
            source: activity.url + "sky.svg"
            height: (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.3
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
        }

        Image {
            id: landscape
            anchors.fill: parent
            sourceSize.width: parent.width
            source: activity.url + "landscape.svg"
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
            x:0
            z:20

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
                        shower.visible = true
                        tuxoff.visible = true
                        showercold.visible = true
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
            MouseArea{
                id: sun_area
                visible: false
                anchors.fill: sun
                onClicked: {
                    sun_info.running = true
                    background.state = "up"
                    cloud_timer.start()
                    sun_area.visible = false
                }
            }
        }

        SequentialAnimation  {
            id: sun_info
            running: false

            ScriptAction {
                script: background.next()
            }

            PauseAnimation {
                duration: 3000
            }

            ScriptAction {
                script: background.next()
            }

            PauseAnimation {
                duration: 5000
            }

            ScriptAction {
                script: background.next()
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
                    background.state = "down"
                    sun_area.visible = false
                    rain.visible = true
                    cloud_info.running = true
                    river_fill.running = true
                    cloud_opacity.start()
                    cloud_area.visible = false
                    river.visible = true
                }
            }
            NumberAnimation on opacity {
                id: cloud_vanish
                running: false
                from: 1
                to: 0
                duration: 5000
            }
        }

        Image {
            id: rain
            source: activity.url + "rain.svg"
            height:cloud.height*2
            width: cloud.width
            anchors {
                top: cloud.bottom
                left: parent.left
                leftMargin: 0.3*parent.width
            }
            visible: false
        }


        SequentialAnimation{
            id: cloud_info
            running: false
            ScriptAction {
                script: background.next()
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
            source: activity.url + "reservoir1.svg"
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
            source: activity.url + "reservoir2.svg"
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
            source: activity.url + "reservoir3.svg"
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
            id: river_fill
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
                if(!river_fill.running)
                {
                    motor_area.visible = true
                }
            }
        }


        SequentialAnimation {
            id: river_empty
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
        }


        Image {
            id: motor
            source: activity.url + "motor.svg"
            width: parent.width*0.07
            height: parent.height*0.08
            anchors {
                top: parent.top
                left:parent.left
                topMargin: parent.height*0.38
                leftMargin: parent.width*0.4
            }
            MouseArea {
                id: motor_area
                visible: false
                anchors.fill: motor
                onClicked: {
                    motor_info.running = true
                    motor_area.visible = false
                    fillwater.opacity = 1
                    towerfull.visible = true
                    anim3.running = true
                    river_empty.running = true
                    waste_area.visible = true
                }
            }
        }



        SequentialAnimation{
            id: motor_info
            running: false

            ScriptAction {
                script: {
                    background.next()
                    wastearea()
                }
            }

            PauseAnimation {
                duration: 10000
            }

            ScriptAction {
                script: background.next()
            }
        }

        function wastearea() {
            waste_area.visible = false
        }

        Image {
            id: tower
            source: activity.url + "watertower.svg"
            sourceSize.width: parent.width*0.18
            sourceSize.height: parent.height*0.15
            anchors {
                top: parent.top
                right: parent.right
                topMargin: parent.height*0.225
                rightMargin: parent.width*0.175
            }

            Image {
                id: towerfull
                scale: 0
                source: activity.url + "watertowerfill.svg"
                sourceSize.width: tower.width*0.4
                anchors {
                    top: tower.top
                    left:tower.left
                    topMargin: tower.height*0.13
                    leftMargin: tower.width*0.3
                }

                NumberAnimation on scale{
                    id: anim2
                    running: false
                    to: 0
                    duration: 10000
                }

                NumberAnimation on scale{
                    id: anim3
                    running: false
                    from: 0
                    to: 1
                    duration: 10000

                    onRunningChanged: {
                        console.log(wastewater.opacity)
                        if(!anim3.running &&  shower_activate == false && cycle_done == false ){
                            shower_area.visible = true
                            shower_activate = true
                        }
                    }
                }
                visible: false
            }
            visible: true
        }

        Image {
            id: shower
            source: activity.url + "shower.svg"
            height: parent.height*0.2
            width: parent.width*0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height* 0.32
                rightMargin: parent.width*0.012
            }
            visible: false
        }

        Image {
            id: tuxoff
            source:activity.url + "tuxoff.svg"
            height: shower.height*0.4
            width: shower.width*0.2
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height*0.1
                horizontalCenterOffset: -shower.width*0.05
            }
            visible: false
        }

        Image {
            id: tuxbath
            source: activity.url + "tuxbath.svg"
            height: shower.height*0.5
            width: shower.width*0.3
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height*0.1
                horizontalCenterOffset: -shower.width*0.05
            }
            visible: false
        }

        Image {
            id: showerhot
            source: activity.url + "showerhot.svg"
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width*0.15
                topMargin: shower.height*0.25
            }
            visible: false
        }

        Image {
            id: showercold
            source: activity.url + "showercold.svg"
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width*0.15
                topMargin: shower.height*0.25
            }
            visible: false
        }

        MouseArea {
            id: shower_area
            visible: false
            anchors.fill: shower
            onClicked: {
                console.log(wastewater.opacity)
                if(wastewater.opacity == 0.4 && shower_activate == true && cycle_done == false) {
                    showerhot.visible = true
                    tuxbath.visible = true
                    showercold.visible = false
                    tuxoff.visible = false
                    anim2.running = true
                    shower_info.running = true
                    empty_water.running = true
                    shower_area.visible = false
                }
            }
        }


        SequentialAnimation {
            id: shower_info
            running: false

            ScriptAction {
                script: background.next()
            }

            PauseAnimation {
                duration: 11000
            }
            ScriptAction {
                script: showercheck()
            }

            PauseAnimation {
                duration: 200
            }

            ScriptAction {
                script:cyclecomplete()
            }

            PauseAnimation {
                duration: 2000
            }

            ScriptAction {
                script: background.next()
            }
            onRunningChanged: {
                if(!shower_info.running)
                {
                    waste_area.visible = true
                }
            }
        }


        Image {
            id: fillwater
            anchors.fill: parent
            sourceSize.width: parent.width
            source: activity.url + "fillwater.svg"
            opacity: 0.1
            NumberAnimation on opacity{
                id: empty_water
                from: 1
                to: 0.5
                running: false
                duration: 10000
            }
            NumberAnimation on opacity{
                id: fill_water
                from: 0.5
                to: 1
                running: false
                duration: 10000
            }
        }

        Image {
            id: wastewater
            anchors.fill: parent
            sourceSize.width: parent.width
            source: activity.url + "wastewater.svg"
            opacity: 0
            NumberAnimation on opacity  {
                id: waste_activate
                from: 0
                to: 0.4
                running: false
                duration: 1
            }
            NumberAnimation on opacity{
                id: waste_flow
                from: 1
                to: 0.4
                running: false
                duration: 5000
            }
            NumberAnimation on opacity{
                id: waste_fetch
                from: 0.4
                to: 1
                running: false
                duration: 5000
            }
        }

        Image {
            id: waste
            source: activity.url + "waste.svg"
            height: parent.height*0.15
            width: parent.width*0.1
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.74
                leftMargin: parent.width*0.66
            }
            MouseArea {
                id: waste_area
                visible: false
                anchors.fill: waste
                onClicked: {
                    if(wastewater.opacity == 0) {
                        waste_area.visible == false
                        waste_activate.running = true
                    }
                    else if(wastewater.opacity == 0.4 && shower_activate == false){
                        waste_info.running = true
                        waste_area.visible = false
                        waste_fetch.running = true
                    }
                }
            }
        }

        SequentialAnimation{
            id: waste_info
            running: false

            PauseAnimation {
                duration: 5000
            }

            ScriptAction {
                script: background.next()
            }

            PauseAnimation {
                duration: 5000
            }

            ScriptAction {
                script: waste_collect()
            }

            PauseAnimation {
                duration: 5000
            }

            ScriptAction {
                script: background.next()
            }


            PauseAnimation {
                duration: 5000
            }

            ScriptAction {
                script: reset()
            }

        }


        states: [ State {
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
                        leftMargin: parent.width*0.05
                        topMargin: parent.height*0.05
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
                        leftMargin: parent.width*0.05
                        topMargin: parent.height*0.15
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
                        leftMargin: parent.width*0.35
                    }
                }
            } ,
            State {
                name: "down"
                AnchorChanges {
                    target: sun
                    anchors {
                        left:parent.left
                        top:parent.top
                    }
                }
                PropertyChanges {
                    target: sun
                    anchors {
                        leftMargin: parent.width*0.05
                        topMargin: parent.height*0.30
                    }
                }

                PropertyChanges {
                    target: vapor
                    opacity: 0
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
                        leftMargin: parent.width*0.35
                    }
                }
            },
            State {
                name: "origin"
                AnchorChanges {
                    target: cloud
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                }
                PropertyChanges {
                    target: cloud
                    opacity: 0
                    anchors {
                        leftMargin: parent.width*0.05
                    }
                }
            }
        ]

        transitions: [
            Transition {
                to: "up"
                SequentialAnimation {

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

                    NumberAnimation {
                        target: vapor
                        property: "opacity"
                        duration: 100
                    }

                    AnchorAnimation {
                        targets: sun
                        duration: 5000
                    }
                }
            }
        ]


        GCText {
            id: info
            visible: false
            fontSize: smallSize
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: parent.top
                topMargin: 10 *ApplicationInfo.ratio
                right: parent.right
                rightMargin: 5 * ApplicationInfo.ratio
                left: parent.left
                leftMargin: parent.width*0.50
            }
            width: parent.width
            wrapMode: Text.WordWrap
            text: items.dataset[items.count].text
        }

        //functions for different checkpoints.

        function next() {
            if(items.count <= items.dataset.length - 2)
            {
                items.count++
            }
            else {
                items.count = 0
            }
        }

        function cyclecomplete(){
            items.bonus.good("smiley")
        }


        function showercheck(){
            if( !anim2.running )
            {
                anim3.running = true
                showercold.visible = true
                tuxoff.visible = true
                showerhot.visible = false
                tuxbath.visible = false
                shower_area.visible = false
                fill_water.running = true
                shower_activate = false
                cycle_done = true
            }
        }

        function waste_collect()
        {
            waste_flow.running = true
        }

        function reset() {
            sun_area.visible = true
            background.next()
            towerfull.scale = 0
            towerfull.visible = false
            river_fill.running = false
            river_empty.running = false
            anim2.running = false
            anim3.running = false
            shower_area.visible = false
            background.state = "origin"
            fillwater.opacity = 0
            river.visible = false
            shower_activate = false
            wastewater.opacity = 0
            cycle_done = false
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id:bonus
        }

        Timer {
            id: cloud_timer
            running: false
            repeat: false
            interval: 11150
            onTriggered: {
                cloud_area.visible= true
                cloud_timer.stop()
            }
        }

        Timer {
            id: cloud_opacity
            repeat: false
            running: false
            onTriggered: {
                rain.visible= false
                cloud_vanish.running= true
            }
        }
    }
}
