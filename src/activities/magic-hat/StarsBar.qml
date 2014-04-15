import QtQuick 2.0
import "magic-hat.js" as Activity

Item {
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int starsSize: 32
    property alias starX : starToMove.x
    property alias starY : starToMove.y
    id: item
    width: starsSize
    height: starsSize

    Row {
        id: rowlayout
        height: item.height
        spacing: 5
        Repeater {
            id: repeaterStarsOn
            model: nbStarsOn
            Star {
                id: staticStar
                starState: "on"
                width: item.height
                height: item.height
                displayBounds: true
                isClickable: authorizeClick
            }
            children:[
                Star {
                    id: starToMove
                    starState: "on"
                    width: item.height
                    height: item.height
                    displayBounds: false
                    isClickable: authorizeClick
                }
            ]
        }
        Repeater {
            id: repeaterStarsOff
            model: 10-nbStarsOn
            Star {
                starState: "off"
                width: item.height
                height: item.height
                isClickable: authorizeClick
            }
        }
    }
}
