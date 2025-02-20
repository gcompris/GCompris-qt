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
import core 1.0

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
    property Item boxBackground

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

    // This function is called when we change locale to dynamically change it without restart
    function restoreBinding() {
        // This is done for font capitalisation box, else the text does not refresh
        currentIndexChanged();
        // This is done to reset the binding of the language box, else the index is reset to 0 after changing locale
        gridview.currentIndex = Qt.binding(function() { return currentIndex });
    }

    /**
     * type:Column
     * Combobox display when inactive: the label and the button with current choice.
     */
    Column {
        id: comboColumn
        width: parent.width
        spacing: GCStyle.halfMargins
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
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.darkBorder
            width: currentTextBox.contentWidth + GCStyle.baseMargins
            height: 50 * ApplicationInfo.ratio
            radius: GCStyle.halfMargins
            color: mouseArea.pressed ? GCStyle.highlightColor : GCStyle.darkTransparentBg
            // Current value of combobox
            GCText {
                id: currentTextBox
                anchors.centerIn: parent
                text: currentText
                color: GCStyle.darkText
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: comboColumn.width - GCStyle.baseMargins
                height: 50 * ApplicationInfo.ratio
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
        color: GCStyle.configBg

        parent: boxBackground
        z: 100
        focus: visible

        // Forward event to activity if key pressed is not one of the handled key
        // (ctrl+F should still resize the window for example)
        Keys.onPressed: (event) => {
            if(event.key !== Qt.Key_Back) {
                boxBackground.currentActivity.Keys.onPressed(event)
            }
        }
        Keys.onReleased: (event) => {
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
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            width: popup.width - 2 * GCStyle.baseMargins
            height: textDescription.height + 2 * GCStyle.baseMargins
            anchors.top: popup.top
            anchors.horizontalCenter: popup.horizontalCenter
            anchors.topMargin: GCStyle.baseMargins

            GCText {
                id: textDescription
                text: label
                width: headerDescription.width - (discardIcon.width + discardIcon.anchors.margins) * 2
                height: 50 * ApplicationInfo.ratio
                anchors.centerIn: headerDescription
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                fontSize: largeSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }

            GCButtonCancel {
                id: discardIcon
                anchors.top: undefined
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: GCStyle.tinyMargins
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
            // each element has a 300 width size minimum. If the screen is larger than it,
            // we do a grid with cases with 300px for width at minimum.
            // If you have a better idea/formula to have a different column number, don't hesitate, change it :).
            readonly property int numberOfColumns: Math.max(1, Math.floor(width / (300 * ApplicationInfo.ratio)))
            width: headerDescription.width
            height: popup.height - headerDescription.height - 2 * GCStyle.baseMargins
            currentIndex: gccombobox.currentIndex
            flickableDirection: Flickable.VerticalFlick
            maximumFlickVelocity: popup.height
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            cellWidth: headerDescription.width / numberOfColumns
            cellHeight: 40 * ApplicationInfo.ratio
            anchors.top: headerDescription.bottom
            anchors.topMargin: GCStyle.halfMargins
            anchors.horizontalCenter: popup.horizontalCenter
            onVisibleChanged: {
                if(visible) {
                    positionViewAtIndex(currentIndex, GridView.Center);
                }
            }

            delegate: Component {
                Item {
                    id: gridItem
                    width: gridview.cellWidth
                    height: gridview.cellHeight
                    property bool itemSelected : GridView.isCurrentItem
                    Rectangle {
                        id: itemBg
                        width: parent.width - radius
                        height: parent.height - radius
                        color: gridItem.itemSelected ? GCStyle.lightBg : GCStyle.lightTransparentBg
                        border.width: gridItem.itemSelected ? GCStyle.thinBorder : GCStyle.thinnestBorder
                        border.color: GCStyle.whiteBorder
                        radius: GCStyle.halfMargins
                        anchors.centerIn: parent
                    }
                    Image {
                        id: isSelectedIcon
                        visible: parent.GridView.isCurrentItem
                        source: "qrc:/gcompris/src/core/resource/apply.svg"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: GCStyle.halfMargins
                        sourceSize.width: parent.height - GCStyle.baseMargins
                    }
                    GCText {
                        id: textValue
                        text: isModelArray ? modelData.text : model.text
                        anchors.centerIn: parent
                        height: itemBg.height
                        width: itemBg.width - isSelectedIcon.width * 2 - GCStyle.baseMargins
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
