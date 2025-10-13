/* GCompris - EditorBox.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr> (toolBar logic extracted from former EditToolBar)
 *   Johnny Jazeix <jazeix@gmail.com> (editor logic extracted from ComparatorEditor)
 *   Timothée Giet <animtim@gmail.com> (unification + logic and visual refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Item {
    id: editorBox
    width: parent.width
    height: parent.height

    required property ListModel editorPrototype
    required property ListModel editorModel
    required property Component fieldsComponent

    property int current: -1
    property bool toolBarEnabled: true
    enabled: toolBarEnabled

    readonly property int minWidth: buttonsRow.width // used for SplitView.minimumWidth when in a StyledSplitView
    readonly property int maxWidth: scrollBg.width - 2 * Style.margins - 10 // used as maxWidth for FieldEdit items when needed

    onCurrentChanged: {
        fitCurrentInView();
    }

    function fitCurrentInView() {
        if(current < 0) {
            return
        } else {
            var currentItemY = mainRepeater.itemAt(current).y;
            var currentItemBottom = currentItemY + mainRepeater.itemAt(current).height;
            if(currentItemY < editorScroll.contentY) {
                // if item is above view, move it down to the top of the view
                editorScroll.contentY = currentItemY;
            } else if(currentItemBottom > editorScroll.height + editorScroll.contentY) {
                // if item is below view, move it up to the bottom of the view
                editorScroll.contentY = currentItemBottom - editorScroll.height;
            }
        }
    }

    Rectangle {
        id: editorToolBar
        color: Style.selectedPalette.base
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
        height: Style.lineHeight
        width: parent.width
        anchors.top: parent.top

        enabled: editorBox.toolBarEnabled

        // Properties initialized with parent properties.
        readonly property bool addEnabled: editorBox.editorPrototype.multiple ? true : (editorBox.editorModel.count < 1)
        readonly property bool removeEnabled: editorBox.current !== -1
        readonly property bool upEnabled: editorBox.editorPrototype.multiple ?
            ((editorBox.editorModel !== null) && (editorBox.editorModel.count > 1) &&
            (editorBox.current > 0) && (editorBox.current !== -1))
            : false
        readonly property bool downEnabled: editorBox.editorPrototype.multiple ?
            ((editorBox.editorModel !== null) && (editorBox.editorModel.count > 1) &&
            (editorBox.current < editorBox.editorModel.count - 1) && (editorBox.current !== -1))
            : false

        Row {
            id: buttonsRow

            SmallButton {        // Add button
                enabled: editorToolBar.addEnabled
                text: "\uf067"
                toolTipOnHover: true
                toolTipText: qsTr("Add")
                onClicked: {
                    editorBox.editorModel.append(datasetEditor.createFromPrototype(editorBox.editorPrototype));
                    editorBox.current = editorBox.editorModel.count - 1;
                }
            }

            SmallButton {        // Remove button
                enabled: editorToolBar.removeEnabled
                text: "\uf068"
                toolTipOnHover: true
                toolTipText: qsTr("Remove")
                onClicked: {
                    var toRemove = editorBox.current;
                    editorBox.current = -1;
                    editorBox.editorModel.remove(toRemove);
                }
            }

            SmallButton {        // Move up button
                enabled: editorToolBar.upEnabled
                text: "\uf077"
                toolTipOnHover: true
                toolTipText: qsTr("Move up")
                onClicked: {
                    editorBox.editorModel.move(editorBox.current, editorBox.current - 1, 1);
                    editorBox.current = editorBox.current - 1;
                }
            }

            SmallButton {        // Move down button
                enabled: editorToolBar.downEnabled
                text: "\uf078"
                toolTipOnHover: true
                toolTipText: qsTr("Move down")
                onClicked: {
                    editorBox.editorModel.move(editorBox.current, editorBox.current + 1, 1);
                    editorBox.current = editorBox.current + 1;
                }
            }
        }
    }

    Rectangle {
        id: scrollBg
        anchors {
            top: editorToolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: Style.selectedPalette.alternateBase
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    StyledFlickable {
        id: editorScroll
        anchors.fill: scrollBg
        anchors.margins: scrollBg.border.width
        contentWidth: mainColumn.width
        contentHeight: mainColumn.height

        Column {
            id: mainColumn
            width: childrenRect.width
            spacing: Style.smallMargins

            Repeater {
                id: mainRepeater
                model: editorBox.editorModel

                Rectangle {
                    id: mainLineItem
                    width: Math.max(editorScroll.width - 10, fieldsColumnLoader.width + 2 * Style.margins)
                    height: fieldsColumnLoader.height + 2 * Style.margins
                    color: mainMouseArea.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.base
                    border.color: mainLineItem.activeFocus ? Style.selectedPalette.highlight :
                            (mainMouseArea.hovered || (editorBox.current === index) ? Style.selectedPalette.text :
                            Style.selectedPalette.accent)
                    border.width: (mainLineItem.activeFocus || (editorBox.current === index)) ? 2 : 1
                    activeFocusOnTab: true
                    required property int index

                    Keys.onPressed: (event)=> {
                        if(event.key == Qt.Key_Space) {
                            mainLineItem.selectItem();
                        }
                    }

                    // Needed because initial position is 0 before being moved to its actual position in the column
                    onYChanged: {
                        if(index === editorBox.current) {
                            editorBox.fitCurrentInView();
                        }
                    }

                    function selectItem() {
                        editorBox.current = index;
                    }

                    MouseArea {
                        id: mainMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        onClicked: {
                            mainLineItem.selectItem();
                        }
                    }

                    Loader {
                        id: fieldsColumnLoader
                        property alias index: mainLineItem.index
                        sourceComponent: editorBox.fieldsComponent
                    }
                }
            }
        }
    }
}
