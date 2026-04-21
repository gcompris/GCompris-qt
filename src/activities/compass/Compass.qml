/* GCompris - Compass.qml
 *
 * SPDX-FileCopyrightText: 2026 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtCore
import core 1.0

import "../../core"
import "../sketch"
import "compass.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    onActivityNextLevel: {
        Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property var levels: activity.datasets
            property int currentLevel: activity.currentLevel
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 0
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property string levelTitle: ""
            readonly property bool isHorizontalLayout: activityBackground.width >= activityBackground.height
            readonly property url tempPath: StandardPaths.writableLocation(StandardPaths.TempLocation)

            property alias mainImage: mainImage
            property alias animationCanvas: animationCanvas
            property alias sceneGrid: sceneGrid
            property alias compass: compass
            property alias gridStepSliderValue: gridStepSlider.value
            property alias canvasSizeSliderValue: canvasSizeSlider.value
            property alias newImageDialog: newImageDialog
            property alias undoStack: undoStack
            property alias svgTemplate: svgTemplate
            property alias svgTank: svgTank
            property alias creationHandler: creationHandler
            property alias file: file

            // Pen and color properties
            readonly property string transparentColor: "#00000000"
            readonly property color contentColor: "#d2d2d2"
            property string backgroundColor: "#ffffff"
            property color newBackgroundColor: backgroundColorSelector.newBackgroundColor


            // View properties
            property real mainSize: Math.min(canvasZone.width, canvasZone.height)
            property real viewSize: 100
            readonly property real devicePixelRatio: Math.max(1, Screen.devicePixelRatio)
            property int gridStep: 50
            property bool gridVisible: true

            // Properties for templates
            property alias stepImage: stepImage
            property alias templateImage: templateImage
            property bool allTemplate: false
            property int currentStep: 0
            property int stepsCount: 0

            // Other properties
            property int baseButtonSize: 60 * ApplicationInfo.ratio
            property alias panelManager: panelManager
            property string mode: "template"
            property bool isTemplateMode: mode == "template" ? true : false
            property bool isFileSaved: true
            property string actionAfter: ""

            onIsTemplateModeChanged: Activity.initLevel()
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        File { id: file }

        function undoAction() {
            if (undoStack.undoCount < 2)
                return
            scrollSound.play()
            undoStack.restoreFromStack(undoStack.undoLast())
            svgTank.undo()
            mainImage.source = svgTank.svgProtocol + svgTank.getSource()
        }

        function redoAction() {
            if (undoStack.redoCount < 1)
                return
            scrollSound.play()
            undoStack.restoreFromStack(undoStack.redoLast())
            svgTank.redo()
            mainImage.source = svgTank.svgProtocol + svgTank.getSource()
        }

        function requestHome() {
            if (!items.isFileSaved) {
                items.actionAfter = "home"
                newImageDialog.active = true
                return
            }
            activity.home()
        }

        UndoStack {
            id: undoStack

            function pushToUndoStack() {
                pushData({
                      "compassX_": compass.x
                    , "compassY_": compass.y
                    , "penX_": compass.compassPen.x
                    , "penY_": compass.compassPen.y
                    , "compassAngle_": compass.compassAngle
                    , "penColor_": compass.penColor
                    , "penWidth_": compass.penWidth
                    , "penOpacity_": compass.penOpacity
                    , "currentPalette_": penColumn.currentPalette
                    , "currentColor_": penColumn.currentColor
                    , "currentDot_": penColumn.currentDot
                })
            }

            function restoreFromStack(todo) {
                if (todo !== undefined) {
                    compass.x = todo.compassX_
                    compass.y = todo.compassY_
                    compass.compassPen.x = todo.penX_
                    compass.compassPen.y = todo.penY_
                    compass.compassAngle = todo.compassAngle_
                    compass.penColor = todo.penColor_
                    penWidthSlider.value = todo.penWidth_
                    penOpacitySlider.value = todo.penOpacity_
                    penColumn.currentColor = todo.currentColor_
                    penColumn.currentPalette = todo.currentPalette_
                    penColumn.currentDot = todo.currentDot_
                }
            }

            // Update pen attributes before drawing to be restored on undo
            function updateUndoStack() {
                const todo = getLastStacked()
                todo.compassX_ = compass.x
                todo.compassY_ = compass.y
                todo.penX_ = compass.compassPen.x
                todo.penY_ = compass.compassPen.y
                todo.compassAngle_ = compass.compassAngle
                todo.penColor_ = compass.penColor
                todo.penWidth_ = compass.penWidth
                todo.penOpacity_ = compass.penOpacity
                todo.currentPalette_ = penColumn.currentPalette
                todo.currentColor_ = penColumn.currentColor
                todo.currentDot_ = penColumn.currentDot
                setLastStacked(todo)
            }
        }

        SvgTank {   // Template svg
            id: svgTemplate
            fileName: items.tempPath + "/GCCompass-template.svg"
            precision: 0
        }

        SvgTank {   // Output svg
            id: svgTank
            fileName: items.tempPath + "/GCCompass.svg"
            precision: 2
            svgOpacity: compass.penOpacity
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        Item {  // useful to compute view size. canvasContainer is scaled
            id: canvasZone
            anchors.fill: canvasContainer
        }


        Item {
            id: canvasContainer
            anchors.fill: layoutArea
            scale: items.mainSize / items.viewSize

            Image {
                id: mainImage
                anchors.centerIn: parent
                width: items.viewSize
                height: items.viewSize
                fillMode: Image.Pad
                smooth: true
                retainWhileLoading: true
            }

            Canvas {
                id: animationCanvas
                property var ctx: null

                anchors.fill: mainImage
                renderStrategy: Canvas.Immediate
                renderTarget: Canvas.Image
                clip: true
                opacity: compass.penOpacity   // Pen opacity is applied to the whole canvas. Context drawing is always done with opacity 1.0

                function initContext() {
                    ctx = getContext("2d")
                    initDrawing()
                }

                function initDrawing() {
                    ctx.clearRect(0, 0, width, height)
                    requestPaint()
                }

                Component.onCompleted: initContext()
            }

            Canvas {
                id: sceneGrid
                anchors.centerIn : canvasContainer
                width: items.viewSize * canvasContainer.scale
                height: width
                visible: items.gridVisible && !hideCompass.checked
                clip: true
                scale: items.viewSize / items.mainSize
                opacity: 0.2

                onPaint: {
                    var ctx = getContext("2d")
                    if (ctx === null)
                        return
                    ctx.clearRect(0, 0, width, height)
                    const scaledGridStep = compass.gridStep / scale
                    ctx.beginPath()
                    var nrows = height / scaledGridStep
                    var offsetY = (height / 2) % scaledGridStep
                    // fixed values used in for loops
                    var xInit = compass.compassTip.x % scaledGridStep % 10
                    var yInit = compass.compassTip.y % scaledGridStep + offsetY
                    for(var i = 0; i < nrows+1; i++){   // Draw dotted rows
                        ctx.moveTo(xInit, (scaledGridStep * i) + yInit)
                        ctx.lineTo(width, (scaledGridStep * i) + yInit)
                    }

                    var ncols = width / scaledGridStep  // Draw dotted columns
                    var offsetX = (width / 2) % scaledGridStep
                    xInit = (compass.compassTip.x % scaledGridStep) + offsetX
                    yInit = compass.compassTip.y % 10
                    for(var j = 0; j < ncols+1; j++){
                        ctx.moveTo((scaledGridStep * j) + xInit, yInit)
                        ctx.lineTo((scaledGridStep * j) + xInit, height)
                    }
                    ctx.lineWidth = 1
                    ctx.strokeStyle = Activity.contrastingColor(items.backgroundColor)
                    ctx.stroke()
                }
            }

            Item { // Set the same coordinate system as animationCanvas for the compass. Does not inherit animationCanvas opacity
                anchors.fill: animationCanvas

                TheCompass {
                    id: compass
                    drawingCanvas: animationCanvas
                    svgTank: svgTank
                    viewSize: items.viewSize
                    tipPenInit: items.gridStep
                    penWidth: penWidthSlider.value
                    penOpacity: penOpacitySlider.value
                    gridStep: items.gridStep
                    visible: !hideCompass.checked
                    canvasScale: canvasContainer.scale

                    onDrawingCompleted: {
                        items.isFileSaved = false
                        mainImage.source = svgTank.svgProtocol + svgTank.getSource()
                        drawingCanvas.initDrawing() // Clear animation canvas for next drawing
                    }

                    onPushUndo: undoStack.pushToUndoStack()
                    onUpdateUndo: undoStack.updateUndoStack()
                }

                Image {     // Image containing a template of current step, over mainImage and animationCanvas
                    id: stepImage
                    anchors.fill: parent
                    sourceSize.width: width * items.devicePixelRatio
                    sourceSize.height: height * items.devicePixelRatio
                    smooth: true
                    visible: !hideCompass.checked && items.stepsCount
                }

                onWidthChanged: sceneGrid.requestPaint()
                onHeightChanged: sceneGrid.requestPaint()
            }
        }

        Column {
            id: templateContainer
            visible: !hideShowTemplate.checked && items.stepsCount
            Image {     // Overlapping image containing a template of level's drawing
                id: templateImage
                width: GCStyle.smallButtonHeight * 5
                height: width
                fillMode: Image.PreserveAspectFit
                clip: true
                smooth: true
                retainWhileLoading: true

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "#A3D5F4"
                    border.width: 1
                }

                GCText {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    fontSize: 6
                    horizontalAlignment: Text.AlignHCenter
                    text: items.levelTitle
                }

                IconButton {
                    id: toTopLeft
                    width: GCStyle.smallButtonHeight
                    height: width
                    source: "qrc:/gcompris/src/activities/compass/resource/angle.svg"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    transformOrigin: Item.TopLeft
                    selected: templateContainer.state === "topLeft"
                    onClicked: templateContainer.state = "topLeft"
                }
                IconButton {
                    id: toTopRight
                    width: GCStyle.smallButtonHeight
                    height: width
                    source: "qrc:/gcompris/src/activities/compass/resource/angle.svg"
                    mirror: true
                    anchors.top: parent.top
                    anchors.right: parent.right
                    transformOrigin: Item.TopRight
                    selected: templateContainer.state === "topRight"
                    onClicked: templateContainer.state = "topRight"
                }
                IconButton {
                    id: toBottomLeft
                    width: GCStyle.smallButtonHeight
                    height: width
                    source: "qrc:/gcompris/src/activities/compass/resource/angle.svg"
                    mirrorVertically: true
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    transformOrigin: Item.BottomLeft
                    selected: templateContainer.state === "bottomLeft"
                    onClicked: templateContainer.state = "bottomLeft"
                }
                IconButton {
                    id: toBottomRight
                    width: GCStyle.smallButtonHeight
                    height: width
                    source: "qrc:/gcompris/src/activities/compass/resource/angle.svg"
                    mirror: true
                    mirrorVertically: true
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    transformOrigin: Item.BottomRight
                    selected: templateContainer.state === "bottomRight"
                    onClicked: templateContainer.state = "bottomRight"
                }
            }

            Rectangle {
                id: templateRect
                width: templateImage.width
                height: GCStyle.smallButtonHeight + GCStyle.baseMargins
                radius: GCStyle.halfMargins
                color: "gray"

                Rectangle {
                    width: parent.width
                    height: parent.radius
                    color: parent.color
                }

                IconButton {
                    id: previousStep
                    width: GCStyle.smallButtonHeight
                    anchors.left: parent.left
                    anchors.margins: GCStyle.halfMargins
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/gcompris/src/core/resource/arrow_left.svg"
                    toolTip: qsTr("Previous step")
                    selected: true
                    onClicked: Activity.previousStep()
                }

                GCText {
                    text: (items.currentStep + 1) + "/" + items.stepsCount
                    height: GCStyle.smallButtonHeight
                    anchors.left: previousStep.right
                    anchors.right: nextStep.left
                    anchors.margins: GCStyle.halfMargins
                    anchors.verticalCenter: parent.verticalCenter
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }

                IconButton {
                    id: nextStep
                    width: GCStyle.smallButtonHeight
                    anchors.right: fullTemplate.left
                    anchors.margins: GCStyle.halfMargins
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/gcompris/src/core/resource/arrow_right.svg"
                    toolTip: qsTr("Next step")
                    selected: true
                    onClicked: Activity.nextStep()
                }

                IconButton {
                    id: fullTemplate
                    width: GCStyle.smallButtonHeight
                    anchors.right: parent.right
                    anchors.margins: GCStyle.halfMargins
                    anchors.verticalCenter: parent.verticalCenter
                    source: items.allTemplate ? "qrc:/gcompris/src/activities/sketch/resource/menu.svg"
                                                : "qrc:/gcompris/src/activities/compass/resource/step.svg"
                    toolTip: items.allTemplate ? qsTr("All steps") : qsTr("Current step")
                    selected: true
                    onClicked: {
                        items.allTemplate = !items.allTemplate
                        Activity.templateToSvg()
                    }
                }
            }

            state: "topLeft"

            states: [
                State {
                    name: "topLeft"
                    AnchorChanges {
                        target: templateContainer
                        anchors.top: layoutArea.top
                        anchors.left: layoutArea.left
                        anchors.right: undefined
                        anchors.bottom: undefined
                    }
                },
                State {
                    name: "topRight"
                    AnchorChanges {
                        target: templateContainer
                        anchors.top: layoutArea.top
                        anchors.left: undefined
                        anchors.right: layoutArea.right
                        anchors.bottom: undefined
                    }
                },
                State {
                    name: "bottomLeft"
                    AnchorChanges {
                        target: templateContainer
                        anchors.top: undefined
                        anchors.left: layoutArea.left
                        anchors.right: undefined
                        anchors.bottom: layoutArea.bottom
                    }
                },
                State {
                    name: "bottomRight"
                    AnchorChanges {
                        target: templateContainer
                        anchors.top: undefined
                        anchors.left: undefined
                        anchors.right: layoutArea.right
                        anchors.bottom: layoutArea.bottom
                    }
                }
            ]
        }

        Rectangle {
            id: toolsContainer
            property int buttonSize: 1

            color: GCStyle.darkBg
            anchors.right: parent.right
            anchors.top: parent.top

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
                    onClicked: panelManager.showPanel(filePanel)
                }

                IconButton {
                    id: compassButton
                    source: "qrc:/gcompris/src/activities/compass/resource/compass.svg"
                    toolTip: qsTr("Compass and grid settings")
                    width: toolsContainer.buttonSize
                    selected: true
                    onClicked: panelManager.showPanel(compassPanel)
                }

                IconButton {
                    id: pencilButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/brushTools.svg"
                    toolTip: qsTr("Pen settings")
                    width: toolsContainer.buttonSize
                    selected: true
                    onClicked: panelManager.showPanel(penPanel)

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: GCStyle.thinnestBorder
                        border.width: width * 0.085
                        border.color: GCStyle.whiteBorder
                        z: -1
                        radius: width
                        color: compass.penColor
                        opacity: compass.penOpacity
                        scale: pencilButton.buttonArea.pressed ? 0.9 : 1
                    }
                }

                IconButton {
                    id: undoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Undo")
                    width: toolsContainer.buttonSize
                    enabled: undoStack.undoCount > 1
                    selected: true
                    onClicked: undoAction()
                }

                IconButton {
                    id: redoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Redo")
                    width: toolsContainer.buttonSize
                    mirror: true
                    enabled: undoStack.redoCount > 0
                    selected: true
                    onClicked: redoAction()
                }

                Item { id: flowSpacer }

                IconButton {
                    id: hideShowTemplate
                    property bool checked: false
                    source: "qrc:/gcompris/src/activities/sketch/resource/" + (templateContainer.visible ? "geometryTools.svg" :  "empty.svg")
                    toolTip: items.isTemplateMode ? checked ? qsTr("Show template") : qsTr("Hide template") : ""
                    width: toolsContainer.buttonSize
                    selected: true
                    enabled: items.isTemplateMode
                    opacity: items.isTemplateMode ? 1 : 0
                    onClicked: checked = !checked
                }

                IconButton {
                    id: hideCompass
                    property bool checked: false
                    source: "qrc:/gcompris/src/activities/drawing_wheels/resource/" + (checked ? "hidden.svg" : "visible.svg")
                    toolTip: checked ? qsTr("Show compass and grid") : qsTr("Hide compass and grid")
                    width: toolsContainer.buttonSize
                    selected: true
                    onClicked: checked = !checked
                }
            }
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontalLayout

                PropertyChanges {
                    toolsContainer.radius: GCStyle.halfMargins
                    toolsContainer.height: layoutArea.height + GCStyle.halfMargins * 2
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

                    panelManager.maxPanelWidth: layoutArea.width
                    panelManager.maxPanelHeight: layoutArea.height
                    panelManager.panelY: GCStyle.halfMargins
                    panelManager.panelRightMargin: toolsContainer.width

                    filePanel.width: Math.min(panelManager.maxPanelWidth, fileColumn.width + GCStyle.baseMargins * 2)
                    compassPanel.width: Math.min(panelManager.maxPanelWidth, compassColumn.width + GCStyle.baseMargins * 2)
                    penPanel.width: panelManager.maxPanelWidth
                }

                AnchorChanges {
                    target: layoutArea
                    anchors.top: activityBackground.top
                    anchors.right: toolsContainer.left
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

                    panelManager.maxPanelWidth: layoutArea.width
                    panelManager.maxPanelHeight: Math.min(layoutArea.height,
                                                          360 * ApplicationInfo.ratio)
                    panelManager.panelY: toolsContainer.height + GCStyle.halfMargins
                    panelManager.panelRightMargin: 0

                    filePanel.width: activityBackground.width
                    compassPanel.width: activityBackground.width
                    penPanel.width: activityBackground.width
                }

                AnchorChanges {
                    target: layoutArea
                    anchors.top: toolsContainer.bottom
                    anchors.right: activityBackground.right
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
                    panelManager.selectedPanel = panel_
                    panelManager.visible = true
                    panelManager.selectedPanel.visible = true
                }
            }

            function closePanel() {
                if(panelManager.selectedPanel) {
                    panelManager.selectedPanel.visible = false
                }
                panelManager.visible = false
                panelManager.selectedPanel = null
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(panelManager.selectedPanel) {
                       panelManager.closePanel()
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
            height: fileColumn.height + GCStyle.baseMargins * 2
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            readonly property int buttonSize: Math.min(items.baseButtonSize,
                    panelManager.maxContentHeight * 0.2 - GCStyle.halfMargins)

            MouseArea { anchors.fill: parent }  // Just to catch click events before the panelManager

            Column {
                id: fileColumn
                anchors.centerIn: parent
                spacing: GCStyle.halfMargins

                GCLabelButton {
                    id: savePngButton
                    maxWidth: panelManager.maxContentWidth
                    height: filePanel.buttonSize
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
                    text: qsTr("Save your image")
                    textColor: GCStyle.contentColor
                    enabled: !items.fileIsEmpty

                    onClicked: {
                        panelManager.closePanel()
                        Activity.saveSvgDialog()
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
                        panelManager.closePanel()
                        Activity.openImageDialog()
                    }
                }

                Rectangle {
                    id: verticalSpacer1
                    color: GCStyle.contentColor
                    opacity: 0.5
                    height: GCStyle.thinnestBorder
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GCLabelButton {
                    id: newButton
                    maxWidth: panelManager.maxContentWidth
                    height: filePanel.buttonSize
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileNew.svg"
                    text: qsTr("Create a new image")
                    textColor: GCStyle.contentColor

                    onClicked: {
                        panelManager.closePanel()
                        if (!items.isFileSaved) {
                            items.actionAfter = "create"
                            newImageDialog.active = true
                        } else {
                            Activity.initLevel()
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
                    visible: !items.isTemplateMode

                    onClicked: {
                        backgroundColorSelector.visible = true
                        displayDialog(backgroundColorSelector)
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

        Rectangle {
            id: compassPanel
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.lightBorder
            color: GCStyle.darkBg
            height: compassColumn.height + (GCStyle.baseMargins * 2)
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin
            readonly property int buttonSize: Math.min(items.baseButtonSize,
                    panelManager.maxContentWidth * 0.1 - GCStyle.halfMargins,
                    panelManager.maxContentHeight * 0.2 - GCStyle.halfMargins)

            readonly property int labelSize: (buttonSize + GCStyle.halfMargins) * 3 - GCStyle.halfMargins
            readonly property int sliderSize: (buttonSize + GCStyle.halfMargins) * 6 - GCStyle.halfMargins
            readonly property int fullWidth: (buttonSize + GCStyle.halfMargins) * 10 - GCStyle.halfMargins

            MouseArea { anchors.fill: parent }  // Just to catch click events before the panelManager

            Column {
                id: compassColumn
                anchors.centerIn: parent
                spacing: GCStyle.halfMargins

                Row {     // Canvas size
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: !items.isTemplateMode ? compassPanel.labelSize : compassPanel.sliderSize
                        text: qsTr("Canvas size")
                    }

                    GCSlider {
                        id: canvasSizeSlider
                        visible: !items.isTemplateMode
                        width: compassPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 600
                        to: 2000
                        value: 800
                        stepSize: 2 * items.gridStep

                        onMoved: {
                            clampValueToStepSize();
                        }

                        onPressedChanged: {
                            if(!pressed && items.viewSize != value) {
                                updateCanvasSize();
                            }
                        }

                        function clampValueToStepSize() {
                            var newCanvasSize = Math.round(canvasSizeSlider.value / stepSize) * stepSize;
                            while(newCanvasSize > canvasSizeSlider.to) {
                                newCanvasSize = newCanvasSize - stepSize;
                            }
                            while(newCanvasSize < canvasSizeSlider.from) {
                                newCanvasSize = newCanvasSize + stepSize;
                            }
                            canvasSizeSlider.value = newCanvasSize;
                        }

                        // Update actual viewSize value only after finishing slider drag to avoid too much computation and possible crash while dragging.
                        function updateCanvasSize() {
                            items.viewSize = value;
                            if(Activity.ready) {
                                svgTank.svgWidth = svgTank.svgHeight = items.viewSize;
                                Activity.level.size = items.viewSize;
                                mainImage.source = svgTank.svgProtocol + svgTank.getSource();
                            }
                            items.sceneGrid.requestPaint();
                        }
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.buttonSize
                        text: canvasSizeSlider.value
                    }
                }

                Row {     // Grid step
                    spacing: GCStyle.halfMargins
                    anchors.horizontalCenter: parent.horizontalCenter

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: !items.isTemplateMode ? compassPanel.labelSize : compassPanel.sliderSize
                        text: qsTr("Grid spacing")
                    }

                    GCSlider {
                        id: gridStepSlider
                        visible: !items.isTemplateMode
                        width: compassPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 20
                        value: 50
                        to: 100
                        stepSize: 5

                        // Update actual gridStep value only after finishing slider drag to avoid too much computation and possible crash while dragging.
                        onPressedChanged: {
                            if(!pressed) {
                                items.gridStep = value;
                                canvasSizeSlider.clampValueToStepSize();

                                if(items.viewSize != canvasSizeSlider.value) {
                                    canvasSizeSlider.updateCanvasSize();
                                } else {
                                    items.sceneGrid.requestPaint();
                                }
                            }
                        }
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.buttonSize
                        text: gridStepSlider.value
                    }
                }

                Row {     // Magnetism
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.sliderSize
                        text: qsTr("Snap to grid")
                    }

                    Image {
                        sourceSize.width: compassPanel.buttonSize
                        sourceSize.height: compassPanel.buttonSize
                        source: compass.magnetism ? "qrc:/gcompris/src/core/resource/apply_white.svg" :
                                                    "qrc:/gcompris/src/core/resource/cancel_white.svg"
                        MouseArea {
                            anchors.fill: parent
                            onReleased: compass.magnetism = !compass.magnetism
                        }
                    }
                }

                Row {     // Grid
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.sliderSize
                        text: qsTr("Show grid")
                    }

                    Image {
                        sourceSize.width: compassPanel.buttonSize
                        sourceSize.height: compassPanel.buttonSize
                        source: items.gridVisible ? "qrc:/gcompris/src/core/resource/apply_white.svg" :
                                                    "qrc:/gcompris/src/core/resource/cancel_white.svg"
                        MouseArea {
                            anchors.fill: parent
                            onReleased: items.gridVisible = !items.gridVisible
                        }
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
            height: paletteSelector.height + penColumn.childrenRect.height + (GCStyle.baseMargins * 4)
            visible: false
            y: panelManager.panelY
            anchors.right: parent.right
            anchors.rightMargin: panelManager.panelRightMargin

            property int colorSlotWidth: Math.min(GCStyle.smallButtonHeight, (width - GCStyle.halfMargins * 10) / 9)

            MouseArea { anchors.fill: parent }  // Just to catch click events before the panelManager

            PaletteSelector {
                id: paletteSelector
                anchors.margins: GCStyle.baseMargins
                onPaletteSelected: {
                    penColumn.currentPalette = currentIndex;
                    colorRepeater.itemAt(penColumn.currentColor).selectColor();
                }
            }

            Column {
                id: penColumn
                property int currentPalette: 0
                property int currentColor: 0
                property int currentDot: 0
                anchors.top: paletteSelector.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: GCStyle.baseMargins
                width: childrenRect.width
                spacing: GCStyle.halfMargins

                GCText {
                    color: GCStyle.contentColor
                    fontSize: regularSize
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: compassPanel.buttonSize
                    width: penPanel.width - GCStyle.baseMargins
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Color")
                }

                Row { // Colors
                    spacing: GCStyle.halfMargins
                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater {  // Color
                        id: colorRepeater
                        model: paletteSelector.paletteList[penColumn.currentPalette]
                        Rectangle {
                            id: colorSlot
                            width: penPanel.colorSlotWidth
                            height: width
                            color: modelData
                            border.color: "white"
                            border.width: (penColumn.currentColor === index) ? 1 : 0

                            function selectColor() {
                                compass.penColor = modelData
                                penColumn.currentColor = index
                                animationCanvas.initDrawing()
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    colorSlot.selectColor();
                                }
                            }
                        }
                    }
                }

                Row { // Pen opacity
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.labelSize
                        text: qsTr("Opacity")
                    }

                    GCSlider {
                        id: penOpacitySlider
                        width: compassPanel.sliderSize
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
                        width: compassPanel.buttonSize
                        height: compassPanel.buttonSize
                        clip: true

                        Rectangle {
                            x: (parent.width - width) * 0.5
                            y: x
                            width: compass.penWidth
                            height: width
                            radius: width
                            color: compass.penColor
                            opacity: penOpacitySlider.value
                        }
                    }
                }

                Row {     // Pen width
                    spacing: GCStyle.halfMargins

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.labelSize
                        text: qsTr(" Pen size")
                    }

                    GCSlider {
                        id: penWidthSlider
                        width: compassPanel.sliderSize
                        anchors.verticalCenter: parent.verticalCenter
                        from: 2
                        value: 10
                        to: 100
                        stepSize: 1
                    }

                    GCText {
                        color: GCStyle.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height: compassPanel.buttonSize
                        width: compassPanel.buttonSize
                        text: penWidthSlider.value
                    }
                }
            }
        }

        GCCreationHandler {
            id: creationHandler
            imageMode: true
            svgMode: true
            fileExtensions: ["*.svg"]
            onClose: activity.focus = true
            onFileLoaded: (data, filePath) => {
                              Activity.initLevel()
                              svgTank.loadSvg(file.read(filePath), true, false)
                              mainImage.source = svgTank.svgProtocol + svgTank.getSource()
                              sceneGrid.requestPaint()
            }
            onSaved: items.isFileSaved = true
        }

        BackgroundColorSelector {
            id: backgroundColorSelector
            visible: false
            onClose: {
                items.backgroundColor = newBackgroundColor
                items.svgTank.backColor = items.backgroundColor
                items.mainImage.source = items.svgTank.svgProtocol + items.svgTank.getSource()
                home()
                items.sceneGrid.requestPaint()
            }
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
                    case "config" :
                        displayDialog(dialogActivityConfig)
                        break
                    case "stop" :
                        Activity.stop()
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

        Keys.onEscapePressed: {
            if(panelManager.selectedPanel) {
                panelManager.closePanel();
            } else {
                requestHome();
            }
        }

        Keys.onPressed: (event) => {
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Z)) {
                undoAction()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Y)) {
                redoAction()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)) {
                Activity.saveSvgDialog()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_O)) {
                Activity.openImageDialog()
                event.accepted = true
            } else if((event.modifiers === Qt.ControlModifier && event.key === Qt.Key_W)) {
                requestHome()
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                Activity.previousStep()
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                Activity.nextStep()
                event.accepted = true
            } else if (event.key === Qt.Key_Space) {
                hideCompass.checked = !hideCompass.checked
                event.accepted = true
            } else if (event.key === Qt.Key_Tab) {
                hideShowTemplate.checked = !hideShowTemplate.checked
                event.accepted = true
            } else if (event.key === Qt.Key_P) {
                panelManager.showPanel(penPanel)
                event.accepted = true
            }
        }

        Keys.onReleased: (event) => {
            if(event.key === Qt.Key_Back) {
                requestHome();
                event.accepted = true;
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: home()
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"]
                }
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | (items.isTemplateMode ? level : 0) | reload | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activityBackground.requestHome()
            onActivityConfigClicked: {
                if (!items.isFileSaved) {
                    items.actionAfter = "config"
                    newImageDialog.active = true
                } else {
                    displayDialog(dialogActivityConfig)
                }
            }
            onReloadClicked: {
                if (!items.isFileSaved) {
                    items.actionAfter = "create"
                    newImageDialog.active = true
                } else {
                    Activity.initLevel()
                }
            }
        }

        // Debug zone
        Column {
            visible: false
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            z: 1000
            width: 250
            Text { text: items.levelTitle }
            Text { text: "mainSize: " + items.mainSize }
            Text { text: "viewSize: " + items.viewSize }
            Text { text: "Scale: " + canvasContainer.scale }
            // Text { text: "legLength: " + compass.legLength }
            Text { text: "Compass x, y: " + compass.x + ", " + compass.y}
            Text { text: "Compass tip x, y: " + compass.compassTip.x + ", " + compass.compassTip.y}
            Text { text: "Tip pen distance: " + compass.tipPenDistance.toFixed(4) }
            Text { text: "Compass angle: " + compass.compassAngle.toFixed(2) }
            Text { text: "Hinge angle: " + compass.hingeAngle.toFixed(2) }
            // Text { text: "Degrees per pixel: " + compass.degreesPerPixel.toFixed(2) }
            Text { text: "tipPenAngle: " + compass.tipPenAngle.toFixed(2) }
            Text { text: "Angle: ? " + ((-compass.tipPenAngle + compass.compassAngle - 90 + 360) % 360).toFixed(0) }
            // Text { text: "compassPen: " + compass.compassPen }
        }
    }
}
