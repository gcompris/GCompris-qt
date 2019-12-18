/* GCompris - Share.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */


// TODO: ne valider que si les poids sont dans la bonne case
// TODO: ajouter des niveaux pour pouvoir le faire tester par un élève
// TODO: fix error when removing a class dragging it
// TODO: give new number only when bonus is finished
// TODO: remove cellsize
// TODO: is it possible to have a vertical mode? If not remove everything related to vertical mode
// TODO: remove settings in bar menu


import QtQuick 2.13
import GCompris 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.5
import QtQml.Models 2.1

import "../../core"

import "numeration_weights_integer.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background

        anchors.fill: parent
        color: "#ffffb3"
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias mainZoneArea: mainZoneArea
            property alias bar: bar
            property alias bonus: bonus
            property alias instruction: instruction
            property alias warningRectangle: warningRectangle
            property alias dataset: dataset
            property alias numberClassListModel: numberClassListModel
            property alias numberClassDragListModel: numberClassDragListModel
            property alias numberWeightDragListModel: numberWeightDragListModel
            property alias numberClassTypeModel: numberClassTypeModel
            property alias leftWidget: leftWidget
            property alias progressBar: progressBar
            property alias numberClassDropAreaRepeater: numberClassDropAreaRepeater
            property alias classNameListView: classNameListView
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.min(background.width / 11, background.height / (9 + barHeightAddon))
            property var levels: activity.datasetLoader.item.data
            property alias numberToConvertRectangle: numberToConvertRectangle
            property alias tutorialSection: tutorialSection
            property alias okButton: okButton
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width >= background.height


        //mainZone
        DropArea {
            id: mainZoneArea

            width: background.vert ?
                       background.width - leftWidget.width - 40 : background.width - 40
            height: ApplicationSettings.isBarHidden ?
                        background.height : background.vert ?
                            background.height - (bar.height * 1.1) :
                            background.height - (bar.height * 1.1) - leftWidget.height

            anchors {
                top: background.vert ? background.top : leftWidget.bottom
                left: background.vert ? leftWidget.right : parent.left
                leftMargin: 20
            }

            keys: "NumberClassKey"

            //shows/hides the objective/instruction
            MouseArea {
                anchors.fill: mainZoneArea
                onClicked: instruction.show()
            }

            Rectangle {
                id: mainZoneAreaDropRectangleVisualisation

                anchors.fill: parent
                color: "pink"
            }

            onDropped: {
                var className = drag.source.name
                drag.source.dragEnabled = false
                Activity.appendClassNameColumn(className, drag.source, false)
            }

            Rectangle {
                id: topBanner

                height: mainZoneArea.height / 10
                width: mainZoneArea.width
                anchors {
                    left: mainZoneArea.left
                    top: mainZoneArea.top
                }
                color: "green"

                Rectangle {
                    id: numberToConvertRectangle
                    anchors.fill: numberToConvertRectangleTxt
                    color: "blue"
                    opacity: 0.8
                    property alias text: numberToConvertRectangleTxt.text
                }

                //display number to convert
                GCText {
                    id: numberToConvertRectangleTxt
                    height: parent.height
                    width: parent.width / 3
                    anchors {
                        left: numberToConvertRectangle.left
                        top: numberToConvertRectangle.top
                    }
                    opacity: numberToConvertRectangle.opacity
                    //z: instruction.z
                    fontSize: background.vert ? regularSize : smallSize
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }

                ProgressBar {
                    id: progressBar
                    height: parent.height
                    width: parent.width / 3

                    property int percentage: 0

                    maximumValue: 100
                    visible: true //!items.isTutorialMode
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 40
                    }

                    GCText {
                        anchors.centerIn: parent

                        fontSize: mediumSize
                        font.bold: true
                        color: "black"
                        //: The following translation represents percentage.
                        text: qsTr("%1%").arg(parent.value)
                        z: 2
                    }
                }
            }

            //store strings Integer and Decimal to display in numeration table header
            ListModel {
                id: numberClassTypeModel
            }

            Rectangle {
                id: numberClassTypeHeader
                width: mainZoneArea.width
                height: mainZoneArea.height / 20
                anchors.top: topBanner.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                border.color: "blue"
                border.width: 1

                ListView {
                    id: numberClassTypeHeaderListView

                    anchors { fill: parent}
                    model: numberClassTypeModel
                    orientation: ListView.Horizontal

                    delegate: Rectangle {
                        width: numberClassTypeModel.get(index).numberClassTypeHeaderWidth
                        height: numberClassTypeHeader.height
                        border.width: 1
                        border.color: "black"
                        color: "lightsteelblue"
                        radius: 2

                        GCText {
                           id: numberClassHeaderCaption

                           anchors.fill: parent
                           anchors.bottom: parent.bottom
                           fontSizeMode: Text.Fit
                           color: "black"
                           verticalAlignment: Text.AlignVCenter
                           horizontalAlignment: Text.AlignHCenter
                           text: numberClassTypeModel.get(index).numberClassType
                           visible: numberClassTypeModel.get(index).numberClassTypeHeaderWidth === 0 ? false : true
                        }
                    }
                 }
            }

            Rectangle {
                id: numberClassHeaders

                width: mainZoneArea.width
                height: mainZoneArea.height / 10
                anchors.top: numberClassTypeHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                border.color: "red"
                border.width: 1


                GCText {
                    id: numberClassHeadersRectangleAdvice
                    height: parent.height
                    width: parent.width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    opacity: visualModel.count === 0 ? 1 : 0
                    fontSizeMode: Text.Fit
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Drag here the class numbers")
                }

                ListView {
                       id: classNameListView

                       anchors { fill: parent}
                       model: visualModel
                       orientation: ListView.Horizontal
                       interactive: false
                       cacheBuffer: 50
                 }

                DelegateModel {
                    id: visualModel

                    model: numberClassListModel
                    delegate: nnumberClassHeaderElement //Qt.createComponent("NumberClassHeaderElement.qml") //ask johnny for some help there
                }
            }

            Component {     // ? what to do when removed element ? TypeError: Cannot read property 'misplaced' of undefined
                id: nnumberClassHeaderElement

                MouseArea {
                    id: dragArea

                    property bool held: false

                    width: mainZoneArea.width / numberClassListModel.count
                    height: numberClassHeaders.height

                    drag.target: held ? content : undefined
                    drag.axis: Drag.XAxis

                    onPressed: held = true
                    onReleased: {
                        if ((content.x < leftWidget.width) && held)  //? don't understand why I have a content.x = 0 when held is not true, this point needs to be cleared
                        {
                            console.log("index className element",index)
                            numberClassListModel.get(index).element_src.dragEnabled = true
                            numberClassListModel.remove(index,1)
                            Activity.updateIntegerAndDecimalHeaderWidth()
                        }
                        held = false
                    }

                    Rectangle {
                        id: content

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        width: mainZoneArea.width / numberClassListModel.count
                        height: numberClassHeaders.height / 1.5
                        border.width: numberClassListModel.get(index).misplaced === true ? 5 : 1
                        //FIXME: when removing an element of NumberClassList model border color is stilll asked
                        border.color: numberClassListModel.get(index).misplaced === true ? "red" : "lightsteelblue"
                        color: dragArea.held ? "lightsteelblue" : "white"
                        Behavior on color { ColorAnimation { duration: 100 } }
                        radius: 2
                        Drag.active: dragArea.held
                        Drag.source: dragArea
                        Drag.hotSpot.x: width / 2
                        Drag.hotSpot.y: height / 2

                        states: State {
                            when: dragArea.held

                            ParentChange { target: content; parent: root }
                            AnchorChanges {
                                target: content
                                anchors { horizontalCenter: undefined; verticalCenter: undefined }
                            }
                        }

                        GCText {
                            id: numberClassHeaderCaption

                            anchors.fill: parent
                            anchors.bottom: parent.bottom
                            fontSizeMode: Text.Fit
                            color: "black"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: numberClassListModel.get(index).name   //here there a problem when removing a number class
                            z: 100
                        }
                    }

                    DropArea {
                        anchors { fill: parent; margins: 10 }
                        onEntered: {
                            console.log("dragArea.DelegateModel.itemsIndex",dragArea.DelegateModel.itemsIndex)
                            console.log("classNameListView.count",classNameListView.count)
                            //move class name columns except the decimal part which stays always on the last position
                            if (dragArea.DelegateModel.itemsIndex < classNameListView.count - 1) {
                                numberClassListModel.move(drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex,1)
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: numberClassDropAreasGridLayout

                property alias numberClassDropAreaRepeater: numberClassDropAreaRepeater

                anchors.top: numberClassHeaders.bottom
                width: parent.width
                height: parent.height - topBanner.height - numberClassHeaders.height - numberClassTypeHeader.height
                spacing: 10

                Repeater {
                    id: numberClassDropAreaRepeater

                    model: numberClassListModel
                    NumberClassDropArea {
                        id: numberClassDropAreaElement

                        //property alias numberWeightDragListModel: activity.background.numberWeightDragListModel //?

                        className: name  //name comes from numberClassListModel

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumWidth: 50
                        Layout.preferredWidth: 100
                    }
                }
            }

            Tutorial {
                id: tutorialSection

                tutorialText.anchors.top: undefined
                tutorialText.anchors.bottom: tutorialSection.bottom
                tutorialText.anchors.margins: tutorialSection.tutorialText.height
                tutorialDetails: Activity.tutorialInstructions
                useImage: false

                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false    //?
                }
            }
        }

        ListModel {
            id: numberClassListModel
        }

        ListModel {
            id: numberClassDragListModel
        }

        ListModel {
            id: numberWeightDragListModel
        }


        //instruction rectangle
        Rectangle {
            id: instruction
            anchors.fill: instructionTxt
            opacity: 0.8
            radius: 10
            border.width: 2
            z: 10
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.hide()
                enabled: instruction.opacity !== 0
            }

            function show() {
                if(text)
                    opacity = 0.8
            }
            function hide() {
                opacity = 0
            }
        }

        //display level objective
        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? parent.top : leftWidget.bottom //?
                topMargin: -10
                horizontalCenter: background.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: background.vert ? regularSize : smallSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }


        //display level objective
        GCText {
            id: warningTxt
            anchors {
                horizontalCenter: background.horizontalCenter
                verticalCenter: background.verticalCenter
            }
            opacity: warningRectangle.opacity
            z: warningRectangle.z + 1
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        Rectangle {
            id: warningRectangle
            anchors.fill: warningTxt
            opacity: 0
            radius: 10
            border.width: 2
            z: 10
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

            property alias text: warningTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: warningRectangle.hide()
                enabled: warningRectangle.opacity !== 0
            }

            function show() {
                if(text)
                    opacity = 0.8
            }
            function hide() {
                opacity = 0
            }
        }





        //dragable weights list (leftwidget)
        Rectangle {
            id: leftWidget
            width: background.vert ?
                       items.cellSize * 1.74 : background.width
            height: background.vert ?
                        background.height : items.cellSize * 1.74
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4
            z: 4


            //grid with ok button and the different draggable number weights
            Flickable {
                id: flickableElement

                anchors.fill: parent
                width: background.height
                height: leftWidget.width
                //contentHeight: gridView.height
                contentHeight: gridView.height * 1.8   //?
                contentWidth: leftWidget.width
                boundsBehavior: Flickable.DragAndOvershootBounds

                Grid {
                    id: gridView
                    x: 10
                    y: 10

                    width: parent.width
                    height: background.height

                    //width: background.vert ? leftWidget.width : 3 * bar.height
                    //     height: background.vert ? background.height - 2 * bar.height : bar.height
                    spacing: 10
                    columns: background.vert ? 1 : 5

                    //ok button
                    Image {
                        id: okButton
                        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                        sourceSize.width: items.cellSize * 1.5
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            enabled: background.finished ? false : true
                            onPressed: okButton.opacity = 0.6
                            onReleased: okButton.opacity = 1
                            onClicked: {
                                Activity.checkAnswer()
                            }
                        }
                    }

                    // numbers classes drag elements
                    Repeater {
                        id: numberClassDragElements
                        model: numberClassDragListModel

                        NumberClassDragElement {
                            id: classDragElement

                            name: model.name
                            color: model.color
                            Drag.keys: model.dragkeys
                        }
                    }

                    // numbers columns weights and numbers weigths drag elements
                    Repeater {
                        id: numberWeightDragElements
                        model: numberWeightDragListModel

                        NumberWeightDragElement {
                            id: weightComponentDragElement
                            name: model.name
                            imageName: model.imageName
                            Drag.keys: model.dragkeys
                            weightValue: model.weightValue
                            caption: model.caption
                            color: model.color
                            selected: model.selected
                        }
                    }
                }
            }
        }


        //bar buttons
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload | config}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reloadRandom()    //?
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
        }
    }
}
