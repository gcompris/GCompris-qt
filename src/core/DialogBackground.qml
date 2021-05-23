/* GCompris - DialogBackground.qml
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
 * Base QML component for all full screen dialog screens.
 * @ingroup components
 *
 * Defines the general screen layout used by the following full screen
 * dialog elements:
 *
 * DialogAbout, DialogHelp.
 *
 * For a general purpose dialog cf. GCDialog.
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    focus: visible
    property bool isDialog: true
    property string title
    property string content
    property string contentIcon
    property alias button0Text: button0.text
    signal close
    signal start
    signal pause
    signal play
    signal stop
    signal button0Hit

    Keys.onPressed: {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        }
    }

    Keys.onEscapePressed: {
        dialogBackground.close();
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            dialogBackground.close();
            event.accepted = true;
        }
    }

    onClose: activity.forceActiveFocus();

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                id: titleRectangle
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                GCText {
                    id: title
                    text: dialogBackground.title
                    width: titleRectangle.width - 120 * ApplicationInfo.ratio //minus twice the cancel button size
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    fontSize: 20
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                }
                // The cancel button
                GCButtonCancel {
                    id: cancel
                    anchors.verticalCenter: titleRectangle.verticalCenter
                    anchors.margins: 2 * ApplicationInfo.ratio
                    onClose: dialogBackground.close()
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogBackground.width - 30
                height: dialogBackground.height - (30 + title.height * 1.2)
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    flickDeceleration: 1500
                    anchors.margins: 8
                    anchors.fill: parent
                    contentWidth: textContent.contentWidth
                    contentHeight: iconImage.height + button0.height + textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    GCButton {
                        id: button0
                        visible: text != ""
                        onClicked: { dialogBackground.button0Hit() }
                        width: 150 * ApplicationInfo.ratio
                        height: visible ? 40 * ApplicationInfo.ratio : 0
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 8
                        }
                        theme: "highContrast"
                    }

                    Image {
                        id: iconImage
                        source: contentIcon
                        visible: contentIcon != ""
                        width: 100 * ApplicationInfo.ratio
                        height: visible ? iconImage.width : 0
                        sourceSize.width: iconImage.width
                        sourceSize.height: iconImage.width
                        anchors.top: button0.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    GCText {
                        id: textContent
                        text: style + "<body>" + content + "</body>"
                        width: flick.width
                        height: flick.height - button0.height
                        anchors.top: iconImage.bottom
                        fontSize: regularSize
                        wrapMode: TextEdit.Wrap
                        textFormat: TextEdit.RichText
                        property string style: "<HEAD><STYLE type='text/css'>A {color: black;}</STYLE></HEAD>"
                    }
                }
                // The scroll buttons
                GCButtonScroll {
                    id: scrollItem
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flick.bottom
                    anchors.bottomMargin: 5 * ApplicationInfo.ratio
                    onUp: flick.flick(0, 1000)
                    onDown: flick.flick(0, -1000)
                    upVisible: flick.visibleArea.yPosition <= 0 ? false : true
                    downVisible: flick.visibleArea.yPosition + flick.visibleArea.heightRatio >= 1 ? false : true
                }
            }
        }
    }
}
