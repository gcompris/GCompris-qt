import QtQuick 2.1

Rectangle{
    width: 40
    height: 40
    color: "grey"
    property string starState: "off"
    property int hatX: 0
    property int hatY: 0

    Image {
        id: starImg
        width: 32
        height: 32
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        state: starState
        fillMode: Image.PreserveAspectFit

        states:[
            State{
                name: "on"
                PropertyChanges {
                    target: starImg
                    source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/star1.svgz"
                }
            },
            State{
                name: "off"
                PropertyChanges {
                    target: starImg
                    source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/star-clear.svgz"
                }
            }
        ]
    }
}
