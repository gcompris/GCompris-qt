/* GCompris - DrawingWheels.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
import QtQuick
// for StandardPaths
import QtCore
import core 1.0

import "../../core"
import "../sketch"
import "drawingWheels.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // Storing undo with QQuickItemGrabResult uses quite some RAM,
    // so limit more by default on mobile which typically has less RAM than computers
    property int undoSetting: ApplicationInfo.isMobile ? 5 : 10

    pageComponent: Rectangle {
        id: activityBackground

        anchors.fill: parent
        color: "#cacaca"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            readonly property bool isHorizontalLayout: activityBackground.width >= activityBackground.height

            property alias creationHandler: creationHandler

            property alias wheelTeeth: wheelTeethSlider.value // Teeth count for the wheel
            property alias gearTeeth: gearTeethSlider.value       // Teeth count for the gear
            property alias theWheel: theWheel
            property alias theGear: theGear
            property alias canvasContainer: canvasContainer    // the initial area to setup the canvas
            property alias canvasArea: canvasArea              // image grabber
            property alias canvasImage: canvasImage            // loaded image
            property alias animationCanvas: animationCanvas    // temporary canvas for drawing animation
            property alias penOffset: penOffsetSlider.value
            property real actualPenOffset: penOffset / devicePixelRatio
            property alias penOpacity: penOpacitySlider.value
            property alias gearTimer: gearTimer
            property alias toolsContainer: toolsContainer
            property alias toothOffset: toothOffsetSlider.value
            property alias file: file
            property alias currentWheel: wheelPanel.currentWheel
            property alias currentGear: wheelPanel.currentGear
            property alias gearsModel: gearsModel
            property alias undoStack: undoStack
            property alias svgTank: svgTank
            property alias newImageDialog: newImageDialog
            property alias scrollSound: scrollSound
            property alias panelManager: panelManager

            property color backgroundColor: Qt.rgba(1,1,1,1)
            property color newBackgroundColor: backgroundColorSelector.newBackgroundColor
            readonly property color transparentColor: Qt.rgba(0,0,0,0)
            property real maxRounds: Activity.computeLcm(wheelTeethSlider.value, gearTeethSlider.value) /
                                        wheelTeethSlider.value
            property real spikesCount: Activity.computeLcm(wheelTeethSlider.value, gearTeethSlider.value) /
                                        gearTeethSlider.value
            property color penColor: Qt.rgba(0,0,0,1)
            property alias penWidth: penSizeSlider.value
            property real actualPenWidth: penWidth / devicePixelRatio
            property point lastPoint: Qt.point(0, 0)
            property int undoIndex: 0
            property bool runCompleted: false // used to avoid moving the gear too far
            property bool startedFromOrigin: true
            property string actionAfter: ""
            property bool canvasLocked: true
            property bool isFileSaved: true
            property int baseButtonSize: 60 * ApplicationInfo.ratio
            property bool fileIsEmpty: true
            // NOTE: looks like on Image using data-URI SVG as source,
            // the sourceSize linked to size doesn't work properly,
            // so we need to multiply it ourselves by devicePixelRatio.
            // Also used to scale penWidth and penOffset.
            readonly property real devicePixelRatio: Screen.devicePixelRatio
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        File { id: file }

        ListModel { id: gearsModel }

        Keys.onEscapePressed: requestHome();

        Keys.onPressed: (event) => {
            if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Z)) {
                Activity.undoAction()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Y)) {
                Activity.redoAction()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)) {
                Activity.saveSvgDialog();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_O)) {
                Activity.openImageDialog();
                event.accepted = true;
            } else if((event.modifiers === Qt.ControlModifier && event.key === Qt.Key_W)) {
                requestHome();
                event.accepted = true;
            }
        }

        Keys.onReleased: (event) => {
            if(event.key === Qt.Key_Back) {
                requestHome();
                event.accepted = true;
            }
        }

        function requestHome() {
            if (!items.isFileSaved) {
                items.actionAfter = "home"
                newImageDialog.active = true
                return
            }
            activity.home()
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        UndoStack {
            id: undoStack
            maxUndo: activity.undoSetting

            function pushToUndoStack() {
                undoStack.pushData({
                    "wheelAngle_": items.theGear.wheelAngle
                    , "toothOffset_": items.toothOffset
                    , "penOffset_": items.penOffset
                    , "penOpacity_": items.penOpacity
                    , "penColor_": items.penColor
                    , "penWidth_": items.penWidth
                    , "currentWheel_": items.currentWheel
                    , "currentGear_": items.currentGear
                    , "wheelTeeth_": items.wheelTeeth
                    , "gearTeeth_": items.gearTeeth
                })
            }

            function restoreFromStack(todo) {
                if (todo === undefined)  return
                items.theGear.wheelAngle = todo.wheelAngle_
                items.toothOffset = todo.toothOffset_
                items.penOffset = todo.penOffset_
                items.penOpacity = todo.penOpacity_
                items.penColor = todo.penColor_
                items.penWidth = todo.penWidth_
                // Always load currentGear before currentWheel, else currentGear risks to change on currentWheelChanged.
                items.currentGear = todo.currentGear_
                items.currentWheel = todo.currentWheel_
                items.wheelTeeth = todo.wheelTeeth_
                items.gearTeeth = todo.gearTeeth_
                Activity.initGear()

                items.animationCanvas.initContext()
                items.animationCanvas.ctx.lineWidth = items.penWidth
                items.animationCanvas.ctx.strokeStyle = items.penColor
                Activity.rotateGear(0)       // move pencil and gear in position, trigger repaint animationCanvas
            }

            // Update pen attributes before drawing to be restored on undo
            function updateUndo() {
                const todo = undoStack.getLastStacked()
                todo.wheelAngle_ = items.theGear.wheelAngle
                todo.toothOffset_ = items.toothOffset
                todo.penOffset_ = items.penOffset
                todo.penOpacity_ = items.penOpacity
                todo.penColor_ = items.penColor
                todo.penWidth_ = items.penWidth
                todo.currentWheel_ = items.currentWheel
                todo.currentGear_ = items.currentGear
                todo.wheelTeeth_ = items.wheelTeeth
                todo.gearTeeth_ = items.gearTeeth
                undoStack.setLastStacked(todo)
            }
        }

        SvgTank {
            id: svgTank
            fileName: canvasArea.tempSavePath + "/GCDrawingWheels.svg"
            stroke: items.penColor
            strokeWidth: items.actualPenWidth
            svgOpacity: items.penOpacity
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Item {
            id: canvasContainer
            anchors.fill: layoutArea

            GImageGrabber {
                id: canvasArea
                x: Math.round((parent.width - width) * 0.5)
                y: Math.round((parent.height - height) * 0.5)
                maxUndo: activity.undoSetting

                readonly property url tempSavePath: StandardPaths.writableLocation(StandardPaths.TempLocation)
                readonly property url tempSaveFile: tempSavePath + "/GCDrawingWheels.png"

                function sendToImageSource() {
                    canvasImage.source = canvasArea.getImageUrl();
                }

                onGrabReady: {
                    canvasArea.sendToImageSource();
                    animationCanvas.clearTempCanvas();
                }

                Rectangle {
                    id: canvasColor
                    anchors.fill: parent
                    color: items.backgroundColor
                }

                // Used to load saved image with size set to fit the canvas
                Image {
                    id: loadedImage
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    smooth: true
                    source: ""
                    visible: false
                    sourceSize.width: width
                    sourceSize.height: height
                }

                Image {
                    id: canvasImage
                    anchors.fill: parent
                    // DO NOT use Image.PreserveAspectFit, as it progressively adds some blur at each paint iteration when deviceRatio != 1...
                    fillMode: Image.Stretch
                    cache: false
                    smooth: true
                }

                Canvas {    // The animation of the drawing is done in animationCanvas and copied to canvasImage once the drawing cycles are complete.
                    id: animationCanvas
                    property var ctx: null
                    anchors.fill: parent
                    anchors.margins: 0
                    renderStrategy: Canvas.Immediate
                    renderTarget: Canvas.Image
                    clip: true
                    opacity: items.penOpacity   // Pen opacity is applied to the whole canvas. Context drawing is always done with opacity 1.0

                    function initContext() {
                        ctx = getContext("2d")
                        ctx.fillStyle = items.transparentColor
                        ctx.clearRect(0, 0, width, height);
                        ctx.lineCap = ctx.lineJoin = "round"
                        requestPaint()
                    }

                    function getPencilPosition() {
                        return animationCanvas.mapFromItem(pencil, pencil.center, pencil.center)
                    }

                    // After loading canvas result to image, clear Canvas and hide other drawing sources
                    function clearTempCanvas() {
                        animationCanvas.ctx.clearRect(0, 0, animationCanvas.width, animationCanvas.height);
                        animationCanvas.requestPaint();
                        loadedImage.visible = false
                        items.canvasLocked = false;
                    }

                    function paintActionFinished() {
                        items.undoStack.pushToUndoStack();
                        canvasArea.safeGrab(Qt.size(canvasArea.width, canvasArea.height));
                        // next steps are in canvasArea onGrabReady...
                    }
                }
            }

            // Wheel and gear
            Image {
                id: theWheel
                property real intRadius: 0
                property real extRadius: 0
                anchors.centerIn: canvasArea
                visible: !hideGears.checked
                opacity: 0.5
                cache: false
                asynchronous: true
                retainWhileLoading: true
                smooth: true
                sourceSize.width: width * items.devicePixelRatio
                sourceSize.height: height * items.devicePixelRatio

                GCText {
                    id: theWheelValue
                    text: wheelTeethSlider.value
                    anchors.top: theWheel.top
                    anchors.horizontalCenter: theWheel.horizontalCenter
                    fontSize: 8
                    fixFontSize: true
                }
            }

            Image {
                id: theGear
                property real centerX: 0
                property real centerY: 0
                property real extRadius: 50
                property real wheelAngle: 0
                x: centerX + (canvasContainer.width - width) * 0.5
                y: centerY + (canvasContainer.height - height) * 0.5
                rotation: 0
                visible: !hideGears.checked
                cache: false
                asynchronous: true
                retainWhileLoading: true
                sourceSize.width: width * items.devicePixelRatio
                sourceSize.height: height * items.devicePixelRatio

                Rectangle {
                    id: gearRadius
                    x: (parent.width - width) * 0.5
                    y: height
                    width: 1
                    height: parent.height * 0.5
                    color: "#80808080"
                    border.width: 0
                    border.pixelAligned: false
                }

                Rectangle {
                    id: pencil
                    property real center: width * 0.5
                    width: 2 + items.actualPenWidth
                    height: width
                    radius: width
                    color: items.penColor
                    border.width: 1
                    border.color: "#80000000"
                    border.pixelAligned: false
                    x: (parent.width - width) * 0.5
                    y: x + items.actualPenOffset
                }
            }
        }

        Rectangle {
            id: toolsContainer
            color: GCStyle.darkBg
            anchors.right: parent.right
            anchors.top: parent.top

            property int buttonSize: 1

            Flow {
                id: toolsFlow
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                spacing: GCStyle.halfMargins

                IconButton {
                    id: fileButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/filesMenu.svg"
                    toolTip: qsTr("File menu")
                    width: toolsContainer.buttonSize
                    selected: true
                    enabled: !gearTimer.running
                    onClicked: {
                        panelManager.showPanel(filePanel);
                    }
                }

                IconButton {
                    id: gearButton
                    source: "qrc:/gcompris/src/activities/drawing_wheels/resource/gear.svg"
                    toolTip: qsTr("Wheel and gear")
                    width: toolsContainer.buttonSize
                    selected: true
                    enabled: !gearTimer.running
                    onClicked: {
                        panelManager.showPanel(wheelPanel);
                    }
                    GCText {
                        anchors.centerIn: parent
                        width: parent.width * 0.6
                        height: width
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        fixFontSize: true
                        color: GCStyle.whiteText
                        text: gearTeethSlider.value
                    }
                }

                IconButton {
                    id: pencilButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/brushTools.svg"
                    toolTip: qsTr("Pencil size and position")
                    width: toolsContainer.buttonSize
                    selected: true
                    enabled: !gearTimer.running
                    onClicked: {
                        panelManager.showPanel(penPanel);
                    }
                }

                IconButton {
                    id: colorButton
                    source: ""
                    toolTip: qsTr("Color selector")
                    width: toolsContainer.buttonSize
                    selected: true
                    enabled: !gearTimer.running
                    onClicked: {
                        panelManager.showPanel(colorPanel)
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: GCStyle.thinnestBorder
                        border.width: width * 0.085
                        border.color: GCStyle.whiteBorder
                        z: -1
                        radius: width
                        color: items.penColor
                        scale: colorButton.buttonArea.pressed ? 0.9 : 1
                    }
                }

                Item {
                    id: flowSpacer
                }

                IconButton {
                    id: undoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Undo")
                    width: toolsContainer.buttonSize
                    enabled: (!gearTimer.running) && (canvasArea.undoSize > 1)
                    selected: true
                    onClicked: {
                        Activity.undoAction();
                    }
                }

                IconButton {
                    id: redoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Redo")
                    mirror: true
                    width: toolsContainer.buttonSize
                    enabled: (!gearTimer.running) && (canvasArea.redoSize > 0)
                    selected: true
                    onClicked: {
                        Activity.redoAction();
                    }
                }

                Item {
                    width: toolsContainer.buttonSize
                    height: toolsContainer.buttonSize

                    GCProgressBar {
                        id: revolutionProgress
                        anchors.centerIn: parent
                        width: toolsContainer.buttonSize
                        from: 0
                        value: items.theGear.wheelAngle / 360
                        to: items.maxRounds
                        GCText {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSize: tinySize
                            text: items.maxRounds
                        }
                    }
                }

                IconButton {
                    id: playButton
                    source: gearTimer.running ? "qrc:/gcompris/src/activities/drawing_wheels/resource/stop.svg" : "qrc:/gcompris/src/activities/drawing_wheels/resource/play.svg"
                    toolTip: gearTimer.running ? qsTr("Stop drawing") : qsTr("Start drawing")
                    width: toolsContainer.buttonSize
                    selected: true
                    onClicked: {
                        if (gearTimer.running)
                            Activity.stopGear()
                        else
                            Activity.startGear()
                    }
                }
            }
        }

        Rectangle {
            id: hideGearsBG
            color: GCStyle.darkBg
            width: hideGears.width + GCStyle.baseMargins * 2
            height: width
            radius: width
            anchors.rightMargin: 30
            anchors.bottomMargin: 20
            anchors.right: canvasContainer.right
            anchors.bottom: canvasContainer.bottom
            opacity: 0.6
        }

        IconButton {
            id: hideGears
            property bool checked: false
            selected: true
            width: toolsContainer.buttonSize
            source: checked ? "qrc:/gcompris/src/activities/drawing_wheels/resource/hidden.svg" :
                "qrc:/gcompris/src/activities/drawing_wheels/resource/visible.svg"
            toolTip: checked ? qsTr("Show wheel and gear") : qsTr("Hide wheel and gear")
            anchors.centerIn: hideGearsBG
            onClicked: checked = !checked
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontalLayout

                PropertyChanges {
                    toolsContainer.radius: GCStyle.halfMargins
                    toolsContainer.height: layoutArea.height + GCStyle.baseMargins * 2
                    toolsContainer.buttonSize: Math.min(items.baseButtonSize,
                        (layoutArea.height - GCStyle.halfMargins) /
                        (toolsFlow.children.length - 1) - GCStyle.halfMargins)
                    toolsContainer.width: toolsContainer.buttonSize + GCStyle.baseMargins + GCStyle.halfMargins
                    toolsContainer.anchors.rightMargin: -GCStyle.halfMargins
                    toolsContainer.anchors.topMargin: -GCStyle.halfMargins

                    toolsFlow.anchors.topMargin: GCStyle.baseMargins
                    flowSpacer.height: toolsFlow.height -
                        (toolsFlow.children.length - 1) *
                        (toolsContainer.buttonSize + toolsFlow.spacing)
                    flowSpacer.width: toolsContainer.buttonSize

                    canvasContainer.anchors.topMargin: 0
                    canvasContainer.anchors.rightMargin: toolsContainer.width

                    panelManager.maxPanelWidth: Math.min(canvasContainer.width - toolsContainer.width,
                                                         500 * ApplicationInfo.ratio)
                    panelManager.maxPanelHeight: canvasContainer.height
                    panelManager.panelY: GCStyle.halfMargins
                    panelManager.panelRightMargin: toolsContainer.width

                    filePanel.width: Math.min(panelManager.maxPanelWidth,
                                              fileColumn.width + GCStyle.baseMargins * 2)
                    wheelPanel.width: Math.min(panelManager.maxPanelWidth,
                                               wheelColumn.width + GCStyle.baseMargins * 2)
                    penPanel.width: Math.min(panelManager.maxPanelWidth,
                                             penColumn.width + GCStyle.baseMargins * 2)
                    colorPanel.width: panelManager.maxPanelWidth

                }
            },
            State{
                name: "verticalLayout"
                when: !items.isHorizontalLayout

                PropertyChanges {
                    toolsContainer.radius: 0
                    toolsContainer.width: activityBackground.width
                    toolsContainer.buttonSize: Math.min(items.baseButtonSize,
                                                (toolsContainer.width - GCStyle.halfMargins) /
                                                (toolsFlow.children.length - 1) - GCStyle.halfMargins)
                    toolsContainer.height: toolsContainer.buttonSize + GCStyle.baseMargins

                    toolsFlow.anchors.topMargin: GCStyle.halfMargins
                    flowSpacer.width: toolsFlow.width -
                        (toolsFlow.children.length - 1) *
                        (toolsContainer.buttonSize + toolsFlow.spacing)
                    flowSpacer.height: toolsContainer.buttonSize

                    canvasContainer.anchors.topMargin: toolsContainer.height
                    canvasContainer.anchors.rightMargin: 0

                    panelManager.maxPanelWidth: canvasContainer.width
                    panelManager.maxPanelHeight: Math.min(canvasContainer.height - toolsContainer.height,
                                                          360 * ApplicationInfo.ratio)
                    panelManager.panelY: toolsContainer.height + GCStyle.halfMargins
                    panelManager.panelRightMargin: 0

                    filePanel.width: activityBackground.width
                    wheelPanel.width: activityBackground.width
                    penPanel.width: activityBackground.width
                    colorPanel.width: activityBackground.width
                }
            }
        ]

        // Panels
        Rectangle {
            id: panelManager
            anchors.fill: parent
            color: "#60000000"
            visible: false
            property Rectangle selectedPanel: null

            // set in states
            property int maxPanelWidth
            property int maxPanelHeight
            property int panelY
            property int panelRightMargin
            property int maxContentWidth: maxPanelWidth - GCStyle.baseMargins * 2
            property int maxContentHeight: maxPanelHeight - GCStyle.baseMargins * 2

            function showPanel(panel_) {
                if(panel_) {
                    panelManager.selectedPanel = panel_;
                    panelManager.visible = true;
                    panelManager.selectedPanel.visible = true;
                }
            }

            function closePanel() {
                if(panelManager.selectedPanel) {
                    panelManager.selectedPanel.visible = false;
                }
                panelManager.visible = false;
                panelManager.selectedPanel = null;
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(panelManager.selectedPanel) {
                       panelManager.closePanel();
                    }
                }
            }

        }

        Rectangle {
            id: filePanel
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.lightBorder
            color: GCStyle.darkBg
            // width set in states
            height: fileColumn.height + GCStyle.baseMargins * 2
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            readonly property int buttonSize: Math.min(items.baseButtonSize,
                    panelManager.maxContentHeight * 0.2 - GCStyle.halfMargins)

            MouseArea {
                // Just to catch click events before the panelManager
                anchors.fill: parent
            }

            Column {
                id: fileColumn
                anchors.centerIn: parent
                spacing: GCStyle.halfMargins

                Column {
                    id: fileColumn1
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: GCStyle.halfMargins

                    GCLabelButton {
                        id: saveSvgButton
                        maxWidth: panelManager.maxContentWidth
                        height: filePanel.buttonSize
                        iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
                        text: qsTr("Save your image")
                        textColor: GCStyle.contentColor
                        enabled: !items.fileIsEmpty

                        onClicked: {
                            panelManager.closePanel();
                            Activity.saveSvgDialog();
                        }
                    }

                    GCLabelButton {
                        id: openButton
                        maxWidth: panelManager.maxContentWidth
                        height: filePanel.buttonSize
                        iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileOpen.svg"
                        text: qsTr("Open an image")
                        textColor: GCStyle.contentColor

                        onClicked: {
                            panelManager.closePanel();
                            Activity.openImageDialog();
                        }
                    }
                }

                Rectangle {
                    id: verticalSpacer1
                    color: GCStyle.contentColor
                    opacity: 0.5
                    height: GCStyle.thinnestBorder
                    width: Math.max(fileColumn1.width, fileColumn2.width)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: fileColumn2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: GCStyle.halfMargins

                    GCLabelButton {
                        id: newButton
                        maxWidth: panelManager.maxContentWidth
                        height: filePanel.buttonSize
                        iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileNew.svg"
                        text: qsTr("Create a new image")
                        textColor: GCStyle.contentColor

                        onClicked: {
                            panelManager.closePanel();
                            if(!items.isFileSaved) {
                                items.actionAfter = "create";
                                newImageDialog.active = true;
                            } else {
                                Activity.initLevel();
                            }
                        }
                    }

                    GCLabelButton {
                        id: bgColorButton
                        maxWidth: panelManager.maxContentWidth
                        height: filePanel.buttonSize
                        iconSource: ""
                        text: qsTr("Background color")
                        textColor: GCStyle.contentColor

                        onClicked: {
                            backgroundColorSelector.visible = true;
                            displayDialog(backgroundColorSelector);
                        }

                        Rectangle {
                            id: bgColorRect
                            width: filePanel.buttonSize
                            height: filePanel.buttonSize
                            x: bgColorButton.buttonIcon.x
                            scale: bgColorButton.buttonIcon.scale
                            radius: GCStyle.halfMargins
                            color: backgroundColorSelector.newBackgroundColor
                            border.color: GCStyle.contentColor
                        }
                    }
                }
            }
        }

        Rectangle {
            id: wheelPanel
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.lightBorder
            color: GCStyle.darkBg
            // width set in states
            height: wheelColumn.height + GCStyle.baseMargins * 2
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            // Size formula for one label and (7 buttons OR one slider and one value display)
            // Values also used in penPanel (so take care if changing them...)
            readonly property int buttonSize: Math.min(items.baseButtonSize,
                    panelManager.maxContentWidth * 0.1 - GCStyle.halfMargins,
                    panelManager.maxContentHeight * 0.2 - GCStyle.halfMargins)
            readonly property int labelSize: (buttonSize + GCStyle.halfMargins) * 3 - GCStyle.halfMargins
            readonly property int sliderSize: (buttonSize + GCStyle.halfMargins) * 6 - GCStyle.halfMargins
            readonly property int fullWidth: (buttonSize + GCStyle.halfMargins) * 10 - GCStyle.halfMargins

            property int currentWheel: 0
            property int currentGear: 0

            onCurrentWheelChanged: {
                gearsModel.clear();
                for(var i = 0; i < Activity.sets[currentWheel].gears.length; i++) {
                    gearsModel.append({ "nbTeeth": Activity.sets[currentWheel].gears[i]});
                }
                if(wheelPanel.currentGear > Activity.sets[currentWheel].gears.length - 1) {
                    wheelPanel.currentGear = Activity.sets[currentWheel].gears.length - 1;
                    gearTeethSlider.value = Activity.sets[currentWheel].gears[wheelPanel.currentGear];
                }
            }

            MouseArea {
                // Just to catch click events before the panelManager
                anchors.fill: parent
            }

            Column {
                id: wheelColumn
                anchors.centerIn: parent
                spacing: GCStyle.halfMargins

                Row {
                    id: wheelRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Wheel")
                    }

                    Repeater {  // Loop on wheels
                        model: Activity.wheelKeys
                        IconButton {
                            visible: items.currentLevel === 0
                            source: "qrc:/gcompris/src/activities/drawing_wheels/resource/wheel.svg"
                            selected: index === wheelPanel.currentWheel
                            width: wheelPanel.buttonSize
                            GCText {
                                anchors.centerIn: parent
                                height: parent.height * 0.6
                                width: height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                fontSize: regularSize
                                fontSizeMode: Text.Fit
                                fixFontSize: true
                                color: GCStyle.whiteText
                                text: modelData
                            }
                            onClicked: {
                                wheelPanel.currentWheel = index;
                                wheelTeethSlider.value = parseInt(modelData);
                            }
                        }
                    }

                    GCSlider {
                        id: wheelTeethSlider
                        visible: items.currentLevel === 1;
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 30
                        value: 96
                        to: 96
                        stepSize: 1
                        onValueChanged: Activity.initWheel()
                    }

                    GCText {
                        visible: items.currentLevel === 1;
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize
                        text: wheelTeethSlider.value
                    }

                }

                Row {
                    id: geerRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Gear")
                    }

                    Repeater {  // Loop on gears
                        model: gearsModel
                        IconButton {
                            visible: items.currentLevel === 0
                            source: "qrc:/gcompris/src/activities/drawing_wheels/resource/gear.svg"
                            selected: index === wheelPanel.currentGear
                            width: wheelPanel.buttonSize
                            GCText {
                                anchors.centerIn: parent
                                height: parent.height * 0.6
                                width: height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                fontSize: regularSize
                                fontSizeMode: Text.Fit
                                fixFontSize: true
                                color: GCStyle.whiteText
                                text: modelData
                            }
                            onClicked: {
                                gearTeethSlider.value = nbTeeth;
                                wheelPanel.currentGear = index;
                            }
                        }
                    }

                    GCSlider {
                        id: gearTeethSlider
                        visible: items.currentLevel === 1;
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 10
                        value: 30
                        to: wheelTeethSlider.value
                        stepSize: 1
                        onValueChanged: Activity.initWheel()
                    }

                    GCText {
                        visible: items.currentLevel === 1;
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize
                        text: gearTeethSlider.value
                    }
                }


                GCText { // Spikes count
                    color: GCStyle.contentColor
                    fontSize: smallSize
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: wheelPanel.buttonSize * 0.5
                    width: wheelPanel.fullWidth
                    text: qsTr("%1 spikes").arg(items.spikesCount)
                }

                Rectangle { // Separator
                    width: wheelPanel.fullWidth
                    height: GCStyle.thinBorder
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: GCStyle.contentColor
                }

                GCText { // Speed label
                    color: GCStyle.contentColor
                    fontSize: regularSize
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: wheelPanel.buttonSize
                    width: wheelPanel.fullWidth
                    text: qsTr("Speed")
                }

                Row {
                    id: speedRow
                    spacing: GCStyle.halfMargins
                    anchors.horizontalCenter: parent.horizontalCenter

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize * 2 + GCStyle.baseMargins
                        text: qsTr("Slow")
                    }

                    GCSlider {  // Controls speed of the gear (time between each step)
                        id: timerValue
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 16
                        value: 5
                        to: 2
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize * 2 + GCStyle.baseMargins
                        text: qsTr("Fast")
                    }
                }
            }
        }

        Rectangle {
            id: penPanel
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.lightBorder
            color: GCStyle.darkBg
            // width set in states
            height: penColumn.height + GCStyle.baseMargins * 2
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            // Reuse size properties from wheelPanel...s

            MouseArea {
                // Just to catch click events before the panelManager
                anchors.fill: parent
            }

            Column {
                id: penColumn
                anchors.centerIn: parent
                spacing: GCStyle.halfMargins

                Row {
                    id: penSizeRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Pen size")
                    }

                    GCSlider {
                        id: penSizeSlider
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 1
                        value: 2 // Default to 2, 1 can look less good/pixelated...
                        to: 18
                        stepSize: 1
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize
                        text: penSizeSlider.value
                    }
                }

                Row {
                    id: penOpacityRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Opacity")
                    }

                    GCSlider {
                        id: penOpacitySlider
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 0.1
                        value: 1.0
                        to: 1.0
                        stepSize: 0.1
                    }

                    Rectangle {
                        color: items.backgroundColor
                        border.width: GCStyle.thinBorder
                        border.color: GCStyle.contentColor
                        width: wheelPanel.buttonSize
                        height: wheelPanel.buttonSize

                        Rectangle {
                            anchors.centerIn: parent
                            width: items.actualPenWidth
                            height: width
                            radius: width
                            color: items.penColor
                            opacity: penOpacitySlider.value
                        }
                    }
                }

                Row {
                    id: offsetRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Offset")
                    }

                    GCSlider {
                        id: penOffsetSlider
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 10
                        value: 40
                        to: Math.round(theGear.extRadius * items.devicePixelRatio - Activity.wheelThickness) / 5 * 5
                        stepSize: 5
                        onValueChanged: Activity.initGear();
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize
                        text: Math.round(penOffsetSlider.value / 5)
                    }
                }

                Row {
                    id: startToothRow
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.labelSize
                        text: qsTr("Start tooth")
                    }

                    GCSlider {
                        id: toothOffsetSlider
                        width: wheelPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: - Math.abs(gearTeethSlider.value / items.maxRounds)
                        value: 0
                        to: Math.abs(gearTeethSlider.value / items.maxRounds)
                        stepSize: 1
                        onValueChanged: Activity.initGear();
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: wheelPanel.buttonSize
                        width: wheelPanel.buttonSize
                        text: items.toothOffset === 0 ? "0" :
                            (items.toothOffset > 0 ? rightToothOffset : leftToothOffset)

                        readonly property string leftToothOffset: "← " + Math.abs(items.toothOffset)
                        readonly property string rightToothOffset: items.toothOffset + " →"
                    }
                }
            }
        }

        Rectangle {
            id: colorPanel
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.lightBorder
            color: GCStyle.darkBg
            // width set in states
            height: Math.min(panelManager.maxPanelHeight, 360 * ApplicationInfo.ratio)
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            MouseArea {
                // Just to catch click events before the panelManager
                anchors.fill: parent
            }

            PaletteSelector {
                id: paletteSelector
                anchors.margins: GCStyle.baseMargins
                onPaletteSelected: {
                    colorSelector.reloadPaletteToButtons();
                }
            }

            Rectangle {
                id: panelVerticalSpacer
                color: GCStyle.contentColor
                opacity: 0.5
                height: GCStyle.thinnestBorder
                anchors.top: paletteSelector.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: GCStyle.halfMargins
            }

            ColorSelector {
                id: colorSelector
                anchors.top: panelVerticalSpacer.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 0

                palette: paletteSelector.currentPalette.modelData
                defaultPalette: paletteSelector.defaultPaletteList[paletteSelector.currentIndex]

                onSelectedColorChanged: {
                    items.penColor = selectedColor;
                    if(animationCanvas.ctx) {
                        animationCanvas.ctx.strokeStyle = selectedColor;
                    }
                }

                // save edited colors to palette lists and refresh paletteListView
                onColorEdited: (colorIndex, editedColor) => {
                    paletteSelector.currentPalette.modelData[colorIndex] = editedColor;
                    paletteSelector.currentPalette.refreshColor(colorIndex, editedColor);
                }
                onResetSelectedPalette: {
                    for(var i = 0; i < palette.length; i++) {
                        paletteSelector.currentPalette.modelData[i] = palette[i];
                    }
                    paletteSelector.currentPalette.reloadPaletteColors(paletteSelector.paletteList[paletteSelector.currentIndex]);
                }
            }
        }

        Timer {
            id: gearTimer
            // timer is sync with the animation timer. Since the animation timer is usually set to 60fps, the resolution of Timer will be at best 16ms.
            interval: 16
            running: false
            repeat: true
            // uncomment memTime and commented part of rotateGear in spiral.js to log time to render a wheel loop.
            // property var memTime: 0
            property var startTime: 0

            function startTimer() {
                items.runCompleted = false;
                startTime = Date.now();
                start();
            }

            onTriggered: {
                var now = Date.now();
                var delta = now - startTime;
                if(delta > timerValue.value) {
                    var numberOfSteps = delta / timerValue.value;
                    rotateGear(numberOfSteps);
                    startTime = now;
                }
            }

            function rotateGear(numberOfSteps) {
                animationCanvas.ctx.beginPath();
                animationCanvas.ctx.moveTo(items.lastPoint.x, items.lastPoint.y);
                for(var i = 0; i < numberOfSteps; i++) {
                    if(!items.runCompleted) {
                        Activity.rotateGear(3); // 3 is rotation angle for curve drawing precision. Higher values make angular lines. Smaller values can make refresh drop frames because of too much calculations.
                    } else {
                        break;
                    }
                }
                animationCanvas.ctx.stroke();
                animationCanvas.ctx.closePath();
                animationCanvas.requestPaint();
                if(items.runCompleted) {
                    Activity.stopGear(true);
                }
            }
        }

        GCCreationHandler {
            id: creationHandler
            imageMode: true
            svgMode: true
            usePngSnapshot: true
            fileExtensions: ["*.svg"]
            onClose: activity.focus = true;
            onFileLoaded: (data, filePath) => {
                Activity.initLevel()
                svgTank.loadSvg(file.read(filePath))  // Reset svgTank with loaded svg
                loadedImage.sourceSize.width = loadedImage.width
                loadedImage.sourceSize.height = loadedImage.height
                loadedImage.source = filePath
                loadedImage.visible = true
                items.fileIsEmpty = false
            }

            onSaved: {
                items.isFileSaved = true;
            }
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
                message: items.actionAfter === "home" ?
                    qsTr("You did not save this image. Do you want to close this activity?") :
                    qsTr("Do you want to erase this image?")
                button1Text: qsTr("Yes")
                button2Text: qsTr("No")
                onClose: newImageDialog.active = false

                onButton1Hit: {
                    items.isFileSaved = true
                    switch (items.actionAfter) {
                    case "home" :
                        activity.home()
                        break
                    case "next" :
                        Activity.nextLevel()
                        break
                    case "previous" :
                        Activity.previousLevel()
                        break
                    case "create" :
                        Activity.initLevel()
                        break
                    case "open" :
                        Activity.openImageDialog()
                        break
                    default:
                        break
                    }
                    items.actionAfter = ""
                }
            }
            anchors.fill: parent
            focus: true
            active: false
            onStatusChanged: if(status == Loader.Ready) item.start()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                activity.home()
            }
            onLoadData: {
                if(activityData && activityData["undoSetting"]) {
                    activity.undoSetting = activityData["undoSetting"];
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            enabled: !gearTimer.running
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onReloadClicked: {
                if(!items.isFileSaved) {
                    items.actionAfter = "create"
                    newImageDialog.active = true
                } else {
                    Activity.initLevel()
                }
            }
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
            onHomeClicked: {
                activityBackground.requestHome()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
