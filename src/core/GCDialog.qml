/* GCompris - GCDialog.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

/**
 * A QML component for GCompris dialogs.
 * @ingroup components
 *
 * Contains the following basic layout elements: Title (message), a GCompris
 * cancel button (GCButtonCancel) at the top right and two optional buttons.
 *
 * Can be conveniently instantiated dynamically in conjunction with
 * showMessageDialog from core.js.
 *
 * GCDialog should now be used wherever you'd use a QtQuick dialog. It has
 * been decided to implement dialogs ourselves in GCompris because of
 * missing translations of labels of Qt's standard buttons for some language
 * supported by GCompris, as well as integration problems on some OSes
 * (Sailfish OS).
 *
 * @inherit QtQuick.Item
 * @sa showMessageDialog
 */
Rectangle {
    id: gcdialog
    color: GCStyle.grayedBg

    /**
     * type:string
     * Heading instruction text.
     */
    property alias message: instructionTxt.textIn

    /**
     * type:string
     * Label of the first button.
     */
    property alias button1Text: button1.text

    /**
     * type:string
     * Label of the second button.
     */
    property alias button2Text: button2.text

    /**
     * type:bool
     * Check is the dialog can be destroyed
     */
    property bool isDestructible: true

    /**
     * type:bool
     * Set to true after clicking on one of the options
     */
    property bool alreadyClicked: false

    /**
     * Emitted when the dialog should be started.
     *
     * Triggers fading in.
     */
    signal start

    /**
     * Emitted when the dialog should be stopped.
     *
     * Triggers fading out.
     */
    signal stop

    /**
     * Emitted when the dialog has stopped.
     */
    signal close

    /**
     * Emitted when the first button has been clicked.
     */
    signal button1Hit

    /**
     * Emitted when the second button has been clicked.
     */
    signal button2Hit

    /**
     * Emitted after the dialog is stopped, useful to trigger some actions AFTER the dialog is closed
     */
    signal deferredAction

    /**
     * type:Component
     * Content component which holds the optional content
     * after instructionText
     */
    property Component content

    focus: true
    opacity: 0

    onVisibleChanged: {
        if(visible) {
            gcdialog.forceActiveFocus();
            parent.Keys.enabled = false;
        }
    }

    anchors {
        fill: parent
    }

    onStart: {
        opacity = 1;
        gcdialog.forceActiveFocus();
        parent.Keys.enabled = false;
        alreadyClicked = false;
    }
    onStop: {
        opacity = 0;
        parent.Keys.enabled = true;
        parent.forceActiveFocus();
        deferredAction();
    }
    onClose: {
        if(isDestructible)
            destroy();
    }

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    z: 1500

    MultiPointTouchArea {
        // Just to catch mouse events
        anchors.fill: parent
    }

    /* Message */
    Item {
        id: instruction
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: buttonCancel.height + GCStyle.baseMargins
            bottom: parent.bottom
            bottomMargin: GCStyle.baseMargins
        }
        width: parent.width - 2 * GCStyle.baseMargins

        Rectangle {
            id: instructionTxtBg
            anchors.top: instruction.top
            width: parent.width
            height: instruction.height - button1.height * 3 - GCStyle.halfMargins * 3
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinBorder
            border.color: GCStyle.whiteBorder
            color: GCStyle.lightBg

            Flickable {
                id: instructionFlick
                maximumFlickVelocity: gcdialog.height
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                flickableDirection: Flickable.VerticalFlick
                clip: true
                contentHeight: instructionTxt.height + extraLoader.height + 2 * GCStyle.baseMargins
                GCText {
                    id: instructionTxt
                    fontSize: regularSize
                    color: GCStyle.darkerText
                    anchors.horizontalCenter: parent.horizontalCenter
                    // need to remove the anchors (left and right) else sometimes text is hidden on the side
                    width: instructionFlick.width
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.RichText
                    text: instructionStyle + "<body>" + textIn + "</body>"
                    property string textIn
                    readonly property string instructionStyle: "<head><style type='text/css'>a {color: #191919;}</style></head>"
                }
                Loader {
                    id: extraLoader
                    anchors.top: instructionTxt.bottom
                    anchors.topMargin: GCStyle.halfMargins
                    active: gcdialog.content != null
                    sourceComponent: gcdialog.content
                    width: instructionFlick.width
                }
            }
            // The scroll buttons
            GCButtonScroll {
                id: scrollInstructions
                opacity: 0.7
                visible: instructionFlick.contentHeight > instructionFlick.height
                anchors.right: parent.right
                anchors.rightMargin: GCStyle.halfMargins
                anchors.bottom: parent.bottom
                anchors.bottomMargin: GCStyle.halfMargins
                onUp: instructionFlick.flick(0, 1000)
                onDown: instructionFlick.flick(0, -1000)
                upVisible: instructionFlick.atYBeginning ? false : true
                downVisible: instructionFlick.atYEnd ? false : true
            }
        }

        GCButton {
            id: button1
            width: parent.width
            height: (visible ? 60 : 30) * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxtBg.bottom
                topMargin: GCStyle.halfMargins
            }
            theme: "highContrast"
            visible: text != ""
            enabled: !gcdialog.alreadyClicked
            onClicked: {
                gcdialog.alreadyClicked = true;
                gcdialog.button1Hit()
                gcdialog.stop()
            }
        }

        GCButton {
            id: button2
            width: parent.width
            height: (visible ? 60 : 30) * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: button1.bottom
                topMargin: GCStyle.halfMargins
            }
            theme: "highContrast"
            visible: text != ""
            enabled: !gcdialog.alreadyClicked
            onClicked: {
                gcdialog.alreadyClicked = true;
                gcdialog.button2Hit()
                gcdialog.stop()
            }
        }
    }

    Keys.onEscapePressed: {
        buttonCancel.close();
    }

    Keys.onTabPressed: {
        return;
    }

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
            if(button2.visible && !button1.selected && !button2.selected) {
                button2.selected = true;
            } else if(button2.visible) {
                button2.selected = !button2.selected;
                button1.selected = !button1.selected;
            } else if(button1.visible) {
                button1.selected = true;
            }
        }
        if(event.key === Qt.Key_Down || event.key === Qt.Key_Right) {
            if(button1.visible && !button1.selected && !button2.selected) {
                button1.selected = true;
            } else if(button2.visible) {
                button1.selected = !button1.selected;
                button2.selected = !button2.selected;
            } else if(button1.visible) {
                button1.selected = true;
            }
        }
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            event.accepted = true;
            if(button1.selected) {
                button1.clicked();
            } else if(button2.selected) {
                button2.clicked();
            } else {
                buttonCancel.close();
            }
        }
    }

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Back) {
            buttonCancel.close();
            event.accepted = true;
        }
    }

    // The cancel button
    GCButtonCancel {
        id: buttonCancel
        anchors.margins: GCStyle.halfMargins
        onClose: {
            if(button2.visible)
                button2.clicked();
            else if(button1.visible)
                button1.clicked();
            else
                parent.stop();
        }
    }
}
