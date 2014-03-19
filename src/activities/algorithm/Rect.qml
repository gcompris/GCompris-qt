import QtQuick 2.0

Rectangle{
    id: sampleTray
    height: parent.height/8
    width: parent.width - parent.width/3
    color: "transparent"
    property string src1: "qrc:/gcompris/src/activities/algorithm/resource/apple.png"
    property string src2: "qrc:/gcompris/src/activities/algorithm/resource/cerise.png"
    property string src3: "qrc:/gcompris/src/activities/algorithm/resource/egg.png"
    property string src4: "qrc:/gcompris/src/activities/algorithm/resource/eggpot.png"
    property string src5: "qrc:/gcompris/src/activities/algorithm/resource/football.png"
    property string src6: "qrc:/gcompris/src/activities/algorithm/resource/glass.png"
    property string src7: "qrc:/gcompris/src/activities/algorithm/resource/peer.png"
    property string src8: "qrc:/gcompris/src/activities/algorithm/resource/strawberry.png"
    property bool visible7: true
    property bool visible8: true

    Image{
        id: img1
        source: sampleTray.src1
        visible: true
        height: parent.height
        width: parent.width/9

    }
    Image{
        id: img2
        source: sampleTray.src2
        visible: true
        height: parent.height
        width: parent.width/9
        anchors.left: img1.right
        anchors.leftMargin: 10
    }
    Image{
        id: img3
        source: sampleTray.src3
        visible: true
        height: parent.height
        width: parent.width/9
        anchors.left: img2.right
        anchors.leftMargin: 10
    }
    Image{
        id: img4
        source: sampleTray.src4
        visible: true
        height: parent.height
        width: parent.width/9
        anchors.left: img3.right
        anchors.leftMargin: 10
    }
    Image{
        id: img5
        source: sampleTray.src5
        visible: true
        height: parent.height
        width: parent.width/9
        anchors.left: img4.right
        anchors.leftMargin: 10
    }
    Image{
        id: img6
        source: sampleTray.src6
        visible: true
        height: parent.height
        width: parent.width/9
        anchors.left: img5.right
        anchors.leftMargin: 10
    }
    Image{
        id: img7
        source: sampleTray.src7
        visible: sampleTray.visible7
        height: parent.height
        width: parent.width/9
        anchors.left: img6.right
        anchors.leftMargin: 10
    }
    Image{
        id: img8
        source: sampleTray.src8
        visible: sampleTray.visible8
        height: parent.height
        width: parent.width/9
        anchors.left: img7.right
        anchors.leftMargin: 10
    }

}
