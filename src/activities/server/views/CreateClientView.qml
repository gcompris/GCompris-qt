import QtQuick 2.0

import "../../../core"
import "../components"


Item {
    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: "CreateClient View"
        }
    }


    CommandBar {
        commandList: masterController.ui_commandController.ui_createClientViewContextCommands
    }
}
