/* GCompris - GCComboBox.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0

/**
 * A QML component unifying comboboxes in GCompris.
 * @ingroup components
 *
 * GCComboBox contains a combobox and a label.
 * When the combobox isn't active, it is displayed as a button containing the current value
 * and the combobox label (its description).
 * Once the button is clicked, the list of all available choices is displayed.
 * Also, above the list is the combobox label.
 *
 * Navigation can be done with keys and mouse/gestures.
 * As Qt comboboxes, you can either have a js Array or a Qml model as model.

 * GCComboBox should now be used wherever you'd use a QtQuick combobox. It has
 * been decided to implement comboboxes ourselves in GCompris because of
 * some integration problems on some OSes (native dialogs unavailable).
 */
Item {
    id: gccombobox
    focus: true

    width: parent.width
    height: flow.height

    /**
     * type:Item
     * Where the list containing all choices will be displayed.
     * Should be the dialogActivityConfig item if used on config.
     */
    property Item background

    /**
     * type:int
     * Current index of the combobox.
     */
    property int currentIndex: -1

    /**
     * type:string
     * Current text displayed in the combobox when inactive.
     */
    property string currentText


    /**
     * type:alias
     * Model for the list (user has to specify one).
     */
    property alias model: gridview.model

    /**
     * type:string
     * Text besides the combobox, used to describe what the combobox is for.
     */
    property string label
    
    /**
     * type:bool
     * Internal value.
     * If model is an js Array, we access data using modelData and [] else qml Model, we need to use model and get().
     */
    readonly property bool isModelArray: model.constructor === Array

    // start and stop trigs the animation
    signal start
    signal stop

    // emitted at stop animation end
    signal close

    onCurrentIndexChanged: {
        currentText = isModelArray ? model[currentIndex].text : (model && model.get(currentIndex) ? model.get(currentIndex).text : "")
    }

    /**
     * type:Flow
     * Combobox display when inactive: the button with current choice  and its label besides.
     */
    Flow {
        id: flow
        width: parent.width
        spacing: 5 * ApplicationInfo.ratio
        Rectangle {
            id: button
            visible: true
            // Add radius to add some space between text and borders
            implicitWidth: Math.max(200, currentTextBox.width+radius)
            implicitHeight: 50 * ApplicationInfo.ratio
            border.width: 2
            border.color: "#373737"
            radius: 10
            gradient: Gradient {
                GradientStop { position: 0 ; color: mouseArea.pressed ? "#C03ACAFF" : "#23373737" }
                GradientStop { position: 1 ; color: mouseArea.pressed ? "#803ACAFF" : "#13373737" }
            }
            // Current value of combobox
            GCText {
                id: currentTextBox
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: currentText
                fontSize: mediumSize
                color: "#373737"
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onReleased: {
                   popup.visible = true
                }
            }
        }

        Item {
            width: labelText.width
            height: button.height
            GCText {
                id: labelText
                text: label
                anchors.verticalCenter: parent.verticalCenter
                fontSize: mediumSize
                wrapMode: Text.WordWrap
            }
        }
    }
 
     /**
     * type:Item
     * Combobox display when active: header with the description and the gridview containing all the available choices.
     */
    Item {
        id: popup
        visible: false
        width: parent.width
        height: parent.height
        
        parent: background
        z: 100
        focus: visible

        // Forward event to activity if key pressed is not one of the handled key
        // (ctrl+F should still resize the window for example)
        Keys.onPressed: {
            if(event.key !== Qt.Key_Back) {
                background.currentActivity.Keys.onPressed(event)
            }
        }
        Keys.onReleased: {
            if(event.key === Qt.Key_Back) {
                // Keep the old value
                discardChange();
                hidePopUpAndRestoreFocus();
                event.accepted = true
            }
        }

        Keys.onRightPressed: gridview.moveCurrentIndexRight();
        Keys.onLeftPressed: gridview.moveCurrentIndexLeft();
        Keys.onDownPressed: gridview.moveCurrentIndexDown();
        Keys.onUpPressed: gridview.moveCurrentIndexUp();

        Keys.onEscapePressed: {
            // Keep the old value
            discardChange();
            hidePopUpAndRestoreFocus();
        }
        Keys.onEnterPressed: {
            acceptChange();
            hidePopUpAndRestoreFocus();
        }
        Keys.onReturnPressed: {
            acceptChange();
            hidePopUpAndRestoreFocus();
        }

        Keys.onSpacePressed: {
            acceptChange();
            hidePopUpAndRestoreFocus();
        }

        // Don't accept the list value, restore previous value
        function discardChange() {
            if(isModelArray) {
                for(var i = 0 ; i < model.count ; ++ i) {
                    if(model[currentIndex].text === currentText) {
                        currentIndex = i;
                        break;
                    }
                }
            }
            else {
                for(var i = 0 ; i < model.length ; ++ i) {
                    if(model.get(currentIndex).text === currentText) {
                        currentIndex = i;
                        break;
                    }
                }
            }
            gridview.currentIndex = currentIndex;
        }

        // Accept the change. Updates the currentIndex and text of the button
        function acceptChange() {
            currentIndex = gridview.currentIndex;
            currentText = isModelArray ? model[currentIndex].text : (model && model.get(currentIndex) ? model.get(currentIndex).text : "")
        }

        function hidePopUpAndRestoreFocus() {
            popup.visible = false;
            // Restore focus on previous activity for keyboard input
            background.forceActiveFocus();
        }
        
        Rectangle {
            id: listBackground
            anchors.fill: parent
            radius: 10
            color: "grey"
            
            Rectangle {
                id : headerDescription
		        z: 10
                width: gridview.width
                height: gridview.elementHeight
                GCText {
                    text: label
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                GCButtonCancel {
                    id: discardIcon
                    anchors.right: headerDescription.right
                    anchors.top: headerDescription.top
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            popup.acceptChange();
                            popup.hidePopUpAndRestoreFocus();
                        }
                    }
                }
            }

            GridView {
                id: gridview
                z: 4
                readonly property int elementHeight: 40 * ApplicationInfo.ratio

                // each element has a 300 width size minimum. If the screen is larger than it,
                // we do a grid with cases with 300px for width at minimum.
                // If you have a better idea/formula to have a different column number, don't hesitate, change it :).
                readonly property int numberOfColumns: Math.max(1, Math.floor(width / (300 * ApplicationInfo.ratio)))
                contentHeight: isModelArray ? elementHeight*model.count/numberOfColumns : elementHeight*model.length/numberOfColumns
                width: listBackground.width
                height: listBackground.height-headerDescription.height
                currentIndex: gccombobox.currentIndex
                flickableDirection: Flickable.VerticalFlick
                clip: true
                anchors.top: headerDescription.bottom
                cellWidth: width / numberOfColumns
                cellHeight: elementHeight

                delegate: Component {
                    Rectangle {
                        width: gridview.cellWidth
                        height: gridview.elementHeight
                        color: GridView.isCurrentItem ? "darkcyan" : "beige"
                        border.width: GridView.isCurrentItem ? 3 : 2
                        radius: 5
                        Image {
                            id: isSelectedIcon
                            visible: parent.GridView.isCurrentItem
                            source: "qrc:/gcompris/src/core/resource/apply.svg"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                            sourceSize.width: (gridview.elementHeight * 0.8)
                        }
                        GCText {
                            id: textValue
                            text: isModelArray ? modelData.text : model.text
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                currentIndex = index
                                popup.acceptChange();
                                popup.hidePopUpAndRestoreFocus();
                            }
                        }
                    }
                }
            }
        }
    }
}
