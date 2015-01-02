/* GCompris - place-your-satellite.qml
*
* Copyright (C) 2014 Jean-Baptiste BUTET
*
* Authors:
*   Matilda Bernard (seah4291@gmail.com) (GTK+ version)
*   Jean-Baptiste BUTET <ashashiwa@gmail.com> (Qt Quick port and rewrite)*/

import QtQuick 2.1
import GCompris 1.0
import QtQuick.Controls 1.2

import "../../core"
import "place-your-satellite.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {

    }

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#111111"
        signal start
        signal stop
        property int massNb: 0
        property int satNb: 0
        property int tick: 0
        property real scaleGlob: 1.0
        property real arrowSatAngle
        property real widthActivity: width
        property real speed
        property bool crash : false

        property real distanceSatInPix


        Timer {
            id:satTimer
            interval: 10
            running: false
            repeat: true
            onTriggered: {if ((tick>=Activity.listPointsPix.length)||crash){
                    satArrowleft.visible=true
                    sat.x = centralItem.width/2 + distanceSatInPix-sat.width/2
                    sat.y = centralItem.height/2-sat.height/2

                        } else {

                    satArrowleft.visible=false
                    sat.x = centralItem.width/2 + Activity.listPointsPix[tick][0]-sat.width/2
                    sat.y = centralItem.height/2+Activity.listPointsPix[tick][1]-sat.height/2
                    tick++}

        }
        }


        onMassNbChanged: {
            Activity.massChanged(massNb)
            massInfo.text = Activity.massObjectName + '\n' + Activity.massObjectMass.toString().replace("e+","*10^") + " kg"
            massImage.source = Activity.url + "resource/" + Activity.massObjectName + ".png"
            diameterInfo.text = items.massObjectDiameter + " km"
            slidDistance.value = 2*items.massObjectDiameter

            //liberation speed -speed maximum to be satellized-
            items.liberationSpeed = Math.sqrt(2*(6.67*Math.pow(10,-11))*Activity.massObjectMass/items.massObjectDiameter)
            slidSpeed.maximumValue = 1.5 * items.liberationSpeed
            slidSpeed.value = 0.33*slidSpeed.maximumValue
            slidSpeed.minimumValue = 0.1*items.liberationSpeed

            console.log(items.liberationSpeed)
        }

        onSatNbChanged: {
            Activity.satChanged(satNb)
            satInfo.text = Activity.satObjectName + '\n' + Activity.satObjectMass + " kg"
            satImage.source = Activity.url + "resource/" + Activity.satObjectName + ".png"
        }

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
            property int massNb: massNb
            property alias massList: massList
            property alias massGrid: massGrid
            property alias satList: satList
            property alias satGrid: satGrid
            property alias trajecCanvas: trajecCanvas
            property alias slidDistance : slidDistance
            property alias slidSpeed : slidSpeed
            property real arrowSatAngle : rotation.angle
            property real pixPerMeter : objectDiameter.width / items.massObjectDiameter
            property alias diameterInfoRect : diameterInfoRect
            property alias objectDiameter : objectDiameter
            property real distanceSatInPix : distanceSatInPix
            property real massObjectDiameter : massObjectDiameter
            property alias instructions : instructions
            property real period : period
            property bool isEllipse : isEllipse
            property real liberationSpeed : liberationSpeed
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        GCText {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0.01*parent.height
            text: "<p><b>Launch your satellite !</b></p><p> Find good distance,  speed value and direction</p><p> to make satellite turn around the object</p>"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 24
            color: "#777"
        }

        GCText {
            id: instructions
            width: 0.2 * parent.width
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 0.25*parent.height
            anchors.rightMargin: 0.25*parent.width
            text: "<p>Adjust the arrow<p></p> to launch in desired direction.</p><p>Then release it</p>"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 18
            color: "#777"
            wrapMode: Text.WordWrap

            PropertyAnimation on opacity {
                id: instructionBlink
                easing.type: Easing.OutInSine
                loops: Animation.Infinite
                from: 0
                to: 1.0
                duration: 500
            }
        }

        //#####################################Central widget#####################
        Rectangle{
            id:centralItem
            scale: scaleGlob
            anchors.top :parent.top
            anchors.topMargin: 0.1*parent.height
            width:0.6*parent.width
            height:0.8*parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            focus:true
            color:'transparent'


            Item {
                id: sat
                x:  distanceSatInPix + parent.width/2-width/2

                width: satInfo.paintedWidth
                height: satInfo.paintedHeight

                y: parent.height / 2 - height / 2

                Rectangle {
                    color: 'transparent'
                    width: parent.width
                    height: parent.height
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onPositionChanged: mouse.accepted = false
                    }
                }

                Image {
                    id: satImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Activity.url + "resource/" + Activity.satObjectName + ".png"
                }

                Rectangle {
                    radius: 10 * ApplicationInfo.ratio
                    color: 'transparent'
                    border.width: 10 * ApplicationInfo.ratio
                    border.color: 'yellow'
                    width: satInfo.paintedWidth + 30 * ApplicationInfo.ratio
                    height: satInfo.paintedHeight + 30 * ApplicationInfo.ratio
                    anchors.top: satImage.bottom
                    GCText {
                        id: satInfo
                        text: Activity.satObjectName + '\n' + Activity.satObjectMass.replace("e+","10^") + " kg"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.pointSize: 18 * ApplicationInfo.ratio
                        color: "#FFF"
                    }
                }

                Image {
                    id: satArrowleft
                    x: parent.width / 2
                    y: parent.height / 2
                    source: Activity.url + "resource/arrowSimple.png"
                    transform: Rotation {
                        id:rotation
                        origin.x: 0
                        origin.y: 18
                        angle: arrowSatAngle
                    }
                }
            }


            //########################################
            //Center Object relative Informations
            Item {
                id: centerObject
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.centerIn: parent


                //border:0
                width: massInfo.paintedWidth + 30 * ApplicationInfo.ratio
                height: massInfo.paintedHeight + 30 * ApplicationInfo.ratio

                Image {
                    id: objectDiameter
                    anchors.bottom: massImage.top
                    anchors.topMargin: 50 * ApplicationInfo.ratio
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: massImage.width
                    source: Activity.url + "resource/arrow.png"
                }

                Rectangle {
                    id: diameterInfoRect
                    radius: 10 * ApplicationInfo.ratio
                    color: 'blue'
                    border.width: 10 * ApplicationInfo.ratio
                    border.color: 'yellow'
                    width: diameterInfo.paintedWidth + 30 * ApplicationInfo.ratio
                    height: diameterInfo.paintedHeight + 30 * ApplicationInfo.ratio
                    anchors.horizontalCenter: massImage.horizontalCenter
                    anchors.bottom: massImage.top
                    anchors.bottomMargin: 50 * ApplicationInfo.ratio
                    scale: scaleGlob
                    GCText {
                        id: diameterInfo
                        text: items.massObjectDiameter/1000 + " km"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 16
                        color: "#777"
                    }
                }

                Image {
                    id: massImage
                    anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Activity.url + "resource/" + Activity.massObjectName + ".png"
                }
            }



            Canvas {
                id: trajecCanvas
                width: parent.width
                height: parent.height
                anchors.top:parent.top
                anchors.left:parent.left
                Component.onCompleted: {
                       loadImage(Activity.url + "resource/crash.png")
                    }

                onPaint: {
                    tick=0
                    crash=false
                    var ctx = trajecCanvas.getContext('2d')
                    ctx.save()
                    ctx.setTransform(1, 0, 0, 1, 0, 0)
                    ctx.clearRect(0, 0, width, height)
                    ctx.restore()

                    ctx.fillStyle = 'white'
                    ctx.strokeStyle = 'white'
                    ctx.save() //first save only styles.

                    ctx.translate(width / 4, height / 4)
                    ctx.save() //save with translation and styles 1

                    if (items.isEllipse){
                        items.instructions.text = "Great !! Satellite is turning over Planet in " + items.period.toFixed(0) + " seconds or "+ (items.period/3600).toFixed(0) +" hours and " +60*((items.period/3600)-Math.floor(items.period/3600)).toFixed(0) +" minutes"
                    }
                        for (var j = 0; j < Activity.listPointsPix.length; j++) {
                            ctx.save() //save with translation and styles 2
                            var xs = Activity.listPointsPix[j][0]
                            var ys = Activity.listPointsPix[j][1]
                            ctx.translate(xs, ys)

                            if ((xs*xs+ys*ys)/(items.pixPerMeter*items.pixPerMeter) < (items.massObjectDiameter*items.massObjectDiameter/4)){  //fall on ground

                                var xx = Activity.listPointsPix[j-1][0]
                                var yy = Activity.listPointsPix[j-1][1]
                                ctx.drawImage(Activity.url + "resource/crash.png",xx+20, yy+20);

                                ctx.restore()//restore with translation and styles 2
                                items.instructions.text = "Great !! Satellite is turning over Planet !! But it crashes on its surface :("
                                tick=0
                                crash=true
                                satTimer.stop()

                                break
                            }

                            ctx.beginPath()

                            //draw a cross
                            ctx.moveTo(0, 3)
                            ctx.lineTo(0, -3)
                            ctx.moveTo(-3, 0)
                            ctx.lineTo(3, 0)
                            ctx.stroke()
                            ctx.restore()//restore with translation and styles 2
                    }

                    satTimer.repeat = true
                    satTimer.start()

                    mouseareaCentral.hoverEnabled = true
                    ctx.restore()//restore with translation and styles 1
                    ctx.restore()//restaure with style 0

                }
            }

            MouseArea {
                id: mouseareaCentral
                hoverEnabled: true
                z:100
                anchors.fill:parent

                onPositionChanged: {


                    var deltaX = mouseX - sat.x - sat.width / 2
                    var deltaY = mouseY - sat.y - sat.height / 2 - 18 * ApplicationInfo.ratio
                    if (deltaX > 0) {

                        arrowSatAngle = 360 / (2 * Math.PI) * Math.atan(
                                    deltaY / deltaX)
                    } else {

                        arrowSatAngle = 360 / (2 * Math.PI) * Math.atan(
                                    deltaY / deltaX) + 180
                    }
                }
                onClicked: {
                    hoverEnabled = false
                    instructions.text ="<p>Now Use sliders to choose</p><p> a speed and a position<p><p>Then LAUNCH it !!</p>"
                    buttonLaunch.visible = true

                }
            }
        }





        Rectangle {
            id: massInfoRect
            radius: 10 * ApplicationInfo.ratio
            color: 'blue'
            border.width: 10 * ApplicationInfo.ratio
            border.color: 'yellow'
            width: massInfo.paintedWidth + 30 * ApplicationInfo.ratio
            height: massInfo.paintedHeightleft + 30 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.3
            GCText {
                id: massInfo
                text: Activity.massObjectName + '\n' + Activity.massObjectMass.toString().replace("e+","*10^") + " kg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pointSize: 20 * ApplicationInfo.ratio
                color: "#777"
            }
        }

        //########################################
        //Satellite Object


        // right menu with different center mass
        ListModel {
            id: massList
        }

        // left menu with different satellites
        ListModel {
            id: satList
        }

        Rectangle {
            id: satMenu
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 0.1*parent.height* ApplicationInfo.ratio
            anchors.leftMargin: 0
            color: '#111111'
            width: parent.width * 0.2
            height: parent.height * 0.8
            radius: 10 * ApplicationInfo.ratio
            border.width: 10 * ApplicationInfo.ratio
            border.color: 'yellow'

            GridView {
                id: satGrid
                cellHeight: 150 * ApplicationInfo.ratio
                cellWidth: satMenu.width
                width: satMenu.width
                height: satMenu.height
                anchors.top: satMenu.top
                anchors.topMargin: 50 * ApplicationInfo.ratio

                Repeater {
                    id: satRepeater

                    Component {
                        id: satDelegate
                        Rectangle {
                            id: satWrapper
                            anchors.horizontalCenter: parent.horizontalCenter
                            //border.width: 10
                            //border.color: "grey"
                            color: "transparent"

                            height: 150 * ApplicationInfo.ratio
                            width: satMenu.width

                            Image {
                                id: satPicture
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                source: Activity.url + "resource/" + name + ".png"
                            }
                            GCText {
                                text: name
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pointSize: 24 * ApplicationInfo.ratio
                                color: satWrapper.GridView.isCurrentItem ? "red" : "white"
                            }
                            MouseArea {
                                hoverEnabled: true
                                anchors.fill: satWrapper
                                onClicked: {
                                    satNb = index
                                    satGrid.currentIndex = index
                                }
                            }
                        }
                    }
                }

                model: satList
                delegate: satDelegate
            }
        }

        Rectangle {
            id: massMenu
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 0.1*parent.height* ApplicationInfo.ratio
            anchors.rightMargin: 0
            color: '#111111'
            width: parent.width * 0.2
            height: parent.height * 0.8
            radius: 10 * ApplicationInfo.ratio
            border.width: 10 * ApplicationInfo.ratio
            border.color: 'yellow'

            GridView {
                id: massGrid
                cellHeight: 150 * ApplicationInfo.ratio
                cellWidth: massMenu.width

                width: massMenu.width
                height: massMenu.height
                anchors.top: massMenu.top
                anchors.topMargin: 50 * ApplicationInfo.ratio

                Repeater {
                    id: massRepeater

                    Component {
                        id: massDelegate
                        Rectangle {
                            id: wrapper
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "transparent"
                            height: 150 * ApplicationInfo.ratio
                            width: massMenu.width

                            Image {
                                id: planetPicture
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                source: Activity.url + "resource/" + name + ".png"
                            }
                            GCText {
                                text: name
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pointSize: 24 * ApplicationInfo.ratio

                                color: wrapper.GridView.isCurrentItem ? "red" : "white"
                            }
                            MouseArea {
                                anchors.fill: wrapper
                                hoverEnabled: true
                                onClicked: {
                                    massNb = index
                                    massGrid.currentIndex = index
                                }
                                onEntered: planetPicture.source = Activity.url
                                           + "resource/" + name + "_scaled.png"
                                onExited: planetPicture.source = Activity.url
                                          + "resource/" + name + ".png"
                            }
                        }
                    }
                }

                model: massList
                delegate: massDelegate
            }
        }

        //###############################################################
        //################CANVAS to draw trajectory######################


        Slider {
            id: slidScale
            anchors.left: parent.left
            anchors.leftMargin: 0.3 * parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.1
            width: parent.width * 0.1
            maximumValue: 2
            activeFocusOnPress: true
            value: 1
            updateValueWhileDragging: false

            GCText {
                text: "ZOOM In or Out"
                anchors.bottom:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color:'white'
                font.pointSize: 16
            }

            onValueChanged: {
                scaleGlob = scaleGlob * value
                value = 1.0
            }
        }

        Slider {
            id: slidDistance
            anchors.left: parent.left
            anchors.leftMargin: 0.6 * parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.2
            width: parent.width * 0.1

            maximumValue: 10 * items.massObjectDiameter //10 times diameter is enough i think
            minimumValue: 1.2 * items.massObjectDiameter
            value: 42000000

            activeFocusOnPress: true
            updateValueWhileDragging: true
            onValueChanged: {
                distanceSatInPix = objectDiameter.width / items.massObjectDiameter * slidDistance.value
            }
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Distance (in km):" + (slidDistance.value/1000).toFixed(0)
                font.pointSize: 16
                anchors.bottom:parent.top
                color:'white'
            }
        }

        Slider {
            id: slidSpeed
            anchors.left: parent.left
            anchors.leftMargin: 0.6 * parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.1
            width: parent.width * 0.1

            maximumValue: 100000
            minimumValue: 100
            value: 3000
            activeFocusOnPress: true
            updateValueWhileDragging: true
            onValueChanged: {
                speed = slidSpeed.value
            }
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(slidSpeed.value)!=0 ? "Speed in m/s : " + slidSpeed.value.toFixed(0) : "Speed in m/s : " + slidSpeed.value.toFixed(2)
                anchors.bottom:parent.top
                font.pointSize: 16
                color:'white'
            }
        }

        Button {
            id:buttonLaunch
            anchors.left: parent.left
            anchors.leftMargin: 0.3 * parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.2
            width: parent.width * 0.1
            visible:false
            onClicked: Activity.calcparameters()
            text : "<b>LAUNCH IT NOW !!</b>"
        }




        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
