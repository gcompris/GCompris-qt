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
        anchors.fill: parent
        color: Style.colourBackground
        border.width: 1
        border.color: "lightgrey"

        GridLayout {
            id: grid
            width: parent.width - 10

            columns: 3
            columnSpacing: 0

            Rectangle {
                id: firstCol
                implicitHeight: 60
              //  color: "orange"
                Layout.preferredWidth: 60
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
                }
            }
            Rectangle {
                id: secondCol
                implicitHeight: 60
              //  color: "lightgreen"
                implicitWidth: grid.width-firstCol.width-thirdCol.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    //leftPadding: 20
                    text: "Groups"
                    font.bold: true
                    color: Style.colourNavigationBarBackground
                }
            }
            Rectangle {
                id: thirdCol
                implicitHeight: 60
            //    color: "orange"
                Layout.preferredWidth: 40
                Text { text: ""}
            }

        }


        GridLayout {
            id: grid2
            width: parent.width - 10

            anchors.top: grid.bottom

            columns: 3
            columnSpacing: 0
            flow: GridLayout.TopToBottom
            rows: repeater.count


            Repeater {
                id: repeater
                model: ["CP", "CE1", "CE2"]
                Rectangle {
                    id: firstCol2
                    implicitHeight: 40
                    Layout.preferredWidth: 60
                    Text {
                        text: "\uf054"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 5
                        color: "grey"
                        font {
                            family: Style.fontAwesome
                            pixelSize: Style.pixelSizeNavigationBarIcon / 2
                        }
                    }
                }
            }

            Repeater {
                id: repeater2
                model: ["CPjfdgdfgdsgdfgdfgdsfgdfgdgfdfgdfgdfgdfgdsgdfgdfgdfgdfgdsfg", "CE1", "CE2"]
                Rectangle {
                    id: secondCol2
                    implicitHeight: 40
                    implicitWidth: grid.width-firstCol.width-thirdCol.width
                    Text {
                        text: modelData
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.implicitWidth
                        color: "grey"
                        leftPadding: 5
                        elide: Text.ElideRight
                    }
                }
            }

            Repeater {
                id: repeater3
                model: ["CP", "CE1", "CE2"]
                Rectangle {
                    id: thirdCol2
                    implicitHeight: 40
                    color: "lightblue"
                    Layout.preferredWidth: 40
                    Text {
                        text: "\uf142"   //elipsis-v
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "grey"
                        font {
                            family: Style.fontAwesome
                            pixelSize: Style.pixelSizeNavigationBarIcon / 2
                        }
                    }
                }
            }

            Text {
                      textFormat: Text.RichText
                      text: "See the <a href=\"http://qt-project.org\">Qt Project website</a>."
                      onLinkActivated: console.log(link + " link activated")
              }
        }
    }
}
