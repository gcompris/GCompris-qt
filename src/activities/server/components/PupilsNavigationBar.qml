import QtQuick 2.9
import QtQuick.Layouts 1.12
import "../../../core"

Item {
    property bool isCollapsed: true
    property int groupTextMargin: 30

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
    }
    width: Style.widthNavigationButton

    Rectangle {
        id: pupilsNavigationRectangle
        width: parent.width
        height: parent.height
        color: Style.colourBackground
        border.width: 1
        border.color: "lightgrey"

        ColumnLayout{
            id: groupNames

            spacing: 2
            anchors.top: parent.top
            width: parent.width - 10


            //groups header
            Rectangle {

                id: test
                height: 60
                width: parent.width

                RowLayout {
                    width: parent.width
                    height: parent.height

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsNavigationRectangle.width/5
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Style.colourNavigationBarBackground
                            font {
                                family: Style.fontAwesome
                                pixelSize: Style.pixelSizeNavigationBarIcon/2
                            }
                            text: "\uf0c0"
                            font.bold: true
                            leftPadding: 20
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        implicitHeight: 60
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            topPadding: 20
                            text: "Groups"
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                        }
                    }
                }
            }

            //groups names
            Repeater {
                id: repeater
                model: ["CP", "CE1", "CE2"]

                Rectangle {
                    width: groupNames.width
                    Layout.preferredHeight: 40

                    RowLayout {
                        width: pupilsNavigationRectangle.width - 10
                        height: 40

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            Text {
                                text: "\uf054"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 20
                                color: "grey"
                                font {
                                    family: Style.fontAwesome
                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            height: 40
                            Text {
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                color: "grey"
                                leftPadding: 5
                                elide: Text.ElideRight
                            }
                        }
                        Rectangle {
                            id: elipsis
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            Layout.fillHeight: true
                            height: 40
                            Text {
                                id: elipsisText
                                text: "\uf142"   //elipsis-v
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "grey"
                                font {
                                    family: Style.fontAwesome
                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2    //? see with style
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: { elipsisText.color = Style.colourNavigationBarBackground }
                                onEntered: { elipsisText.color = Style.colourNavigationBarBackground }
                                onExited: { elipsisText.color = "grey" }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: addAGroupLabelRectangle

            anchors.top: groupNames.bottom
            anchors.left: parent.left

            width: parent.width - 10
            height: 40

            Text {
                id: addAGroupText
                text: "\uf067" + qsTr("  Add a group")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
                color: "grey"
                font {
                    family: Style.fontAwesome
                    pixelSize: Style.pixelSizeNavigationBarIcon / 3   //? see with style
                }

                onHoveredLinkChanged: {
                    color = "blue"
                    console.log("fffffffff")
                }
            }

            MouseArea {
                   anchors.fill: parent
                   hoverEnabled: true
                   onClicked: { addAGroupText.color = Style.colourNavigationBarBackground }
                   onEntered: { addAGroupText.color = Style.colourNavigationBarBackground }
                   onExited: { addAGroupText.color = "grey" }
            }
        }
    }
}
