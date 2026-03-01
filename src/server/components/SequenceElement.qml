/* GCompris - SequenceElement.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls

import "../singletons"

Rectangle {
    id: sequenceItem
    required property var modelData
    required property int index

    color: mainMouseArea.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.base
    border.color: sequenceItem.activeFocus ? Style.selectedPalette.highlight :
    (mainMouseArea.hovered || (elements.current === index) ? Style.selectedPalette.text :
    Style.selectedPalette.accent)
    border.width: (sequenceItem.activeFocus || (elements.current === index)) ? 2 : 1
    activeFocusOnTab: true

    function selectItem() {
        elements.current = index;
    }

    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: {
            sequenceItem.selectItem();
        }
    }

    Keys.onPressed: (event) => {
        if(event.key == Qt.Key_Space) {
            sequenceItem.selectItem();
        }
    }
    Text {
        anchors.fill: parent
        text: modelData.activity_title
    }
    Rectangle {
        width: sequenceItem - 10
        height:  Style.lineHeight
        anchors.bottom: parent.bottom
        color: Style.selectedPalette.alternateBase
        Text {
            anchors.fill: parent
            text: modelData.dataset_name
        }
    }
}
