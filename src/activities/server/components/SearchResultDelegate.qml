import QtQuick 2.9
import assets 1.0
import CM 1.0

Item {
    property Client client

    implicitWidth: parent.width
    implicitHeight: Math.max(clientColumn.implicitHeight, textAddress.implicitHeight) + (Style.heightDataControls / 2)

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: Style.colourPanelBackground

        Column {
            id: clientColumn
            width: parent / 2
            anchors {
                left: parent.left
                top: parent.top
                margins: Style.heightDataControls / 4
            }
            spacing: Style.heightDataControls / 2

            Text {
                id: textReference
                anchors.left: parent.left
                text: client.ui_reference.ui_label + ": " + client.ui_reference.ui_value
                font.pixelSize: Style.pixelSizeDataControls
                color: Style.colourPanelFont
            }
            Text {
                id: textName
                anchors.left: parent.left
                text: client.ui_name.ui_label + ": " + client.ui_name.ui_value
                font.pixelSize: Style.pixelSizeDataControls
                color: Style.colourPanelFont
            }
        }

        Text {
            id: textAddress
            anchors {
                top: parent.top
                right: parent.right
                margins: Style.heightDataControls / 4
            }
            text: client.ui_supplyAddress.ui_fullAddress
            font.pixelSize: Style.pixelSizeDataControls
            color: Style.colourPanelFont
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: borderBottom
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: 1
            color: Style.colourPanelFont
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: background.state = "hover"
            onExited: background.state = ""
            onClicked: masterController.selectClient(client)
        }

        states: [
            State {
                name: "hover"
                PropertyChanges {
                    target: background
                    color: Style.colourPanelBackgroundHover
                }
            }
        ]
    }
}
