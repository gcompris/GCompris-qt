/* GCompris - GCDialog.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

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
Item {
    id: gcdialog

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
    }
    onStop: {
        opacity = 0;
        parent.Keys.enabled = true;
        parent.forceActiveFocus();
    }
    onClose: {
        if(isDestructible)
            destroy();
    }

    Behavior on opacity { NumberAnimation { duration: 200 } }
    onOpacityChanged: opacity === 0 ? close() : null

    z: 1500

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "grey"
    }

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
            topMargin: buttonCancel.height
        }
        width: parent.width * 0.8

        Rectangle {
            id: instructionTxtBg
            anchors.top: instruction.top
            z: 1
            width: parent.width
            height: gcdialog.height - button1.height * 5
            opacity: 0.9
            radius: 10
            border.width: 2
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 0.9; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }

            Flickable {
                id: flick
                anchors.margins: 8
                anchors.fill: parent
                contentWidth: instructionTxt.contentWidth
                contentHeight: instructionTxt.contentHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                GCText {
                    id: instructionTxt
                    fontSize: regularSize
                    color: "black"
                    // @FIXME This property breaks the wrapping
//                    horizontalAlignment: Text.AlignHCenter
                    // need to remove the anchors (left and right) else sometimes text is hidden on the side
                    width: instruction.width - 2*flick.anchors.margins
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.RichText
                    z: 2
                    text: style + "<body>" + textIn + "</body>"
                    property string textIn
                    property string style: "<HEAD><STYLE type='text/css'>A {color: black;}</STYLE></HEAD>"
                }
            }
        }

        Rectangle {
            id: buttonSelector
            width: 0
            height: 0
            color: "#803ACAFF"
            scale: 1.1
        }

        GCButton {
            id: button1
            width: parent.width
            height: (visible ? 60 : 30) * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxtBg.bottom
                topMargin: 10
            }
            theme: "highContrast"
            visible: text != ""
            property bool selected: false;
            onClicked: {
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
                topMargin: 10
            }
            theme: "highContrast"
            visible: text != ""
            property bool selected: false;
            onClicked: {
                gcdialog.button2Hit()
                gcdialog.stop()
            }
        }

        states: [
            State {
                name: "button1Selected"
                when: button1.selected
                PropertyChanges {
                    target: buttonSelector
                    anchors.fill: button1
                }
            },
            State {
                name: "button2Selected"
                when: button2.selected
                PropertyChanges {
                    target: buttonSelector
                    anchors.fill: button2
                }
            }
        ]
    }

    Keys.onEscapePressed: {
        buttonCancel.close();
    }

    Keys.onTabPressed: {
        return;
    }

    Keys.onPressed: {
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

    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            buttonCancel.close();
            event.accepted = true;
        }
    }

    // The cancel button
    GCButtonCancel {
        id: buttonCancel
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
