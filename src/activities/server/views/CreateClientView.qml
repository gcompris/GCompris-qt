import QtQuick 2.0

import CM 1.0
import "../components"
import "../../../core"



Item {

    property Client newClient: masterController.ui_newClient

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
