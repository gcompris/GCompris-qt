/* GCompris - Baby_mouse.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "baby_mouse.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/colors/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        readonly property real defaultScale: 1
        readonly property real mediumScale: 1.2
        readonly property real largeScale: 1.4

        readonly property int toleranceLimit: 5

        property bool isArrowPressed: false

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias duckModel: duckModel
            property bool hasBeenDragged: false
        }

        onStart: {
            Activity.start(items)
            resetDuckPosition()
        }
        onStop: {
            Activity.stop()
            resetArrowTimer.stop()
            pressArrowTimer.stop()
        }

        Item {
            id: mainArea
            width: background.width - duckGrid.width
            height: background.height - bar.height * 1.05 - y
            anchors.left: duckGrid.right
            anchors.top: arrowsArea.bottom

            // To detect click in this area with mainAreaBlock...
            Rectangle {
                anchors.fill: parent
                color: "transparent"
            }

            readonly property double rightDirectionLimit: mainArea.width - mainDuck.width
            readonly property double downDirectionLimit: mainArea.height - mainDuck.height

            property alias mainDuckX: mainDuck.x
            property alias mainDuckY: mainDuck.y
            property real previousDuckX
            property real previousDuckY

            Image {
                id: mainDuck
                source: Activity.duckColorURL + "blue_duck.svg"
                sourceSize.width: 70 * ApplicationInfo.ratio
                sourceSize.height: 70 * ApplicationInfo.ratio

                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: mainDuck
                        property: "rotation"
                        from: -10; to: 10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: mainDuck
                        property: "rotation"
                        from: 10; to: -10
                        duration: 400 + Math.floor(Math.random() * 400)
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            MouseArea {
                id: mouseMovement
                anchors.fill: parent
                hoverEnabled: true

                property real startX: 0
                property real startY: 0

                onEntered: {
                    setStartPosition()
                }

                onPositionChanged: {
                    if(items.hasBeenDragged) {
                        setStartPosition()
                        items.hasBeenDragged = false
                        return;
                    }

                    resetArrowTimer.restart()

                    // Comparing the current mouse position with the previous mouse position
                    var moveX = mouseX - startX
                    var moveY = mouseY - startY

                    background.moveDuckHorizontally(moveX)
                    background.moveDuckVertically(moveY)
                    background.indicateArrowScale()

                    setStartPosition()
                }

                function setStartPosition() {
                    startX = mouseX
                    startY = mouseY
                }
            }
        }

        MultiPointTouchArea {
            id: touchArea
            anchors.fill: parent

            property real previousX
            property real previousY

            property real startX
            property real startY

            onPressed: {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    previousX = touch.x
                    previousY = touch.y

                    startX = touch.x
                    startY = touch.y

                    items.hasBeenDragged = true

                    var arrowsPoint = parent.mapToItem(arrowsArea, touch.x, touch.y)
                    var arrowsBlock = arrowsArea.childAt(arrowsPoint.x, arrowsPoint.y)

                    if(arrowsBlock) {
                        background.isArrowPressed = true
                        if(arrowsArea.contains(arrowsPoint.x, arrowsPoint.y, arrowsArea.upArrow)) {
                            pressArrowTimer.upPressed = true
                            pressArrowTimer.start()
                        }
                        else if(arrowsArea.contains(arrowsPoint.x, arrowsPoint.y, arrowsArea.downArrow)) {
                            pressArrowTimer.downPressed = true
                            pressArrowTimer.start()
                        }
                        else if(arrowsArea.contains(arrowsPoint.x, arrowsPoint.y, arrowsArea.leftArrow)) {
                            pressArrowTimer.start()
                        }
                        else if(arrowsArea.contains(arrowsPoint.x, arrowsPoint.y, arrowsArea.rightArrow)) {
                            pressArrowTimer.rightPressed = true
                            pressArrowTimer.start()
                        }
                    }
                }
            }

            onTouchUpdated: {
                if(background.isArrowPressed) return;
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var moveX = touch.x - previousX
                    var moveY = touch.y - previousY

                    background.moveDuckHorizontally(moveX)
                    background.moveDuckVertically(moveY)
                    background.indicateArrowScale()

                    previousX = touch.x
                    previousY = touch.y
                }
            }

            onReleased: {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]

                    var maxToleranceX = startX + background.toleranceLimit
                    var minToleranceX = startX - background.toleranceLimit

                    var maxToleranceY = startY + background.toleranceLimit
                    var minToleranceY = startY - background.toleranceLimit

                    if(minToleranceX <= touch.x && touch.x <= maxToleranceX && minToleranceY <= touch.y && touch.y <= maxToleranceY) {
                        var ducksPoint = parent.mapToItem(duckGrid, touch.x, touch.y)
                        var ducksBlock = duckGrid.itemAt(ducksPoint.x, ducksPoint.y)

                        var mainAreaPoint = parent.mapToItem(mainArea, touch.x, touch.y)
                        var mainAreaBlock = mainArea.childAt(mainAreaPoint.x, mainAreaPoint.y)

                        if(ducksBlock) {
                            ducksBlock.restartAnimation()
                        }
                        else if(mainAreaBlock){
                            pressCircle.x = touch.x - pressCircle.width / 2
                            pressCircle.y = touch.y - pressCircle.height / 2
                            pressCircle.visible = true
                            Activity.playSound(4)
                        }
                    }

                    background.isArrowPressed = false
                    background.resetArrowScale()
                    pressArrowTimer.stopTimer()
                }
            }
        }

        Timer {
            id: resetArrowTimer
            interval: 200
            onTriggered: background.resetArrowScale()
        }

        Timer {
            id: pressArrowTimer

            property bool upPressed: false
            property bool downPressed: false
            property bool rightPressed: false

            function stopTimer() {
                upPressed = false
                downPressed = false
                rightPressed = false
                stop()
            }

            interval: 10
            repeat: true
            triggeredOnStart: true
            onTriggered: upPressed ? arrowsArea.upArrow.moveDuckUp() :
                                     downPressed ? arrowsArea.downArrow.moveDuckDown() :
                                                   rightPressed ? arrowsArea.rightArrow.moveDuckToRight() :
                                                                  arrowsArea.leftArrow.moveDuckToLeft()
        }

        function moveDuckHorizontally(moveX) {
            mainArea.previousDuckX = mainArea.mainDuckX

            // Duck Motion in x-direction.
            if(mainArea.previousDuckX + moveX >= mainArea.rightDirectionLimit) {
                mainArea.mainDuckX = mainArea.rightDirectionLimit
            }
            else if(mainArea.previousDuckX + moveX <= 0) {
                mainArea.mainDuckX = 0
            }
            else {
                mainArea.mainDuckX += moveX
            }
        }

        function moveDuckVertically(moveY) {
            mainArea.previousDuckY = mainArea.mainDuckY

            // Duck Motion in y-direction.
            if(mainArea.previousDuckY + moveY >= mainArea.downDirectionLimit) {
                mainArea.mainDuckY = mainArea.downDirectionLimit
            }
            else if(mainArea.previousDuckY + moveY <= 0) {
                mainArea.mainDuckY = 0
            }
            else {
                mainArea.mainDuckY += moveY
            }
        }

        function indicateArrowScale() {
            resetArrowScale()
            var diffX = mainArea.mainDuckX - mainArea.previousDuckX
            var diffY = mainArea.mainDuckY - mainArea.previousDuckY

            if(diffX === 0 && diffY === 0) return;

            // In case main duck moves in the y-direction only.
            if(diffX === 0) {
                if(diffY < 0) arrowsArea.upArrow.scale = largeScale
                else arrowsArea.downArrow.scale = largeScale
                return
            }

            // In case main duck moves in the x-direction only.
            if(diffY === 0) {
                if(diffX < 0) arrowsArea.leftArrow.scale = largeScale
                else arrowsArea.rightArrow.scale = largeScale
                return
            }

            // In case main duck moves in both x and y directions.
            if(Math.abs(diffX) > Math.abs(diffY)) {
                if(diffX < 0) arrowsArea.leftArrow.scale = largeScale
                else arrowsArea.rightArrow.scale = largeScale

                if(diffY < 0) arrowsArea.upArrow.scale = mediumScale
                else arrowsArea.downArrow.scale = mediumScale
            }
            else if(Math.abs(diffX) < Math.abs(diffY)) {
                if(diffX < 0) arrowsArea.leftArrow.scale = mediumScale
                else arrowsArea.rightArrow.scale = mediumScale

                if(diffY < 0) arrowsArea.upArrow.scale = largeScale
                else arrowsArea.downArrow.scale = largeScale
            }
            else {
                if(diffX < 0) arrowsArea.leftArrow.scale = mediumScale
                else arrowsArea.rightArrow.scale = mediumScale

                if(diffY < 0) arrowsArea.upArrow.scale = mediumScale
                else arrowsArea.downArrow.scale = mediumScale
            }
        }

        // Area for displaying the 4 arrows.
        Item {
            id: arrowsArea
            width: duckGrid.cellWidth
            height: width
            anchors.top: parent.top
            anchors.topMargin: width * 0.1
            anchors.right: parent.right
            anchors.rightMargin: anchors.topMargin

            property alias upArrow: upArrow
            property alias leftArrow: leftArrow
            property alias downArrow: downArrow
            property alias rightArrow: rightArrow

            function contains(x, y, item) {
                return (x > item.x && x < item.x + item.width &&
                        y > item.y && y < item.y + item.height)
            }

            Image {
                id: upArrow
                source: Activity.arrowImageURL
                width: 0.33 * arrowsArea.width
                sourceSize.width: width * largeScale
                fillMode: Image.PreserveAspectFit
                anchors.top: arrowsArea.top
                anchors.horizontalCenter: arrowsArea.horizontalCenter
                rotation: -90

                function moveDuckUp() {
                    upArrow.scale = background.largeScale
                    if(mainArea.mainDuckY - 1 >= 0) {
                        mainArea.mainDuckY -= 5;
                    }
                }

                Behavior on scale { NumberAnimation { duration: 200 } }
            }

            Image {
                id: rightArrow
                source: Activity.arrowImageURL
                width: upArrow.width
                sourceSize.width: upArrow.sourceSize.width
                fillMode: Image.PreserveAspectFit
                anchors.right: arrowsArea.right
                anchors.verticalCenter: arrowsArea.verticalCenter
                rotation: 0

                function moveDuckToRight() {
                    rightArrow.scale = background.largeScale
                    if(mainArea.mainDuckX + 1 <= mainArea.rightDirectionLimit) {
                        mainArea.mainDuckX += 5;
                    }
                }

                Behavior on scale { NumberAnimation { duration: 200 } }
            }

            Image {
                id: downArrow
                source: Activity.arrowImageURL
                width: upArrow.width
                sourceSize.width: upArrow.sourceSize.width
                fillMode: Image.PreserveAspectFit
                anchors.bottom: arrowsArea.bottom
                anchors.horizontalCenter: arrowsArea.horizontalCenter
                anchors.left: upArrow.left
                rotation: 90

                function moveDuckDown() {
                    downArrow.scale = background.largeScale
                    if(mainArea.mainDuckY + 1 <= mainArea.downDirectionLimit) {
                        mainArea.mainDuckY += 5;
                    }
                }

                Behavior on scale { NumberAnimation { duration: 200 } }
            }

            Image {
                id: leftArrow
                source: Activity.arrowImageURL
                width: upArrow.width
                sourceSize.width: upArrow.sourceSize.width
                fillMode: Image.PreserveAspectFit
                anchors.left: arrowsArea.left
                anchors.verticalCenter: arrowsArea.verticalCenter
                rotation: 180

                function moveDuckToLeft() {
                    leftArrow.scale = background.largeScale
                    if(mainArea.mainDuckX - 1 >= 0) {
                        mainArea.mainDuckX -= 5;
                    }
                }

                Behavior on scale { NumberAnimation { duration: 200 } }
            }
        }

        ListModel {
            id: duckModel
        }

        GridView {
            id: duckGrid
            model: duckModel
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.margins: 5
            width: mainDuck.width
            flow: GridView.FlowTopToBottom
            interactive: false
            cellWidth: duckGrid.width
            cellHeight: mainDuck.height * 1.1

            delegate: Image {
                id: duckImage
                source: Activity.duckColorURL + model.image + ".svg"
                sourceSize.width: duckGrid.cellWidth
                sourceSize.height: mainDuck.height

                function restartAnimation() {
                    duckAnim.start()
                }

                ParticleSystemStarLoader {
                    id: particles
                    clip: false
                }

                SequentialAnimation {
                    id: duckAnim
                    loops: 1
                    NumberAnimation {
                        target: duckImage
                        property: "rotation"
                        from: 0; to: 360
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    onRunningChanged: {
                        if(running) {
                            Activity.playSound(index)
                            particles.burst(20)
                        }
                        else {
                            rotation = 0
                        }
                    }
                }
            }

            add: Transition {
                PathAnimation {
                    path: Path {
                        PathCurve { x: 0; y: 0}
                        PathCurve {}
                    }
                    easing.type: Easing.InOutQuad
                    duration: 1000
                }
            }
        }

        Rectangle {
            id: pressCircle
            width: ApplicationInfo.ratio * 20
            height: width
            color: "#E77936"
            border.width: width * 0.1
            border.color: "#EEEEEE"
            visible: false
            radius: width * 0.5
        }

        onWidthChanged: {
            resetDuckPosition()
            pressCircle.visible = false;
        }

        onHeightChanged: {
            resetDuckPosition()
            pressCircle.visible = false;
        }

        function resetDuckPosition() {
            mainArea.mainDuckX = mainArea.width / 2
            mainArea.mainDuckY = mainArea.height / 2
        }

        function resetArrowScale() {
            arrowsArea.upArrow.scale = defaultScale
            arrowsArea.downArrow.scale = defaultScale
            arrowsArea.leftArrow.scale = defaultScale
            arrowsArea.rightArrow.scale = defaultScale
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
    }
}
