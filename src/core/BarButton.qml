import QtQuick 2.1
import GCompris 1.0

Image {
    id: button
    state: "notclicked"
    visible: contentId & bar.content.value

    property int contentId

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked();
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: button
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: button
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: button
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }

}
