/* GCompris - DrawingWheels.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
import QtQuick
import QtQuick.Controls // for Popup
import QtQuick.Layouts
import core 1.0

import "../../core"
import "../sketch"
import "drawingWheels.js" as Activity

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
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        property var paletteList: [
            // Default palette
            ["#000000","#e87836","#e8ba36","#75d11c","#1cd1d1","#1c8cd1","#cc78d6","#e07070","#ffffff"],
            // Gray palette
            ["#1a1a1a","#333333","#4d4d4d","#666666","#808080","#999999","#b3b3b3","#cccccc","#e6e6e6"],
            // Red
            ["#730c0c","#991010","#be1515","#ea1313","#ee3939","#f26161","#f88585","#faadad","#fcd7d7"],
            // Orange
            ["#73330c","#994710","#be5915","#ea6913","#ee7d39","#f29b61","#f8b385","#faccad","#fce6d7"],
            // Yellow
            ["#735c0c","#997d10","#be9c15","#eabf13","#eec639","#f2d561","#f8e185","#faebad","#fcf4d7"],
            // Green (yellowish)
            ["#35730c","#479910","#5dbe15","#69ea13","#81ee39","#9bf261","#b6f885","#ccfaad","#e6fcd7"],
            // Green (bluish)
            ["#0c7333","#109944","#15be59","#13ea64","#39ee81","#61f298","#85f8b3","#adfacc","#d7fce6"],
            // Blue (sky)
            ["#0c5e73","#107d99","#15a0be","#13bfea","#39caee","#61d5f2","#85e1f8","#adebfa","#d7f5fc"],
            // Blue (marine)
            ["#0c3573","#104799","#155dbe","#1369ea","#3981ee","#619bf2","#85b6f8","#adccfa","#d7e6fc"],
            // Purple (bluish)
            ["#330c73","#471099","#5915be","#6913ea","#7d39ee","#9b61f2","#b385f8","#ccadfa","#e5d7fc"],
            // Purple (redish)
            ["#5c0c73","#7a1099","#9c15be","#ba13ea","#c639ee","#d161f2","#de85f8","#e9adfa","#f4d7fc"],
            // Pink
            ["#730c35","#991047","#be155d","#ea1369","#ee3981","#f2619b","#f885b3","#faadcc","#fcd7e6"]
        ]

        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus

            property alias creationHandler: creationHandler

            property alias wheelTeeth: wheelTeeth.value     // Teeth count for the wheel
            property alias gearTeeth: gearTeeth.value       // Teeth count for the gear
            property alias theWheel: theWheel
            property alias theGear: theGear
            property alias mainCanvas: mainCanvas
            property alias animationCanvas: animationCanvas
            property alias canvasImage: canvasImage         // Offscreen image to store and restore canvas
            property alias penOffset: penOffset.value
            property alias penOpacity: penOpacity.value
            property alias gearTimer: gearTimer
            property alias toolsContainer: toolsContainer
            property alias toothOffset: offsetTooth.value
            property alias file: file
            property alias currentColor: columnPen.currentColor
            property alias currentDotSize: columnPen.currentDotSize
            property alias currentWheel: gearGrid.currentWheel
            property alias currentGear: gearGrid.currentGear
            property alias gearsModel: gearsModel
            property alias undoStack: undoStack
            property alias svgTank: svgTank
            property alias newImageDialog: newImageDialog

            property alias filePopup: filePopup
            property alias gearPopup: gearPopup
            property alias penPopup: penPopup

            readonly property string backgroundColor: "#ffffff"
            readonly property string transparentColor: "#00000000"
            readonly property color contentColor: "#d2d2d2"
            property real maxRounds: Activity.computeLcm(wheelTeeth.value, gearTeeth.value) / wheelTeeth.value
            property real spikesCount: Activity.computeLcm(wheelTeeth.value, gearTeeth.value) / gearTeeth.value
            property string penColor: "#000000"
            property int penWidth: 1
            property point lastPoint: Qt.point(0, 0)
            property int undoIndex: 0
            property int paletteIndex: 0
            property int imageSize: 150     // will be set by initLevel
            property bool runCompleted: false // used to avoid moving the gear too far
            property bool startedFromOrigin: true
            property string actionAfter: ""

        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        File { id: file }

        ListModel { id: gearsModel }

        function pushToUndoStack(withImage = false) {
            undoStack.pushData({
                             "wheelAngle_": items.theGear.wheelAngle
                           , "toothOffset_": items.toothOffset
                           , "penOffset_": items.penOffset
                           , "penOpacity_": items.penOpacity
                           , "currentColor_": items.currentColor
                           , "penColor_": items.penColor
                           , "currentDotSize_": items.currentDotSize
                           , "penWidth_": items.penWidth
                           }
                           , withImage)
        }

        function restoreFromStack(todo) {
            if (todo === undefined)  return
            Activity.initGear()
            items.theGear.wheelAngle = todo.wheelAngle_
            items.toothOffset = todo.toothOffset_
            items.penOffset = todo.penOffset_
            items.penOpacity = todo.penOpacity_
            items.currentColor = todo.currentColor_
            items.penColor = todo.penColor_
            items.currentDotSize = todo.currentDotSize_
            items.penWidth = todo.penWidth_
            if (todo.savedFile !== "") {
                canvasImage.reloaded = true
                canvasImage.source = todo.savedFile
                mainCanvas.requestPaint()
            }

            items.animationCanvas.initContext()
            items.animationCanvas.ctx.lineWidth = items.penWidth
            items.animationCanvas.ctx.strokeStyle = items.penColor
            Activity.rotateGear(0)       // move pencil and gear in position, trigger repaint animationCanvas
        }

        // Update pen attributes before drawing to be restored on undo
        function updateUndo() {
            const todo = items.undoStack.getLastStacked()
            todo.wheelAngle_ = items.theGear.wheelAngle
            todo.toothOffset_ = items.toothOffset
            todo.penOffset_ = items.penOffset
            todo.penOpacity_ = items.penOpacity
            todo.currentColor_ = items.currentColor
            todo.penColor_ = items.penColor
            todo.currentDotSize_ = items.currentDotSize
            todo.penWidth_ = items.penWidth
            items.undoStack.setLastStacked(todo)
        }

        Keys.onPressed: (event) => {
            if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Z)) {
                restoreFromStack(undoStack.undoLast())
                svgTank.undo()
                svgTank.writeSvg()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Y)) {
                restoreFromStack(undoStack.redoLast())
                svgTank.redo()
                svgTank.writeSvg()
                event.accepted = true
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)) {
                Activity.savePngDialog();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_D)) {
                Activity.saveSvgDialog();
                event.accepted = true;
            } else if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_O)) {
                Activity.openImageDialog();
                event.accepted = true;
            }
        }

        UndoStack {
            id: undoStack
            canvas: mainCanvas
            filePrefix: "/GCDrawingWheels"
            image: canvasImage
        }

        SvgTank {
            id: svgTank
            fileName: undoStack.tempFile + ".svg"
            stroke: items.penColor
            strokeWidth: items.penWidth
            svgOpacity: items.penOpacity
        }

        Rectangle {
            id: canvasContainer
            anchors.top: parent.top
            anchors.right: toolsContainer.left
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: bar.height + GCStyle.halfMargins
            color: items.backgroundColor

            Canvas {    // Once the drawing cycles are complete, animationCanvas is copied to mainCanvas with its opacity.
                id: mainCanvas
                property var ctx: null

                // anchors.fill: parent
                width: items.imageSize
                height: items.imageSize
                anchors.centerIn: parent
                anchors.margins: 0
                renderStrategy: Canvas.Immediate
                renderTarget: Canvas.Image
                clip: true

                function initContext() {
                    ctx = getContext("2d")
                    ctx.fillStyle = items.backgroundColor
                    ctx.fillRect(0, 0, width, height)
                    ctx.lineCap = ctx.lineJoin = "round"
                    requestPaint()
                }

                function redrawImage() {    // Called after resizing or reloading. Centered copy from canvasImage to mainCanvas
                    if (ctx) {
                        if (gearTimer.running) {
                            gearTimer.stop()
                            Activity.initGear()
                            Core.showMessageDialog(parent, qsTr("Avoid resizing window while drawing"), "", null, "", null, null)
                        }
                        ctx.clearRect(0, 0, width, height); // view has changed, clear all
                        ctx.drawImage(canvasImage, (width - canvasImage.sourceSize.width) * 0.5, (height - canvasImage.sourceSize.height) * 0.5)
                        Activity.rotateGear(0)              // Move pen to new relative position. Update scene
                    }
                }
                onWidthChanged: redrawImage()
                onHeightChanged: redrawImage()
            }

            Canvas {    // The animation of the drawing is done in animationCanvas and copied to mainCanvas once the drawing cycles are complete.
                id: animationCanvas
                property var ctx: null

                anchors.fill: mainCanvas
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
            }

            // Wheel and gear
            Image {
                id: theWheel
                property real intRadius: 0
                property real extRadius: 0
                x: (canvasContainer.width * 0.5) - (width * 0.5)
                y: (canvasContainer.height * 0.5) - (height * 0.5)
                visible: !hideGears.checked
            }
            Image {
                id: theGear
                property real centerX: 0
                property real centerY: 0
                property real extRadius: 50
                property real wheelAngle: 0
                x: centerX + (canvasContainer.width * 0.5) - (width * 0.5)
                y: centerY + (canvasContainer.height * 0.5) - (height * 0.5)
                rotation: 0
                visible: !hideGears.checked

                Rectangle {
                    id: pencil
                    property real center: width * 0.5
                    width: 4 + items.penWidth
                    height: width
                    radius: width / 2
                    color: items.penColor
                    border.width: 1
                    border.color: "black"
                    border.pixelAligned: false
                    x: (theGear.width * 0.5) - (width * 0.5)
                    y: (theGear.height * 0.5) - (height * 0.5) + items.penOffset
                }
            }
        }

        Image {     // Offscreen image containing a canvas copy, never visible. Used by undo/redo stacks
            id: canvasImage
            property bool reloaded: false
            anchors.fill: canvasContainer
            fillMode: Image.Pad
            visible: false
            onStatusChanged: {
                if ((status === Image.Ready) && reloaded) {
                    mainCanvas.redrawImage()
                    reloaded = false
                }
                if (status === Image.Error)
                    console.log("Error loading image")
            }
        }

        Rectangle {
            id: toolsContainer
            anchors.topMargin: GCStyle.halfMargins
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height + GCStyle.halfMargins
            width: 80
            color: GCStyle.darkBg
            radius: 10

            ColumnLayout {
                id: tools
                anchors.fill: parent

                IconButton {
                    id: fileButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/filesMenu.svg"
                    toolTip: qsTr("Save drawing")
                    Layout.topMargin: GCStyle.baseMargins
                    Layout.alignment:Qt.AlignHCenter
                    enabled: !gearTimer.running
                    opacity: gearTimer.running ? 0.6 : 1.0
                    onPushed: {
                        mapPadToItem(items.filePopup, fileButton)
                        items.filePopup.open()
                    }
                }

                IconButton {
                    id: gearButton
                    source: "qrc:/gcompris/src/activities/drawing_wheels/resource/gear.svg"
                    toolTip: qsTr("Wheel and gear")
                    Layout.alignment:Qt.AlignHCenter
                    enabled: !gearTimer.running
                    opacity: gearTimer.running ? 0.5 : 1.0
                    onPushed: {
                        mapPadToItem(items.gearPopup, gearButton)
                        items.gearPopup.open()
                    }
                    GCText {
                        anchors.fill: parent
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSize: tinySize
                        text: gearTeeth.value
                    }
                }

                IconButton {
                    id: pencilButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/brushTools.svg"
                    toolTip: qsTr("Pencil's color and width")
                    Layout.alignment:Qt.AlignHCenter
                    enabled: !gearTimer.running
                    opacity: gearTimer.running ? 0.5 : 1.0
                    onPushed: {
                        mapPadToItem(items.penPopup, pencilButton)
                        items.penPopup.open()
                    }
                }

                IconButton {
                    id: undoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Undo")
                    Layout.alignment:Qt.AlignHCenter
                    enabled: (!gearTimer.running) && (undoStack.undoCount > 1)
                    opacity: enabled ? 1.0 : 0.5
                    selected: true
                    onPushed: {
                        restoreFromStack(undoStack.undoLast())
                        svgTank.undo()
                        svgTank.writeSvg()
                    }
                }

                IconButton {
                    id: redoButton
                    source: "qrc:/gcompris/src/activities/sketch/resource/undo.svg"
                    toolTip: qsTr("Redo")
                    mirror: true
                    Layout.alignment:Qt.AlignHCenter
                    enabled: (!gearTimer.running) && (undoStack.redoCount > 0)
                    opacity: enabled ? 1.0 : 0.5
                    selected: true
                    onPushed: {
                        restoreFromStack(undoStack.redoLast())
                        mainCanvas.requestPaint()
                        svgTank.redo()
                        svgTank.writeSvg()
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                GCProgressBar {
                    id: revolutionProgress
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    Layout.margins: 5
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

                IconButton {
                    id: playButton
                    source: gearTimer.running ? "qrc:/gcompris/src/activities/drawing_wheels/resource/stop.svg" : "qrc:/gcompris/src/activities/drawing_wheels/resource/play.svg"
                    toolTip: gearTimer.running ? qsTr("Stop drawing") : qsTr("Start drawing")
                    Layout.alignment:Qt.AlignHCenter
                    Layout.bottomMargin: GCStyle.baseMargins
                    selected: true
                    onPushed: {
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
            source: checked ? "qrc:/gcompris/src/activities/drawing_wheels/resource/hidden.svg" : "qrc:/gcompris/src/activities/drawing_wheels/resource/visible.svg"
            toolTip: checked ? qsTr("Show wheel and gear") : qsTr("Hide wheel and gear")
            anchors.centerIn: hideGearsBG
            onPushed: checked = !checked
        }

        function mapPadToItem(pad_, item_){
            pad_.x = Qt.binding(function() { return activityBackground.width - item_.width - 2 * GCStyle.baseMargins - pad_.width })
            pad_.y = GCStyle.baseMargins
        }

        // Popups
        Popup {
            id: filePopup
            property int maxX: activityBackground.width - width - GCStyle.baseMargins
            property int maxY: activityBackground.height - height - GCStyle.baseMargins
            background: Rectangle {
                radius: 5
                color: GCStyle.darkBg
            }
            modal: true
            contentItem: Grid {
                columns: 2
                spacing: GCStyle.baseMargins
                horizontalItemAlignment: Grid.AlignRight
                GCText {
                    text: qsTr("Save your image")
                    color: items.contentColor
                    fontSize: smallSize
                    fontSizeMode: Text.Fit
                }
                SelectionButton {
                    id: saveButton
                    buttonSize: 40* ApplicationInfo.ratio
                    isButtonSelected: false
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
                    onButtonClicked: {
                        filePopup.close()
                        Activity.savePngDialog();
                    }
                }
                GCText {
                    text: qsTr("Save as a drawing")
                    color: items.contentColor
                    fontSize: smallSize
                    fontSizeMode: Text.Fit
                }
                SelectionButton {
                    id: saveSvgButton
                    buttonSize: 40* ApplicationInfo.ratio
                    isButtonSelected: false
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileSave.svg"
                    onButtonClicked: {
                        filePopup.close()
                        Activity.saveSvgDialog();
                    }
                }
                GCText {
                    text: qsTr("Open an image")
                    color: items.contentColor
                    fontSize: smallSize
                    fontSizeMode: Text.Fit
                }
                SelectionButton {
                    id: openButton
                    buttonSize: 40* ApplicationInfo.ratio
                    isButtonSelected: false
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileOpen.svg"
                    onButtonClicked: {
                        filePopup.close()
                        Activity.openImageDialog();
                    }
                }
                GCText {
                    text: qsTr("Create a new image")
                    color: items.contentColor
                    fontSize: smallSize
                    fontSizeMode: Text.Fit
                }
                SelectionButton {
                    buttonSize: 40 * ApplicationInfo.ratio
                    isButtonSelected: false
                    iconSource: "qrc:/gcompris/src/activities/sketch/resource/fileNew.svg"
                    onButtonClicked: {
                        filePopup.close()
                        if (!undoStack.isFileSaved) {
                            items.actionAfter = "create"
                            newImageDialog.active = true
                            return
                        }
                        Activity.initLevel()
                    }
                }
            }
        }

        Popup {
            id: gearPopup
            property int maxX: activityBackground.width - width - GCStyle.baseMargins
            property int maxY: activityBackground.height - height - GCStyle.baseMargins
            background: Rectangle {
                radius: 5
                color: GCStyle.darkBg
            }
            modal: true
            contentItem:
                Column {
                Grid {
                    id: gearGrid
                    property int currentWheel: 0
                    property int currentGear: 0
                    visible: items.currentLevel === 0
                    columns: Activity.sets.length + 1
                    spacing: GCStyle.baseMargins
                    horizontalItemAlignment: Grid.AlignRight
                    GCText {    // Wheel label
                        id: wheelLabel
                        text: qsTr("Wheel")
                        color: items.contentColor
                        fontSize: regularSize
                    }
                    Repeater {  // Loop on wheels
                        model: Activity.wheelKeys
                        IconButton {
                            source: "qrc:/gcompris/src/activities/drawing_wheels/resource/wheel.svg"
                            selected: index === gearGrid.currentWheel
                            GCText {
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                fontSize: tinySize
                                color: "white"
                                text: modelData
                            }
                            onPushed: {
                                gearGrid.currentWheel = index
                                wheelTeeth.value = parseInt(modelData)
                                gearsModel.clear()
                                for (var i = 0; i < Activity.sets[index].gears.length; i++) {
                                    gearsModel.append({ "nbTeeth": Activity.sets[index].gears[i]})
                                }
                                if (gearGrid.currentGear > Activity.sets[index].gears.length - 1) {
                                    gearGrid.currentGear = Activity.sets[index].gears.length - 1
                                    gearTeeth.value = Activity.sets[index].gears[gearGrid.currentGear]
                                }
                            }
                        }
                    }
                    GCText {    // Gear label
                        text: qsTr("Gear")
                        color: items.contentColor
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                    }
                    Repeater {  // Loop on the gears of the selected set
                        model: gearsModel
                        IconButton {
                            source: "qrc:/gcompris/src/activities/drawing_wheels/resource/gear.svg"
                            selected: index === gearGrid.currentGear
                            GCText {
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                fontSize: tinySize
                                text: nbTeeth
                            }
                            onPushed: {
                                gearTeeth.value = nbTeeth
                                gearGrid.currentGear = index
                            }
                        }
                    }
                    Repeater {  // Empty items to fill grid
                        model: Activity.sets.length - gearsModel.count
                        Rectangle {
                            width: 10
                            height: 10
                            color: "transparent"
                        }
                    }
                }

                GridLayout {    // free wheel and gear teeth count
                    columns: 3
                    width: parent.width
                    visible: items.currentLevel === 1
                    GCText {    // Wheel label
                        text: qsTr("Wheel")
                        color: items.contentColor
                        fontSize: tinySize
                        fontSizeMode: Text.Fit
                    }
                    GCSlider {
                        id: wheelTeeth
                        Layout.fillWidth: true
                        from: 30
                        value: 96
                        to: 96
                        stepSize: 1
                        onValueChanged: Activity.initWheel()
                    }
                    GCText {    // Wheel value
                        text: wheelTeeth.value
                        color: items.contentColor
                        fontSize: tinySize
                        fontSizeMode: Text.Fit
                    }
                    GCText {    // Gear label
                        text: qsTr("Gear")
                        color: items.contentColor
                        fontSize: tinySize
                        fontSizeMode: Text.Fit
                    }
                    GCSlider {
                        id: gearTeeth
                        width: 400
                        from: 10
                        value: 30
                        to: wheelTeeth.value
                        stepSize: 1
                        onValueChanged: Activity.initWheel()
                    }
                    GCText {    // Wheel value
                        text: gearTeeth.value
                        color: items.contentColor
                        fontSize: tinySize
                        fontSizeMode: Text.Fit
                    }
                }

                GCText {    // Spikes count
                    width: gearGrid.width
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("%1 spikes").arg(items.spikesCount)
                    color: items.contentColor
                    fontSize: smallSize
                }

                GCText {    // Speed label
                    width: gearGrid.width
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Speed")
                    color: items.contentColor
                    fontSize: smallSize
                }

                GridLayout {    // Speed control
                    width: gearGrid.width
                    GCText {
                        horizontalAlignment: Text.AlignHCenter
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: qsTr("Slow")
                    }
                    GCSlider {  // Controls speed of the gear (time between each step)
                        id: timerValue
                        Layout.columnSpan: Activity.sets.length
                        Layout.fillWidth: true
                        from: 16
                        value: 2
                        to: 1
                    }
                    GCText {
                        horizontalAlignment: Text.AlignHCenter
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: qsTr("Fast")
                    }
                }
            }
        }

        Popup {
            id: penPopup
            property int maxX: activityBackground.width - width - GCStyle.baseMargins
            property int maxY: activityBackground.height - height - GCStyle.baseMargins
            background: Rectangle {
                radius: 5
                color: GCStyle.darkBg
            }
            modal: true
            contentItem:
                Column {
                id: columnPen
                property int currentColor: 0
                property int currentDotSize: 0
                RowLayout { // Palettes
                    id: rowPalette
                    width: parent.width
                    height: 80
                    spacing: 10
                    anchors.bottomMargin: 10
                    GCText {
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 80
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: qsTr("Palettes")
                    }

                    IconButton {
                        source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
                        width: 15
                        height: 56
                        onPushed: if (paletteListView.currentIndex > 0) paletteListView.currentIndex--
                    }

                    ListView {
                        id: paletteListView
                        Layout.fillWidth: true
                        height: 56
                        spacing: 2
                        orientation: ListView.Horizontal
                        boundsBehavior: Flickable.StopAtBounds
                        highlightFollowsCurrentItem: true
                        highlightMoveDuration: 100
                        clip: true
                        currentIndex: 0
                        model: paletteList

                        highlight: Rectangle {
                            height: 56
                            width: height
                            color: "transparent"
                            border.color: "white"
                            border.width: (items.paletteIndex === paletteListView.currentIndex) ? 1 : 0
                            x: paletteListView.currentItem.x
                            y: paletteListView.currentItem.y
                        }

                        delegate: Item {
                            width: 56
                            height: 56
                            Grid {
                                property int currentPalette: index
                                anchors.fill: parent
                                anchors.margins: 1
                                columns: 3
                                Repeater {
                                    model: activityBackground.paletteList[parent.currentPalette]
                                    Rectangle {
                                        width: 18
                                        height: width
                                        color: activityBackground.paletteList[parent.currentPalette][index]
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: paletteListView.currentIndex = index
                            }
                        }

                        onCurrentIndexChanged: {
                            items.paletteIndex = currentIndex
                            items.penColor = activityBackground.paletteList[items.paletteIndex][columnPen.currentColor]
                        }
                    }

                    IconButton {
                        source: "qrc:/gcompris/src/activities/sketch/resource/arrow.svg"
                        width: 15
                        height: 56
                        mirror: true
                        onPushed: if (paletteListView.currentIndex < paletteListView.count - 1) paletteListView.currentIndex++
                    }
                }

                Grid {
                    id: gridColor
                    spacing: 10
                    columns: 10
                    GCText {
                        Layout.preferredWidth: 180
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: qsTr("Color")
                    }

                    Repeater {  // Color
                        model: activityBackground.paletteList[items.paletteIndex]
                        Rectangle {
                            width: 50
                            height: width
                            color: modelData
                            border.color: "white"
                            border.width: (columnPen.currentColor === index) ? 1 : 0
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    items.penColor = modelData
                                    columnPen.currentColor = index
                                    items.animationCanvas.ctx.strokeStyle = items.penColor
                                }
                            }
                        }
                    }
                    GCText {
                        Layout.preferredWidth: 180
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: qsTr("Pensize")
                    }
                    Repeater {  // Pen size
                        model: [ 1, 3, 5, 7, 9, 11, 13, 15, 17]
                        Rectangle {
                            width: 50
                            height: width
                            color: items.transparentColor
                            border.color: "white"
                            border.width: (columnPen.currentDotSize === index) ? 1 : 0
                            Rectangle {
                                anchors.centerIn: parent
                                width: 2 * modelData
                                height: width
                                radius: modelData
                                color: items.penColor
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    items.penWidth = modelData
                                    columnPen.currentDotSize = index
                                    items.animationCanvas.ctx.lineWidth = items.penWidth

                                }
                            }
                        }
                    }
                }
                GridLayout {
                    id: gridPen
                    columns: 3
                    rows: 2
                    width: parent.width

                    GCText {    // Opacity
                        fontSize: smallSize
                        color: items.contentColor
                        text: qsTr("Opacity")
                    }
                    GCSlider {
                        id: penOpacity
                        Layout.fillWidth: true
                        from: 0.1
                        value: 1.0
                        to: 1.0
                        stepSize: 0.1
                    }
                    Rectangle {
                        color: "black"
                        border.width: 1
                        border.color: "white"
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter
                        IconButton {
                            anchors.fill: parent
                            anchors.margins: 1
                            source: "qrc:/gcompris/src/activities/sketch/resource/roundBrush.svg"
                            opacity: penOpacity.value
                        }
                    }

                    GCText {    // Distance to center
                        fontSize: smallSize
                        color: items.contentColor
                        text: qsTr("Distance to center")
                    }
                    GCSlider {
                        id: penOffset
                        Layout.fillWidth: true
                        from: 10
                        value: 40
                        to: Math.round((theGear.extRadius - Activity.wheelThickness) / 5) * 5
                        stepSize: 5
                        onValueChanged: Activity.initGear()
                    }
                    GCText {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 70
                        horizontalAlignment: Text.AlignHCenter
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: Math.round(penOffset.value / 5)
                    }

                    GCText {    // Starting tooth
                        horizontalAlignment: Text.AlignRight
                        fontSize: smallSize
                        color: items.contentColor
                        text: qsTr("Starting tooth")
                    }
                    GCSlider {
                        id: offsetTooth
                        Layout.fillWidth: true
                        from: - Math.abs(gearTeeth.value / items.maxRounds)
                        value: 0
                        to: Math.abs(gearTeeth.value / items.maxRounds)
                        stepSize: 1
                        onValueChanged: Activity.initGear()
                    }
                    GCText {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 70
                        Layout.preferredHeight: 60
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSize: smallSize
                        fontSizeMode: Text.Fit
                        color: items.contentColor
                        text: `${(items.toothOffset === 0) ? "" : Math.abs(items.toothOffset)} ${(items.toothOffset > 0) ? qsTr("right") : (items.toothOffset === 0) ? "" : qsTr("left")}`
                    }
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
                for(var i = 0; i < numberOfSteps; i++) {
                    if(!items.runCompleted) {
                        Activity.rotateGear(1) // 1 is rotation angle for curve drawing precision. Higher values make angular lines.
                    } else {
                        break;
                    }
                }
            }
        }

        GCCreationHandler {
            id: creationHandler
            imageMode: true
            fileExtensions: ["*.svg", "*.png", "*.jpg", "*.jpeg", "*.webp"]
            onClose: activity.focus = true;
            onFileLoaded: (data, filePath) => {
                              Activity.initLevel()
                              canvasImage.source = filePath
                              mainCanvas.redrawImage()
                              if (filePath.endsWith(".svg"))
                                svgTank.loadSvg(file.read(filePath))  // Reset svgTank with loaded svg
                              // Png images are not inserted into svgTank (too big and dirty render)
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
                    switch (items.actionAfter) {
                    case "home" :
                        activity.home()
                        break
                    case "next" :
                        undoStack.clear()
                        Activity.nextLevel()
                        break
                    case "previous" :
                        undoStack.clear()
                        Activity.previousLevel()
                        break
                    case "create" :
                        undoStack.clear()
                        Activity.initLevel()
                        break
                    case "open" :
                        undoStack.clear()
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            enabled: !gearTimer.running
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onReloadClicked: Activity.initLevel()
            onHomeClicked: {
                if (!undoStack.isFileSaved) {
                    items.actionAfter = "home"
                    newImageDialog.active = true
                    return
                }
                activity.home()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
