import QtQuick 2.0
import "magic-hat.js" as Activity

Item{
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int starsSize: 32

    id: item
    width: row.width
    height: starsSize

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
                displayBounds: true
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
