/* GCompris - DialogBackground.qml
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
    color: GCStyle.configBg
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

    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Down) {
            scrollItem.down();
        } else if(event.key === Qt.Key_Up) {
            scrollItem.up();
        }
    }

    Keys.onEscapePressed: {
        dialogBackground.close();
    }

    Keys.onReleased: (event) => {
        if(event.key === Qt.Key_Back) {
            dialogBackground.close();
            event.accepted = true;
        }
    }

    onClose: activity.forceActiveFocus();

    Column {
        spacing: GCStyle.halfMargins
        anchors.top: parent.top
        anchors.topMargin: GCStyle.baseMargins
        anchors.horizontalCenter: parent.horizontalCenter
        width: dialogBackground.width - 2 * GCStyle.baseMargins
        Rectangle {
            id: titleRectangle
            color: GCStyle.lightBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: Math.max(title.height, cancel.height) + GCStyle.baseMargins

            GCText {
                id: title
                text: dialogBackground.title
                width: titleRectangle.width - (cancel.width + cancel.anchors.margins) * 2
                anchors.horizontalCenter: titleRectangle.horizontalCenter
                anchors.verticalCenter: titleRectangle.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: mediumSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }
            // The cancel button
            GCButtonCancel {
                id: cancel
                anchors.top: undefined
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: GCStyle.tinyMargins
                onClose: dialogBackground.close()
            }
        }
        Rectangle {
            color: GCStyle.lightTransparentBg
            radius: GCStyle.baseMargins
            width: parent.width
            height: dialogBackground.height - (2 * parent.anchors.topMargin) - titleRectangle.height - parent.spacing
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.midBorder

            Flickable {
                id: flick
                anchors.margins: GCStyle.baseMargins
                anchors.fill: parent
                contentWidth: textContent.contentWidth
                contentHeight: iconImage.height + button0.height + textContent.contentHeight + 70 * ApplicationInfo.ratio
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: dialogBackground.height
                boundsBehavior: Flickable.StopAtBounds
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
                        topMargin: parent.anchors.margins
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
                    anchors.margins: parent.anchors.margins
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GCText {
                    id: textContent
                    text: instructionStyle + "<body>" + content + "</body>"
                    width: flick.width
                    height: flick.height - button0.height
                    anchors.top: iconImage.bottom
                    anchors.margins: parent.anchors.margins
                    fontSize: regularSize
                    wrapMode: TextEdit.Wrap
                    textFormat: TextEdit.RichText
                    readonly property string instructionStyle: "<head><style>A {color: #191919;}</style></head>"
                }
            }
            // The scroll buttons
            GCButtonScroll {
                id: scrollItem
                anchors.right: parent.right
                anchors.rightMargin: GCStyle.halfMargins
                anchors.bottom: flick.bottom
                anchors.bottomMargin: GCStyle.halfMargins
                onUp: flick.flick(0, 1000)
                onDown: flick.flick(0, -1000)
                upVisible: flick.atYBeginning ? false : true
                downVisible: flick.atYEnd ? false : true
            }
        }
    }
}
