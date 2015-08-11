/* GCompris - renewable_energy.qml
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

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/renewable_energy/resource/"

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

        property bool transformer: false

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
            property alias daysky: daysky
        }

        Image {
            id: daysky
            anchors.top: parent.top
            sourceSize.width: parent.width
            source: activity.url + "sky.svg"
            height: (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.3
            visible: true
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
            visible: true
        }

        Image {
            id: moon
            source: activity.url + "moon.svg"
            sourceSize.width: parent.width*0.05
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.1
                topMargin: parent.height*0.05
            }
            opacity: 0
            NumberAnimation on opacity {
                id:  moon_rise
                running: false
                from: 0
                to: 1
                duration: 10000
            }
            NumberAnimation on opacity {
                id:  moon_set
                running: false
                from: 1
                to: 0
                duration: 10000
            }
        }

        Timer {
            id: moon_anim
            running: false
            repeat: true
            interval: 50000
            onTriggered: if(Activity.scene == false) {
                             moon_rise.running = true
                             anim_pause.start()
                             moon_anim.stop()
                         }
                         else {
                             moon_set.running = true
                             anim_pause.start()
                             moon_anim.stop()
                         }
        }

        Timer {
            id: anim_pause
            running: false
            interval: 10000
            repeat: false
            onTriggered: {
                anim_pause.stop()
                moon_anim.start()
            }
        }

        Image {
            id: landscape
            anchors.fill: parent
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            source: activity.url + "landscape.svg"
        }

        Rectangle {
            id: check
            visible: false
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
                text: qsTr( "It is not possible to consume more electricity "+
                           "than what is produced. This is a key limitation in the "+
                           "distribution of electricity, with minor exceptions, "+
                           "electrical energy cannot be stored, and therefore it "+
                           "must be generated as it is needed. A sophisticated "+
                           "system of control is therefore required to ensure electric "+
                           "generation very closely matches the demand. If supply and demand "+
                           "are not in balance, generation plants and transmission equipment "+
                           "can shut down which, in the worst cases, can lead to a major "+
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
                onClicked: check.visible = false
            }
        }

        Image {
            id: stepdown
            source: activity.url + "transformer.svg"
            sourceSize.width: parent.width*0.06
            height: parent.height*0.09
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.41
                leftMargin: parent.width*0.72
            }
            MouseArea {
                anchors.fill: stepdown
                onClicked: {
                    power()
                    if( Activity.power > 0 ) {
                        stepdownwire.visible = true
                    }
                    else {
                        stepdownwire.visible = false
                    }
                }
            }
        }

        Image{
            source:  activity.url + "right.svg"
            sourceSize.width: stepdown.width/2
            sourceSize.height: stepdown.height/2
            anchors {
                right:stepdown.left
                bottom:stepdown.bottom
                bottomMargin: parent.height*0.03
            }


            Rectangle{
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
                }
            }
        }

        Image{
            source: activity.url + "down.svg"
            sourceSize.width: stepdown.width/2
            sourceSize.height: stepdown.height/2
            anchors {
                left: stepdown.left
                top: stepdown.top
                topMargin: stepdown.height*0.8
                leftMargin: parent.width*0.05
            }


            Rectangle{
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
            visible: false
        }

        Image {
            id: residentsmalloff
            visible: false
            source: activity.url + "off.svg"
            sourceSize.height: parent.height*0.03
            sourceSize.width: parent.height*0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.55
                topMargin: parent.height*0.65
            }
            MouseArea {
                id: small_area
                visible: false
                anchors.fill: residentsmalloff
                onClicked: {
                    if( Activity.power >= 300 && stepdownwire.visible == true) {
                        Activity.add(-300)
                        resident_smalllights.visible = true
                        residentsmalloff.visible = false
                        residentsmallon.visible = true
                        Activity.consume(300)
                        Activity.update()
                        small_consume.text = "300 W"
                        checkbonus()
                    }
                    else {
                        if(stepdownwire.visible == true)
                        {
                            check.visible= true
                        }
                    }
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
                anchors.fill: residentsmallon
                onClicked: {
                    Activity.add(300)
                    Activity.consume(-300)
                    resident_smalllights.visible = false
                    residentsmallon.visible = false
                    residentsmalloff.visible = true
                    small_consume.text= "0 W"
                    Activity.update()

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
                anchors.fill: residentbigoff
                onClicked: {
                    if( Activity.power >= 600 && stepdownwire.visible == true) {
                        Activity.add(-600)
                        resident_biglights.visible = true
                        residentbigoff.visible = false
                        residentbigon.visible = true
                        Activity.consume(600)
                        Activity.update()

                        big_consume.text = "600 W"
                        checkbonus()
                    }
                    else {
                        if(stepdownwire.visible == true)
                        {
                            check.visible = true
                        }
                    }
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
                anchors.fill: residentbigon
                onClicked: {
                    Activity.add(600)
                    Activity.consume(-600)
                    residentbigon.visible = false
                    residentbigoff.visible = true
                    resident_biglights.visible = false
                    Activity.update()

                    big_consume.text = "0 W"
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

        Rectangle{
            id: big_consume_rect
            width: big_consume.width*1.1
            height: big_consume.height*1.1
            border.color: "black"
            radius :5
            color:"yellow"
            anchors {
                top: residentbigon.bottom
                left: small_consume_rect.right
                leftMargin: parent.width*0.05
            }
            GCText {
                id: big_consume
                anchors.centerIn: parent
                text: "0 W"
                fontSize: smallSize * 0.5
            }
            visible: false
        }

        //tuxoff is visible when tuxboat animation stops and on is activated after stepdown is activated.

        Image {
            id: tuxoff
            source: activity.url + "lightsoff.svg"
            sourceSize.height: parent.height*0.2
            sourceSize.width: parent.width*0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height* 0.3
                rightMargin: parent.width*0.02
            }
            visible: false
            Image {
                id: off
                source: activity.url + "off.svg"
                sourceSize.height: parent.height*0.20
                sourceSize.width: parent.height*0.20
                anchors {
                    right: tuxoff.right
                    top: tuxoff.top
                    rightMargin: tuxoff.width*0.20
                    topMargin: tuxoff.height*0.30
                }
                MouseArea {
                    id: off_area
                    visible: false
                    anchors.fill: off
                    onClicked: {
                        if( Activity.power >= 100 && stepdownwire.visible == true) {
                            Activity.add(-100)
                            tuxon.visible = true
                            tuxoff.visible = false
                            Activity.consume(100)
                            Activity.update()

                            checkbonus()
                            tux_consume.text = "100 W"
                        }
                    }
                }
            }
        }

        Image {
            id: tuxon
            source: activity.url + "lightson.svg"
            sourceSize.height: parent.height*0.2
            sourceSize.width: parent.width*0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height* 0.3
                rightMargin: parent.width*0.02
            }
            Image {
                id: on
                source: activity.url + "on.svg"
                sourceSize.height: parent.height*0.20
                sourceSize.width: parent.height*0.20
                anchors {
                    right: tuxon.right
                    top: tuxon.top
                    rightMargin: tuxon.width*0.20
                    topMargin: tuxon.height*0.30
                }
                MouseArea {
                    anchors.fill: on
                    onClicked: {
                        Activity.add(100)
                        Activity.consume(-100)
                        tuxon.visible = false
                        tuxoff.visible = true
                        Activity.update()
                        tux_consume.text = "0 W"
                    }
                }
            }
            visible: false
        }

        Rectangle{
            id: tux_meter
            width: tux_consume.width*1.1
            height: tux_consume.height*1.1
            border.color: "black"
            radius :5
            color:"yellow"
            anchors {
                top: tuxon.bottom
                left: tuxon.left
            }
            GCText {
                id: tux_consume
                anchors.centerIn: parent
                text: "0 W"
                fontSize: smallSize * 0.5
            }
            visible: false
        }


        function initiate() {
            unload()
            reload()
            power()
        }

        Loader {
            id: hydro
            anchors.fill: parent
        }

        Loader {
            id: wind
            anchors.fill: parent
        }

        Loader {
            id: solar
            anchors.fill: parent
        }

        function unload( )
        {
            pow.text = "0 W"
            stepdown_info.text = "0 W"
            stepdownwire.visible = false
            off_area.visible = false
            small_area.visible = false
            big_area.visible = false
            tuxon.visible = false
            tuxoff.visible = false
            residentsmalloff.visible = false
            residentsmallon.visible= false
            residentbigoff.visible = false
            residentbigon.visible = false
            resident_smalllights.visible = false
            resident_biglights.visible = false
            small_consume_rect.visible = false
            big_consume_rect.visible = false
            tux_meter.visible = false
            small_consume.text = "0 W"
            big_consume.text= "0 W"
            tux_consume.text = "0 W"
            wind.source = ""
            hydro.source =""
            solar.source = ""
            moon_set.running = false
            moon_rise.running = false
            moon.opacity = 0
            moon_anim.running= false
            daysky.source = activity.url + "sky.svg"
        }

        function reload() {
            if(Activity.currentLevel == 0) {
                hydro.source = "Hydro.qml"
            }
            if(Activity.currentLevel == 1) {
                wind.source = "Wind.qml"
                hydro.source = "Hydro.qml"
                residentsmalloff.visible = true
                small_consume_rect.visible = true

            }
            if(Activity.currentLevel == 2) {
                solar.source = "Solar.qml"
                wind.source = "Wind.qml"
                hydro.source = "Hydro.qml"
                residentsmalloff.visible = true
                residentbigoff.visible = true
                small_consume_rect.visible = true
                big_consume_rect.visible = true
                daysky.source = activity.url + "sky.svg"
                moon_anim.running = true
            }
        }

        function power() {
            if(Activity.currentLevel == 0 && Activity.power >= 0 ) {
                off_area.visible = true
            }
            if(Activity.currentLevel == 1 && Activity.power >= 0) {
                off_area.visible = true
                small_area.visible = true
            }
            if(Activity.currentLevel == 2 && Activity.count >= 0 ) {
                off_area.visible = true
                small_area.visible = true
                big_area.visible = true
            }
        }

        function tux() {
            Activity.add(100)
            Activity.consume(-100)
            tuxon.visible = false
            tuxoff.visible = true
            Activity.update()
            tux_consume.text = "0 W"
        }

        function small() {
            resident_smalllights.visible = false
            residentsmalloff.visible = true
            residentsmallon.visible =false
            Activity.add(300)
            Activity.consume(-300)
            Activity.update()
            small_consume.text= "0 W"

        }

        function big() {
            resident_biglights.visible = false
            residentbigoff.visible = true
            residentbigon.visible = false
            Activity.add(600)
            Activity.consume(-600)
            Activity.update()
            big_consume.text= "0 W"
        }

        function reset() {
            if(Activity.currentLevel == 0) {
                if(Activity.voltage == 0) {
                    stepdownwire.visible = false
                }

            }
            if(Activity.currentLevel == 1) {
                if(Activity.voltage == 0  && residentsmallon.visible != true && tuxon.visible != true)
                {
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible == true)
                {
                    tux()
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible != true && tuxon.visible == true)
                {
                    tux()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible != true)
                {
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 100  && residentsmallon.visible == true && tuxon.visible == true)
                {
                    small()
                    check.visible = true
                }

                if(Activity.voltage == 100  && residentsmallon.visible == true && tuxon.visible != true)
                {
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

            }
            if(Activity.currentLevel == 2) {
                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible == true && residentbigon.visible == true)
                {
                    tux()
                    small()
                    big()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible == true && residentbigon.visible != true)
                {
                    tux()
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible != true && tuxon.visible == true && residentbigon.visible == true)
                {
                    tux()
                    big()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible != true && residentbigon.visible == true)
                {
                    big()
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible == true && tuxon.visible != true && residentbigon.visible != true)
                {
                    small()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible != true && tuxon.visible == true && residentbigon.visible != true)
                {
                    tux()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if(Activity.voltage == 0  && residentsmallon.visible != true && tuxon.visible != true && residentbigon.visible == true)
                {
                    big()
                    stepdownwire.visible = false
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible == true && residentsmallon.visible == true && residentbigon.visible == true)
                {
                    small()
                    big()
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible == true &&residentsmallon.visible == true && residentbigon.visible != true)
                {
                    small()
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible == true &&residentsmallon.visible != true && residentbigon.visible == true)
                {
                    big()
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible != true && residentsmallon.visible == true && residentbigon.visible == true) {
                    big()
                    small()
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible != true && residentsmallon.visible != true && residentbigon.visible == true) {
                    big()
                    check.visible = true
                }

                if (Activity.voltage == 100 && tuxon.visible != true && residentsmallon.visible == true && residentbigon.visible != true) {
                    small()
                    check.visible = true
                }

                if (Activity.voltage <= 400 && residentbigon.visible == true)
                {
                    big()
                    check.visible = true
                }
            }
        }

        function checkbonus() {
            if(Activity.currentLevel == 0 && tuxon.visible == true)
            {
                Activity.win()
            }
            if(Activity.currentLevel == 1 && tuxon.visible == true && residentsmallon.visible == true)
            {
                Activity.win()
            }
            if(Activity.currentLevel == 2 && tuxon.visible == true && residentbigon.visible == true && residentsmallon.visible == true)
            {
                Activity.win()
            }
        }

        onStart: { Activity.start(items,pow,solar,tux_meter,stepdown_info) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
