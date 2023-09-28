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
import GCompris 1.0

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
        id: background
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
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property var barHeightAddon: ApplicationSettings.isBarHidden ? textMessage.height : bar.height
            property bool isPortrait: (background.height >= background.width)
            property int cellSize: boardBg.width * 0.1
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
            property string message
            property bool isWarningMessage
            property alias trigComputerMove: trigComputerMove
            property alias timerSwap: timerSwap
            property alias whiteTakenPieceModel: whiteTakenPieces.takenPiecesModel
            property alias blackTakenPieceModel: blackTakenPieces.takenPiecesModel
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
                whiteTakenPieces.takenPiecesModel.remove(whiteTakenPieces.takenPiecesModel.count-1)
            }
            if(!items.twoPlayer) {
                movesCount--
            }
            if(blackTakenPieces.pushedLast[blackTakenPieces.pushedLast.length-1] == movesCount) {
                blackTakenPieces.pushedLast.pop()
                blackTakenPieces.takenPiecesModel.remove(blackTakenPieces.takenPiecesModel.count-1)
            }
            movesCount--
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

        GCText {
            id: textMessage
            z: 20
            color: items.isWarningMessage ? "red" : "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: layoutArea.width
            fontSize: smallSize
            text: items.message
            horizontalAlignment: Text.AlignHCenter
            wrapMode: TextEdit.WordWrap
        }

        Grid {
            id: controls
            z: 20
            spacing: (boardBg.width - items.cellSize * 4) * 0.25
            columns: items.isPortrait ? 4 : 1
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

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

        Rectangle {
            id: layoutArea
            width: background.width
            height: background.height - textMessage.height - items.barHeightAddon * 1.1
            opacity: 0
            anchors.horizontalCenter: background.horizontalCenter
        }

        Rectangle {
            id: controlsArea
            anchors.left: background.left
            anchors.right: boardBg.left
            anchors.top: boardBg.top
            anchors.bottom: boardBg.bottom
            opacity: 0
        }

        states: [
            State {
                name: "portraitLayout"; when: items.isPortrait
                PropertyChanges {
                    target: layoutArea
                    width: background.width * 0.86
                    height: background.height - textMessage.height - bar.height * 1.1
                }
                PropertyChanges {
                    target: controls
                    width:layoutArea.width
                    height: items.cellSize * 1.2
                    anchors.leftMargin: controls.spacing * 0.5
                    anchors.topMargin: 0
                    anchors.horizontalCenterOffset: 0
                }
                PropertyChanges {
                    target: boardBg
                    anchors.verticalCenterOffset: items.cellSize * -0.6
                }
                AnchorChanges {
                    target: layoutArea
                    anchors.top: controls.bottom
                }
                AnchorChanges {
                    target: controls
                    anchors.top: textMessage.bottom
                    anchors.horizontalCenter: undefined
                    anchors.left: boardBg.left
                }
            },
            State {
                name: "horizontalLayout"; when: !items.isPortrait
                PropertyChanges {
                    target: layoutArea
                    width: background.width
                    height: background.height - textMessage.height - items.barHeightAddon * 1.1
                }
                PropertyChanges {
                    target: controls
                    width: items.cellSize * 1.2
                    height: layoutArea.height
                    anchors.leftMargin: 0
                    anchors.topMargin: controls.spacing * 0.5
                    anchors.horizontalCenterOffset: items.cellSize * 0.8
                }
                PropertyChanges {
                    target: boardBg
                    anchors.verticalCenterOffset: 0
                }
                AnchorChanges {
                    target: layoutArea
                    anchors.top: textMessage.bottom
                }
                AnchorChanges {
                    target: controls
                    anchors.top: controlsArea.top
                    anchors.horizontalCenter: controlsArea.horizontalCenter
                    anchors.left: undefined
                }
            }
        ]

        Rectangle {
            id: boardBg
            width: Math.min(layoutArea.width, layoutArea.height)
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
                delegate: square
                rotation: 180
                z: 10
                anchors.centerIn: boardBg

                Component {
                    id: square
                    Image {
                        source: index % 2 + (Math.floor(index / 8) % 2) == 1 ?
                        Activity.url + 'chess-white.svg' : Activity.url + 'chess-black.svg';
                        width: items.cellSize
                        height: items.cellSize
                    }
                }

                Behavior on rotation { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1400 } }

                function swap() {
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/flip.wav')
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
            delegate: square
            parent: chessboard

            DropArea {
                id: square
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                width: items.cellSize - spacing
                height: square.width
                z: 1
                keys: acceptMove ? ['acceptMe'] : ['sorryNo']
                property bool acceptMove : false
                property int pos: modelData.pos
                property int spacing: 6 * ApplicationInfo.ratio
                Rectangle {
                    id: possibleMove
                    anchors.fill: parent
                    color: parent.containsDrag ? '#803ACAFF' : 'transparent'
                    border.width: parent.acceptMove ? 5 : 0
                    border.color: '#FF4EB271'
                    z: 1
                }
            }

            function getSquareAt(pos) {
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
            delegate: piece
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

            function moveTo(from, to) {
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
                           items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                           if(pawnPiece.isWhite) {
                               whiteTakenPieces.takenPiecesModel.append(pawnPiece)
                               whiteTakenPieces.pushedLast.push(movesCount)
                           } else {
                               blackTakenPieces.takenPiecesModel.append(pawnPiece)
                               blackTakenPieces.pushedLast.push(movesCount)
                           }
                           pawnPiece.hide(pawnPiece.pos)
                           break
                    }
                }

                if(toPiece.img !== '') {
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                    if(toPiece.isWhite) {
                        whiteTakenPieces.takenPiecesModel.append(toPiece)
                        whiteTakenPieces.pushedLast.push(movesCount)
                    } else {
                        blackTakenPieces.takenPiecesModel.append(toPiece)
                        blackTakenPieces.pushedLast.push(movesCount)
                    }
                }
                else
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                toPiece.hide(from)
                fromPiece.move(to)
            }

            function promotion(to) {
                var toPiece = getPieceAt(to)
                toPiece.promotion()
            }

            function getPieceAt(pos) {
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
        }
        TakenPiecesList {
            id: blackTakenPieces
            width: items.cellSize * 0.8
            edge: true
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
