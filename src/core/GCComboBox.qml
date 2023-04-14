/* GCompris - GCComboBox.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
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
    focus: visible

    width: parent.width
    height: comboColumn.height

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
     * type:Column
     * Combobox display when inactive: the label and the button with current choice.
     */
    Column {
        id: comboColumn
        width: parent.width
        spacing: 5 * ApplicationInfo.ratio
        Item {
            id: labelArea
            width: labelText.width
            height: labelText.height
            GCText {
                id: labelText
                text: label
                anchors.verticalCenter: parent.verticalCenter
                width: comboColumn.width
                fontSize: mediumSize
                wrapMode: Text.WordWrap
            }
        }
        Rectangle {
            id: button
            visible: true
            border.width: 2
            border.color: "#373737"
            width: currentTextBox.contentWidth + radius * 2
            height: 50 * ApplicationInfo.ratio
            radius: 10
            gradient: Gradient {
                GradientStop { position: 0 ; color: mouseArea.pressed ? "#C03ACAFF" : "#23373737" }
                GradientStop { position: 1 ; color: mouseArea.pressed ? "#803ACAFF" : "#13373737" }
            }
            // Current value of combobox
            GCText {
                id: currentTextBox
                anchors.centerIn: parent
                text: currentText
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: comboColumn.width - 20
                height: 50 * ApplicationInfo.ratio
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
    }
 
     /**
     * type:Item
     * Combobox display when active: header with the description and the gridview containing all the available choices.
     */
    Rectangle {
        id: popup
        visible: false
        width: if(parent) parent.width
        height: if(parent) parent.height
        color: "#696da3"

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
            parent.forceActiveFocus();
        }

        Rectangle {
            id : headerDescription
            z: 10
            color: "#e6e6e6"
            radius: 10 * ApplicationInfo.ratio
            width: popup.width - 30
            height: textDescription.height * 1.2
            anchors.top: popup.top
            anchors.horizontalCenter: popup.horizontalCenter
            anchors.topMargin: 10 * ApplicationInfo.ratio

            GCText {
                id: textDescription
                text: label
                width: headerDescription.width - 120 * ApplicationInfo.ratio //minus twice the discard button size
                height: 50 * ApplicationInfo.ratio
                anchors.centerIn: headerDescription
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#191919"
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: largeSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }

            GCButtonCancel {
                id: discardIcon
                anchors.verticalCenter: headerDescription.verticalCenter
                anchors.margins: 2 * ApplicationInfo.ratio
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
            width: headerDescription.width
            height: popup.height - headerDescription.height - 20 * ApplicationInfo.ratio
            currentIndex: gccombobox.currentIndex
            flickableDirection: Flickable.VerticalFlick
            clip: true
            cellWidth: width / numberOfColumns
            cellHeight: elementHeight
            anchors.top: headerDescription.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            anchors.horizontalCenter: popup.horizontalCenter

            delegate: Component {
                Item {
                    id: gridItem
                    width: gridview.cellWidth
                    height: gridview.elementHeight
                    property bool itemSelected : GridView.isCurrentItem
                    Rectangle {
                        width: gridview.cellWidth - radius
                        height: gridview.elementHeight - radius
                        color: gridItem.itemSelected ? "#e6e6e6" : "#bdbed0"
                        border.width: gridItem.itemSelected ? 3 : 1
                        border.color: "white"
                        radius: 5 * ApplicationInfo.ratio
                        anchors.centerIn: parent
                    }
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
                        height: parent.height
                        width: parent.width - isSelectedIcon.width * 2 - 20
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: mediumSize
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
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
