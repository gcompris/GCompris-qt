/* GCompris - TextToolPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import "../../core"

Item {
    id: textToolPanel
    visible: false
    anchors.fill: parent

    property Item selectedModeButton: Item { property string iconSource: "qrc:/gcompris/src/activities/sketch/resource/textMode.svg" }
    readonly property string toolTitle: qsTr("Text Tool")

    property alias textString: textEdit.text
    property alias textEdit: textEdit

    onTextStringChanged: {
        textTool.textString = textString;
    }

    // Triggered when selecting the tool
    function setToolMode() {
        toolsPanel.loadModeSettings();
    }

    GCText {
        id: textInputTitle
        text: qsTr("Type your text here")
        color: items.contentColor
        width: parent.width
        height: toolsPanel.settingsLineHeight
        fontSize: regularSize
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignBottom
    }

    Rectangle {
        id: textContainer
        anchors.top: textInputTitle.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: items.baseMargins
        color: "#20FFFFFF"
        radius: items.baseMargins

        Flickable {
            id: textFlickable
            anchors.fill: parent
            anchors.margins: items.baseMargins
            clip: true

            function ensureVisible(r: var) {
                if(contentX >= r.x) {
                    contentX = r.x;
                } else if (contentX+width <= r.x+r.width) {
                    contentX = r.x+r.width-width;
                }
                if(contentY >= r.y) {
                    contentY = r.y;
                } else if (contentY+height <= r.y+r.height) {
                    contentY = r.y+r.height-height;
                }
            }

            TextEdit {
                id: textEdit
                anchors.fill: parent
                wrapMode: TextEdit.Wrap
                font.pointSize: 20
                color: items.contentColor
                selectionColor: items.panelColor
                onCursorRectangleChanged: textFlickable.ensureVisible(cursorRectangle);
            }
        }
    }
}
