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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 1.1
import GCompris 1.0

Item {
    id: gccombobox
    focus: true

    width: button.width
    height: button.height

    property Item background
    property int currentIndex: -1
    // The current text displayed in the combobox
    property string currentText

    property alias model: listview.model

    // Text besides the combobox, used to describe what the combobox is for
    property string label
    
    // If model is an (js) Array, we access data using modelData and [] else qml Model, we need to use model and get().
    property bool isModelArray: model.constructor === Array

    // start and stop trigs the animation
    signal start
    signal stop

    // emitted at stop animation end
    signal close

    onCurrentIndexChanged: {
        currentText = isModelArray ? model[currentIndex].text : (model && model.get(currentIndex) ? model.get(currentIndex).text : "")
    }

    Flow {
        width: button.width+labelText.width+10
        spacing: 5 * ApplicationInfo.ratio
        Rectangle {
            id: button
            visible: true
            // Add radius to add some space between text and borders
            implicitWidth: Math.max(200, currentTextBox.width+radius)
            implicitHeight: 50 * ApplicationInfo.ratio
            border.width: 2
            border.color: "black"
            radius: 10
            gradient: Gradient {
                GradientStop { position: 0 ; color: mouseArea.pressed ? "#87ff5c" : "#ffe85c" }
                GradientStop { position: 1 ; color: mouseArea.pressed ? "#44ff00" : "#f8d600" }
            }
            // Current value of combobox
            GCText {
                id: currentTextBox
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: currentText
                fontSize: mediumSize
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onReleased: {
                   popup.visible = true
                }
            }
        }

        GCText {
            id: labelText
            text: label
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
    }
 
    /* List */
    Item {
        id: popup
        visible: false
        width: parent.width
        height: parent.height
        
        parent: background
        
        focus: visible

        // Forward event to activity if key pressed is not one of the handled key
        // (ctrl+F should still resize the window for example)
        Keys.onPressed: background.currentActivity.Keys.onPressed(event)

        Keys.onUpPressed: listview.decrementCurrentIndex()
        Keys.onDownPressed: listview.incrementCurrentIndex()
        
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
            listview.currentIndex = currentIndex;
        }

        // Accept the change. Updates the currentIndex and text of the button
        function acceptChange() {
            currentIndex = listview.currentIndex;
            currentText = isModelArray ? model[currentIndex].text : (model && model.get(currentIndex) ? model.get(currentIndex).text : "")
        }

        function hidePopUpAndRestoreFocus() {
            popup.visible = false;
            // Restore focus on previous activity for keyboard input
            background.currentActivity.forceActiveFocus();
        }
        
        Rectangle {
            id: listBackground
            anchors.fill: parent
            radius: 10
            color: "grey"
            
            Rectangle {
                id : headerDescription
                width: listview.width
                height: listview.elementHeight
                GCText {
                    text: label
                    fontSize: mediumSize
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popup.acceptChange();
                        popup.hidePopUpAndRestoreFocus();
                    }
                }
            }
            ListView {
                id: listview
                readonly property int elementHeight: 40 * ApplicationInfo.ratio
                contentHeight: isModelArray ? elementHeight*model.count : elementHeight*model.length
                width: listBackground.width
                height: listBackground.height-headerDescription.height
                currentIndex: gccombobox.currentIndex
                flickableDirection: Flickable.VerticalFlick
                clip: true
                anchors.top: headerDescription.bottom

                delegate: Component {
                    Rectangle {
                        width: listBackground.width
                        height: listview.elementHeight
                        color: ListView.isCurrentItem ? "darkcyan" : "beige"
                        border.width: ListView.isCurrentItem ? 3 : 2
                        radius: 5
                        Image {
                            id: isSelectedIcon
                            visible: parent.ListView.isCurrentItem
                            source: "qrc:/gcompris/src/core/resource/apply.svg"
                            fillMode: Image.PreserveAspectFit
                            anchors.right: textValue.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 10
                            sourceSize.width: (listview.elementHeight*0.8) * ApplicationInfo.ratio
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
