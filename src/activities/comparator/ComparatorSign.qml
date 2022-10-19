/* GCompris - ComparatorSign.qml
*
* SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Johnny Jazeix <jazeix@gmail.com>
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "../../core"

GCButton {
    id: signButton
    height: parent.height
    width: parent.height
    property string signValue
    property bool isSelected: false

    enabled: !bonus.isPlaying

    signal clickTriggered;

    onClicked: {
        //increment the numberOfRowsCompleted if there was no symbol previously
        if(dataListModel.get(items.selectedLine).symbol === "") {
            items.numberOfRowsCompleted ++;
        }
        dataListModel.get(items.selectedLine).symbol = signButton.signValue;
        dataListModel.get(items.selectedLine).isValidationImageVisible = false;
        clickTriggered();
    }
    Rectangle {
        anchors.fill: parent
        radius: width * 0.5
        color: isSelected ? "#DE5946" : "#6495ED"
        border.color: "#FFFFFF"
        border.width: 4
    }

    GCText {
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: signButton.signValue
        fontSize: largeSize
        color: "#FFFFFF"
    }
}
