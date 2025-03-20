/* GCompris - mining.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Peter Albrecht <pa-dev@gmx.de> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (various improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "mining.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: activityBackground
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
            property alias activityBackground: activityBackground
            property alias miningBg: miningBg
            property alias tuto: tuto
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias mineModel: mineObjects.model
            property alias rainbowSound: rainbowSound
            property Item nugget
            property int collectedNuggets: 0
            property bool gotIt: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: pickSound
            source: Activity.url + "pickaxe.wav"
        }

        GCSoundEffect {
            id: rainbowSound
            source: Activity.url + "realrainbow.wav"
        }

        Image {
            id: miningBg
            source: Activity.url + "rockwall.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            sourceSize.width: parent.width * 3
            width: parent.width
            height: parent.height
            scale: miningBg._MIN_SCALE

            property int maxSubLevel
            property real _MAX_SCALE: 3
            property real _MIN_SCALE: 1

            onScaleChanged: items.nugget.checkOnScreen()

            Image {
                id: leftBorder
                source: Activity.url + "vertical_border.svg"
                sourceSize.height: parent.height
                width: parent.width * 0.05
                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }
            }

            Image {
                id: rightBorder
                source: Activity.url + "vertical_border.svg"
                sourceSize.height: parent.height
                width: parent.width * 0.05
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
            }

            Image {
                id: topBorder
                source: Activity.url + "horizontal_border.svg"
                sourceSize.width: parent.width
                height: parent.height * 0.05
                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.left
                }
            }

            GridView {
                id: mineObjects
                anchors.right: rightBorder.left
                anchors.left: leftBorder.right
                y: items.currentLevel === 0 ? tuto.height + GCStyle.baseMargins : topBorder.height
                height: carriage.y - y
                cellWidth: width * 0.25
                cellHeight: height * 0.25

                delegate: Item {
                    width: mineObjects.cellWidth
                    height: mineObjects.cellHeight
                    // Calculated value true when the nugget is on the visible
                    // part of the screen
                    property bool onScreen: true
                    property alias nuggetImg: nuggetImg
                    signal hit(real x, real y)
                    signal checkOnScreen

                    onHit: {
                        if(!mouseArea.enabled)
                            return

                        var point = parent.mapToItem(nuggetImg, x, y)
                        if(point.x > 0 && point.x < nuggetImg.width &&
                            point.y > 0 && point.y < nuggetImg.height)
                            nuggetImg.hit()
                    }

                    onCheckOnScreen: {
                        // Calc if the nugget is visible or not
                        var nuggetCoord1 =
                                activityBackground.mapFromItem(items.nugget.nuggetImg, 0, 0)
                        var nuggetCoord2 =
                                activityBackground.mapFromItem(items.nugget.nuggetImg,
                                                        items.nugget.nuggetImg.width,
                                                        items.nugget.nuggetImg.height)

                        if(nuggetCoord1.x > miningBg.width ||
                                nuggetCoord2.x < 0 ||
                                nuggetCoord1.y > miningBg.height ||
                                nuggetCoord2.y < 0)
                            onScreen = false
                        else
                            onScreen = true
                    }

                    Image {
                        id: nuggetImg
                        source: Activity.url + "gold_nugget.svg"
                        width: GCStyle.bigButtonHeight / 3
                        height: width * 0.6
                        sourceSize.width: width * 3
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: modelData.isTarget && miningBg.scale === miningBg._MAX_SCALE &&
                                !items.gotIt ? 1 : 0

                        signal hit
                        onHit: {
                            pickSound.play()
                            items.gotIt = true
                            items.collectedNuggets++
                            if(items.collectedNuggets < miningBg.maxSubLevel) {
                                tuto.setState("Unzoom");
                            } else {
                                tuto.setState("Stopped")
                                bonus.good("lion");
                            }
                        }

                        Component.onCompleted: {
                            if(modelData.isTarget)
                                items.nugget = parent
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            enabled: modelData.isTarget &&
                                        miningBg.scale === miningBg._MAX_SCALE &&
                                        items.gotIt === false
                            onClicked: parent.hit()
                        }

                        Behavior on opacity { PropertyAnimation { duration: 500 } }
                    }

                    Image {
                        id: cell
                        source: modelData.source
                        width: modelData.isTarget ? GCStyle.bigButtonHeight / 3 :
                            Math.min(mineObjects.cellWidth, mineObjects.cellHeight) * modelData.sizeFactor
                        height: width
                        sourceSize.width: width * 3
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        rotation: modelData.rotation
                        opacity: !modelData.isTarget ? 1 : (items.gotIt ||
                            miningBg.scale === miningBg._MAX_SCALE ? 0 : 1)
                        mipmap: true

                        ParallelAnimation {
                            running: modelData.isTarget && opacity === 1
                            loops: Animation.Infinite
                            SequentialAnimation {
                                loops: Animation.Infinite
                                NumberAnimation {
                                    target: cell
                                    property: "rotation"
                                    from: 0; to: 360
                                    duration: 5000;
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    target: cell; property: "rotation"
                                    from: 360; to: 0
                                    duration: 5000;
                                    easing.type: Easing.InOutQuad
                                }
                            }
                            SequentialAnimation {
                                loops: Animation.Infinite
                                NumberAnimation {
                                    target: cell; property: "scale"
                                    from: 0; to: 1
                                    duration: 3000;
                                    easing.type: Easing.InOutQuad
                                }
                                PauseAnimation { duration: 300 + Math.random() * 300 }
                                NumberAnimation {
                                    target: cell
                                    property: "scale"
                                    from: 1; to: 0
                                    duration: 1000;
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }

            function updateScale(zoomDelta: real, x: real, y: real) {
                var xx1 = activityBackground.mapFromItem(miningBg, x, y)
                var previousScale = miningBg.scale
                var miningBgScale = miningBg.scale
                var miningBgHOffset = miningBg.anchors.horizontalCenterOffset
                var miningBgVOffset = miningBg.anchors.verticalCenterOffset
                if (zoomDelta > 0 && miningBg.scale < miningBg._MAX_SCALE) {
                    // zoom-in cases
                    if(miningBgScale < miningBg._MAX_SCALE - 0.1)
                        miningBgScale += 0.1;
                    else
                        miningBgScale = miningBg._MAX_SCALE

                    if(items.gotIt)
                        tuto.setState("Unzoom")
                    else if(miningBgScale < miningBg._MAX_SCALE)
                        tuto.setState(items.nugget.onScreen ? "ZoomOk" : "ZoomBad")
                    else
                        tuto.setState(items.nugget.onScreen ? "NuggetSeen" : "NuggetNotSeen")

                } else if (zoomDelta < 0) {
                    // zoom-out cases
                    if(miningBgScale > miningBg._MIN_SCALE) {
                        miningBgScale -= 0.1;

                        if(items.gotIt)
                            tuto.setState("Unzoom")
                        else if(miningBgScale > miningBg._MIN_SCALE)
                            tuto.setState(items.nugget.onScreen ? "UnzoomOk" : "UnzoomBad")
                        else
                            tuto.setState("Started")
                    } else if (items.gotIt) {
                        items.gotIt = false
                        Activity.resetSetup()
                        Activity.createLevel()
                        return
                    } else {
                        miningBgScale = miningBg._MIN_SCALE
                        miningBgHOffset = 0
                        miningBgVOffset = 0
                        tuto.setState("Started")
                    }
                }
                if(miningBgScale <= miningBg._MIN_SCALE) {
                    miningBgScale = miningBg._MIN_SCALE
                }
                miningBg.scale = miningBgScale
                if(previousScale != miningBg.scale && miningBg.scale > miningBg._MIN_SCALE) {
                    var xx2 = activityBackground.mapFromItem(miningBg, x, y)
                    miningBgHOffset += xx1.x - xx2.x
                    miningBgVOffset += xx1.y - xx2.y
                } else if(miningBg.scale === miningBg._MIN_SCALE) {
                    miningBgHOffset = 0
                    miningBgVOffset = 0
                }
                miningBg.anchors.horizontalCenterOffset = miningBgHOffset
                miningBg.anchors.verticalCenterOffset = miningBgVOffset
            }

            MouseArea {
                anchors.fill: parent
                enabled: !bonus.isPlaying
                propagateComposedEvents: true
                onWheel: (wheel) => {
                    miningBg.updateScale(wheel.angleDelta.y, wheel.x, wheel.y)
                }
            }

            MultiPointTouchArea {
                anchors.fill: parent
                enabled: !bonus.isPlaying
                mouseEnabled: false
                minimumTouchPoints: 1
                maximumTouchPoints: 2
                // To determine if we zoom or unzoom
                property int prevDist: 0
                // To avoid having too many updates or the zoom flickers
                    property date dateEvent: new Date()
                touchPoints: [
                            TouchPoint { id: point1 },
                            TouchPoint { id: point2 }
                        ]
                onReleased: prevDist = 0
                onTouchUpdated: {
                    if(!point2.pressed) {
                        mineObjects.itemAt(point1.x, point1.y).hit(point1.x, point1.y)
                        return
                    }
                    // Calc Distance
                    var dist = Math.floor(Math.sqrt(Math.pow(point1.x - point2.x, 2) +
                                                    Math.pow(point1.y - point2.y, 2)))
                    var newDateEvent = new Date()
                    if(prevDist != dist &&
                            newDateEvent.getTime() - dateEvent.getTime() > 50) {
                        miningBg.updateScale(dist - prevDist,
                                                (point1.x + point2.x) / 2,
                                                (point1.y + point2.y) / 2)
                        dateEvent = newDateEvent
                    }
                    prevDist = dist
                }
            }
        }

        Image {
            id: carriage
            source: Activity.url + "gold_carriage.svg"
            width: GCStyle.bigButtonHeight
            height: width
            sourceSize.width: width
            anchors {
                right: parent.right
                bottom: bar.top
                margins: GCStyle.baseMargins
            }

            GCText {
                id: score
                width: carriage.width * 0.6
                height: carriage.height * 0.3
                anchors.left: carriage.left
                anchors.top: carriage.top
                anchors.leftMargin: carriage.width * 0.3
                anchors.topMargin: carriage.height * 0.37
                text: items.collectedNuggets + "/" + miningBg.maxSubLevel
                color: GCStyle.whiteText
                font.bold: true
                style: Text.Outline
                styleColor: GCStyle.darkerBorder
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                horizontalAlignment: TextEdit.AlignHCenter
                verticalAlignment: TextEdit.AlignVCenter
            }
        }



        Rectangle {
            id: tutoBackground
            color: "#D0373737"
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: tuto.contentHeight + GCStyle.baseMargins
            visible: tuto.state != "Stopped"
            Behavior on height { PropertyAnimation { duration: 100 } }

            GCText {
                id: tuto
                anchors.centerIn: parent
                width: parent.width - GCStyle.baseMargins
                height: activityBackground.height * 0.25 - GCStyle.baseMargins
                fontSize: smallSize
                fontSizeMode: Text.Fit
                color: GCStyle.whiteText
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: TextEdit.AlignHCenter
                verticalAlignment: TextEdit.AlignVCenter

                property string newState

                function setState(nextState: string) {
                    if(bar.level == 1) {
                        if(newState !== nextState) {
                            newState = nextState
                            anim.restart()
                        }
                    } else {
                        newState = "Stopped"
                        anim.restart()
                    }
                }

                states: [
                    State {
                        name: "Started"
                        PropertyChanges {
                           tuto {
                               text: qsTr("Find the sparkle and zoom in around it. If you have a mouse, point the cursor on the sparkle then use the scroll wheel. If you have a trackpad, point the cursor on the sparkle then drag one finger on the right area or two fingers on the center. On a touch area, drag two fingers away from the sparkle, one in each direction.")
                           }
                        }
                    },
                    State {
                        name: "Stopped"
                        PropertyChanges {
                            tuto {
                                text: ""
                            }
                        }
                    },
                    State {
                        name: "ZoomOk"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Perfect you are zooming. Continue until you see the nugget.")
                            }
                        }
                    },
                    State {
                        name: "ZoomBad"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Hum, take care, you are zooming too far from the sparkle.")
                            }
                        }
                    },
                    State {
                        name: "NuggetSeen"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Now you see the nugget, click on it to catch it.")
                            }
                        }
                    },
                    State {
                        name: "NuggetNotSeen"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Hum, you are too far from the nugget to see it. Unzoom then zoom again as close as you can from the sparkle.")
                            }
                        }
                    },
                    State {
                        name: "Unzoom"
                        PropertyChanges {
                            tuto {
                            text: qsTr("Now unzoom and try to find another sparkle.")
                            }
                        }
                    },
                    State {
                        name: "UnzoomBad"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Continue to unzoom until you see the sparkle.")
                            }
                        }
                    },
                    State {
                        name: "UnzoomOk"
                        PropertyChanges {
                            tuto {
                                text: qsTr("Now you see the sparkle, go ahead, you can zoom on it.")
                            }
                        }
                    }
                ]

                SequentialAnimation {
                    id: anim
                    PropertyAnimation {
                        target: tuto
                        property: "opacity"
                        easing.type: Easing.Linear
                        from: 1.0; to: 0
                        duration: 200
                    }
                    PropertyAction {
                        target: tuto
                        property: "state"
                        value: tuto.newState
                    }
                    PropertyAnimation {
                        target: tuto
                        property: "opacity"
                        easing.type: Easing.Linear
                        from: 0; to: 1.0
                        duration: 200
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
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
