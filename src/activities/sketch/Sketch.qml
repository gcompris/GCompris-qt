/* GCompris - Sketch.qml
 *
 * SPDX-FileCopyrightText: 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2019-2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import GCompris 1.0

// for Shapes
import QtQuick.Shapes

// for StandardPaths
import QtCore

import "../../core"
import "sketch.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#cacaca"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item selectedTool: brushTool
            property Item openPanel

            property int baseMargins: 5 * ApplicationInfo.ratio
            property bool isHorizontalLayout: background.width >= background.height
            property int buttonSize
            property real panelHandleWidth
            property real panelHandleHeight
            property int panelHandleColumns
            property int panelHandleRows
            property real panelGridY

            property bool canvasLocked: true
            property color selectedForegroundColor: Qt.rgba(0,0,0,1)
            property color foregroundColor: eraserMode ? backgroundColor : selectedForegroundColor
            property color backgroundColor: Qt.rgba(1,1,1,1)
            property color colorStop1
            property color colorStop2
            property real selectedAlpha: 0.5
            property bool eraserMode: false
            property alias layoutArea: layoutArea
            property alias canvasArea: canvasArea
            property alias canvasColor: canvasColor
            property alias canvasImage: canvasImage
            property alias tempCanvas: tempCanvas
            property alias scrollSound: scrollSound
            property alias smudgeSound: smudgeSound
            property color panelColor: "#383838"
            property color contentColor: "#D2D2D2"
            property var canvasImageSource
            property int undoIndex: 0
            // WARNING: if devicePixelRatio is not integer or .5 value (like 2.75), and software renderer is used, it will lead to incremental blur on the image...
            // Maybe we should disable the activity in case of such system combination...
            property real devicePixelRatio: Screen.devicePixelRatio
            property real grabWidth: canvasArea.width * devicePixelRatio
            property real grabHeight: canvasArea.height * devicePixelRatio

            property var patternList: [
                                        Qt.SolidPattern,
                                        Qt.HorPattern,
                                        Qt.VerPattern,
                                        Qt.CrossPattern,
                                        Qt.BDiagPattern,
                                        Qt.FDiagPattern,
                                        Qt.DiagCrossPattern,
                                        Qt.Dense7Pattern,
                                        Qt.Dense6Pattern,
                                        Qt.Dense5Pattern,
                                        Qt.Dense4Pattern,
                                        Qt.Dense3Pattern,
                                        Qt.Dense2Pattern,
                                        Qt.Dense1Pattern
                                    ]
        }

        function clearOpenPanels() {
            // reset saved open panel to isOpen = false, as they close automatically on window size change.
            if(items.openPanel) {
                items.openPanel.forceClose()
                items.openPanel = null
            }
        }

        onWidthChanged: {
            clearOpenPanels()
        }

        onHeightChanged: {
            clearOpenPanels()
        }

        onStart: { Activity.start(items) }
        onStop: {
            processTimer.stop()
            Activity.stop()
        }

        // // TO TEST Blending modes...
        // Keys.onPressed: (event) => {
        //     if (event.key === Qt.Key_Right) {
        //         selectNextBlendingMode()
        //     }
        // }
        // property var blendingModes: ["source-atop", "source-in", "source-out", "source-over", "destination-atop", "destination-in", "destination-out", "destination-over", "lighter", "copy", "xor", "qt-clear", "qt-destination", "qt-multiply", "qt-screen", "qt-overlay", "qt-darken", "qt-lighten", "qt-color-dodge", "qt-color-burn", "qt-hard-light", "qt-soft-light", "qt-difference", "qt-exclusion"]
        // property var selectedBlendingMode: 0
        // function selectNextBlendingMode() {
        //     selectedBlendingMode += 1
        //     if(selectedBlendingMode >= blendingModes.length) {
        //         selectedBlendingMode = 0;
        //     }
        //     tempCanvas.ctx.globalCompositeOperation = blendingModes[selectedBlendingMode]
        //     console.log("Blending mode is " + blendingModes[selectedBlendingMode])
        // }
        // //

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: layoutArea
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: bar.height * 1.2 + items.baseMargins
            anchors.leftMargin: items.baseMargins
        }

        Item {
            id: canvasArea
            anchors.centerIn: layoutArea

            property url savePath: "file://" + ApplicationSettings.userDataPath + "/sketch/cache" + items.undoIndex.toString() + ".png"

            function init() {
                canvasInput.resetPoints()
                items.selectedTool.toolInit()
            }

            Rectangle {
                id: canvasColor
                anchors.fill: parent
            }

            // The QML Canvas has lots of issues when deviceRatio != 1, especially it can't load images at real pixel size, only device pixel size.
            // This makes it impossible to have good undo/redo or load images with proper resolution (not looking pixelated).
            // Using an Image instead to store the painting is the only solution I found which doesn't require coding the painting tools in C++.
            Image {
                id: canvasImage
                anchors.fill: parent
                // DO NOT use Imgage.PreserveAspectFit, as it progressively adds some blur at each paint iteration when deviceRatio != 1...
                fillMode: Image.Stretch
                cache: false
                smooth: true

                // After loading canvas result to image, clear Canvas and hide other drawing sources
                onSourceChanged: {
                    console.log("source changed")
                    tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height)
                    tempCanvas.requestPaint()
                    geometryShape.visible = false
                    ovalShape.visible = false
                    lineShape.visible = false
                    gradientShape.visible = false
                    gradientShapePath.fillGradient = null
                    stampImage.visible = false
                    textShape.visible = false
                    items.canvasLocked = false
                }
            }

            Canvas {
                id: tempCanvas
                anchors.fill: parent
                scale: 1
                x: 0
                y: 0
                renderStrategy: Canvas.Immediate
                renderTarget: Canvas.Image
                clip: true // useful to avoid Rectangle, Shapes, etc... overflows

                property var ctx
                property url tempPath: StandardPaths.writableLocation(StandardPaths.TempLocation) + "/GCSketchCache"

                function initContext() {
                    ctx = getContext("2d")
                }

                function paintActionFinished() {
                    canvasArea.grabToImage(function(result) {
                        items.canvasImageSource = result.url;
                        canvasImage.source = items.canvasImageSource;
                        var undoPath = tempPath + items.undoIndex.toString() + ".png"
                        result.saveToFile(undoPath)
                        // push last snapshot to undo stack
                        Activity.pushToUndo(undoPath);
                        Activity.resetRedo();
                    }, Qt.size(items.grabWidth, items.grabHeight))
                }

                MouseArea {
                    id: canvasInput
                    anchors.fill: parent
                    enabled: true

                    property var lastPoint
                    property var midPoint
                    property var currentPoint

                    function savePoint() {
                        return { x: mouseX, y: mouseY }
                    }

                    function resetPoints() {
                        lastPoint = midPoint = currentPoint = { x: -1, y: -1 }
                    }

                    onPressed: {
                        if(!items.canvasLocked)
                            items.selectedTool.toolStart()
                    }

                    onReleased: {
                        items.canvasLocked = true
                        items.selectedTool.toolStop()
                    }

                    onPositionChanged: {
                        if(items.selectedTool.usePositionChanged) {
                            items.selectedTool.toolProcess()
                        }
                    }
                }

                Timer {
                    id: processTimer
                    interval: 30
                    repeat: true
                    onTriggered: {
                        items.selectedTool.toolProcess()
                    }
                }

                Image {
                    id: stampImage
                    visible: false
                    x: 0
                    y: 0
                    width: 0
                    height: width
                    sourceSize.width: width
                    sourceSize.height: width
                    fillMode: Image.PreserveAspectFit
                }

                Rectangle {
                    id: geometryShape
                    visible: false
                    x: 0
                    y: 0
                    width: 0
                    height: 0
                    color: items.selectedForegroundColor
                }

                RadialGradient {
                    id: radialGradientFill
                    centerX: 0
                    centerY: 0
                    focalX: centerX
                    focalY: centerY
                    centerRadius: 1
                    focalRadius: 1
                    property bool isInverted: false
                    GradientStop { position: 0; color: radialGradientFill.isInverted ? items.colorStop2 : items.colorStop1 }
                    GradientStop { position: 1; color: radialGradientFill.isInverted ? items.colorStop1 : items.colorStop2 }
                }

                LinearGradient {
                    id: linearGradientFill
                    x1: 0
                    y1: 0
                    x2: 0
                    y2: 0
                    GradientStop { position: 0; color: items.colorStop1 }
                    GradientStop { position: 1; color: items.colorStop2 }
                }

                Shape {
                    id: gradientShape
                    visible: false
                    z: -1
                    x: 0
                    y: 0
                    width: tempCanvas.width
                    height: tempCanvas.height

                    ShapePath {
                        id: gradientShapePath
                        startX: 0
                        startY: 0
                        strokeWidth: -1
                        fillGradient: null
                        PathLine { x: gradientShape.width; y: 0 }
                        PathLine { x: gradientShape.width; y: gradientShape.height }
                        PathLine { x: 0 ; y: gradientShape.height }
                        PathLine { x: 0 ; y: 0 }
                    }
                }

                Shape {
                    id: ovalShape
                    visible: false
                    x: 0
                    y: 0
                    width: 0
                    height: 0
                    preferredRendererType: Shape.CurveRenderer
                    onVisibleChanged: {
                        if(!visible) {
                            x = y = width = height =0
                        }
                    }
                    ShapePath {
                        id: ovalShapePath
                        fillColor: items.selectedForegroundColor
                        strokeWidth: -1
                        startX: ovalShape.width * 0.5
                        startY: 0
                        PathArc {
                            x: ovalShape.width * 0.5
                            y: ovalShape.height
                            radiusX: ovalShape.width * 0.5
                            radiusY: ovalShape.height * 0.5
                            useLargeArc: true
                        }
                        PathArc {
                            x: ovalShape.width * 0.5
                            y: 0
                            radiusX: ovalShape.width * 0.5
                            radiusY: ovalShape.height * 0.5
                            useLargeArc: true
                        }
                    }
                }


                Shape {
                    id: lineShape
                    visible: false
                    x: 0
                    y: 0
                    width: parent.width
                    height: parent.height
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath {
                        id: lineShapePath
                        capStyle: ShapePath.RoundCap
                        strokeWidth: -1
                        strokeColor: items.selectedForegroundColor
                        startX: 0
                        startY: 0
                        PathLine {
                            id: lineShapeEnd
                            x: 0
                            y: 0
                        }
                    }
                }

                GCText {
                    id: textShape
                    visible: false
                    x: 0
                    y: 0
                    width: parent.width
                    height: parent.height
                    color: items.selectedForegroundColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: ""
                }

            }
        }

        // All tools, one Item for each
        BrushTool{
            id: brushTool
        }

        GeometryTool {
            id: geometryTool
        }

        GradientTool {
            id: gradientTool
        }

        StampTool {
            id: stampTool
        }

        TextTool {
            id: textTool
        }

        MouseArea {
            anchors.fill: parent
            enabled: items.openPanel!= null
            onClicked: {
                items.openPanel.toggleOpen()
            }
        }

        // All 3 foldable panels
        MenuPanel {
            id: menuPanel
        }

        ToolsPanel {
            id: toolsPanel
        }

        ColorsPanel {
            id: colorsPanel
        }

        Rectangle {
            id: undoPanel
            radius: items.baseMargins
            color: items.panelColor
            height: items.panelHandleHeight
            border.color: items.contentColor
            anchors.right: background.right
            anchors.margins: -items.baseMargins

            Grid {
                id: undoRedoGrid
                x: items.baseMargins
                y: items.panelGridY
                spacing: items.baseMargins
                columns: items.panelHandleColumns
                rows: items.panelHandleRows

                Image {
                    id: undo
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    height: items.buttonSize
                    width: items.buttonSize
                    sourceSize.width: items.buttonSize
                    sourceSize.height: items.buttonSize
                    MouseArea {
                        anchors.fill: parent
                        // enabled: !items.canvasLocked
                        onPressed: parent.scale = 0.9
                        onReleased: parent.scale = 1
                        onClicked: {
                            Activity.undoAction()
                        }
                    }
                }

                Image {
                    id: redo
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    mirror: true // mirrored undo image for redo
                    height: items.buttonSize
                    width: items.buttonSize
                    sourceSize.width: items.buttonSize
                    sourceSize.height: items.buttonSize
                    MouseArea {
                        anchors.fill: parent
                        // enabled: !items.canvasLocked
                        onPressed: parent.scale = 0.9
                        onReleased: parent.scale = 1
                        onClicked: {
                            Activity.redoAction()
                        }
                    }
                }
            }
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontalLayout

                PropertyChanges {
                    items.buttonSize: Math.min(((background.height - bar.height * 1.2) - 15 * items.baseMargins) * 0.125, 50 * ApplicationInfo.ratio)
                    items.panelHandleWidth: items.buttonSize + items.baseMargins * 3
                    items.panelHandleHeight: items.buttonSize * 2 + items.baseMargins * 3
                    items.panelHandleColumns: 1
                    items.panelHandleRows: 2
                    items.panelGridY: items.baseMargins

                    layoutArea.anchors.topMargin: items.baseMargins
                    layoutArea.anchors.rightMargin: items.buttonSize + items.baseMargins * 3

                    toolsPanel.handleOffset: items.panelHandleHeight + items.baseMargins
                    colorsPanel.handleOffset: (items.panelHandleHeight + items.baseMargins) * 2
                    undoPanel.y: items.panelHandleHeight * 3 + items.baseMargins * 3
                    undoPanel.width: items.panelHandleWidth
                }
                AnchorChanges {
                    target: layoutArea
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
            },
            State {
                name: "verticalLayout"
                when: !items.isHorizontalLayout

                PropertyChanges {
                    items.buttonSize: Math.min((background.width - 15 * items.baseMargins) * 0.125, 50 * ApplicationInfo.ratio)
                    items.panelHandleWidth: items.buttonSize * 2 + items.baseMargins * 3
                    items.panelHandleHeight: items.buttonSize + items.baseMargins * 3
                    items.panelHandleColumns: 2
                    items.panelHandleRows: 1
                    items.panelGridY: items.baseMargins * 2

                    layoutArea.anchors.topMargin: items.buttonSize + items.baseMargins * 3
                    layoutArea.anchors.rightMargin: items.baseMargins

                    toolsPanel.handleOffset: items.panelHandleWidth + items.baseMargins
                    colorsPanel.handleOffset: (items.panelHandleWidth + items.baseMargins) * 2
                    undoPanel.y: -items.baseMargins
                    undoPanel.width: items.panelHandleWidth + items.baseMargins
                }
                AnchorChanges {
                    target: layoutArea
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
            }

        ]

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: {
                activity.home()
                // saveToFilePrompt.buttonPressed = "home"
                // if (!items.nothingChanged) {
                //     saveToFilePrompt.text = qsTr("Do you want to save your painting?")
                //     saveToFilePrompt.opacity = 1
                //     saveToFilePrompt.z = 200
                // } else {
                //     if (main.x == 0)
                //         load.opacity = 0
                //         activity.home()
                // }
            }
            onReloadClicked: {
                Activity.initLevel()
                // if (!items.nothingChanged) {
                //     saveToFilePrompt.buttonPressed = "reload"
                //     saveToFilePrompt.text = qsTr("Do you want to save your painting before reseting the board?")
                //     saveToFilePrompt.opacity = 1
                //     saveToFilePrompt.z = 200
                // } else {
                //     Activity.initLevel()
                // }
            }
        }
    }
}
