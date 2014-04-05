import QtQuick 2.0

Item{
    property int vertOffset: 0
    property int nbStarsOn: 0
    property bool authorizeClick: false

    id: item
    width: row.width
    height: parent.width/26
    anchors.right: parent.right
    anchors.rightMargin: parent.width/25
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: vertOffset

    Row{
        id: row
        height: item.height
        spacing: 5
        Repeater{
            model: nbStarsOn
            Star{
                starState: "on"
                width: item.height
                height: item.height
                isClickable: authorizeClick
            }
        }
        Repeater{
            model: 10-nbStarsOn
            Star{
                starState: "off"
                width: item.height
                height: item.height
                isClickable: authorizeClick
            }
        }
    }
}
