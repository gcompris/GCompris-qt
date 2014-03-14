import QtQuick 2.0

Item {
    property string imgPath : "qrc:/gcompris/src/activities/enumerate/resource/banana.png"
    property int type: 0
    height: 100
    width: 100

    id : itemToEnumerate
    Image{
        id: img
        anchors.fill: parent
        source: imgPath
        fillMode : Image.PreserveAspectFit
    }

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x : 10
    Drag.hotSpot.y : 10

    MouseArea{
        id: dragArea
        anchors.fill: parent
        drag.target: parent
        onReleased: parent.Drag.drop()
    }
}
