import QtQuick 2.0

import CM 1.0
import "../components"
import "../../../core"
import QtQuick.Controls 2.2
import "."



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

    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            //bottom: commandBar.top
            margins: Style.sizeScreenMargin
        }
        clip: true

        Column {
            spacing: Style.sizeScreenMargin
            width: scrollView.width

            Panel {
                headerText: "Client Details"
                contentComponent:
                    Column {
                        spacing: Style.sizeControlSpacing
                        StringEditorSingleLine {
                            stringDecorator: newClient.ui_reference
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }
                        StringEditorSingleLine {
                            stringDecorator: newClient.ui_name
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                        }
                    }
            }
            AddressEditor {
                address: newClient.ui_supplyAddress
                headerText: "Supply Address"
            }
            AddressEditor {
                address: newClient.ui_billingAddress
                headerText: "Billing Address"
            }
        }
    }


    CommandBar {
        commandList: masterController.ui_commandController.ui_createClientViewContextCommands
    }
}
