/* GCompris - Sketch.qml
 *
 * SPDX-FileCopyrightText: 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2019-2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

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
        id: activityBackground
        anchors.fill: parent
        color: "#cacaca"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item selectedTool: brushTool
            property Item openPanel

            readonly property int baseMargins: 5 * ApplicationInfo.ratio
            readonly property bool isHorizontalLayout: activityBackground.width >= activityBackground.height
            property int buttonSize
            property real panelHandleWidth
            property real panelHandleHeight
            property int panelHandleRows: 2
            property int panelHandleColumns: 2
            property real panelGridY

            property bool canvasLocked: true
            property bool toolStarted: false
            property bool isSaved: true
            property bool resetRequested: false
            property bool homeRequested: false
            property color selectedForegroundColor: colorsPanel.selectedColor
            readonly property color foregroundColor: eraserMode ? backgroundColor : selectedForegroundColor
            property color backgroundColor: Qt.rgba(1,1,1,1)
            property color newBackgroundColor: backgroundColorSelector.newBackgroundColor
            property string backgroundToLoad: ""
            property color colorStop1
            property color colorStop2
            property real selectedAlpha: 0.5
            property bool eraserMode: false
            property alias layoutArea: layoutArea
            property alias canvasArea: canvasArea
            property alias canvasColor: canvasColor
            property alias canvasImage: canvasImage
            property alias loadedImage: loadedImage
            property alias tempCanvas: tempCanvas
            property alias outlineCursorRadius: outlineCursor.radius
            property alias scrollSound: scrollSound
            property alias smudgeSound: smudgeSound
            property alias newImageDialog: newImageDialog
            property alias creationHandler: creationHandler
            readonly property color panelColor: "#383838"
            readonly property color contentColor: "#D2D2D2"
            property var canvasImageSource
            property int undoIndex: 0
            readonly property real devicePixelRatio: Screen.devicePixelRatio
            readonly property real grabWidth: canvasArea.width * devicePixelRatio
            readonly property real grabHeight: canvasArea.height * devicePixelRatio

            readonly property var patternList: [
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
                items.openPanel.forceClose();
            }
        }

        onWidthChanged: {
            clearOpenPanels();
        }

        onHeightChanged: {
            clearOpenPanels();
        }

        onStart: {
            Activity.start(items);
            // TODO: remove this and uncomment the properties in ovalShape and lineShape items after we set minimum Qt >= 6.6
            if(ApplicationInfo.QTVersion.startsWith("6.5.") === false) {
                ovalShape.preferredRendererType = Shape.CurveRenderer;
                lineShape.preferredRendererType = Shape.CurveRenderer;
            }
        }
        onStop: {
            processTimer.stop();
            Activity.stop();
        }

        Keys.onEscapePressed: requestHome();

        Keys.onPressed: (event) => {
            if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Z)) {
                Activity.undoAction();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Y)) {
                Activity.redoAction();
                event.accepted = true;
            } else if(event.key === Qt.Key_Delete ||
                    event.key === Qt.Key_Backspace ||
                    ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_N))) {
                Activity.requestNewImage();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)) {
                Activity.saveImageDialog();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_O)) {
                Activity.openImageDialog();
                event.accepted = true;
            } else if((event.modifiers === Qt.ControlModifier && event.key === Qt.Key_W) || event.key === Qt.Key_Back) {
                requestHome();
                event.accepted = true;
            }
        }

        function requestHome() {
            if(items.isSaved) {
                activity.home();
            } else {
                items.homeRequested = true;
                newImageDialog.active = true;
            }
        }


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

            function init() {
                canvasInput.resetPoints();
                items.selectedTool.toolInit();
            }

            Rectangle {
                id: canvasColor
                anchors.fill: parent
            }

            Image {
                id: loadedImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                cache: false
                smooth: true
                source: ""
                visible: false
            }

            // The QML Canvas has lots of issues when deviceRatio != 1, especially it can't load images at real pixel size, only device pixel size.
            // This makes it impossible to have good undo/redo or load images with proper resolution (not looking pixelated).
            // Using an Image instead to store the painting is the only solution I found which doesn't require coding the painting tools in C++.
            Image {
                id: canvasImage
                anchors.fill: parent
                // DO NOT use Image.PreserveAspectFit, as it progressively adds some blur at each paint iteration when deviceRatio != 1...
                fillMode: Image.Stretch
                cache: false
                smooth: true

                // After loading canvas result to image, clear Canvas and hide other drawing sources
                onSourceChanged: {
                    tempCanvas.ctx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);
                    tempCanvas.requestPaint();
                    loadedImage.visible = false;
                    geometryShape.visible = false;
                    ovalShape.visible = false;
                    lineShape.visible = false;
                    gradientShape.visible = false;
                    gradientShapePath.fillGradient = null;
                    stampImage.visible = false;
                    textShape.visible = false;
                    items.canvasLocked = false;
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
                    ctx = getContext("2d");
                }

                function paintActionFinished() {
                    canvasArea.grabToImage(function(result) {
                        items.canvasImageSource = result.url;
                        canvasImage.source = items.canvasImageSource;
                        var undoPath = tempPath + items.undoIndex.toString() + ".png";
                        result.saveToFile(undoPath);
                        // push last snapshot to undo stack
                        Activity.pushToUndo(undoPath);
                        Activity.resetRedo();
                    }, Qt.size(items.grabWidth, items.grabHeight))
                }

                MouseArea {
                    id: canvasInput
                    anchors.fill: parent
                    enabled: items.openPanel == null
                    hoverEnabled: true

                    property var lastPoint
                    property var midPoint
                    property var currentPoint

                    function savePoint() {
                        return { x: mouseX, y: mouseY };
                    }

                    function resetPoints() {
                        lastPoint = midPoint = currentPoint = { x: -1, y: -1 };
                    }

                    onPressed: {
                        if(!items.canvasLocked) {
                            items.isSaved = false;
                            items.selectedTool.toolStart();
                            items.toolStarted = true;
                        }
                    }

                    onReleased: {
                        items.canvasLocked = true;
                        items.selectedTool.toolStop();
                        items.toolStarted = false;
                    }

                    onPositionChanged: {
                        if(items.selectedTool.usePositionChanged && items.toolStarted) {
                            items.selectedTool.toolProcess();
                        }
                    }
                }

                Timer {
                    id: processTimer
                    interval: 30
                    repeat: true
                    onTriggered: {
                        items.selectedTool.toolProcess();
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
                    // TODO: uncomment this and update the start function once we set minimum Qt version required >= 6.6
                    // This property is not available on Qt 6.5, so for now we set it conditionally in the start function.
                    // preferredRendererType: Shape.CurveRenderer
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
                    // TODO: see comment in ovalShape...
                    // preferredRendererType: Shape.CurveRenderer
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

        Rectangle {
            id: outlineCursor
            color: "#00000000"
            border.color: "#80000000"
            border.width: 1
            radius: 0
            width: 2 * radius
            height: width
            visible: canvasInput.containsMouse && radius > 0
            x: canvasInput.mouseX - radius + canvasArea.x
            y: canvasInput.mouseY - radius + canvasArea.y

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: parent.color
                border.color: "#80FFFFFF"
                border.width: 1
                radius: width
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
                items.openPanel.toggleOpen();
            }
        }

        // All 3 foldable panels
        FilesPanel {
            id: filesPanel
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
            anchors.right: activityBackground.right
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
                        enabled: !items.canvasLocked
                        onPressed: parent.scale = 0.9
                        onReleased: parent.scale = 1
                        onClicked: {
                            Activity.undoAction();
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
                        enabled: !items.canvasLocked
                        onPressed: parent.scale = 0.9
                        onReleased: parent.scale = 1
                        onClicked: {
                            Activity.redoAction();
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
                    items.buttonSize: Math.min(((activityBackground.height - bar.height * 1.2) - 15 * items.baseMargins) * 0.125, 50 * ApplicationInfo.ratio)
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
                    items.buttonSize: Math.min((activityBackground.width - 15 * items.baseMargins) * 0.125, 50 * ApplicationInfo.ratio)
                    items.panelHandleWidth: items.buttonSize * 2 + items.baseMargins * 3
                    items.panelHandleHeight: items.buttonSize + items.baseMargins * 3
                    items.panelHandleRows: 1
                    items.panelHandleColumns: 2
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

        GCCreationHandler {
            id: creationHandler
            imageMode: true
            fileExtensions: ["*.svg", "*.png", "*.jpg", "*.jpeg", "*.webp"]
            onSaved: {
                items.isSaved = true;
            }
            onFileLoaded: (data, filePath) => {
                Activity.imageToLoad = filePath;
                Activity.requestNewImage();
            }
            onClose: {
                filesPanel.forceClose();
                activity.focus = true;
            }
        }

        BackgroundSelector {
            id: backgroundSelector
            visible: false
            onClose: home();
        }

        BackgroundColorSelector {
            id: backgroundColorSelector
            visible: false
            onClose: home();
        }

        Loader {
            id: newImageDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: items.homeRequested ?
                    qsTr("You did not save this image. Do you want to close this activity?") :
                    qsTr("Do you want to erase this image?")
                button1Text: qsTr("Yes")
                button2Text: qsTr("No")
                onClose: {
                    newImageDialog.active = false;
                    items.homeRequested = false;
                    items.resetRequested = false;
                }

                property bool yesPressed: false

                onButton1Hit: {
                    yesPressed = true;
                    if(items.homeRequested) {
                        return;
                    } else if(items.resetRequested) {
                        Activity.resetLevel();
                    } else {
                        Activity.newImage();
                    }
                }
                onButton2Hit: {
                    yesPressed = false;
                    Activity.imageToLoad = "";
                }
                onDeferredAction: {
                    if(items.homeRequested && yesPressed) {
                        activity.home();
                    }
                }
            }
            anchors.fill: parent
            focus: true
            active: false
            onStatusChanged: if(status == Loader.Ready) item.start();
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onHomeClicked: {
                activityBackground.requestHome();
            }
            onReloadClicked: {
                if(items.isSaved) {
                    Activity.resetLevel();
                } else {
                    items.resetRequested = true;
                    newImageDialog.active = true;
                }
            }
        }
    }
}
