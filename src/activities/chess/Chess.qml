/* GCompris - chess.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (big layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "."
import "chess.js" as Activity

ActivityBase {
    id: activity

    property bool acceptClick: true
    property bool buttonsBlocked: false
    onButtonsBlockedChanged: if(buttonsBlocked) unlockButtonBlock.restart()
    Timer {
        id: unlockButtonBlock
        interval: 400
        running: false
        repeat: false
        onTriggered: buttonsBlocked = false
    }

    property bool twoPlayers: false
    property bool displayTakenPiecesButton: true
    // In end of party mode, we consider we need a check mate to win, a draw is not enough
    property bool drawIsWin: true
    property int coordsOpacity: 1
    property int movesCount: 0
    // difficultyByLevel means that at level 1 computer is bad better at last level
    property bool difficultyByLevel: true
    property var fen: [
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"]
    ]

    onStart: focus = true
    onStop: unlockButtonBlock.stop()

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + 'background-wood.svg'
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
            property var barHeightAddon: ApplicationSettings.isBarHidden ? instructionPanel.height : bar.height
            property bool isVertical: layoutArea.height - bar.height > layoutArea.width
            property int cellSize: 1
            property var fen: activity.fen
            property bool twoPlayer: activity.twoPlayers
            property bool difficultyByLevel: activity.difficultyByLevel
            property bool drawIsWin: activity.drawIsWin
            property var positions
            property var pieces: pieces
            property var squares: squares
            property var history
            property var redo_stack
            property alias redoTimer: redoTimer
            property int from
            property bool blackTurn
            property bool gameOver
            property string message
            property bool isWarningMessage
            property alias trigComputerMove: trigComputerMove
            property alias timerSwap: timerSwap
            property alias whiteTakenPieces: whiteTakenPieces
            property alias blackTakenPieces: blackTakenPieces
            property bool displayUndoAllDialog: false
            // Used to stop piece animation on board resize; set to true on board resize, and to false on any action that triggers a piece move
            property bool noPieceAnimation: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        function performUndo() {
            if(items.history.length <= 0)
                return
            Activity.undo()
            if(whiteTakenPieces.pushedLast[whiteTakenPieces.pushedLast.length-1] == movesCount) {
                whiteTakenPieces.pushedLast.pop()
                whiteTakenPieces.removeLastPiece()
            }
            if(!items.twoPlayer) {
                movesCount--
            }
            if(blackTakenPieces.pushedLast[blackTakenPieces.pushedLast.length-1] == movesCount) {
                blackTakenPieces.pushedLast.pop()
                blackTakenPieces.removeLastPiece()
            }
            movesCount--
        }

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

        Loader {
            id: undoAllDialogLoader
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                //: Translators: undo all the moves in chess activity
                message: qsTr("Do you really want to undo all the moves?")
                button1Text: qsTr("Yes")
                button2Text: qsTr("No")
                onClose: items.displayUndoAllDialog = false
                onButton1Hit: {
                    stop()
                    while(items.history.length > 0)
                        performUndo()
                }
                onButton2Hit: {}
            }
            anchors.fill: parent
            focus: true
            active: items.displayUndoAllDialog
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

        GCTextPanel {
            id: instructionPanel
            z: 20
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
            textItem.color: items.isWarningMessage ? "red" : GCStyle.lightText
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
            columns: items.isVertical ? 4 : 1
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            anchors.centerIn: controlsArea

            GCTimerButton {
                id: undo
                height: items.cellSize
                width: items.cellSize
                enabled: !buttonsBlocked && opacity == 1
                opacity: items.history.length > 0 ? 1 : 0
                Image {
                    source: Activity.url + 'undo.svg'
                    height: items.cellSize
                    width: items.cellSize
                    sourceSize.height: items.cellSize
                    fillMode: Image.PreserveAspectFit
                }

                onClicked: {
                    if(!items.displayUndoAllDialog)
                        performUndo()
                }
                onPressAndHold: {
                    items.displayUndoAllDialog = true
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
                    buttonsBlocked = true
                    if (!twoPlayers) {
                        acceptClick = false;
                        Activity.redo()
                    } else {
                        Activity.redo()
                    }
                }
                enabled: !buttonsBlocked && opacity == 1
                opacity: items.redo_stack.length > 0 && acceptClick ? 1 : 0
                Image {
                    source: Activity.url + 'redo.svg'
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
                id: drawerButton
                height: items.cellSize
                width: items.cellSize
                text: "";
                theme: "noStyle"

                onClicked: {
                    whiteTakenPieces.open = !whiteTakenPieces.open
                    blackTakenPieces.open = !blackTakenPieces.open
                }

                enabled: !buttonsBlocked && displayTakenPiecesButton
                opacity: displayTakenPiecesButton ? 1 : 0
                Image {
                    source: Activity.url + 'captured.svg'
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
                enabled: !timerSwap.running && items.twoPlayer
                opacity: items.twoPlayer
                Image {
                    source: Activity.url + 'turn.svg'
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
                        spacing: (controls.width - items.cellSize * 4) / 3
                        width: chessboard.width
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
                        spacing: (controls.height - items.cellSize * 4) / 3
                        width: items.cellSize
                        height: chessboard.height
                    }
                }
            }
        ]

        Rectangle {
            id: boardBg
            width: items.cellSize * 10 + GCStyle.baseMargins
            height: boardBg.width
            anchors.centerIn: layoutArea
            z: 08
            color: "#452501"
            onWidthChanged: items.noPieceAnimation = true

            // The chessboard
            GridView {
                id: chessboard
                cellWidth: items.cellSize
                cellHeight: items.cellSize
                width: items.cellSize * 8
                height: chessboard.width
                interactive: false
                keyNavigationWraps: true
                model: 64
                layoutDirection: Qt.RightToLeft
                delegate: squareBoard
                rotation: 180
                z: 10
                anchors.centerIn: boardBg

                Component {
                    id: squareBoard
                    Image {
                        source: index % 2 + (Math.floor(index / 8) % 2) == 1 ?
                        Activity.url + 'chess-white.svg' : Activity.url + 'chess-black.svg';
                        width: items.cellSize
                        height: items.cellSize
                    }
                }

                Behavior on rotation { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1400 } }

                function swap() {
                    flipSound.play()
                    coordsOpacity = 0
                    timerSwap.start()
                    if(chessboard.rotation == 180)
                        chessboard.rotation = 0
                        else
                            chessboard.rotation = 180
                }
            }

            Timer {
                id: timerSwap
                interval: 1500
                running: false
                repeat: false
                onTriggered: coordsOpacity = 1
            }

            Item {
                id: letters
                anchors.left: chessboard.left
                anchors.top: chessboard.bottom
                opacity: coordsOpacity
                Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 500} }
                Repeater {
                    id: lettersA
                    model: chessboard.rotation == 0 ? ["H", "G", "F", "E", "D", "C", "B", "A"] : ["A", "B", "C", "D", "E", "F", "G", "H"]
                    GCText {
                        x: items.cellSize * (index % 8) + (items.cellSize/2-width/2)
                        y: items.cellSize * Math.floor(index / 8)
                        text: modelData
                        color: "#CBAE7B"
                        font.pointSize: NaN
                        font.pixelSize: items.cellSize * 0.5
                    }
                }
            }
            Item {
                id: numbers
                anchors.left: chessboard.right
                anchors.top: chessboard.top
                opacity: coordsOpacity
                Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 500} }
                Repeater {
                    model: chessboard.rotation == 0 ? ["1", "2", "3", "4", "5", "6", "7", "8"] : ["8", "7", "6", "5", "4", "3", "2", "1"]
                    GCText {
                        x: items.cellSize * Math.floor(index / 8) + width
                        y: items.cellSize * (index % 8) + (items.cellSize/2-height/2)
                        text: modelData
                        color: "#CBAE7B"
                        font.pointSize: NaN
                        font.pixelSize: items.cellSize * 0.5
                    }
                }
            }

            Rectangle {
                id: boardBorder
                width: items.cellSize * 10
                height: boardBorder.width
                anchors.centerIn: boardBg
                z: -1
                color: "#542D0F"
                border.color: "#3A1F0A"
                border.width: items.cellSize * 0.1
            }
        }

        Repeater {
            id: squares
            model: items.positions
            parent: chessboard

            DropArea {
                id: squareArea
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                width: items.cellSize - spacing
                height: squareArea.width
                z: 1
                keys: acceptMove ? ['acceptMe'] : ['sorryNo']
                property bool acceptMove : false
                property int pos: modelData.pos
                property int spacing: GCStyle.halfMargins
                Rectangle {
                    id: possibleMove
                    anchors.fill: parent
                    color: parent.containsDrag ? '#803ACAFF' : 'transparent'
                    border.width: parent.acceptMove ? GCStyle.midBorder : 0
                    border.color: '#FF4EB271'
                    z: 1
                }
            }

            function getSquareAt(pos: int): var {
                for(var i=0; i < squares.count; i++) {
                    if(squares.itemAt(i).pos === pos)
                        return squares.itemAt(i)
                }
                return(undefined)
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
                height: piece.width
                source: img ? Activity.url + img + '.svg' : ''
                img: modelData.img
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                z: 1
                pos: modelData.pos
                newPos: modelData.pos
                rotation: -chessboard.rotation

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
                            pieces.getPieceAt(pos).move(pos)
                        }
                    }
                }
            }

            function moveTo(from: int, to: int) {
                movesCount ++
                var fromPiece = getPieceAt(from)
                var toPiece = getPieceAt(to)

                // Specific case for en passant move. It is a case where
                // we capture a pawn without having it at the "to" position.
                // To know if we captured, we browse the whole board to look 
                // for missing pawn
                var state = Activity.simplifiedState(Activity.state.board)
                for(var i=0; i < state.length; ++i) {
                    var pos = state[i].pos
                    var pawnPiece = getPieceAt(pos)
                    if(pos != from && state[i].img === "" &&
                       pawnPiece && pawnPiece.img[1] === 'p') {
                           smudgeSound.play()
                           if(pawnPiece.isWhite) {
                               whiteTakenPieces.addToList(pawnPiece)
                               whiteTakenPieces.pushedLast.push(movesCount)
                           } else {
                               blackTakenPieces.addToList(pawnPiece)
                               blackTakenPieces.pushedLast.push(movesCount)
                           }
                           pawnPiece.hide(pawnPiece.pos)
                           break
                    }
                }
                if(toPiece.img !== '') {
                    smudgeSound.play()
                    if(toPiece.isWhite) {
                        whiteTakenPieces.addToList(toPiece)
                        whiteTakenPieces.pushedLast.push(movesCount)
                    } else {
                        blackTakenPieces.addToList(toPiece)
                        blackTakenPieces.pushedLast.push(movesCount)
                    }
                }
                else
                    scrollSound.play()
                toPiece.hide(from)
                fromPiece.move(to)
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
                return(undefined)
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

        TakenPiecesList {
            id: whiteTakenPieces
            width: items.cellSize * 0.8
            edge: false
            z: 10
        }
        TakenPiecesList {
            id: blackTakenPieces
            width: items.cellSize * 0.8
            edge: true
            z: 10
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
