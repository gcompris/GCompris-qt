/* GCompris - GCInputDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
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
     * type:object
     * The content object as loaded dynamically.
     */
    property alias inputItem: loader.item

    /**
     * type:Component
     * Content component which holds the visual presentation of the
     * config settings in the QML scene.
     */
    property Component content

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
     * By default, we should close the dialog whenever a choice has been made.
     * In some cases (an error), we don't want to close it so we let the choice.
     */
    property bool closeDialogOnClick: true

    property alias active: loader.active
    property alias loader: loader
    focus: true
    opacity: 0

    anchors {
        fill: parent
    }

    onStart: { opacity = 1; }
    onStop: { opacity = 0; }
    //onClose: destroy()

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
            height: Math.min(instructionTxt.height + flick.anchors.margins*2, gcdialog.height - button1.height * 5)
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
            id: textInputBg
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: instructionTxtBg.bottom
                topMargin: 10
            }
            z: 1
            width: parent.width
            height: gcdialog.inputItem ? gcdialog.inputItem.height : 100
            opacity: 0.9
            radius: 10
            border.width: 2
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 0.9; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }

            Loader {
                id: loader
                active: false
                sourceComponent: gcdialog.content
                property alias rootItem: gcdialog
            }
        }

        GCButton {
            id: button1
            width: parent.width
            height: (visible ? 60 : 30) * ApplicationInfo.ratio
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: textInputBg.bottom
                topMargin: 10
            }
            theme: "highContrast"
            visible: text != ""
            onClicked: {
                gcdialog.button1Hit()
                if(closeDialogOnClick) {
                    gcdialog.stop()
                }
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
            onClicked: {
                gcdialog.button2Hit()
                if(closeDialogOnClick) {
                    gcdialog.stop()
                }
            }
        }
    }


    // Fixme not working, need to properly get the focus on this dialog
    Keys.onEscapePressed: {
        stop()
        event.accepted = true;
    }

    // The cancel button
    GCButtonCancel {
        id: buttonCancel
        onClose: parent.stop()
    }
}
