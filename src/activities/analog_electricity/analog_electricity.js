/* GCompris - analog_electricity.js
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (GTK+ version)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Help for the Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "cktsim.js" as Engine
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/analog_electricity/resource/";
var urlDigital = "qrc:/gcompris/src/activities/digital_electricity/resource/";

var numberOfLevel;
var items;
var view;
var toolDelete;
var animationInProgress;
var selectedIndex;
var selectedTerminal;
var components = [];
var determiningComponents = [];
var connectionCount = 0;
var levelProperties;
var invalidCircuit = false;
var processingAnswer = false;
var answerKeys = [];

var uniqueID = 0;
var netlistComponents = [];
var vSourcesList = [];
var netlist = [];

var wireColors = [
    "#72559b",
    "#094386",
    "#97509e",
    "#2890d4",
    "#407a52",
    "#fee348",
    "#a3ca4b",
    "#ea6712",
    "#f4819a",
    "#b82c58",
    "#6b4a36",
    "#d42e2e",
    "#e9dfc9"
]
var colorIndex = 0;

var currentZoom;
var maxZoom = 0.375;
var minZoom = 0.125;
var defaultZoom = 0.25;
var zoomStep = 0.0625;
//bool to avoid createNetList when deleting wires on stop function...
var isStopped = false;

var direction = {
    LEFT: -1,
    RIGHT: 1,
    UP: -2,
    DOWN: 2
};

var viewPort = {
    leftExtreme: 0,
    rightExtreme: 1,
    topExtreme: 0,
    bottomExtreme: 1,
    leftEdge: 0,
    topEdge: 0
};

function start(items_) {
    items = items_;
    numberOfLevel = items.tutorialDataset.tutorialLevels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function reset() {
    stop();
    initLevel();
}

function stop() {
    isStopped = true;
    var nbOfComponents = components.length;
    for(var i = 0 ; i < nbOfComponents ; ++i) {
        removeComponent(0);
    }
}

function initLevel() {
    connectionCount = 0;
    netlistComponents = [];
    netlist = [];
    components = [];
    items.availablePieces.model.clear();
    items.availablePieces.view.currentDisplayedGroup = 0;
    items.availablePieces.view.previousNavigation = 1;
    items.availablePieces.view.nextNavigation = 1;
    determiningComponents = [];
    colorIndex = 0;
    animationInProgress = false;
    disableToolDelete();
    deselect();
    items.availablePieces.hideToolbar();

    currentZoom = defaultZoom;
    viewPort.leftEdge = 0;
    viewPort.topEdge = 0;
    items.playArea.x = items.mousePan.drag.maximumX;
    items.playArea.y = items.mousePan.drag.maximumY;
    isStopped = false;


    if (!items.isTutorialMode) {
        items.tutorialInstruction.index = -1;
        processingAnswer = false;
        loadFreeMode();
    } else {
        processingAnswer = false;
        levelProperties = items.tutorialDataset.tutorialLevels[items.currentLevel];

        for (var i = 0; i < levelProperties.inputComponentList.length; i++) {
            var currentInputComponent = levelProperties.inputComponentList[i];
            items.availablePieces.model.append( {
                "imgName": currentInputComponent.imageName,
                "componentSrc": currentInputComponent.componentSource,
                "imgWidth": currentInputComponent.width,
                "imgHeight": currentInputComponent.height,
                "toolTipText": currentInputComponent.toolTipText
            });
        }

        for (var i = 0; i < levelProperties.playAreaComponentList.length; i++) {
            var index = components.length;

            var currentPlayAreaComponent = levelProperties.playAreaComponentList[i];
            var staticElectricalComponent = Qt.createComponent("qrc:/gcompris/src/activities/analog_electricity/components/" + currentPlayAreaComponent.componentSource);

            components[index] = staticElectricalComponent.createObject(
                        items.playArea, {
                            "componentIndex": index,
                            "posX": levelProperties.playAreaComponentPositionX[i] * currentZoom,
                            "posY": levelProperties.playAreaComponentPositionY[i] * currentZoom,
                            "imgWidth": currentPlayAreaComponent.width * currentZoom,
                            "imgHeight": currentPlayAreaComponent.height * currentZoom,
                            "destructible": false
                        });
            ++uniqueID;
            components[index].componentName = components[index].componentName + uniqueID.toString();
            components[index].initConnections();
        }
        deselect();

        var _determiningComponentsIndex = levelProperties.determiningComponentsIndex
        for (var i = 0; i < _determiningComponentsIndex.length; i++) {
            determiningComponents[i] = components[_determiningComponentsIndex[i]];
        }

        //create wires
        for (i = 0; i < levelProperties.wires.length; i++) {
            var terminalNumber = levelProperties.wires[i][1];
            var connectionPoint = components[levelProperties.wires[i][0]].connectionPoints.itemAt(terminalNumber);
            terminalPointSelected(connectionPoint, false);

            terminalNumber = levelProperties.wires[i][3];
            var terminalToConnect = components[levelProperties.wires[i][2]].connectionPoints.itemAt(terminalNumber);
            terminalPointSelected(terminalToConnect, false);
        }

        if (levelProperties.introMessage.length != 0) {
            items.tutorialInstruction.index = 0;
            items.tutorialInstruction.intro = levelProperties.introMessage;
        } else {
            items.tutorialInstruction.index = -1;
        }
    }
}

function loadFreeMode() {
    var componentList = items.tutorialDataset.componentList;

    for (var i = 0; i < componentList.length; i++) {
        items.availablePieces.model.append( {
            "imgName": componentList[i].imageName,
            "componentSrc": componentList[i].componentSource,
            "imgWidth": componentList[i].width,
            "imgHeight": componentList[i].height,
            "toolTipText": componentList[i].toolTipText,
        });
    }
}

function checkAnswer() {
    answerKeys = [];

    if(invalidCircuit){
        if(items.currentLevel === 1) {
        //special case for level 2 to teach voltage source loop
            items.bonus.good('gnu');
            processingAnswer = false;
            return;
        } else {
        //default case for all other levels
            items.bonus.bad('gnu', items.bonus.checkAnswer);
            processingAnswer = false;
            return;
        }
    }

    for(var i = 0; i < determiningComponents.length; ++i) {
        answerKeys[i] = determiningComponents[i].checkComponentAnswer();
        processingAnswer = true;
    }

    for(var i in answerKeys) {
        if(levelProperties.answerKey[i] === answerKeys[i] && processingAnswer) {
            items.bonus.good('gnu');
        } else {
            items.bonus.bad('gnu', items.bonus.checkAnswer);
            processingAnswer = false;
        }
    }
}

function zoomIn() {
    var previousZoom = currentZoom;
    currentZoom += zoomStep;
    if (currentZoom > maxZoom)
        currentZoom = maxZoom;
    var zoomRatio = currentZoom / previousZoom;
    updateComponentDimension(zoomRatio);

    if (currentZoom == maxZoom) {
        items.availablePieces.zoomInBtn.state = "cannotZoomIn";
    } else {
        items.availablePieces.zoomInBtn.state = "canZoomIn";
    }
    items.availablePieces.zoomOutBtn.state = "canZoomOut";

    if (items.zoomLvl < 0.5) {
        items.zoomLvl += 0.125;
    }
}

function zoomOut() {
    var previousZoom = currentZoom;
    currentZoom -= zoomStep;
    if (currentZoom < minZoom)
        currentZoom = minZoom;
    var zoomRatio = currentZoom / previousZoom;
    updateComponentDimension(zoomRatio);

    if (currentZoom == minZoom) {
        items.availablePieces.zoomOutBtn.state = "cannotZoomOut";
    } else {
        items.availablePieces.zoomOutBtn.state = "canZoomOut";
    }
    items.availablePieces.zoomInBtn.state = "canZoomIn";

    if (items.zoomLvl > 0) {
        items.zoomLvl -= 0.125;
    }
}

function updateComponentDimension(zoomRatio) {
    for (var i = 0; i < components.length; i++) {
        components[i].posX *= zoomRatio;
        components[i].posY *= zoomRatio;
        components[i].imgWidth *= zoomRatio;
        components[i].imgHeight *= zoomRatio;
        updateWires(i);
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    reset();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    reset();
}

function createComponent(x, y, componentIndex) {
    x = x / items.playArea.width;
    y = y / items.playArea.height;

    var index = components.length;

    var component = items.availablePieces.repeater.itemAt(componentIndex);
    var electricComponent = Qt.createComponent("qrc:/gcompris/src/activities/analog_electricity/components/" + component.source);

    components[index] = electricComponent.createObject(
                        items.playArea, {
                            "componentIndex": index,
                            "posX": x,
                            "posY": y,
                            "imgWidth": component.imageWidth * currentZoom,
                            "imgHeight": component.imageHeight * currentZoom,
                            "destructible": true
                        });
    ++uniqueID;
    components[index].componentName = components[index].componentName + uniqueID.toString();
    components[index].initConnections();
    deselect();
}

/* Creates wire between two points.
*/
function terminalPointSelected(terminal, destructible) {
    if(destructible == undefined)
        destructible = true;
    if(selectedTerminal == -1 || selectedTerminal == terminal)
        selectedTerminal = terminal;
    else if(selectedTerminal.parent != terminal.parent) {
        var connectionPoint = terminal;
        createWire(connectionPoint, destructible);
        deselect();
    }
    else {
        deselect();
        selectedTerminal = terminal;
        terminal.selected = true;
    }
    disableToolDelete();
}

function disableToolDelete() {
    if(toolDelete == true) {
        toolDelete = false;
        items.availablePieces.toolDelete.state = "notSelected";
    }
}

function nextColorIndex() {
    if(colorIndex < wireColors.length - 1)
        ++colorIndex;
    else
        colorIndex = 0;
}

function createWire(connectionPoint, destructible) {
    var wireComponent = Qt.createComponent("qrc:/gcompris/src/activities/analog_electricity/Wire.qml");
    if(connectionPoint.wires.length === 0 && selectedTerminal.wires.length === 0) {
        connectionPoint.updateNetlistIndex(selectedTerminal.netlistIndex);
        selectedTerminal.updateNetlistIndex(selectedTerminal.netlistIndex);
        connectionPoint.colorIndex = colorIndex;
        selectedTerminal.colorIndex = colorIndex;
        nextColorIndex();
    } else {
        if(connectionPoint.wires.length > 0) {
            selectedTerminal.updateNetlistIndex(connectionPoint.netlistIndex, connectionPoint.colorIndex);
        }
        if(selectedTerminal.wires.length > 0) {
            connectionPoint.updateNetlistIndex(selectedTerminal.netlistIndex, selectedTerminal.colorIndex);
        }
    }
    var wire = wireComponent.createObject(
               items.playArea, {
                    "node1": selectedTerminal,
                    "node2": connectionPoint,
                    "destructible": destructible,
                });
    connectionPoint.wires.push(wire);
    selectedTerminal.wires.push(wire);
    updateWires(connectionPoint.parent.componentIndex);
    updateWires(selectedTerminal.parent.componentIndex);
    connectionPoint.parent.checkConnections();
    selectedTerminal.parent.checkConnections();
    restartTimer();
}

function updateWires(index) {
    var component = components[index];
    if(component == undefined || component.noOfConnectionPoints == undefined)
        return;

    var rotatedAngle = component.initialAngle * Math.PI / 180;
    var rotatedAngleSin = Math.sin(rotatedAngle);
    var rotatedAngleCos = Math.cos(rotatedAngle);
    for(var i = 0 ; i < component.noOfConnectionPoints ; ++i) {
        var terminal = component.connectionPoints.itemAt(i);
        for(var j = 0 ; j < terminal.wires.length ; ++j) {
            var wire = terminal.wires[j];
            if(wire.node1 != terminal) {
                var otherAngle = wire.node1.parent.initialAngle * Math.PI / 180;
                var otherAngleCos = Math.cos(otherAngle);
                var otherAngleSin = Math.sin(otherAngle);
                var x = wire.node1.xCenterFromComponent;
                var y = wire.node1.yCenterFromComponent;
                var x1 = wire.node1.xCenter - x + x * otherAngleCos - y * otherAngleSin;
                var y1 = wire.node1.yCenter - y + x * otherAngleSin + y * otherAngleCos;

                x = terminal.xCenterFromComponent;
                y = terminal.yCenterFromComponent;
                var x2 = terminal.xCenter - x + x * rotatedAngleCos - y * rotatedAngleSin;
                var y2 = terminal.yCenter - y + x * rotatedAngleSin + y * rotatedAngleCos;

                var width = Math.pow((Math.pow(x1 - x2, 2) +  Math.pow(y1 - y2, 2)),0.5) + 2;
                var angle = (180/Math.PI)*Math.atan((y2-y1)/(x2-x1));
                if(x2 - x1 < 0)
                    angle = angle - 180;
                wire.x = x1;
                wire.y = y1 - wire.height / 2;
                wire.width = width;
                wire.rotation = angle;
            }
        }
    }
    for(var i = 0 ; i < component.noOfConnectionPoints ; ++i) {
        var terminal = component.connectionPoints.itemAt(i);
        for(var j = 0 ; j < terminal.wires.length ; ++j) {
            var x = terminal.xCenterFromComponent;
            var y = terminal.yCenterFromComponent;
            var x1 = terminal.xCenter - x + x * rotatedAngleCos - y * rotatedAngleSin;
            var y1 = terminal.yCenter - y + x * rotatedAngleSin + y * rotatedAngleCos;

            var wire = terminal.wires[j];
            if(wire.node2 != terminal) {
                var otherAngle = wire.node2.parent.initialAngle * Math.PI / 180;
                var otherAngleCos = Math.cos(otherAngle);
                var otherAngleSin = Math.sin(otherAngle);
                x = wire.node2.xCenterFromComponent;
                y = wire.node2.yCenterFromComponent;
                var x2 = wire.node2.xCenter - x + x * otherAngleCos - y * otherAngleSin;
                var y2 = wire.node2.yCenter - y + x * otherAngleSin + y * otherAngleCos;

                var width = Math.pow((Math.pow(x1 - x2, 2) +  Math.pow(y1 - y2, 2)),0.5) + 2;
                var angle = (180/Math.PI)*Math.atan((y2-y1)/(x2-x1));
                if(x2 - x1 < 0)
                    angle = angle - 180;
                wire.x = x1;
                wire.y = y1;
                wire.width = width;
                wire.rotation = angle;
            }
        }
    }
}

function updateWiresOnResize() {
    for(var i = 0; i < components.length; ++i) {
        updateWires(i);
    }
}

function deselect() {
    items.availablePieces.rotateLeft.state = "canNotBeSelected";
    items.availablePieces.rotateRight.state = "canNotBeSelected";
    items.availablePieces.info.state = "canNotBeSelected";
    items.infoTxt.visible = false
    selectedIndex = -1;
    selectedTerminal = -1;
    for(var i = 0 ; i < components.length ; ++i) {
        var component = components[i];
        for(var j = 0 ; j < component.noOfConnectionPoints ; ++j)
            component.connectionPoints.itemAt(j).selected = false;
    }
}

function removeComponent(index) {
    var component = components[index];
    for(var i = 0 ; i < component.noOfConnectionPoints ; ++i) {
        var terminal = component.connectionPoints.itemAt(i);
        if(terminal.wires.length != 0) {
            var wiresLength = terminal.wires.length;
            for(var j = 0; j < wiresLength; ++j) {
                removeWire(terminal.wires[0]);
            }
        }
    }

    components[index].destroy();
    components.splice(index, 1);

    for(var i = index; i < components.length; ++i) {
        --components[i].componentIndex;
    }
    deselect();
}

function removeWire(wire) {
    var connectionPoint1 = wire.node1;
    var connectionPoint2 = wire.node2;

    var removeIndex = connectionPoint1.wires.indexOf(wire);
    connectionPoint1.wires.splice(removeIndex, 1);
    removeIndex = connectionPoint2.wires.indexOf(wire);
    connectionPoint2.wires.splice(removeIndex, 1);

    wire.destroy();
    deselect();

    if(connectionPoint1.wires.length === 0) {
        connectionPoint1.resetIndex();
    } else {
        ++connectionCount;
        connectionPoint1.updateNetlistIndex(connectionCount, colorIndex);
        nextColorIndex();
    }
    if(connectionPoint2.wires.length === 0) {
        connectionPoint2.resetIndex();
    } else {
        ++connectionCount;
        connectionPoint2.updateNetlistIndex(connectionCount, colorIndex);
        nextColorIndex();
    }
    connectionPoint1.parent.checkConnections();
    connectionPoint2.parent.checkConnections();

    if(!isStopped)
        restartTimer();
}

function componentSelected(index) {
    selectedIndex = index;
    items.availablePieces.rotateLeft.state = "canBeSelected";
    items.availablePieces.rotateRight.state = "canBeSelected";
    items.availablePieces.info.state = "canBeSelected";
}

function rotateLeft() {
    components[selectedIndex].rotationAngle = -2;
    components[selectedIndex].rotateComponent.start();
}

function rotateRight() {
    components[selectedIndex].rotationAngle = 2;
    components[selectedIndex].rotateComponent.start();
}

function displayInfo() {
    var component = components[selectedIndex];
    deselect();
    items.infoTxt.visible = true;
    items.infoTxt.text = component.information;

    if(component.infoImageSrc != undefined) {
        items.infoImage.imgVisible = true;
        items.infoImage.source = url + component.infoImageSrc;
    }
    else {
        items.infoImage.imgVisible = false;
        items.infoImage.source = "";
    }
}

function updateToolTip(toolTipText) {
    items.toolTip.show(toolTipText);
}

function restartTimer() {
    items.netlistTimer.restart();
}

function createNetlist() {
    netlist.length = 0;
    netlistComponents.length = 0;
    vSourcesList.length = 0;
    for(var i = 0; i < components.length; i++) {
        var component = components[i];
        component.addToNetlist();
    }
    dcAnalysis();
}

function dcAnalysis() {
    var ckt = new Engine.cktsim.Circuit();
    ckt.load_netlist(netlist);
    var voltageResults = ckt.dc();
    if(ckt.GCWarning != "") {
        displayWarning(ckt.GCWarning);
        return;
    } else {
        invalidCircuit = false;
    }

    var currentResults = ckt.GCCurrentResults;
    for(var i in currentResults) {
        if(vSourcesList[i] != undefined)
            vSourcesList[i].current = currentResults[i];
    }

    for(var i in netlistComponents) {
        if(netlistComponents[i].nodeVoltages == undefined) {
            continue;
        } else {
            for(var j = 0 ; j < netlistComponents[i].nodeVoltages.length ; j++) {
                if(netlistComponents[i].internalNetlistIndex != null) {
                    netlistComponents[i].nodeVoltages[j] = voltageResults[netlistComponents[i].internalNetlistIndex[j]];
                } else {
                    netlistComponents[i].nodeVoltages[j] = voltageResults[netlistComponents[i].externalNetlistIndex[j]];
                }
            }
            netlistComponents[i].updateValues();
        }
    }
}

function displayWarning(message_) {
    items.availablePieces.hideToolbar();
    items.infoTxt.visible = true;
    items.infoTxt.text = message_;
    invalidCircuit = true;
}
