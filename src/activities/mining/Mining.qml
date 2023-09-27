/* GCompris - mining.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Peter Albrecht <pa-dev@gmx.de> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "mining.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop

        property bool gotIt: false
        property bool horizontalLayout: background.width >= background.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias miningBg: miningBg
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias mineModel: mineObjects.model
            property Item nugget
            property int collectedNuggets: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
                id: miningBg
                source: Activity.url + "rockwall.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.width: parent.width
                width: parent.width
                height: parent.height
                scale: miningBg._MIN_SCALE

                property int subLevel
                property int maxSubLevel
                property real _MAX_SCALE: 3
                property real _MIN_SCALE: 1

                onScaleChanged: items.nugget.checkOnScreen()

                Image {
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
                    anchors.fill: parent
                    cellWidth: parent.width / 4
                    cellHeight: parent.height / 4

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
                                    background.mapFromItem(miningBg,
                                                           items.nugget.x + items.nugget.nuggetImg.x,
                                                           items.nugget.y + items.nugget.nuggetImg.y)
                            var nuggetCoord2 =
                                    background.mapFromItem(miningBg,
                                                           items.nugget.x + items.nugget.nuggetImg.x + items.nugget.nuggetImg.width,
                                                           items.nugget.y + items.nugget.nuggetImg.y + items.nugget.nuggetImg.height)

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
                            sourceSize.width: mineObjects.cellWidth * 3
                            width: mineObjects.cellWidth * modelData.widthFactor / 2
                            height: mineObjects.cellHeight * modelData.widthFactor / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: modelData.isTarget &&
                                     miningBg.scale === miningBg._MAX_SCALE &&
                                     !background.gotIt ? 1 : 0

                            signal hit
                            onHit: {
                                activity.audioEffects.play(Activity.url + "pickaxe.wav")
                                background.gotIt = true
                                items.collectedNuggets++
                                tuto.setState("Unzoom")
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
                                         background.gotIt === false
                                onClicked: parent.hit()
                            }

                            Behavior on opacity { PropertyAnimation { duration: 1000 } }
                        }

                        Image {
                            id: cell
                            source: modelData.source
                            sourceSize.width: mineObjects.cellWidth * 3
                            width: mineObjects.cellWidth * modelData.widthFactor
                            height: mineObjects.cellHeight * modelData.widthFactor
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            rotation: modelData.rotation
                            opacity: !modelData.isTarget ? 1 : (background.gotIt ? 0 : 1)

                            Component.onCompleted: {
                                activity.audioEffects.play(Activity.url + "realrainbow.wav")
                            }

                            ParallelAnimation {
                                running: modelData.isTarget && !background.gotIt
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

                function updateScale(zoomDelta, x, y) {
                    var xx1 = background.mapFromItem(miningBg, x, y)
                    var previousScale = miningBg.scale
                    if (zoomDelta > 0 && miningBg.scale < miningBg._MAX_SCALE) {
                        if(miningBg.scale < miningBg._MAX_SCALE - 0.1)
                            miningBg.scale += 0.1;
                        else
                            miningBg.scale = miningBg._MAX_SCALE

                        if(gotIt)
                            tuto.setState("Unzoom")
                        else if(miningBg.scale < miningBg._MAX_SCALE)
                            tuto.setState(items.nugget.onScreen ? "ZoomOk" : "ZoomBad")
                        else
                            tuto.setState(items.nugget.onScreen ? "NuggetSeen" : "NuggetNotSeen")

                    } else if (zoomDelta < 0) {
                        if(miningBg.scale > miningBg._MIN_SCALE) {
                            miningBg.scale -= 0.1;

                            if(gotIt)
                                tuto.setState("Unzoom")
                            else if(miningBg.scale > miningBg._MIN_SCALE)
                                tuto.setState(items.nugget.onScreen ? "UnzoomOk" : "UnzoomBad")
                            else
                                tuto.setState("Started")
                        } else if (gotIt) {
                            gotIt = false
                            if(miningBg.subLevel == miningBg.maxSubLevel) {
                                bonus.good("lion")
                            } else {
                                miningBg.subLevel++
                                miningBg.scale = miningBg._MIN_SCALE
                                Activity.createLevel()
                            }
                            tuto.setState("Stopped")
                        } else {
                            miningBg.anchors.horizontalCenterOffset = 0
                            miningBg.anchors.verticalCenterOffset = 0
                            if(miningBg.subLevel != items.collectedNuggets)
                                tuto.setState("Started")
                        }
                    }
                    if(previousScale != miningBg.scale) {
                        var xx2 = background.mapFromItem(miningBg, x, y)
                        miningBg.anchors.horizontalCenterOffset += xx1.x - xx2.x
                        miningBg.anchors.verticalCenterOffset += xx1.y - xx2.y
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onWheel: miningBg.updateScale(wheel.angleDelta.y, wheel.x, wheel.y)
                }

                MultiPointTouchArea {
                    anchors.fill: parent
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
            sourceSize.height: background.horizontalLayout ? 120 * ApplicationInfo.ratio : 80 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: background.horizontalLayout ? parent.bottom : bar.top
            }

            GCText {
                id: score
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    horizontalCenterOffset: parent.width / 10
                }
                text: items.collectedNuggets + "/" + miningBg.maxSubLevel
                color: "white"
                font.bold: true
                style: Text.Outline
                styleColor: "black"
                fontSize: 22
            }
        }

        Rectangle {
            id: tutoBackground
            color: "#C0b7b353"
            border.color: "black"
            border.width: 2
            radius: 10
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 10
            }
            height: tuto.height + anchors.margins * 2
            visible: tuto.state != "Stopped"
            Behavior on height { PropertyAnimation { duration: 100 } }

            GCText {
                id: tuto
                fontSize: 13
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 10
                }
                color: "white"
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: TextEdit.AlignHCenter

                property string newState

                function setState(nextState) {
                    if(bar.level == 1) {
                        if(newState != nextState) {
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
                            target: tuto;
                            text: qsTr("Find the sparkle and zoom in around it. If you have a mouse, point the cursor on the sparkle then use the scroll wheel. If you have a trackpad, point the cursor on the sparkle then drag one finger on the right area or two fingers on the center. On a touch area, drag two fingers away from the sparkle, one in each direction.")
                        }
                    },
                    State {
                        name: "Stopped"
                        PropertyChanges { target: tuto; text: ""}
                    },
                    State {
                        name: "ZoomOk"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Perfect you are zooming. Continue until you see the nugget.")}
                    },
                    State {
                        name: "ZoomBad"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Hum, take care, you are zooming too far from the sparkle.")}
                    },
                    State {
                        name: "NuggetSeen"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Now you see the nugget, click on it to catch it.")}
                    },
                    State {
                        name: "NuggetNotSeen"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Hum, you are too far from the nugget to see it. Unzoom then zoom again as close as you can from the sparkle.")}
                    },
                    State {
                        name: "Unzoom"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Now unzoom and try to find another sparkle.")}
                    },
                    State {
                        name: "UnzoomBad"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Continue to unzoom until you see the sparkle.")}
                    },
                    State {
                        name: "UnzoomOk"
                        PropertyChanges {
                            target: tuto
                            text: qsTr("Now you see the sparkle, go ahead, you can zoom on it.")}
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

                Behavior on opacity { PropertyAnimation { duration: 100 } }
                transitions: Transition {
                    PropertyAnimation {
                        target: tuto
                        property: "opacity"
                        to: 1.0
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

            onLevelChanged: {
                miningBg.subLevel = 1
                miningBg.anchors.horizontalCenterOffset = 0
                miningBg.anchors.verticalCenterOffset = 0
                miningBg.scale = miningBg._MIN_SCALE
                tuto.setState("Started")

                switch(bar.level) {
                case 1:
                    miningBg.maxSubLevel = 2
                    break
                case 2:
                    miningBg.maxSubLevel = 4
                    break
                case 3:
                    miningBg.maxSubLevel = 10
                    break
                }

            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
