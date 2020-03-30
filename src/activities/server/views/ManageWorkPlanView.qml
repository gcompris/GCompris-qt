import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import CM 1.0
import "../components"
import "../../../core"
import QtQuick.Controls 2.2
import "."
import "../server.js" as Activity




Item {

  //  property Client newClient: masterController.ui_newClient

    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: "Manage Xork Plan"
        }
    }

    ListView {
        id: column1
        width: 320; height: 480
        //cellWidth: 80; cellHeight: 80


        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

    //! [0]
        model: DelegateModel {
    //! [0]
            id: visualModel
            model: ListModel {
                id: colorModel
                ListElement { color: "blue" }
                ListElement { color: "green" }
                ListElement { color: "red" }
                ListElement { color: "yellow" }
                ListElement { color: "orange" }
                ListElement { color: "purple" }
                ListElement { color: "cyan" }
                ListElement { color: "magenta" }
                ListElement { color: "chartreuse" }
                ListElement { color: "aquamarine" }
                ListElement { color: "indigo" }
                ListElement { color: "black" }
                ListElement { color: "lightsteelblue" }
                ListElement { color: "violet" }
                ListElement { color: "grey" }
                ListElement { color: "springgreen" }
                ListElement { color: "salmon" }
                ListElement { color: "blanchedalmond" }
                ListElement { color: "forestgreen" }
                ListElement { color: "pink" }
                ListElement { color: "navy" }
                ListElement { color: "goldenrod" }
                ListElement { color: "crimson" }
                ListElement { color: "teal" }
            }
    //! [1]
            delegate: DropArea {
                id: delegateRoot

                width: 80; height: 80

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Rectangle {
                    id: icon
                    property int visualIndex: 0
                    width: 72; height: 72
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    radius: 3
                    color: model.color

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: parent.visualIndex
                    }

                    DragHandler {
                        id: dragHandler
                    }

                    Drag.active: dragHandler.active
                    Drag.source: icon
                    Drag.hotSpot.x: 36
                    Drag.hotSpot.y: 36

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
    //! [1]
        }
    }

    ListView {
        id: column2
        width: 320; height: 480
        anchors.left: column1.right
        anchors.top: parent.top
        //cellWidth: 80; cellHeight: 80


        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

    //! [0]
        model: DelegateModel {
    //! [0]
            id: visualModel2
            model: ListModel {
                id: colorModel2
                ListElement { color: "blue" }
                ListElement { color: "green" }
                ListElement { color: "red" }
                ListElement { color: "yellow" }
                ListElement { color: "orange" }
                ListElement { color: "purple" }
                ListElement { color: "cyan" }
                ListElement { color: "magenta" }
                ListElement { color: "chartreuse" }
                ListElement { color: "aquamarine" }
                ListElement { color: "indigo" }
                ListElement { color: "black" }
                ListElement { color: "lightsteelblue" }
                ListElement { color: "violet" }
                ListElement { color: "grey" }
                ListElement { color: "springgreen" }
                ListElement { color: "salmon" }
                ListElement { color: "blanchedalmond" }
                ListElement { color: "forestgreen" }
                ListElement { color: "pink" }
                ListElement { color: "navy" }
                ListElement { color: "goldenrod" }
                ListElement { color: "crimson" }
                ListElement { color: "teal" }
            }
    //! [1]
            delegate: DropArea {
                id: delegateRoot2

                width: 80; height: 80

                onEntered: {
                    //visualModel2.items.move(drag.source.visualIndex, icon2.visualIndex)
                    console.log("---")
                    drag.source.color = "red"
                    drag.source.parent = delegateRoot2
                }

                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon2; property: "visualIndex"; value: visualIndex }

                Rectangle {
                    id: icon2
                    property int visualIndex: 0
                    width: 72; height: 72
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    radius: 3
                    color: model.color

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: parent.visualIndex
                    }

                    DragHandler {
                        id: dragHandler2
                    }

                    Drag.active: dragHandler2.active
                    Drag.source: icon2
                    Drag.hotSpot.x: 36
                    Drag.hotSpot.y: 36

                    states: [
                        State {
                            when: icon2.Drag.active
                            ParentChange {
                                target: icon2
                                parent: root
                            }

                            AnchorChanges {
                                target: icon2
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
    //! [1]
        }
    }

    GridView {
        width: 300; height: 200
        cellWidth: 80; cellHeight: 80
        anchors.left: column2.right
        anchors.top: parent.top

        model: Activity.dataArray

        Component {
            id: contactsDelegate
            Rectangle {
                id: wrapper
                width: 80
                height: 80
                color: Activity.dataArray[index].color
                Text {
                    id: contactInfo
                    text: "oiu"
                }
            }
        }

     /*   ListView {
            model: dataArray //the array from above
            delegate: Label {
                text: dataArray[index].name
            }
        }

      /*  model: ListModel {
            id: colorModel3
            ListElement { color: "blue" }
            ListElement { color: "green" }
            ListElement { color: "red" }
            ListElement { color: "yellow" }
            ListElement { color: "orange" }
            ListElement { color: "purple" }
            ListElement { color: "cyan" }
            ListElement { color: "magenta" }
            ListElement { color: "chartreuse" }
            ListElement { color: "aquamarine" }
            ListElement { color: "indigo" }
            ListElement { color: "black" }
            ListElement { color: "lightsteelblue" }
            ListElement { color: "violet" }
            ListElement { color: "grey" }
            ListElement { color: "springgreen" }
            ListElement { color: "salmon" }
            ListElement { color: "blanchedalmond" }
            ListElement { color: "forestgreen" }
            ListElement { color: "pink" }
            ListElement { color: "navy" }
            ListElement { color: "goldenrod" }
            ListElement { color: "crimson" }
            ListElement { color: "teal" }
        }*/
        delegate: contactsDelegate
        focus: true
    }


  /*  TopBanner {
        id: topBanner
    }

    PupilsNavigationBar {
        id: pupilsNavigationBar

        anchors.top: topBanner.bottom

    }

    Rectangle {
        id: managePupilsViewRectangle

        anchors.left: pupilsNavigationBar.right
        anchors.top: topBanner.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        //color: "red"

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            width: 200; height: 100

            DelegateModel {
                id: visualModel
                model: ListModel {
                    ListElement { name: "Apple" }
                    ListElement { name: "Orange" }
                }
                delegate: Rectangle {
                    height: 25
                    width: 100
                    Text { text: "Name: " + name}
                }
            }

            ListView {
                anchors.fill: parent
                model: visualModel
            }
            z: 100
        }

        ColumnLayout{
            id: pupilsDetailsColumn

            spacing: 2
            anchors.top: parent.top
            width: parent.width - 10

            property int pupilNameColWidth : pupilsDetailsColumn.width/3
            property int yearOfBirthColWidth : pupilsDetailsColumn.width/8


            //groups header
            Rectangle {
                id: test

                height: 60
                width: parent.width


                RowLayout {
                    width: managePupilsViewRectangle.width - 10
                    height: parent.height

                    Rectangle {
                        id: pupilNameHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: Style.colourNavigationBarBackground
                            text: "Pupils Names"
                            font.bold: true
                            leftPadding: 20
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        id: yearOfBirthHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth     //any way to find "year of birth text width" if translations ?
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Year of Birth"
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            text: "Groups"
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                }
            }

            //groups names
            Repeater {
                id: repeater
                model: [["Thomas petit","2004","CP, CE1, CE2"],["Georges Grand","2007","CE1, CE2, CM1"]]

                Rectangle {
                    width: parent.width
                    Layout.preferredHeight: 40

                    RowLayout {
                        width: managePupilsViewRectangle.width - 10
                        height: 40

                        Rectangle {
                            id: pupilName
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                            Text {
                                text: modelData[0]
                                //anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 20
                                color: "grey"
                            }
                        }
                        Rectangle {
                            id: yearOfBirth
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth   //any way to find "year of birth text width" if translations ?
                            Text {
                                id: yearText
                                text: modelData[1]
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "grey"
                            }
                        }
                        Rectangle {
                            id: groups
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            height: 40
                            Text {
                                id: elipsisText
                                text: modelData[2]
                                leftPadding: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: "grey"
                            }
                        }
                    }
                }
            }
        }


    }

    CommandBar {
        commandList: masterController.ui_commandController.ui_managePupilsViewContextCommands
    }



/*    ScrollView {
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
*/

}
