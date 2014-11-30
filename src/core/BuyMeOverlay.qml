import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import GCompris 1.0

Component {
    Item {
        
        anchors {
            fill: parent
            bottomMargin: bar.height
        }
        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: "grey"
        }
        /* Activation Instruction */
        Item {
            id: instruction
            z: 99
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 40
            }
            width: parent.width * 0.9
            
            GCText {
                id: instructionTxt
                font.pointSize: 16
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: TextEdit.WordWrap
                z: 2
                text: qsTr("This activity is only available in the full version of GCompris.")
            }
            
            Button {
                width: parent.width * 0.8
                height: 60 * ApplicationInfo.ratio
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: instructionTxt.bottom
                    topMargin: 10
                }
                text: qsTr("Buy the full version").toUpperCase()
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.activeFocus ? 4 : 2
                        border.color: "black"
                        radius: 10
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? "#87ff5c" : "#ffe85c"}
                            GradientStop { position: 1 ; color: control.pressed ? "#44ff00" : "#f8d600"}
                        }
                    }
                    label: GCText {
                        text: control.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                    }
                }
                
                onClicked: {
                    ApplicationSettings.isDemoMode = !ApplicationSettings.isDemoMode
                    console.log("call buying api")
                }
            }
            
            Rectangle {
                anchors.fill: instructionTxt
                z: 1
                opacity: 0.8
                radius: 10
                border.width: 2
                border.color: "black"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
            }
        }
        
        MultiPointTouchArea {
            // Just to catch mouse events
            anchors.fill: parent
        }
    }
}
