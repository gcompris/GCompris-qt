/* GCompris - checkers.qml
 *
 * SPDX-FileCopyrightText: 2017 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com> (big layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "."
import "checkers.js" as Activity

ActivityBase {
    id: activity

    property bool acceptClick: true
    property bool twoPlayers: false
    // difficultyByLevel means that at level 1 computer is bad better at last level
    property bool difficultyByLevel: true

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property bool isVertical: layoutArea.height - bar.height > layoutArea.width
            property int cellSize: 1
            property var fen: activity.fen
            property bool twoPlayer: activity.twoPlayers
            property bool difficultyByLevel: activity.difficultyByLevel
            property var positions
            property var pieces: pieces
            property var squares: squares
            property var history
            property var redo_stack
            property alias redoTimer: redoTimer
            property int from
            property bool blackTurn
            property bool gameOver
            property var movesToDo: []
            property string message
            property alias trigComputerMove: trigComputerMove
             // Used to stop piece animation on board resize; set to true on board resize, and to false on any action that triggers a piece move
            property bool noPieceAnimation: false

            property int numberOfCases: 10
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: flipSound
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        GCTextPanel {
            id: instructionPanel
            z: 20
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
            textItem.text: items.message
            textItem.fontSize: textItem.smallSize
        }

        Item {
            id: layoutArea
            width: activityBackground.width
            anchors.top: instructionPanel.bottom
            anchors.topMargin: GCStyle.halfMargins
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ApplicationSettings.isBarHidden ? GCStyle.baseMargins : bar.height * 1.2
        }

        Item {
            id: controlsArea
            x: layoutArea.width - width
            y: layoutArea.y
        }

        Grid {
            id: controls
            z: 20
            columns: items.isVertical ? 3 : 1
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            anchors.centerIn: controlsArea

            GCButton {
                id: undo
                height: items.cellSize
                width: items.cellSize
                text: "";
                theme: "noStyle"
                onClicked: Activity.undo()
                enabled: (items.history && items.history.length > 0) ? true : false
                opacity: enabled ? 1 : 0
                Image {
                    source: 'qrc:/gcompris/src/activities/chess/resource/undo.svg'
                    height: items.cellSize
                    width: items.cellSize
                    sourceSize.height: items.cellSize
                    fillMode: Image.PreserveAspectFit
                }
                Behavior on opacity {
                    PropertyAnimation {
                        easing.type: Easing.InQuad
                        duration: 200
                    }
                }
            }

            GCButton {
                id: redo
                height: items.cellSize
                width: items.cellSize
                text: "";
                theme: "noStyle"
                onClicked: {
                    Activity.redo()
                }
                enabled: items.redo_stack.length > 0 && acceptClick ? 1 : 0
                opacity: enabled
                Image {
                    source: 'qrc:/gcompris/src/activities/chess/resource/redo.svg'
                    height: items.cellSize
                    width: items.cellSize
                    sourceSize.height: items.cellSize
                    fillMode: Image.PreserveAspectFit
                }
                Behavior on opacity {
                    PropertyAnimation {
                        easing.type: Easing.InQuad
                        duration: 200
                    }
                }
            }

            GCButton {
                height: items.cellSize
                width: items.cellSize
                text: "";
                theme: "noStyle"
                enabled: items.twoPlayer
                opacity: enabled
                Image {
                    source: 'qrc:/gcompris/src/activities/chess/resource/turn.svg'
                    height: items.cellSize
                    width: items.cellSize
                    sourceSize.height: items.cellSize
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: chessboard.swap()
            }
        }

        states: [
            State {
                name: "verticalLayout"; when: items.isVertical
                PropertyChanges {
                    items {
                        cellSize: Math.min((layoutArea.width - GCStyle.baseMargins * 2) / 10,
                                        (layoutArea.height - GCStyle.baseMargins * 3) / 12)
                    }
                    controlsArea {
                        width: layoutArea.width
                        height: (layoutArea.height - boardBg.height) * 0.5
                    }
                    controls {
                        spacing: (controls.width - items.cellSize * 3) * 0.5
                        width: boardBg.width
                        height: items.cellSize
                    }

                }
            },
            State {
                name: "horizontalLayout"; when: !items.isVertical
                PropertyChanges {
                    items {
                        cellSize: Math.min((layoutArea.width  - GCStyle.baseMargins * 3 - bar.height) / 12,
                                    (layoutArea.height - GCStyle.baseMargins) / 10)
                    }
                    controlsArea {
                        width: (layoutArea.width - boardBg.width) * 0.5
                        height: layoutArea.height
                    }
                    controls {
                        spacing: (controls.height - items.cellSize * 3) * 0.5
                        width: items.cellSize
                        height: boardBg.height
                    }
                }
            }
        ]

        Rectangle {
            id: boardBg
            width: items.cellSize * 10 + GCStyle.baseMargins
            height: boardBg.width
            anchors.centerIn: layoutArea
            z: 09
            color: "#2E1B0C"
            onWidthChanged: items.noPieceAnimation = true

            // The chessboard
            GridView {
                id: chessboard
                cellWidth: items.cellSize
                cellHeight: items.cellSize
                width: items.cellSize * items.numberOfCases
                height: items.cellSize * items.numberOfCases
                interactive: false
                keyNavigationWraps: true
                model: items.numberOfCases*items.numberOfCases
                layoutDirection: Qt.RightToLeft
                delegate: squareBoard
                rotation: 180
                z: 10
                anchors.centerIn: boardBg
                Component {
                    id: squareBoard
                    Image {
                        source: index % 2 + (Math.floor(index / items.numberOfCases) % 2) == 1 ?
                        Activity.url + 'checkers-white.svg' : Activity.url + 'checkers-black.svg';
                        width: items.cellSize
                        height: items.cellSize
                    }
                }

                Behavior on rotation { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1400 } }

                function swap() {
                    flipSound.play()
                    if(chessboard.rotation == 180)
                        chessboard.rotation = 0
                        else
                            chessboard.rotation = 180
                }
            }
        }


        Repeater {
            id: squares
            model: items.positions
            parent: chessboard

            DropArea {
                id: squareArea
                x: items.cellSize * (9 - pos % items.numberOfCases) + squareArea.spacing / 2
                y: items.cellSize * Math.floor(pos / items.numberOfCases) + squareArea.spacing / 2
                width: items.cellSize - squareArea.spacing
                height: items.cellSize - squareArea.spacing
                z: 1
                keys: acceptMove ? ['acceptMe'] : ['sorryNo']
                property bool acceptMove: false
                property bool jumpable: false
                property int pos: modelData.pos
                property int spacing: GCStyle.halfMargins
                Rectangle {
                    id: possibleMove
                    anchors.fill: parent
                    color: parent.containsDrag ?  '#803ACAFF' : 'transparent'
                    border.width: parent.acceptMove || parent.jumpable ? GCStyle.midBorder : 0
                    border.color: parent.acceptMove ? '#FF808080' : '#C0808080'
                    radius: parent.acceptMove ? width*0.5 : 0
                    z: 1
                }
            }

            function getSquareAt(pos: int): var {
                for(var i=0; i < squares.count; i++) {
                    if(squares.itemAt(i).pos === pos)
                        return squares.itemAt(i)
                }
                return undefined
            }
        }

        Repeater {
            id: pieces
            model: items.positions
            parent: chessboard

            Piece {
                id: piece
                sourceSize.width: items.cellSize
                width: items.cellSize - spacing
                height: items.cellSize - spacing
                source: img ? Activity.url + img + '.svg' : ''
                img: modelData.img
                x: items.cellSize * (items.numberOfCases - 1 - pos % items.numberOfCases) + spacing / 2
                y: items.cellSize * Math.floor(pos / items.numberOfCases) + spacing / 2
                z: 1
                pos: modelData.pos
                newPos: modelData.pos
                rotation: - chessboard.rotation

                property int spacing: 6 * ApplicationInfo.ratio

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    enabled: !items.gameOver && !items.trigComputerMove.running
                    drag.target: ((items.blackTurn && !parent.isWhite) || (!items.blackTurn && parent.isWhite)) ?
                                parent : null
                    onPressed: {
                        piece.Drag.keys = ['acceptMe']
                        parent.z = 100

                        if(parent.isWhite == 1 && !items.blackTurn ||
                                parent.isWhite == 0 && items.blackTurn) {
                            items.from = parent.newPos
                            Activity.showPossibleMoves(items.from)
                        } else if(items.from != -1 && squares.getSquareAt(parent.newPos)['acceptMove']) {
                            Activity.moveTo(items.from, parent.newPos)
                        }
                    }
                    onReleased: {
                        // If no target or move not possible, we reset the position
                        if(!piece.Drag.target || (items.from != -1 && !Activity.moveTo(items.from, piece.Drag.target.pos))) {
                            var pos = parent.pos
                            // Force recalc of the old x,y position
                            parent.pos = -1
                            if(pieces.getPieceAt(pos))
                                pieces.getPieceAt(pos).move(pos)
                        }
                    }
                }
            }

            function moveTo(from: int, to: int, moves) {
                items.movesToDo.push({"from": from, "to": to, "move": moves});
                if(items.movesToDo.length == 1) {
                    moveInternal();
                }
            }

            function moveInternal() {
                var moveToDo = items.movesToDo[0]
                var from = moveToDo.from;
                var to = moveToDo.to;
                var moves = moveToDo.move;

                var fromPiece = getPieceAt(from)
                var toPiece = getPieceAt(to)

                if(moves.jumps.length !== 0)
                    smudgeSound.play()
                else
                    scrollSound.play()

                toPiece.hide(from)
                movingPiece = fromPiece

                if(moves.jumps.length !== 0) {
                    listJumps = moves.jumps
                }
                else {
                    // create the move if needed
                    listJumps = [Activity.viewPosToEngine(from), Activity.viewPosToEngine(to)]
                }
            }

            function promotion(to: int) {
                var toPiece = getPieceAt(to)
                toPiece.promotion()
            }

            function getPieceAt(pos: int): var {
                for(var i=0; i < pieces.count; i++) {
                    if(pieces.itemAt(i).newPos === pos)
                        return pieces.itemAt(i)
                }
                return undefined
            }
        }

        property var movingPiece: undefined
        property var listJumps
        property bool restartNeeded: false
        onListJumpsChanged: {
            if(listJumps.length >= 2) {
                if(!animationTimer.isRunning)
                    animationTimer.restart();
                else
                    restartNeeded = true;
            }
        }

        SequentialAnimation {
            id: animationTimer
            onRunningChanged: {
                if(!running && restartNeeded)
                    start()
            }
            ScriptAction {
                script: {
                    restartNeeded = false
                    var to = Activity.engineToViewPos(listJumps[1])
                    movingPiece.move(to)
                }
            }
            PauseAnimation { duration: 200 }
            ScriptAction {
                script: {
                    listJumps.shift()
                    // only shifting does not trigger the onChanged
                    var tmp = listJumps
                    listJumps = tmp
                    // only change player once all the jumps have been done
                    if(listJumps.length === 1) {

                        items.movesToDo.shift()
                        if(items.movesToDo.length > 0) {
                           pieces.moveInternal()
                        }
                        else {
                            Activity.refresh()
                            movingPiece = undefined
                        }
                    }
                }
            }
        }

        Timer {
            id: trigComputerMove
            repeat: false
            interval: 400
            onTriggered: Activity.randomMove()
        }

        // Use to redo the computer move after the user move
        Timer {
            id: redoTimer
            repeat: false
            interval: 400
            onTriggered: {
                acceptClick = true;
                Activity.moveByEngine(move)
            }
            property var move

            function moveByEngine(engineMove) {
                move = engineMove
                redoTimer.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | (items.twoPlayer ? 0 : level) |
                                             (items.twoPlayer && !items.gameOver ? 0 : reload) }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                trigComputerMove.stop()
                Activity.initLevel()
            }
        }

        Bonus {
            id: bonus
        }
    }
}
